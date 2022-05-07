import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_model.freezed.dart';
part 'request_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

class TimestampNullableConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampNullableConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class Request implements _$Request {
  const Request._();

  const factory Request({
    String? id,
    required String artist,
    required String title,
    required String notes,
    required String requesterId,
    required String requesterUsername,
    required String requesterPhotoUrl,
    required String entertainerId,
    required String entertainerUsername,
    @Default(false) bool played,
    @TimestampConverter() required DateTime timestamp,
    // @TimestampConverter() required DateTime timestamp,
  }) = _Request;

  factory Request.empty() => Request(
        artist: '',
        title: '',
        notes: '',
        requesterId: '',
        requesterUsername: '',
        requesterPhotoUrl: '',
        entertainerId: '',
        entertainerUsername: '',
        timestamp: DateTime.now(),
      );

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  // BOLO for issues caused by this .fromDocument(doc) method.
  factory Request.fromDocument(doc) {
    final data = doc.data()!;
    return Request.fromJson(data)
        .copyWith(id: doc.id, timestamp: doc['timestamp'].toDate());
  }

  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
