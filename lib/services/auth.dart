import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/services/firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException {
      // handle error
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  void updatePassword(String password, String currentPassword) {
    dynamic provider = GoogleAuthProvider();

    if (((user?.providerData.length) ?? 0) < 2) {
      return;
    } else {
      if (user?.providerData[1] == "google.com") {
        provider = GoogleAuthProvider();
      } else if (user?.providerData[1] == "apple.com") {
        provider = AppleAuthProvider();
      }
    }
    user?.reauthenticateWithProvider(provider);
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((value) => {
                if (value.user != null)
                  {FirestoreService().createUserData(value.user!)}
              });
    } on FirebaseAuthException catch (e) {}
  }

  Future<bool> createUserWithUsernameAndPassword({
    required String name,
    required String phoneOrEmail,
    required List<String> subTopics,
    required List<String> topics,
    required File? profileIMG,
    required String password,
    required String? username,
    required DateTime dob,
    required List<String> followers,
  }) async {
    print('${username} : username');
    AuthCredential? authCredential;

    try {
      if (isPhone(phoneOrEmail) == true) {
        FirebaseAuth auth = FirebaseAuth.instance;

        await auth.verifyPhoneNumber(
          phoneNumber: '+44 7123 123 456',
          codeSent: (String verificationId, int? resendToken) async {
            // Update the UI - wait for the user to enter the SMS code
            String smsCode = 'xxxx';

            // Create a PhoneAuthCredential with the code
            final credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);

            // Sign the user in (or link) with the credential
            await auth.signInWithCredential(credential);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            final credential = phoneAuthCredential;
            authCredential = PhoneAuthProvider.credential(
                smsCode: credential.smsCode ?? '',
                verificationId: credential.verificationId ?? '');
          },
          verificationFailed: (FirebaseAuthException error) {},
        );
      } else {
        print("${phoneOrEmail} - ${password}");
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: phoneOrEmail, password: password)
            .then((value) {
          print("value");
          return value;
        });

        final googleAuth = await credential.credential;
        authCredential = EmailAuthProvider.credential(
          email: phoneOrEmail,
          password: password,
        );
      }

      await FirebaseAuth.instance
          .signInWithCredential(authCredential!)
          .then((value) => {
                if (value.user != null)
                  {
                    FirestoreService().createUserDataFromCustom(
                      value.user!,
                      followers: followers,
                      dob: dob,
                      name: name,
                      phoneOrEmail: phoneOrEmail,
                      password: password,
                      profileIMG: profileIMG,
                      subTopics: subTopics,
                      topics: topics,
                      username: username,
                    )
                  }
              });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  bool isPhone(String input) {
    // Regular expression for a phone number
    final phoneRegex = RegExp(
        r'^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$');

    // Regular expression for an email
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

    if (phoneRegex.matchAsPrefix(input) != null) {
      return true;
    } else {}
    return false;
  }
}
