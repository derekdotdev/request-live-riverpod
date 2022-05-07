import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/controllers/new_request_controller.dart';
import 'package:request_live_riverpods/screens/entertainer/entertainer_bio.dart';
import 'package:request_live_riverpods/screens/entertainer/new_request_form.dart';
import 'package:request_live_riverpods/widgets/scaffold_snackbar.dart';

class EntertainerScreenArgs {
  final String entertainerUid;
  final String entertainerUserName;
  EntertainerScreenArgs(this.entertainerUid, this.entertainerUserName);
}

class EntertainerScreen extends HookConsumerWidget {
  final _isLoading = false;

  const EntertainerScreen({Key? key}) : super(key: key);

  Future<void> _sendRequest({
    required WidgetRef ref,
    required BuildContext ctx,
    required String artist,
    required String title,
    required String notes,
    required String entertainerId,
    required String entertainerUsername,
    required String requesterId,
    required String requesterUsername,
    required String requesterPhotoUrl,
  }) async {
    try {
      await ref.read(newRequestControllerProvider.notifier).createRequest(
            artist: artist,
            title: title,
            notes: notes,
            entertainerId: entertainerId,
            entertainerUsername: entertainerUsername,
            requesterUsername: requesterUsername,
            requesterPhotoUrl: requesterPhotoUrl,
          );
      showCustomSnackbar(
          ctx: ctx, message: 'Your request has been sent!', success: true);
    } catch (e) {
      showCustomSnackbar(
          ctx: ctx,
          message: 'Something went wrong. Please try again. $e',
          success: false);
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as EntertainerScreenArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text('${args.entertainerUserName}\'s Page'),
      ),
      // drawer: AppDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const EntertainerBio(),
              NewRequestForm(
                args.entertainerUid.toString(),
                args.entertainerUserName.toString(),
                _isLoading,
                _sendRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
