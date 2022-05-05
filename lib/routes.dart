import 'package:flutter/material.dart';
import 'package:request_live_riverpods/screens/auth/register_screen.dart';
import 'package:request_live_riverpods/screens/auth/sign_in_screen.dart';
import 'package:request_live_riverpods/screens/home/welcome_screen.dart';
import 'package:request_live_riverpods/screens/entertainer/entertainer_screen.dart';
import 'package:request_live_riverpods/screens/requests/request_detail_screen.dart';
import 'package:request_live_riverpods/screens/requests/requests_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiating this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String entertainer = '/entertainer';
  static const String welcome = '/welcome';
  static const String requests = '/requests';
  static const String requestDetail = '/request-detail';

  static final routes = <String, WidgetBuilder>{
    // splash: (BuildContext context) => const SplashScreen(),
    login: (BuildContext context) => const SignInScreen(),
    register: (BuildContext context) => const RegisterScreen(),
    welcome: (BuildContext context) => const WelcomeScreen(),
    requests: (BuildContext context) => const RequestsScreen(),
    requestDetail: (BuildContext context) => RequestDetailScreen(),
    entertainer: (BuildContext context) => EntertainerScreen(),
  };
}
