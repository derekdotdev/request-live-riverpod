import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SignInScreenHook(),
          ),
        ],
      ),
    );
  }
}

class SignInScreenHook extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  SignInScreenHook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _passwordFocusNode = useFocusNode();

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
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) => (value == null || value.isEmpty
                      ? 'Please enter a valid email address'
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 12,
                    controller: _passwordController,
                    style: Theme.of(context).textTheme.bodyText2,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {},
                    validator: (value) => (value == null || value.length < 7
                        ? 'Password must be at least 7 characters'
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
                    'Sign In',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();

                      final localUserId = await ref
                          .read(authControllerProvider.notifier)
                          .signInWithEmailAndPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim());

                      if (localUserId.isEmpty || localUserId == 'null') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error signing in...',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
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
                    'Don\'t have an account?',
                    style: Theme.of(context).textTheme.button,
                  )),
                ),
                TextButton(
                  child: Text(
                    'Create account',
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(Routes.register);
                  },
                )
              ]),
        ),
      ),
    );
  }
}
