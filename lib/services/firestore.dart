import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<dynamic> getUsers(String user) async {
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var data = snapshot.data() as Map<String, dynamic>;
    return data;
  }

  void CreateTweet(Tweet tweet) {}

  Stream<UserData> streamUserData() {
    print("cool");
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        print("nn");
        var ref = _db.collection('users').doc(user.uid);
        print('WHY: ${user.uid}');
        return ref
            .snapshots()
            .map((doc) => UserData.fromJson(doc.data()!, user.uid));
      } else {
        print("n");
        return Stream.fromIterable([UserData()]);
      }
    });
  }

  String removeSpacesAndMakeLowerCase(String str) {
    // Replace all spaces with the empty string
    str = str.replaceAll(' ', '');

    // Convert the string to lowercase
    str = str.toLowerCase();

    return str;
  }

  void createUserData(User user) async {
    var ref = _db.collection("users").doc(user.uid);
    final usersRef = _db.collection("users");
    final q = usersRef
        .where("displayName", isEqualTo: user.displayName)
        .orderBy("username")
        .limit(1);
    final querySnapshot = await q.get();
    print("queryTime");
    String username = "";
    print(
        "${querySnapshot.docs.isEmpty}, ${querySnapshot.docs.length}, ${querySnapshot.docs}, ${user.displayName}");
    if (querySnapshot.docs.isEmpty) {
      username = user.displayName ?? "";
    } else {
      querySnapshot.docs.forEach((doc) {
        String index = UserData.fromJson(doc.data(), doc.id)
            .username
            .split(user.displayName ?? "")[1];
        if (index == "0") {
          index = "0";
        }
        username = 'displayName ${(int.parse(index) + 1).toString()}';
      });
    }

    ref.set({
      "displayName": user.displayName,
      "email": user.email,
      "username": removeSpacesAndMakeLowerCase(username),
      "profileIMG": user.photoURL,
    });
  }
}
