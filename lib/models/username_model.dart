import 'package:freezed_annotation/freezed_annotation.dart';

part 'username_model.freezed.dart';
part 'username_model.g.dart';

// generate files using:
// flutter packages pub run build_runner watch --delete-conflicting-outputs
// then SAVE

@freezed
abstract class Username implements _$Username {
  const Username._();

  const factory Username({
    required String id,
    required String username,
  }) = _Username;

  factory Username.fromJson(Map<String, dynamic> json) =>
      _$UsernameFromJson(json);

  // factory User.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
  factory Username.fromDocument(doc) {
    final data = doc.data()!;
    return Username.fromJson(data);
  }

  Map<String, dynamic> toDocument() => toJson();
}
