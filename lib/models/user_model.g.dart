// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      photoUrl: json['photoUrl'] as String,
      isEntertainer: json['isEntertainer'] as bool,
      isLive: json['isLive'] as bool? ?? false,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'website': instance.website,
      'photoUrl': instance.photoUrl,
      'isEntertainer': instance.isEntertainer,
      'isLive': instance.isLive,
    };
