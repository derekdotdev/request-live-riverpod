import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/new_request_controller.dart';
import 'package:request_live_riverpods/screens/entertainer/entertainer_bio.dart';
import 'package:request_live_riverpods/screens/entertainer/new_request_form.dart';

// import 'package:provider/provider.dart';

// import '../../resources/firestore_database.dart';
// import '../../providers/auth_provider.dart';

class EntertainerScreenArgs {
  final String entertainerUid;
  final String entertainerUserName;
  EntertainerScreenArgs(this.entertainerUid, this.entertainerUserName);
}

class EntertainerScreen extends HookConsumerWidget {
  final _isLoading = false;
  var userData = {};

  Future<void> _sendRequest({
    required WidgetRef ref,
    required BuildContext ctx,
    required String artist,
    required String title,
    required String notes,
    required String entertainerId,
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
            requesterUsername: requesterUsername,
            requesterPhotoUrl: requesterPhotoUrl,
          );
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Your request has been sent!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: ' + e.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      print(e);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EntertainerBio(),
          NewRequestForm(
            args.entertainerUid.toString(),
            _isLoading,
            _sendRequest,
          ),
        ],
      ),
    );
  }
}

// class EntertainerScreenHook extends HookConsumerWidget {
//   const EntertainerScreenHook({
//     Key? key,
//     required String entertainerUid,
//     required String entertainerUsername,
//   }) : super(key: key);

  

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _artistController = useTextEditingController();
//     final _titleController = useTextEditingController();
//     final _notesController = useTextEditingController();

//     final userProvider = ref.watch(userControllerProvider);
//     final newRequestProvider = ref.read(newRequestControllerProvider);

//     return;
//   }
// }
