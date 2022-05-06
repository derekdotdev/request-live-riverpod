// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Request _$$_RequestFromJson(Map<String, dynamic> json) => _$_Request(
      id: json['id'] as String?,
      artist: json['artist'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String,
      requesterId: json['requesterId'] as String,
      requesterUsername: json['requesterUsername'] as String,
      requesterPhotoUrl: json['requesterPhotoUrl'] as String,
      entertainerId: json['entertainerId'] as String,
      played: json['played'] as bool? ?? false,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$$_RequestToJson(_$_Request instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artist': instance.artist,
      'title': instance.title,
      'notes': instance.notes,
      'requesterId': instance.requesterId,
      'requesterUsername': instance.requesterUsername,
      'requesterPhotoUrl': instance.requesterPhotoUrl,
      'entertainerId': instance.entertainerId,
      'played': instance.played,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
