import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
import 'package:request_live_riverpods/screens/requests/requests_screen.dart';

// import '../requests/requests_screen.dart';
// import '../search/search_screen.dart';
import '../../routes.dart';
// import '../../providers/auth_provider.dart';

class AppDrawer extends HookConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authProvider = ref.watch(authControllerProvider);
    final userControlProvider = ref.watch(userControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);
    // final user = userControlProvider.retrieveUserInfo;
    final Map<String, String> userMap = {};
    return Drawer(
      child: user.when(
        loading: () => const CircularProgressIndicator(
          color: Colors.white,
        ),
        error: (error, stacktrace) => Text('Error: $error'),
        data: (userData) {
          return Column(
            children: [
              AppBar(
                title: const Text('Options'),
                automaticallyImplyLeading: false,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Main'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(Routes.welcome);
                },
              ),
              const Divider(),
              // TODO if(in app purchases (purchased) token) show 'my requests'
              userData.isEntertainer
                  ? ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('My Requests'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.requests,
                          arguments: RequestsScreenArgs(
                            // TODO figure this out!
                            userData.id, userData.username,
                          ),
                        );
                      },
                    )
                  : Container(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  // Navigator.of(context).pop();
                  _confirmSignOut(context, ref);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  _confirmSignOut(BuildContext context, WidgetRef ref) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        material: (_, PlatformTarget target) => MaterialAlertDialogData(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
        title: const Text('Alert'),
        content: const Text('This will log you out. Are you sure?'),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText('Yes'),
            onPressed: () {
              final authProvider = ref.read(authControllerProvider.notifier);

              authProvider.signOut();

              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.login, ModalRoute.withName(Routes.login));
            },
          )
        ],
      ),
    );
  }
}
