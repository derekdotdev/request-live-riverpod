import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
abstract class Location implements _$Location {
  const Location._();

  const factory Location({
    String? id,
    String? venue,
    String? address,
    required double latitude,
    required double longitude,
  }) = _Location;

  factory Location.empty() => const Location(
        venue: '',
        address: '',
        latitude: 51.53394,
        longitude: -0.17769,
      );

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  factory Location.fromDocument(doc) {
    final data = doc.data()!;
    return Location.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
