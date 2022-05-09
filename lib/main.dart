import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/firebase_options.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
    final userController = ref.watch(userControllerProvider);

    return authControllerState?.uid == null
        ? const SignInScreen()
        : userController.when(
            data: (userData) {
              return userData.isEntertainer
                  ? const RequestsScreen()
                  : const WelcomeScreen();
            },
            error: (error, stacktrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
  }
}


// userController.when(
//         loading: () => const Center(
//               child: CircularProgressIndicator(color: Colors.green),
//             ),
//         error: (error, stacktrace) => Text('Error: $error'),
//         data: (userData) => userData.isEntertainer
//             ? const RequestsScreen()
//             : const WelcomeScreen());