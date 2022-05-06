import 'package:flutter/material.dart';
import 'package:request_live_riverpods/routes.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      body:
          LayoutBuilder(builder: (context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(children: [
              const Text('404 Page Not Found...'),
              TextButton(
                child: const Text('Return to Login'),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.login);
                },
              ),
            ]),
          ),
        );
      }),
    );
  }
}
