import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/request_model.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';

import 'package:request_live_riverpods/extensions/firebase_firestore_extension.dart';

abstract class BaseRequestRepository {
  Future<List<Request>> retrieveRequests({required String entertainerId});

  Future<List<Request>> retrieveUserRequests({required String userId});

  Future<Request> retrieveRequest(
      {required String entertainerId, required String requestId});

  Future<String> createNewRequest({required Request request});

  Future<String> createRequest(
      {required String entertainerId, required Request request});

  Future<String> createUserRequest({required Request request});

  Future<void> updateRequestPlayed(
      {required String entertainerId, required Request request});

  Future<void> deleteRequest(
      {required String entertainerId, required String requestId});

  Future<void> deleteUserRequest(
      {required String userId, required String requestId});

  Stream<QuerySnapshot<Map<String, dynamic>>> requestsSnapshotStream(
      {required String entertainerId});

  Stream<QuerySnapshot<Map<String, dynamic>>> userRequestsSnapshotStream(
      {required String userId});
}

final requestRepositoryProvider =
    Provider<RequestRepository>((ref) => RequestRepository(ref.read));

class RequestRepository implements BaseRequestRepository {
  final Reader _read;

  const RequestRepository(this._read);

  @override
  Future<String> createNewRequest({required Request request}) async {
    try {
      final docRef = await _read(firebaseFirestoreProvider)
          .collection('requests')
          .add(request.toDocument());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<String> createRequest(
      {required String entertainerId, required Request request}) async {
    try {
      final docRef = await _read(firebaseFirestoreProvider)
          .entertainersRequestRef(entertainerId)
          .add(request.toDocument());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<String> createUserRequest({required Request request}) async {
    try {
      final docRef = await _read(firebaseFirestoreProvider)
          .usersRequestRef(request.requesterId)
          .add(request.toDocument());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<Request>> retrieveRequests(
      {required String entertainerId}) async {
    try {
      final snap = await _read(firebaseFirestoreProvider)
          .entertainersRequestRef(entertainerId)
          .get();
      return snap.docs.map((doc) => Request.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<Request>> retrieveUserRequests({required String userId}) async {
    try {
      final snap =
          await _read(firebaseFirestoreProvider).usersRequestRef(userId).get();
      return snap.docs.map((doc) => Request.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<Request> retrieveRequest(
      {required String entertainerId, required String requestId}) async {
    try {
      final doc = await _read(firebaseFirestoreProvider)
          .entertainersRequestRef(entertainerId)
          .doc(requestId)
          .get();
      return Request.fromDocument(doc);
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> updateRequestPlayed(
      {required String entertainerId, required Request request}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .entertainersRequestRef(entertainerId)
          .doc(request.id)
          .update(request.toDocument());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteRequest(
      {required String entertainerId, required String requestId}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .entertainersRequestRef(entertainerId)
          .doc(requestId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteUserRequest(
      {required String userId, required String requestId}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersRequestRef(userId)
          .doc(requestId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> requestsSnapshotStream(
      {required String entertainerId}) {
    try {
      final snaps = _read(firebaseFirestoreProvider)
          .collection('entertainers')
          .doc(entertainerId)
          .collection('requests')
          .orderBy('timestamp')
          .snapshots();
      return snaps;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> userRequestsSnapshotStream(
      {required String userId}) {
    try {
      final snaps = _read(firebaseFirestoreProvider)
          .collection('users')
          .doc(userId)
          .collection('requests')
          .orderBy('timestamp')
          .snapshots();
      return snaps;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
