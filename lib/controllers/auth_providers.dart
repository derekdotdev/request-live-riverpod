import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:request_live_riverpods/services/auth_services.dart';

// TODO switch from old(auth_controller) to new (this) auth provider??

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authServicesProvider = Provider<AuthenticationService>(
    ((ref) => AuthenticationService(ref.read(firebaseAuthProvider))));

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServicesProvider).authStateChange);
