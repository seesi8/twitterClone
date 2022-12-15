// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      to: json['to'] as String? ?? '',
      from: json['from'] as String? ?? '',
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'to': instance.to,
      'from': instance.from,
    };

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      groupName: json['groupName'] as String? ?? '',
      latestMessage: json['latestMessage'] == null
          ? null
          : DateTime.parse(json['latestMessage'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'latestMessage': instance.latestMessage?.toIso8601String(),
      'groupName': instance.groupName,
      'id': instance.id,
      'members': instance.members,
      'messages': instance.messages,
    };

ThreadId _$ThreadIdFromJson(Map<String, dynamic> json) => ThreadId(
      id: json['id'] as String? ?? '',
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ThreadIdToJson(ThreadId instance) => <String, dynamic>{
      'id': instance.id,
      'members': instance.members,
    };

Username _$UsernameFromJson(Map<String, dynamic> json) => Username(
      uid: json['uid'] as String? ?? '',
    );

Map<String, dynamic> _$UsernameToJson(Username instance) => <String, dynamic>{
      'uid': instance.uid,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      profileIMG: json['profileIMG'] as String? ?? '',
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      id: json['id'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'profileIMG': instance.profileIMG,
      'followers': instance.followers,
      'following': instance.following,
      'username': instance.username,
      'id': instance.id,
    };

LengthTime _$LengthTimeFromJson(Map<String, dynamic> json) => LengthTime(
      hours: json['hours'] as num? ?? 0,
      days: json['days'] as num? ?? 0,
      min: json['min'] as num? ?? 0,
    );

Map<String, dynamic> _$LengthTimeToJson(LengthTime instance) =>
    <String, dynamic>{
      'hours': instance.hours,
      'days': instance.days,
      'min': instance.min,
    };

Poll _$PollFromJson(Map<String, dynamic> json) => Poll(
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      lengthTime: json['lengthTime'] == null
          ? const LengthTime()
          : LengthTime.fromJson(json['lengthTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'choices': instance.choices,
      'lengthTime': instance.lengthTime,
    };

Tweet _$TweetFromJson(Map<String, dynamic> json) {
  var thing = Tweet(
    text: json['text'] as String,
    poll: json['poll'] == null
        ? null
        : Poll.fromJson(json['poll'] as Map<String, dynamic>),
    imagePathsOrUrls: (json['imagePathsOrUrls'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    audioUrl: json['audioUrl'] as String?,
    timeSent: DateTime.parse(json['timeSent'] as String),
    authorUid: json['authorUid'] as String,
    numComments: json['numComments'] as int? ?? 0,
    numHearts: json['numHearts'] as int? ?? 0,
    numRetweets: json['numRetweets'] as int? ?? 0,
  );
  return thing;
}

Map<String, dynamic> _$TweetToJson(Tweet instance) => <String, dynamic>{
      'poll': instance.poll,
      'text': instance.text,
      'imagePathsOrUrls': instance.imagePathsOrUrls,
      'audioUrl': instance.audioUrl,
      'timeSent': instance.timeSent.toIso8601String(),
      'authorUid': instance.authorUid,
      'numHearts': instance.numHearts,
      'numComments': instance.numComments,
      'numRetweets': instance.numRetweets,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      message: json['message'] as String? ?? '',
      sentBy: json['sentBy'] as Map<String, dynamic>? ?? const {},
      timeSent: json['timeSent'] == null
          ? null
          : DateTime.parse(json['timeSent'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'message': instance.message,
      'sentBy': instance.sentBy,
      'timeSent': instance.timeSent?.toIso8601String(),
    };

SentBy _$SentByFromJson(Map<String, dynamic> json) => SentBy(
      profileIMG: json['profileIMG'] as String? ?? '',
      user: json['user'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );

Map<String, dynamic> _$SentByToJson(SentBy instance) => <String, dynamic>{
      'profileIMG': instance.profileIMG,
      'user': instance.user,
      'username': instance.username,
    };
