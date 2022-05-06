import 'package:flutter/material.dart';
import 'package:request_live_riverpods/screens/screens.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiating this object

  static const String entertainer = '/entertainer';
  static const String editProfile = '/edit-profile';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String requestDetail = '/request-detail';
  static const String requests = '/requests';
  static const String splash = '/splash';
  static const String unknown = '/unknown';
  static const String welcome = '/welcome';

  static final routes = <String, WidgetBuilder>{
    entertainer: (BuildContext context) => const EntertainerScreen(),
    login: (BuildContext context) => const SignInScreen(),
    editProfile: (BuildContext context) => const EditProfileScreen('', ''),
    profile: (BuildContext context) => const ProfileScreen('', ''),
    register: (BuildContext context) => const RegisterScreen(),
    requestDetail: (BuildContext context) => RequestDetailScreen(),
    requests: (BuildContext context) => const RequestsScreen(),
    unknown: (BuildContext context) => const UnknownRouteScreen(),
    // splash: (BuildContext context) => const SplashScreen(),
    welcome: (BuildContext context) => const WelcomeScreen(),
  };
}
