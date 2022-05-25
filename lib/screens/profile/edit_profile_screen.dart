import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/models/user_model.dart';
import 'package:request_live_riverpods/widgets/scaffold_snackbar.dart';

class EditProfileScreen extends HookConsumerWidget {
  final String userId;
  final String username;
  EditProfileScreen(this.userId, this.username, {Key? key}) : super(key: key);

  var _usernameAvailable = false;

  Future<void> checkUsernameInUse(
      String username, String currentUsername, WidgetRef ref) async {
    if (username != currentUsername) {
      _usernameAvailable = await ref
          .read(usernameControllerProvider.notifier)
          .checkUsernameAvailable(username: username);
    } else {
      _usernameAvailable = true;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

    final userControllerNotifier = ref.watch(userControllerProvider.notifier);

    final user = ref.watch(userControllerProvider);

    Future<void> _updateUserPhoto({required User user}) async {
      // Instantiate image picker and pick medium-resolution image
      // final ImagePicker _picker = ImagePicker();
      // final imageFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
      // Strategy used with image_picker 0.8.5 (errors)
      final imageFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, maxWidth: 600);

      // Convert to bytes
      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();
        await userControllerNotifier.updateUserImage(
            user: user, image: imageBytes);
      }
    }

    Future<void> _updateUserProfile(
        {required User user,
        required String username,
        required String website,
        required String bio}) async {
      await userControllerNotifier.updateUserProfile(
          user: user, username: username, website: website, bio: bio);
    }

    Future<void> _updateIsEntertainer(
        {required User user, required bool value}) async {
      final updatedUser = user.copyWith(isEntertainer: value);
      await userControllerNotifier.updateUser(user: updatedUser);
    }

    return Scaffold(
      appBar: AppBar(),
      body: user.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        error: (error, stacktrace) => Text('Error: $error'),
        data: (userData) {
          var _isEntertainer = userData.isEntertainer;
          // final _usernameController =
          //     useTextEditingController(text: userData.username);
          final _websiteController =
              useTextEditingController(text: userData.website);
          final _bioController = useTextEditingController(text: userData.bio);
          final _usernameController =
              useTextEditingController(text: userData.username);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userData.photoUrl),
                          radius: 64,
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.camera),
                          onPressed: () => _updateUserPhoto(user: userData),
                          label: const Text('Change Profile Photo'),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // TODO figure out how to change username..
                        // Username (requires same validation as register screen)
                        // Can use same functionality as update user live and request played
                        // Not important right now!
                        // Will take a lot of work to update info on any prior requests
                        TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          style: Theme.of(context).textTheme.bodyText2,
                          textInputAction: TextInputAction.done,
                          onChanged: (txt) =>
                              checkUsernameInUse(txt, userData.username, ref),
                          validator: (value) => (value == null || value.isEmpty
                              ? 'Username is required'
                              : (!_usernameAvailable
                                  ? 'Username already in use'
                                  : null)),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        // Website
                        TextFormField(
                          controller: _websiteController,
                          decoration: const InputDecoration(
                            labelText: 'Website',
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.url,
                          style: Theme.of(context).textTheme.bodyText2,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).unfocus(),
                        ),
                        // Bio
                        TextFormField(
                          controller: _bioController,
                          decoration: const InputDecoration(labelText: 'Bio'),
                          autocorrect: true,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.sentences,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        TextButton(
                          child: const Text('Save Changes'),
                          onPressed: () async {
                            // Validate username choice
                            if (_formKey.currentState!.validate()) {
                              // Hide keyboard
                              FocusScope.of(context).unfocus();

                              final newUsername =
                                  _usernameController.text.trim();
                              final newSite = _websiteController.text.trim();
                              final newBio = _bioController.text.trim();

                              // Check if any changes were made
                              if ((newBio != userData.bio) ||
                                  (newSite != userData.website) ||
                                  newUsername != userData.username) {
                                try {
                                  await _updateUserProfile(
                                    user: userData,
                                    username: newUsername,
                                    website: newSite,
                                    bio: newBio,
                                  );

                                  showCustomSnackbar(
                                    ctx: context,
                                    message: 'Profile successfuly updated!',
                                    success: true,
                                  );
                                } catch (e) {
                                  showCustomSnackbar(
                                    ctx: context,
                                    message:
                                        'There was a problem updating your profile. Please try again later.',
                                    success: false,
                                  );
                                }
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _isEntertainer ? 'Premium Subscription' : 'Free Account!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Switch.adaptive(
                      value: _isEntertainer,
                      activeColor: Colors.indigo,
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onPrimary),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.red,
                      onChanged: (value) async {
                        await _updateIsEntertainer(
                            user: userData, value: value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
