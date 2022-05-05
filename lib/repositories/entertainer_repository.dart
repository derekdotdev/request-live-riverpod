import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/user_model.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';

import 'package:request_live_riverpods/extensions/firebase_firestore_extension.dart';

abstract class BaseEntertainerRepository {
  Future<List<User>> retrieveEntertainersList();
  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveEntertainersStream();
}

final entertainerRepositoryStreamProvider =
    StreamProvider<Stream<QuerySnapshot<Map<String, dynamic>>>>((ref) async* {
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
      // .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
      return snaps;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}

// final entertainerListProvider =
//     FutureProvider.autoDispose<List<User>>((ref) async {
//   return await EntertainerRepository(ref.read).retrieveEntertainersList();
// });

// final entertainerRepositoryProvider =
//     Provider<EntertainerRepository>((ref) => EntertainerRepository(ref.read));



// final entertainerRepositoryStreamProvider =
//     StreamProvider<AsyncValue<QuerySnapshot<Map<String, dynamic>>>>(
//         (ref) async* {
//   // Debug print
//   print('entertainerRepositoryStreamProvider.entry');

//   // Open the connection
//   final channel = ref
//       .read(firebaseFirestoreProvider)
//       .usersRef()
//       .where('is_entertainer', isEqualTo: true)
//       .snapshots() as AsyncValue<QuerySnapshot<Map<String, dynamic>>>;

//   yield channel;

//   // Debug print
//   print('entertainerRepositoryStreamProvider.afterChannel');

//   // yield channel as AsyncValue<Stream<QuerySnapshot<Object?>>>;

//   // Debug print
//   print('entertainerRepositoryStreamProvider.afterChannelYield');
//   // await for (final user in channel) {
//   //   yield user.docs.map((doc) => User.fromDocument(doc)).toList();
//   // }

//   // EntertainerRepository(ref.read);
// });