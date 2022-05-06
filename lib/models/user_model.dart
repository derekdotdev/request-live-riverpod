import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default(false) bool isLive,
  }) = _User;

  factory User.empty() => const User(
      id: 'null',
      email: 'null',
      username: 'null',
      photoUrl: 'null',
      isEntertainer: false);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
  factory User.fromDocument(doc) {
    final data = doc.data()!;
    return User.fromJson(data).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson();
}
