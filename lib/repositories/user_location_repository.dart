import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/extensions/firebase_firestore_extension.dart';
import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/user_location_model.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';

abstract class BaseUserRepository {
  Future<void> createLocation({
    required String userId,
    required UserLocation location,
  });
  Future<UserLocation> retrieveUserLocation({required String userId});
  Future<void> updateUserLocation(
      {required String userId, required UserLocation location});
}

final userRepositoryProvider =
    Provider<UserLocationRepository>((ref) => UserLocationRepository(ref.read));

class UserLocationRepository implements BaseUserRepository {
  final Reader _read;

  const UserLocationRepository(this._read);

  @override
  Future<void> createLocation({
    required String userId,
    required UserLocation location,
  }) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersLocationDocRef(userId)
          .set(location.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> updateUserLocation(
      {required String userId, required UserLocation location}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersLocationDocRef(userId)
          .update(location.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<UserLocation> retrieveUserLocation({required String userId}) async {
    try {
      final doc = await _read(firebaseFirestoreProvider)
          .usersLocationDocRef(userId)
          .get();
      return UserLocation.fromDocument(doc);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
