import 'package:firebase_auth/firebase_auth.dart';

// TODO switch from old(auth_controller) to new (this) auth provider??

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return "Signup Successful";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
