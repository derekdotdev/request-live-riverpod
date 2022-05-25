import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/username_model.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';

abstract class BaseUsernameRepository {
  Future<void> reserveUsername({
    required Username username,
  });

  Future<bool> checkUsernameAvailable({required String username});
}

final usernameRepositoryProvider =
    Provider<UsernameRepository>((ref) => UsernameRepository(ref.read));

class UsernameRepository implements BaseUsernameRepository {
  final Reader _read;

  const UsernameRepository(this._read);

  @override
  Future<bool> checkUsernameAvailable({required String username}) async {
    try {
      final snap = await _read(firebaseFirestoreProvider)
          .collection('users')
          .doc(username)
          .get();

      if (snap.data() == null || !snap.exists) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> reserveUsername({required Username username}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection('usernames')
          .doc(username.username)
          .set(username.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
