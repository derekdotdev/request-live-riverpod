import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/models/user_model.dart' as local_user;
import 'package:request_live_riverpods/repositories/user_repository.dart';
import 'custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<String> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  );
  // Future<void> signInAnonymously();
  User? currentFirebaseAuthUser();

  Future<local_user.User> currentFirestoreUser();

  Future<void> signOut();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  registering
}

class AuthRepository implements BaseAuthRepository {
  // Reader allows AuthRepository to read other providers in the app
  // In this case, we need to read FirebaseAuth.instance from FirebaseAuthProvider
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  Future<String> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      Status.authenticating;
      final userCred = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCred.user != null) {
        final userId = userCred.user!.uid;
        Status.authenticated;
        return userId;
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
    return 'null';
  }

  @override
  User? currentFirebaseAuthUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<local_user.User> currentFirestoreUser() async {
    try {
      final user = currentFirebaseAuthUser();

      if (user?.uid != null) {
        return await _read(userRepositoryProvider)
            .retrieveFirestoreUser(userId: user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
    throw UnimplementedError();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      Status.authenticating;
      final userCred = await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      Status.authenticated;
      if (userCred.user != null) {
        return userCred.user!.uid;
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
    return 'null';
  }

  // @override
  // Future<void> signInAnonymously() async {
  //   try {
  //     await _read(firebaseAuthProvider).signInAnonymously();
  //   } on FirebaseAuthException catch (e) {
  //     throw CustomException(message: e.message);
  //   }
  // }

  @override
  Future<void> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
      Status.unauthenticated;
      // await signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
