import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Request {
  String to;
  String from;
  Request({this.to = '', this.from = ''});
  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable()
class Thread {
  DateTime? createdAt;
  DateTime? latestMessage;
  String groupName;
  String id;
  List<String> members;
  List<Message> messages;

  Thread(
      {this.members = const [],
      this.messages = const [],
      this.groupName = '',
      this.latestMessage,
      this.createdAt,
      this.id = ''});
  factory Thread.fromJson(Map<String, dynamic> json, String id) {
    json["createdAt"] = ((json["createdAt"] as Timestamp).toDate().toString());
    json["id"] = id;
    json["latestMessage"] =
        ((json["latestMessage"] as Timestamp).toDate().toString());
    var result = _$ThreadFromJson(json);
    return result;
  }

  Map<String, dynamic> toJson() => _$ThreadToJson(this);
}

@JsonSerializable()
class ThreadId {
  String id;
  List<String> members;

  ThreadId({this.id = '', this.members = const []});
  factory ThreadId.fromJson(Map<String, dynamic> json) =>
      _$ThreadIdFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadIdToJson(this);
}

@JsonSerializable()
class Username {
  String uid;

  Username({this.uid = ''});

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);
  Map<String, dynamic> toJson() => _$UsernameToJson(this);
}

@JsonSerializable()
class UserRecomendation {
  List<String> topics;
  List<String> subTopics;
  String user;
  DateTime? dob;

  UserRecomendation({
    this.topics = const [],
    this.subTopics = const [],
    this.user = '',
    this.dob,
  });

  factory UserRecomendation.fromJson(Map<String, dynamic> json) {
    json["dob"] = ((json["dob"] as Timestamp).toDate().toString());

    return _$UserRecomendationFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserRecomendationToJson(this);
}

@JsonSerializable()
class UserData {
  String displayName;
  String email;
  String phone;
  String description;
  DateTime dateJoined;
  String profileIMG;
  int followers;
  int following;
  String username;
  String preUsername;
  String id;

  UserData({
    this.displayName = '',
    this.preUsername = '',
    this.phone = '',
    this.email = '',
    this.username = '',
    this.profileIMG = '',
    this.followers = 0,
    this.description = '',
    required this.dateJoined,
    this.following = 0,
    this.id = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json, {required String id}) {
    json["id"] = id;
    json["dateJoined"] =
        ((json["dateJoined"] as Timestamp).toDate().toString());
    var result = _$UserDataFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

enum AudioState { Recording, Stopped, Paused }

enum AccountTab { Tweets, TweetsAndReplies, Media, Likes }

enum TopicsTab { Followed, Suggested, Not_Interested }

@JsonSerializable()
class LengthTime {
  final num hours;
  final num days;
  final num min;

  LengthTime from(LengthTime lengthTime) {
    return LengthTime(
        hours: lengthTime.hours, days: lengthTime.days, min: lengthTime.min);
  }

  const LengthTime({
    this.hours = 0,
    this.days = 0,
    this.min = 0,
  });

  factory LengthTime.fromJson(Map<String, dynamic> json) {
    var result = _$LengthTimeFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$LengthTimeToJson(this);
}

@JsonSerializable()
class Poll {
  List<Map<String, int>> choices;
  List<Voter> voters;
  LengthTime lengthTime;
  int totalVotes;

  Poll({
    required this.choices,
    this.totalVotes = 0,
    this.voters = const [],
    this.lengthTime = const LengthTime(days: 1),
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    var result = _$PollFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$PollToJson(this);
}

@JsonSerializable()
class Voter {
  String user;

  int choice;

  Voter({
    required this.user,
    required this.choice,
  });

  factory Voter.fromJson(Map<String, dynamic> json) {
    var result = _$VoterFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$VoterToJson(this);
}

@JsonSerializable()
class Retweet {
  String user;

  String parent;

  Retweet({
    required this.user,
    required this.parent,
  });

  factory Retweet.fromJson(Map<String, dynamic> json) {
    var result = _$RetweetFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$RetweetToJson(this);
}

@JsonSerializable()
class Tweet {
  Poll? poll;
  String text;
  List<String>? imagePathsOrUrls;
  String? audioUrl;
  DateTime timeSent;
  String authorUid;
  int numHearts;
  int numComments;
  UserData? retweeted;
  String id;
  int numRetweets;
  List<String> heartedBuy;
  List<Retweet> retweetedBy;

  Tweet({
    this.heartedBuy = const [],
    this.retweetedBy = const [],
    required this.text,
    this.poll,
    this.imagePathsOrUrls,
    this.audioUrl,
    required this.timeSent,
    required this.authorUid,
    this.retweeted,
    this.numComments = 0,
    this.numHearts = 0,
    this.numRetweets = 0,
    this.id = "",
  });

  factory Tweet.fromJson(
    Map<String, dynamic> json, {
    required String id,
    List<Map<String, dynamic>>? choices,
    List<Map<String, dynamic>>? voters,
    List<Map<String, dynamic>>? retweetedBy = const [],
    UserData? retweeted,
    List<String> heartedBuy = const [],
  }) {
    json["timeSent"] = ((json["timeSent"] as Timestamp).toDate().toString());
    json["id"] = id;
    if (json["poll"] != null) {
      json["poll"]["voters"] = voters;
      json["poll"]["choices"] = choices;
    }

    json["heartedBuy"] = heartedBuy;
    json["retweetedBy"] = retweetedBy;
    json["retweeted"] = retweeted;

    var result = _$TweetFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$TweetToJson(this);
}

class LengthTimeChoices {
  final List<num> hours;
  final List<num> days;
  final List<num> min;

  LengthTimeChoices({
    required this.hours,
    required this.days,
    required this.min,
  });
}

@JsonSerializable()
class Message {
  final String message;
  final Map sentBy;
  final DateTime? timeSent;

  const Message({this.message = '', this.sentBy = const {}, this.timeSent});
  factory Message.fromJson(Map<String, dynamic> json) {
    json["timeSent"] = ((json["timeSent"] as Timestamp).toDate().toString());
    return _$MessageFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class SentBy {
  final String profileIMG;
  final String user;
  final String username;

  const SentBy({this.profileIMG = '', this.user = '', this.username = ''});

  factory SentBy.fromJson(Map<String, dynamic> json) {
    return _$SentByFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SentByToJson(this);
}
