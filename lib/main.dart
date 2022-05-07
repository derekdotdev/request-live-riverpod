import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
            // TODO return an error screen (screens/unknown/error_screen.dart)
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: 120,
            width: 120,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const HomeScreen(),
              routes: Routes.routes,
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const UnknownRouteScreen(),
                );
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void navigate(BuildContext ctx, bool isEnt) {
    if (isEnt) {
      const Navigator();
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authControllerState = ref.watch(authControllerProvider);

    return authControllerState?.uid == null
        ? const SignInScreen()
        : const WelcomeScreen();

    /**
     * TODO consider switching to this (uses stream) lib/services/auth_services + lib/controlelrs/auth_providers.dart
     * OR simply fit this into what you're already using!
     * 
     * final authState = ref.watch(authStateProvider)
     * return _authState.when(loading: () {
     *  return Scaffold(body: Center(child: CircularProgessIndicator(),),);
     * }), 
     * error: (error, stacktrace)  ...,
     * data: (value) {
     *  if(value != null) {
     *  return WelcomeScreen();
     * } 
     *  return SignInScreen();
     * }
     */
  }
}
