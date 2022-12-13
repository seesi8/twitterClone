import 'package:cloud_firestore/cloud_firestore.dart';
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
class UserData {
  String displayName;
  String email;
  String profileIMG;
  int followers;
  int following;
  String username;
  String id;

  UserData(
      {this.displayName = '',
      this.email = '',
      this.username = '',
      this.profileIMG = '',
      this.followers = 0,
      this.following = 0,
      this.id = ''});

  factory UserData.fromJson(Map<String, dynamic> json, String id) {
    json["id"] = id;
    var result = _$UserDataFromJson(json);
    return result;
  }
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

enum AudioState { Recording, Stopped, Paused }

class LengthTime {
  final num hours;
  final num days;
  final num min;

  const LengthTime({
    this.hours = 0,
    this.days = 0,
    this.min = 0,
  });
}

class Poll {
  List<String> choices;
  LengthTime lengthTime;

  Poll({
    required this.choices,
    this.lengthTime = const LengthTime(),
  });
}

class Tweet {
  Poll? poll;
  String text;
  List<String>? imagePaths;
  String? audioUrl;
  DateTime timeSent;
  String authorUid;
  int numHearts;
  int numComments;
  int numRetweets;

  Tweet({
    required this.text,
    this.poll,
    this.imagePaths,
    this.audioUrl,
    required this.timeSent,
    required this.authorUid,
    this.numComments = 0,
    this.numHearts = 0,
    this.numRetweets = 0,
  });
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
