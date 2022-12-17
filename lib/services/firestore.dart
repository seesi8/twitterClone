import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spark/services/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserData?> getUser(String user) async {
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var data = snapshot.data();
    if (data != null) {
      return UserData.fromJson(data, snapshot.id);
    }
  }

  void AddToPoll(String choice, String id, String uid, int index) {
    var ref = _db
        .collection('tweets')
        .doc(id)
        .collection("choices")
        .doc(index.toString());
    var ref2 = _db.collection('tweets').doc(id).collection("voters").doc(uid);
    var forceUpdateRef = _db.collection("tweets").doc(id);
    var batch = _db.batch();
    var forceUpdateStapshot =
        batch.update(forceUpdateRef, {"totalVotes": FieldValue.increment(1)});
    var snapshot = batch.update(
      ref,
      {
        "${choice}": FieldValue.increment(1),
      },
    );
    var snapshot2 = batch.set(
      ref2,
      {
        "choice": index,
        "user": uid,
      },
    );

    batch.commit();
  }

  void CreateTweet(Tweet tweet) async {
    var batch = _db.batch();
    String uuid = Uuid().v4();
    if (tweet.imagePathsOrUrls != null) {
      int index = 0;
      for (String PathOrUrl in tweet.imagePathsOrUrls!) {
        tweet.imagePathsOrUrls![index] =
            await StorageService().UploadFile(file: File(PathOrUrl));
        index += 1;
      }
    }
    batch.set(_db.collection("tweets").doc(uuid), {
      "text": tweet.text,
      "timeSent": FieldValue.serverTimestamp(),
      "poll": tweet.poll != null
          ? {
              "lengthTime": {
                "days": tweet.poll!.lengthTime.days,
                "hours": tweet.poll!.lengthTime.hours,
                "min": tweet.poll!.lengthTime.hours,
              },
            }
          : null,
      "imagePathsOrUrls": tweet.imagePathsOrUrls,
      "audioUrl": tweet.audioUrl,
      "authorUid": tweet.authorUid,
      "numComments": 0,
      "numHearts": 0,
      "numRetweets": 0,
    });

    int index = 0;

    if (tweet.poll != null) {
      tweet.poll!.choices.forEach((e) {
        batch.set(
            _db.collection("tweets").doc(uuid).collection("choices").doc(
                  index.toString(),
                ),
            e);

        index += 1;
      });
    }

    batch.commit();
  }

  Stream<UserData> streamUserData() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('users').doc(user.uid);
        return ref
            .snapshots()
            .map((doc) => UserData.fromJson(doc.data()!, user.uid));
      } else {
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

  Stream<List<Future<Tweet>>> streamTweets(String userId) {
    var ref = _db.collection("tweets").limit(20).orderBy("timeSent");

    return ref.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var tweet = Tweet.fromJson(
          e.data(),
          e.id,
          (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          (await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
        );
        return tweet;
      }).toList();
    });
  }

  void createUserData(User user) async {
    var ref = _db.collection("users").doc(user.uid);
    final usersRef = _db.collection("users");
    final q = usersRef
        .where("displayName", isEqualTo: user.displayName)
        .orderBy("username")
        .limit(1);
    final querySnapshot = await q.get();
    String username = "";

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
