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
    required String bio,
    String? website,
    required String photoUrl,
    required bool isEntertainer,
    required UserLocation location,
    @Default(false) bool isOnStage,
    @Default(false) bool isLive,
  }) = _User;

  factory User.empty() => User(
      id: 'null',
      email: 'null',
      username: 'null',
      bio: '',
      photoUrl: 'https://i.stack.imgur.com/l60Hf.png',
      isEntertainer: false,
      isOnStage: false,
      location: UserLocation.empty(),
      website: '');

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
  factory User.fromDocument(doc) {
    final data = doc.data()!;
    return User.fromJson(data).copyWith(id: doc.id);
  }
  // location: UserLocation.fromDocument(doc.dalocation)

  Map<String, dynamic> toDocument() => toJson();
}
