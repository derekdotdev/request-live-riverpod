import 'package:cloud_firestore/cloud_firestore.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  CollectionReference entertainersRequestRef(String entertainerId) =>
      collection('entertainers').doc(entertainerId).collection('requests');

  CollectionReference usersRequestRef(String userId) =>
      collection('users').doc(userId).collection('requests');

  CollectionReference usersRef() => collection('users');

  DocumentReference usersDocRef(String userId) =>
      collection('users').doc(userId);
}
