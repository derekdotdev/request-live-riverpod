import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/extensions/firebase_firestore_extension.dart';
import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/user_model.dart' as local_user;
import 'package:request_live_riverpods/repositories/custom_exception.dart';

abstract class BaseUserRepository {
  Future<void> createUser({
    required String userId,
    required local_user.User localUser,
  });
  Future<local_user.User> retrieveFirestoreUser({required String userId});

  // Future<void> updateUserIsLive({required String userId, required bool isLive});
}

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository(ref.read));

class UserRepository implements BaseUserRepository {
  final Reader _read;

  const UserRepository(this._read);

  @override
  Future<void> createUser({
    required String userId,
    required local_user.User localUser,
  }) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersDocRef(userId)
          .set(localUser.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<bool> updateUserLiveStatus(
      {required local_user.User localUser}) async {
    try {
      final newStatus = !localUser.isLive;
      final updatedStatus = localUser.copyWith(isLive: newStatus);
      await _read(firebaseFirestoreProvider)
          .usersDocRef(localUser.id)
          .update(updatedStatus.toDocument());
      return newStatus;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> updateUserProfile({required local_user.User localUser}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersDocRef(localUser.id)
          .update(localUser.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<local_user.User> updateUserPhoto(
      {required local_user.User localUser,
      required Uint8List image,
      required String childName}) async {
    try {
      final Reference storageRef = _read(firebaseStorageProvider)
          .ref()
          .child(childName)
          .child(localUser.id);

      final UploadTask uploadTask = storageRef.putData(image);

      final TaskSnapshot snapshot = await uploadTask;

      final String newPhotoUrl = await snapshot.ref.getDownloadURL();

      final newUser = localUser.copyWith(photoUrl: newPhotoUrl);

      await _read(firebaseFirestoreProvider)
          .usersDocRef(newUser.id)
          .update(newUser.toDocument());

      return newUser;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<local_user.User> retrieveFirestoreUser(
      {required String userId}) async {
    try {
      final doc =
          await _read(firebaseFirestoreProvider).usersDocRef(userId).get();
      return local_user.User.fromDocument(doc);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
