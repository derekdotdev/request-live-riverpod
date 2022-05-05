import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  Future<String> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final newUserId =
          await _read(authRepositoryProvider).registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      return newUserId;
    } catch (e) {
      print(e);
    }
    return 'null';
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final newUserId = await _read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
      return newUserId;
    } catch (e) {
      print(e);
    }
    return 'null';
  }

  // void appStarted() async {
  //   final user = _read(authRepositoryProvider).getcurrentUser();
  // }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
