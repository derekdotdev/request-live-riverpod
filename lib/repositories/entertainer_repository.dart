import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/user_model.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';

import 'package:request_live_riverpods/extensions/firebase_firestore_extension.dart';

abstract class BaseEntertainerRepository {
  Future<List<User>> retrieveEntertainersList();
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersStream();
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersSearchStream(
      String username);
  Future<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersSearchFuture(
      String username);
}

final entertainerRepositorySearchFutureProvider =
    FutureProvider.family<Future<QuerySnapshot<Map<String, dynamic>>>, String>(
        (ref, username) async {
  ref.onDispose(() {});
  return EntertainerRepository(ref.read)
      .retrieveEntertainersSearchFuture(username);
});
final entertainerRepositorySearchProvider =
    StreamProvider.family<Stream<QuerySnapshot<Map<String, dynamic>>>, String>(
        (ref, username) async* {
  ref.onDispose(() {});
  yield EntertainerRepository(ref.read)
      .retrieveEntertainersSearchStream(username);
});

final entertainerRepositoryStreamProvider =
    StreamProvider<Stream<QuerySnapshot<Map<String, dynamic>>>>((ref) async* {
  ref.onDispose(() {});
  yield EntertainerRepository(ref.read).retrieveEntertainersStream();
});

class EntertainerRepository implements BaseEntertainerRepository {
  final Reader _read;

  const EntertainerRepository(this._read);

  @override
  Future<List<User>> retrieveEntertainersList() async {
    try {
      final snap = await _read(firebaseFirestoreProvider)
          .usersRef()
          .where('isEntertainer', isEqualTo: true)
          .get();
      return snap.docs.map((doc) => User.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersStream() {
    try {
      final snaps = _read(firebaseFirestoreProvider)
          .collection('users')
          .where('isEntertainer', isEqualTo: true)
          .snapshots();
      return snaps;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersSearchStream(
      String username) {
    try {
      final snaps = _read(firebaseFirestoreProvider)
          .collection('users')
          .where('isEntertainer', isEqualTo: true)
          .where('username', isGreaterThanOrEqualTo: username)
          .snapshots();
      return snaps;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersSearchFuture(
      String username) async {
    try {
      return await _read(firebaseFirestoreProvider)
          .collection('users')
          .where('isEntertainer', isEqualTo: true)
          .where('username', isGreaterThanOrEqualTo: username)
          .get();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
