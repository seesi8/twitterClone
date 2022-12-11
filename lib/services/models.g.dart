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
