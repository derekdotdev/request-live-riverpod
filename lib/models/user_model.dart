import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:request_live_riverpods/models/models.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

// generate files using:
// flutter packages pub run build_runner watch --delete-conflicting-outputs
// then SAVE

@freezed
abstract class User implements _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    required String username,
    String? displayName,
    String? phoneNumber,
    String? bio,
    String? website,
    required String photoUrl,
    required bool isEntertainer,
    required UserLocation location,
    bool? podcastMode,
    @Default(false) bool isLive,
  }) = _User;

  factory User.empty() => User(
        id: 'null',
        email: 'null',
        username: 'null',
        photoUrl: 'null',
        isEntertainer: false,
        podcastMode: false,
        location: UserLocation.empty(),
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
  factory User.fromDocument(doc) {
    final data = doc.data()!;
    return User.fromJson(data).copyWith(id: doc.id);
  }
  // location: UserLocation.fromDocument(doc.dalocation)

  Map<String, dynamic> toDocument() => toJson();
}
