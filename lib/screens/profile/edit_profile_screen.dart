import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
// import 'package:request_live_riverpods/controllers/username_controller.dart';
import 'package:request_live_riverpods/models/user_model.dart';

import 'package:request_live_riverpods/widgets/scaffold_snackbar.dart';

class EditProfileScreen extends HookConsumerWidget {
  final String userId;
  final String username;
  const EditProfileScreen(this.userId, this.username, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

    // var _usernameAvailable = false;
    final userControllerNotifier = ref.watch(userControllerProvider.notifier);
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as EditProfileScreenArgs;
    final authControllerNotifier = ref.watch(authControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);

    // Future<void> checkUsernameInUse(String username, WidgetRef ref) async {
    //   _usernameAvailable = await ref
    //       .read(usernameControllerProvider.notifier)
    //       .checkUsernameAvailable(username: username);
    // }

    Future<void> _updateUserPhoto({required User user}) async {
      // Instantiate image picker and pick medium-resolution image
      final ImagePicker _picker = ImagePicker();
      final imageFile =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);

      // Convert to bytes
      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();
        await userControllerNotifier.updateUserImage(
            user: user, image: imageBytes);
      }
    }

    Future<void> _updateUserProfile(
        {required User user,
        required String website,
        required String bio}) async {
      await userControllerNotifier.updateUserProfile(
          user: user, website: website, bio: bio);
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
            final _usernameController =
                useTextEditingController(text: userData.username);
            final _websiteController =
                useTextEditingController(text: userData.website);
            final _bioController = useTextEditingController(text: userData.bio);

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
                          // Username (requires same validation as register screen)
                          // Can use same functionality as update user live and request played
                          // Not important right now!
                          // Will take a lot of work to update info on any prior requests
                          // TextFormField(
                          //   controller: _usernameController,
                          //   decoration:
                          //       const InputDecoration(labelText: 'Username'),
                          //   autocorrect: false,
                          //   enableSuggestions: false,
                          //   textCapitalization: TextCapitalization.none,
                          //   style: Theme.of(context).textTheme.bodyText2,
                          //   textInputAction: TextInputAction.done,
                          //   onFieldSubmitted: (_) =>
                          //       FocusScope.of(context).unfocus(),
                          // ),
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
                          // Bio (need to add bio field to user_model)
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
                              // Hide keyboard
                              FocusScope.of(context).unfocus();

                              final newBio = _bioController.text.trim();
                              final newSite = _websiteController.text.trim();

                              // Check if any changes were made
                              if ((newBio != userData.bio) ||
                                  (newSite != userData.website)) {
                                try {
                                  await _updateUserProfile(
                                    user: userData,
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
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
