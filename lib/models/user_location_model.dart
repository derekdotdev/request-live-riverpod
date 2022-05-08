import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location_model.freezed.dart';
part 'user_location_model.g.dart';

@freezed
// @JsonSerializable(explicitToJson: true)
abstract class UserLocation implements _$UserLocation {
  const UserLocation._();

  const factory UserLocation({
    String? id,
    String? venueName,
    // ignore: non_constant_identifier_names
    double? street_number,
    String? address,
    String? city,
    String? postalCode,
    String? state,
    String? country,
    @JsonKey(nullable: true) required double latitude,
    @JsonKey(nullable: true) required double longitude,
  }) = _UserLocation;

  factory UserLocation.empty() => const UserLocation(
        venueName: '',
        address: '',
        latitude: 51.53394,
        longitude: -0.17769,
      );

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  factory UserLocation.fromDocument(doc) {
    final data = doc.data()!;
    return UserLocation.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
