// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserLocation _$$_UserLocationFromJson(Map<String, dynamic> json) =>
    _$_UserLocation(
      id: json['id'] as String?,
      venueName: json['venueName'] as String?,
      street_number: (json['street_number'] as num?)?.toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$_UserLocationToJson(_$_UserLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueName': instance.venueName,
      'street_number': instance.street_number,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'state': instance.state,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
