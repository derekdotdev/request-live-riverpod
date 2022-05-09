import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/controllers.dart';
import 'package:request_live_riverpods/screens/entertainer/new_request_form.dart';

import 'package:request_live_riverpods/screens/screens.dart';
import 'package:request_live_riverpods/widgets/widgets.dart';

class EntertainerScreenArgs {
  final String entertainerId;
  final String entertainerUsername;
  EntertainerScreenArgs(this.entertainerId, this.entertainerUsername);
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

    final authControllerNotifier = ref.watch(authControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);
    final entertainer =
        ref.watch(entertainerControllerProvider(args.entertainerId));

    return entertainer.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
      error: (error, stacktrace) => Text('Error: $error'),
      data: (entertainerData) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              entertainerData.username.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: user.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.indigo)),
            error: (error, stacktrace) => Text('Error: $error'),
            data: (userData) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                entertainerData.photoUrl,
                              ),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // TODO figure this out!
                                      buildStatColumn(0, "requests played"),
                                      buildStatColumn(0, "followers"),
                                      buildStatColumn(0, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      args.entertainerId != userData.id
                                          ? FollowButton(
                                              text: 'Follow',
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                // TODO implement 'follow' functionality
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      args.entertainerId == userData.id
                                          ? FollowButton(
                                              text: 'Sign Out',
                                              backgroundColor: Colors.white,
                                              textColor: Colors.black,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                authControllerNotifier
                                                    .signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignInScreen(),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Padding
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Text(
                            entertainerData.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                            top: 1,
                          ),
                          child: Text(
                            entertainerData.bio == ''
                                ? '${entertainerData.username} has not uploaded a bio yet...'
                                : entertainerData.bio,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Center(
                    child: Text(
                      'Send a request to ${args.entertainerUsername}!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  NewRequestForm(
                    args.entertainerId.toString(),
                    args.entertainerUsername.toString(),
                    _isLoading,
                    _sendRequest,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}


//         }),
//       Container(
//         alignment = Alignment.center,
//         child = SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const EntertainerBio(),
//               NewRequestForm(
//                 args.entertainerId.toString(),
//                 args.entertainerUsername.toString(),
//                 _isLoading,
//                 _sendRequest,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
