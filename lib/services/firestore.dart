import 'dart:async';
import 'dart:io';
import 'dart:async' show Stream;
import 'package:async/async.dart' show StreamGroup;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/services/auth.dart';
import 'package:spark/services/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spark/services/storage.dart';
import 'package:spark/shared/ProfileImg.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserData?> getUser(String user) async {
    var ref = _db.collection('users').doc(user);
    var snapshot = await ref.get();
    var data = snapshot.data();
    if (data != null) {
      var userData = UserData.fromJson(data, id: snapshot.id);
      return userData;
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
      "retweeted": null,
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

  void CreateComment(Tweet tweet, String id) async {
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

    batch.update(_db.collection("tweets").doc(id),
        {"numComments": FieldValue.increment(1)});
    batch.set(
        _db.collection("tweets").doc(id).collection("comments").doc(uuid), {
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
      "retweeted": null,
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

  void heart({required String uid, required String id}) async {
    var heartRef =
        _db.collection("tweets").doc(id).collection("heartedBuy").doc(uid);
    var mainRef = _db.collection("tweets").doc(id);
    var batch = _db.batch();

    batch.set(heartRef, {"user": uid});

    if (!(await (heartRef.get())).exists) {
      batch.update(mainRef, {"numHearts": FieldValue.increment(1)});
    }

    batch.commit();
  }

  void retweet({required String uid, required String id}) async {
    var retweetRef =
        _db.collection("tweets").doc(id).collection("retweetedBy").doc(uid);
    var mainRef = _db.collection("tweets").doc(id);
    var batch = _db.batch();

    batch.set(retweetRef, {"user": uid, "parent": id});

    if (!(await (retweetRef.get())).exists) {
      batch.update(mainRef, {"numRetweets": FieldValue.increment(1)});
    }

    batch.commit();
  }

  Stream<UserData> streamUserData() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('users').doc(user.uid);
        return ref
            .snapshots()
            .map((doc) => UserData.fromJson(doc.data()!, id: user.uid));
      } else {
        return Stream.fromIterable([UserData(dateJoined: DateTime.now())]);
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

  Stream<List<Future<Tweet>>> streamComments(String userId, String id) {
    var ref = _db
        .collection("tweets")
        .doc(id)
        .collection("comments")
        .limit(7)
        .orderBy("timeSent", descending: true);

    var tweets = ref.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    return tweets;
  }

  Stream<List<Future<Tweet>>> streamTweets(String userId) {
    var ref =
        _db.collection("tweets").limit(7).orderBy("timeSent", descending: true);

    var tweets = ref.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var retweets =
        _db.collectionGroup("retweetedBy").limit(7).snapshots().map((event) {
      return event.docs.map((e) async {
        var parent = Retweet.fromJson(e.data()).parent;
        var user = await _db
            .collection("users")
            .doc(Retweet.fromJson(e.data()).user)
            .get();

        var parentsRef = _db.collection("tweets").doc(parent);

        var parentData = await parentsRef.get();

        var choicesRef =
            _db.collection("tweets").doc(parent).collection("choices");
        var votersRef =
            _db.collection("tweets").doc(parent).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(parent).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(parent).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          parentData.data()!,
          id: parent,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
          retweeted: UserData.fromJson(user.data()!, id: user.id),
        );
        return tweet;
      }).toList();
    });

    Stream<List<Future<Tweet>>> combinedStream = Stream.fromFuture(Future.wait([
      tweets.first,
      retweets.first,
    ]).then((lists) {
      return lists[0]..addAll(lists[1]);
    }));

    return combinedStream;
  }

  Stream<List<Future<Tweet>>> streamUserTweets(String userId) {
    var ref = _db
        .collection("tweets")
        .where("authorUid", isEqualTo: userId)
        .limit(7)
        .orderBy("timeSent", descending: true);

    var tweets = ref.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var retweets = _db
        .collectionGroup("retweetedBy")
        .where("user", isEqualTo: userId)
        .limit(7)
        .snapshots()
        .map((event) {
      return event.docs.map((e) async {
        var parent = Retweet.fromJson(e.data()).parent;
        var user = await _db
            .collection("users")
            .doc(Retweet.fromJson(e.data()).user)
            .get();

        var parentsRef = _db.collection("tweets").doc(parent);

        var parentData = await parentsRef.get();

        var choicesRef =
            _db.collection("tweets").doc(parent).collection("choices");
        var votersRef =
            _db.collection("tweets").doc(parent).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(parent).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(parent).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          parentData.data()!,
          id: parent,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
          retweeted: UserData.fromJson(user.data()!, id: user.id),
        );
        return tweet;
      }).toList();
    });

    Stream<List<Future<Tweet>>> combinedStream = Stream.fromFuture(Future.wait([
      tweets.first,
      retweets.first,
    ]).then((lists) {
      return lists[0]..addAll(lists[1]);
    }));

    return combinedStream;
  }

  Stream<List<Future<Tweet>>> streamUserMedia(String userId) {
    //audio

    var refMedia = _db
        .collection("tweets")
        .where("authorUid", isEqualTo: userId)
        .where("imagePathsOrUrls", isNull: false)
        .limit(7);

    var tweets = refMedia.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var retweets = _db
        .collectionGroup("retweetedBy")
        .where("imagePathsOrUrls", isNull: false)
        .where("user", isEqualTo: userId)
        .limit(7)
        .snapshots()
        .map((event) {
      return event.docs.map((e) async {
        var parent = Retweet.fromJson(e.data()).parent;
        var user = await _db
            .collection("users")
            .doc(Retweet.fromJson(e.data()).user)
            .get();

        var parentsRef = _db.collection("tweets").doc(parent);

        var parentData = await parentsRef.get();

        var choicesRef =
            _db.collection("tweets").doc(parent).collection("choices");
        var votersRef =
            _db.collection("tweets").doc(parent).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(parent).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(parent).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          parentData.data()!,
          id: parent,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
          retweeted: UserData.fromJson(user.data()!, id: user.id),
        );
        return tweet;
      }).toList();
    });

    //media

    var mediaRef = _db
        .collection("tweets")
        .where("authorUid", isEqualTo: userId)
        .where("audioUrl", isNull: false)
        .limit(7);

    var mediaTweets = mediaRef.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var mediaRetweets = _db
        .collectionGroup("retweetedBy")
        .where("user", isEqualTo: userId)
        .where("audioUrl", isNull: false)
        .limit(7)
        .snapshots()
        .map((event) {
      return event.docs.map((e) async {
        var parent = Retweet.fromJson(e.data()).parent;
        var user = await _db
            .collection("users")
            .doc(Retweet.fromJson(e.data()).user)
            .get();

        var parentsRef = _db.collection("tweets").doc(parent);

        var parentData = await parentsRef.get();

        var choicesRef =
            _db.collection("tweets").doc(parent).collection("choices");
        var votersRef =
            _db.collection("tweets").doc(parent).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(parent).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(parent).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          parentData.data()!,
          id: parent,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
          retweeted: UserData.fromJson(user.data()!, id: user.id),
        );
        return tweet;
      }).toList();
    });

    Stream<List<Future<Tweet>>> combinedStream = Stream.fromFuture(Future.wait([
      tweets.first,
      retweets.first,
      mediaTweets.first,
      mediaRetweets.first,
    ]).then((lists) {
      return lists[0]
        ..addAll(lists[1])
        ..addAll(lists[2])
        ..addAll(lists[3]);
    }));

    return combinedStream;
  }

  Stream<List<Future<Tweet>>> streamUserLikes(String userId) {
    var ref = _db
        .collectionGroup("heartedBuy")
        .where("user", isEqualTo: userId)
        .limit(7);

    return ref.snapshots().map(
          (event) => event.docs.map(
            (e) async {
              var parent = await e.reference.parent.parent?.get();

              var choicesRef = _db
                  .collection("tweets")
                  .doc(parent?.id ?? "")
                  .collection("choices");
              var votersRef = _db
                  .collection("tweets")
                  .doc(parent?.id ?? "")
                  .collection("voters");
              var heartedRef = _db
                  .collection("tweets")
                  .doc(parent?.id ?? "")
                  .collection("heartedBuy");
              var retweetedRef = _db
                  .collection("tweets")
                  .doc(parent?.id ?? "")
                  .collection("retweetedBy");
              var tweet = Tweet.fromJson(
                parent?.data() ??
                    Tweet(text: "", timeSent: DateTime.now(), authorUid: "")
                        .toJson(),
                id: parent?.id ?? "",
                choices: (await choicesRef.get()).docs.map((doc) {
                  return doc.data();
                }).toList(),
                voters: ((await votersRef.get()).docs.map((doc) {
                  return doc.data();
                }).toList()),
                heartedBuy: ((await heartedRef.get()).docs.map((doc) {
                  return (doc.data())["user"] as String;
                }).toList()),
                retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
                  return (doc.data());
                }).toList()),
              );
              return tweet;
            },
          ).toList(),
        );
  }

  Stream<List<Future<Tweet>>> streamUserTweetsAndComments(String userId) {
    var ref = _db
        .collection("tweets")
        .where("authorUid", isEqualTo: userId)
        .limit(7)
        .orderBy("timeSent", descending: true);

    var tweets = ref.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var commentsRef = _db
        .collectionGroup("comments")
        .where("authorUid", isEqualTo: userId)
        .limit(7)
        .orderBy("timeSent", descending: true);

    var comments = commentsRef.snapshots().map((event) {
      return event.docs.map((e) async {
        var choicesRef =
            _db.collection("tweets").doc(e.id).collection("choices");
        var votersRef = _db.collection("tweets").doc(e.id).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(e.id).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(e.id).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          e.data(),
          id: e.id,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
        );
        return tweet;
      }).toList();
    });

    var retweets = _db
        .collectionGroup("retweetedBy")
        .where("user", isEqualTo: userId)
        .limit(20)
        .snapshots()
        .map((event) {
      return event.docs.map((e) async {
        var parent = Retweet.fromJson(e.data()).parent;
        var user = await _db
            .collection("users")
            .doc(Retweet.fromJson(e.data()).user)
            .get();

        var parentsRef = _db.collection("tweets").doc(parent);

        var parentData = await parentsRef.get();

        var choicesRef =
            _db.collection("tweets").doc(parent).collection("choices");
        var votersRef =
            _db.collection("tweets").doc(parent).collection("voters");
        var heartedRef =
            _db.collection("tweets").doc(parent).collection("heartedBuy");
        var retweetedRef =
            _db.collection("tweets").doc(parent).collection("retweetedBy");
        var tweet = Tweet.fromJson(
          parentData.data()!,
          id: parent,
          choices: (await choicesRef.get()).docs.map((doc) {
            return doc.data();
          }).toList(),
          voters: ((await votersRef.get()).docs.map((doc) {
            return doc.data();
          }).toList()),
          heartedBuy: ((await heartedRef.get()).docs.map((doc) {
            return (doc.data())["user"] as String;
          }).toList()),
          retweetedBy: ((await retweetedRef.get()).docs.map((doc) {
            return (doc.data());
          }).toList()),
          retweeted: UserData.fromJson(user.data()!, id: user.id),
        );
        return tweet;
      }).toList();
    });

    Stream<List<Future<Tweet>>> combinedStream = Stream.fromFuture(Future.wait([
      tweets.first,
      retweets.first,
      comments.first,
    ]).then((lists) {
      return lists[0]
        ..addAll(lists[1])
        ..addAll(lists[2]);
    }));

    return combinedStream;
  }

  Future<String> getUniqueUsername({required String username}) async {
    String uniqueUsername = "";

    final usersRef = _db.collection("users");
    final q = usersRef
        .where("preUsername", isEqualTo: removeSpacesAndMakeLowerCase(username))
        .orderBy("username")
        .limit(1);
    final querySnapshot = await q.get();

    if (querySnapshot.docs.isEmpty) {
      uniqueUsername = username;
    } else {
      querySnapshot.docs.forEach((doc) {
        String index = UserData.fromJson(doc.data(), id: doc.id)
            .username
            .split(username)[1];
        if (index == "0") {
          index = "0";
        }
        uniqueUsername = '${username}${(int.parse(index) + 1).toString()}';
      });
    }
    return uniqueUsername;
  }

  Future<bool> checkUniqueUsername({required String username}) async {
    final usersRef = _db.collection("users");
    final q = usersRef
        .where("preUsername", isEqualTo: removeSpacesAndMakeLowerCase(username))
        .orderBy("username")
        .limit(1);
    final querySnapshot = await q.get();

    if (querySnapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getSuggestedUsernames(
      {required String email, required String name}) async {
    bool isPhone = true;

    var usernames = List.filled(6, "", growable: false);
    final phoneRegex = RegExp(
        r'^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$');

    // Regular expression for an email
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

    if (phoneRegex.matchAsPrefix(email) != null) {
      isPhone = true;
    } else if (emailRegex.matchAsPrefix(email) != null) {
      isPhone = false;
    } else {
      isPhone = true;
    }

    usernames[0] = await getUniqueUsername(
        username: !isPhone ? email.split("@")[0] : '${name}_');
    usernames[1] = await getUniqueUsername(username: name);
    usernames[2] = await getUniqueUsername(
        username: name.split(" ").length > 1 ? name.split(" ")[0] : 'the$name');
    usernames[3] = await getUniqueUsername(
        username: name.split(" ").length > 1
            ? name.split(" ")[1]
            : !isPhone
                ? '${email.split("@")[0]}_$name'
                : '_${name}_');
    usernames[4] = await getUniqueUsername(
        username: name.split(" ").length > 1
            ? '${name.split(" ")[0]}_${name.split(" ")[1]}'
            : !isPhone
                ? 'the${email.split("@")[0]}_$name'
                : '${name}${DateTime.now().year}');
    usernames[5] = await getUniqueUsername(
        username: name.split(" ").length > 1
            ? '${name.split(" ")[1]}_${name.split(" ")[0]}'
            : !isPhone
                ? '${name}_${email.split("@")[0]}'
                : '${name}_${DateTime.now().year}');

    return usernames;
  }

  void createUserData(User user) async {
    var ref = _db.collection("users").doc(user.uid);
    final usersRef = _db.collection("users");
    final q = usersRef
        .where("preUsername",
            isEqualTo: removeSpacesAndMakeLowerCase(user.displayName ?? ""))
        .orderBy("username")
        .limit(1);
    final querySnapshot = await q.get();
    String username = "";

    if (querySnapshot.docs.isEmpty) {
      username = user.displayName ?? "";
    } else {
      querySnapshot.docs.forEach((doc) {
        String index = UserData.fromJson(doc.data(), id: doc.id)
            .username
            .split(user.displayName ?? "")[1];
        if (index == "0") {
          index = "0";
        }
        username = '${user.displayName}${(int.parse(index) + 1).toString()}';
      });
    }

    ref.set({
      "displayName": user.displayName,
      "email": user.email,
      "description": "Just Joined Spark Social",
      "dateJoined": FieldValue.serverTimestamp(),
      "followers": 0,
      "following": 0,
      "username": removeSpacesAndMakeLowerCase(username),
      "profileIMG": user.photoURL,
      "phone": user.phoneNumber,
      "preUsername": removeSpacesAndMakeLowerCase(user.displayName ?? ""),
    });

    _db.collection("userRecomendations").doc(user.uid).set(
      {
        "user": user.uid,
      },
    );
  }

  void createUserDataFromCustom(
    User user, {
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
    var ref = _db.collection("users").doc(user.uid);
    final usersRef = _db.collection("users");

    String updatedUsername = "";

    if (username != null) {
      print(username);
      final q = usersRef
          .where("preUsername",
              isEqualTo: removeSpacesAndMakeLowerCase(username ?? ""))
          .orderBy("username")
          .limit(1);
      final querySnapshot = await q.get();

      if (querySnapshot.docs.isEmpty) {
        updatedUsername = username ?? "";
      } else {
        querySnapshot.docs.forEach((doc) {
          String index = UserData.fromJson(doc.data(), id: doc.id)
              .username
              .split(username ?? "")[1];
          if (index == "0") {
            index = "0";
          }
          updatedUsername = '$username${(int.parse(index) + 1).toString()}';
        });
      }
    } else {
      final q = usersRef
          .where("preUsername",
              isEqualTo: removeSpacesAndMakeLowerCase(name ?? ""))
          .orderBy("username")
          .limit(1);
      final querySnapshot = await q.get();

      if (querySnapshot.docs.isEmpty) {
        updatedUsername = name ?? "";
      } else {
        querySnapshot.docs.forEach((doc) {
          String index = UserData.fromJson(doc.data(), id: doc.id)
              .username
              .split(name ?? "")[1];
          if (index == "0") {
            index = "0";
          }
          updatedUsername = '$name${(int.parse(index) + 1).toString()}';
        });
      }
    }

    print('hi: $updatedUsername');

    String photoURL = defaultImageURL;

    if (profileIMG != null) {
      photoURL = await StorageService().UploadFile(file: profileIMG);
    }

    ref.set({
      "displayName": name,
      "email": user.email ?? user.phoneNumber,
      "description": "Just Joined Spark Social",
      "dateJoined": FieldValue.serverTimestamp(),
      "followers": 0,
      "following": 1,
      "username": removeSpacesAndMakeLowerCase(updatedUsername),
      "profileIMG": photoURL,
      "phone": user.phoneNumber ?? user.email,
      "preUsername": removeSpacesAndMakeLowerCase(username ?? name),
    });

    followers.forEach((element) {
      follow(user.uid, element);
    });

    _db.collection("userRecomendations").doc(user.uid).set(
      {
        "user": user.uid,
        "subTopics": subTopics,
        "topics": topics,
        "dob": dob,
      },
    );
  }

  void unFollowTopic(String userId, String topic) {
    _db.collection("userRecomendations").doc(userId).update({
      "topics": FieldValue.arrayRemove([topic]),
      "subTopics": FieldValue.arrayRemove([topic]),
    });
  }

  Stream<bool> isFollowing(String fromUserUid, String toUserUid) {
    return _db
        .collection("users")
        .doc(fromUserUid)
        .collection("following")
        .doc(toUserUid)
        .snapshots()
        .map((event) => event.exists);
  }

  void unFollow(String fromUserUid, String toUserUid) async {
    print('$fromUserUid : $toUserUid');
    await _db.collection("users").doc(fromUserUid).update({
      "following": FieldValue.increment(-1),
    });

    await _db.collection("users").doc(toUserUid).update({
      "followers": FieldValue.increment(-1),
    });

    await _db
        .collection("users")
        .doc(fromUserUid)
        .collection("following")
        .doc(toUserUid)
        .delete();

    return;
  }

  Stream<List<String>> getAllTopics(String userUid) {
    return (_db
        .collection("userRecomendations")
        .doc(userUid)
        .snapshots()
        .map((event) {
      if (event.data() != null) {
        print("not null");

        var dataTyped = UserRecomendation.fromJson(event.data() ?? {});

        var subTopics = dataTyped.subTopics;
        print(' hu $subTopics');

        var topics = dataTyped.topics;
        var subTopicsList = subTopics.toList();

        subTopicsList.addAll(topics);
        return subTopicsList;
      } else {
        print("null");
        return [];
      }
    }));
  }

  void follow(String fromUserUid, String toUserUid) async {
    await _db.collection("users").doc(fromUserUid).update({
      "following": FieldValue.increment(1),
    });
    await _db.collection("users").doc(toUserUid).update({
      "followers": FieldValue.increment(1),
    });

    await _db
        .collection("users")
        .doc(fromUserUid)
        .collection("following")
        .doc(toUserUid)
        .set({
      "follower": fromUserUid,
      "following": toUserUid,
    });
  }

  Future<List<UserData>> getSuggestedFollowers() async {
    var data = await _db.collection('users').orderBy("followers").get();

    return data.docs
        .map((doc) => UserData.fromJson(doc.data(), id: doc.id))
        .toList();
  }
}
