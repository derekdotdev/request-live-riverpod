import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:js/js.dart';

// @JS('google.tag_manager')
// import 'package:google_tag_manager/google_tag_manager.dart' as gtm;

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
import 'package:request_live_riverpods/controllers/username_controller.dart';
import 'package:request_live_riverpods/general_providers.dart';
import 'package:request_live_riverpods/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: RegisterScreenHook(),
          )
        ],
      ),
    );
  }
}

// TODO figure out how to fix var _usernameAvailable error
// TODO add switch for bool isEntertainer

// ignore: must_be_immutable
class RegisterScreenHook extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  var _usernameAvailable = false;

  RegisterScreenHook({Key? key}) : super(key: key);

  Future<void> checkUsernameInUse(String username, WidgetRef ref) async {
    _usernameAvailable = await ref
        .read(usernameControllerProvider.notifier)
        .checkUsernameAvailable(username: username);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _emailController = useTextEditingController();
    final _usernameController = useTextEditingController();
    final _usernameFocusNode = useFocusNode();
    final _passwordController = useTextEditingController();
    final _passwordFocusNode = useFocusNode();
    final _analytics = ref.watch(firebaseAnalyticsProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FlutterLogo(size: 128),
              ),
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                style: Theme.of(context).textTheme.bodyText2,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_usernameFocusNode);
                },
                validator: (value) => (value == null || value.isEmpty
                    ? 'Please enter an email address'
                    : null),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  style: Theme.of(context).textTheme.bodyText2,
                  focusNode: _usernameFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  onChanged: (txt) => checkUsernameInUse(txt, ref),
                  validator: (value) => (value == null || value.isEmpty
                      ? 'Username is required'
                      : (!_usernameAvailable
                          ? 'Username already in use'
                          : null)),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: 'Username',
                      border: const OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                  obscureText: true,
                  maxLength: 12,
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyText2,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  validator: (value) => (value == null || value.length < 7
                      ? 'Passwords must be at least 7 characters'
                      : null),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,
                          color: Theme.of(context).iconTheme.color),
                      labelText: 'Password',
                      border: const OutlineInputBorder()),
                ),
              ),
              TextButton(
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();

                    final email = _emailController.text.trim();
                    final username = _usernameController.text.trim();
                    // Create new FirebaseAuth User
                    final userId = await ref
                        .read(authControllerProvider.notifier)
                        .registerWithEmailAndPassword(
                          email,
                          _passwordController.text.trim(),
                        );

                    // Persist additional user info to firestore db
                    if (userId != 'null') {
                      await ref
                          .read(userControllerProvider.notifier)
                          .createNewUser(
                            userId: userId,
                            email: email,
                            username: username,
                            isEntertainer: false,
                          );
                    }

                    if (userId == 'null') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Error: An account with this email address already exists!',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // gtm.pushEvent('sign_up');
                      await _analytics.logSignUp(signUpMethod: email);
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.welcome);
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                    child: Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.button,
                )),
              ),
              TextButton(
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.login);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
