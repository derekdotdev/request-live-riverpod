import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';

class NewRequestForm extends HookConsumerWidget {
  NewRequestForm(this.entertainerId, this.entertainerUsername, this.isLoading,
      this.submitRequestFn,
      {Key? key})
      : super(key: key);

  final String entertainerId;
  final String entertainerUsername;
  final bool isLoading;
  final Future<void> Function(
      {required WidgetRef ref,
      required BuildContext ctx,
      required String artist,
      required String title,
      required String notes,
      required String entertainerId,
      required String entertainerUsername,
      required String requesterId,
      required String requesterUsername,
      required String requesterPhotoUrl}) submitRequestFn;

  final _formKey = GlobalKey<FormState>();
  final Map<String, String> requestMap = {};
  final _artistController = useTextEditingController();
  final _titleController = useTextEditingController();
  final _notesController = useTextEditingController();
  final _titleFocusNode = useFocusNode();
  final _notesFocusNode = useFocusNode();

  Future<void> _trySubmit(BuildContext context, WidgetRef ref) async {
    // Run validation on Artist & Title TextFormFields
    final isValid = _formKey.currentState!.validate();

    // Close the soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      // Save Form Data
      _formKey.currentState!.save();

      // Call parent function
      submitRequestFn(
        ref: ref,
        ctx: context,
        artist: requestMap['artist'] ?? 'requestFormError',
        title: requestMap['title'] ?? 'requestFormError',
        notes: requestMap['notes'] ?? 'requestFormError',
        entertainerId: requestMap['entertainerId'] ?? 'requestFormError',
        entertainerUsername:
            requestMap['entertainerUsername'] ?? 'requestFormError',
        requesterId: requestMap['requesterId'] ?? 'requestFormError',
        requesterUsername:
            requestMap['requesterUsername'] ?? 'requestFormError',
        requesterPhotoUrl:
            requestMap['requesterPhotoUrl'] ?? 'requestFormError',
      );

      // Clear TextFields
      _clearFields();
    }
  }

  void _clearFields() {
    _artistController.clear();
    _titleController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Store user info from userControllerProvider to requestMap
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, _) {
                      return ref.watch(userControllerProvider).when(
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stacktrace) => Text(error.toString()),
                          data: (user) {
                            requestMap['requesterId'] = user.id;
                            requestMap['requesterUsername'] =
                                user.username == ""
                                    ? user.email
                                    : user.username;
                            requestMap['requesterPhotoUrl'] = user.photoUrl;
                            requestMap['entertainerId'] = entertainerId;
                            requestMap['entertainerUsername'] =
                                entertainerUsername;
                            return const SizedBox();
                          });
                    },
                  ),
                  // Artist Input
                  TextFormField(
                    controller: _artistController,
                    key: const ValueKey('artist'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Artist'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_titleFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the artist\'s name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      requestMap['artist'] = value!.trim();
                    },
                  ),
                  // Title Input
                  TextFormField(
                    controller: _titleController,
                    key: const ValueKey('title'),
                    focusNode: _titleFocusNode,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    decoration: const InputDecoration(labelText: 'Song Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_notesFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the song title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      requestMap['title'] = value!.trim();
                    },
                  ),
                  // Additional Notes
                  TextFormField(
                    controller: _notesController,
                    key: const ValueKey('notes'),
                    focusNode: _notesFocusNode,
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'It\'s my birthday!',
                      labelText: 'Notes',
                    ),
                    onSaved: (value) {
                      requestMap['notes'] = value!.trim();
                    },
                  ),

                  const SizedBox(height: 10),
                  // Send it!
                  TextButton.icon(
                    onPressed: () => _trySubmit(context, ref),
                    icon: const Icon(
                      Icons.send,
                      size: 30,
                    ),
                    label: const Text(
                      'Send',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
