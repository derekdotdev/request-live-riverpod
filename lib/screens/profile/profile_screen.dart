import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
import 'package:request_live_riverpods/controllers/user_request_list_controller.dart';
import 'package:request_live_riverpods/controllers/user_request_stream_controller.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/requests/user_request_card.dart';
import 'package:request_live_riverpods/screens/screens.dart';
import 'package:request_live_riverpods/widgets/follow_button.dart';

class ProfileScreen extends HookConsumerWidget {
  final String userId;
  final String username;
  const ProfileScreen(this.userId, this.username, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProfileScreenArgs;

    final authControllerNotifier = ref.watch(authControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          args.username.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
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
                            userData.photoUrl,
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
                                  buildStatColumn(0, "posts"),
                                  buildStatColumn(0, "followers"),
                                  buildStatColumn(0, "following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  args.userId == userData.id
                                      ? FollowButton(
                                          text: 'Edit Profile',
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          borderColor: Colors.grey,
                                          function: () async {
                                            // Navigator.of(context)
                                            //     .pushNamed(Routes.editProfile);
                                            Navigator.pushNamed(
                                              context,
                                              Routes.editProfile,
                                              arguments: EditProfileScreenArgs(
                                                userData.id,
                                                userData.username,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  args.userId == userData.id
                                      ? FollowButton(
                                          text: 'Sign Out',
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          borderColor: Colors.grey,
                                          function: () async {
                                            authControllerNotifier.signOut();
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        userData.username,
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
                        userData.bio ?? 'Edit your profile to add a bio!',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // If requester and this is their page, show requests they have made
              if (args.userId == userData.id) const ProfileScreenRequestsHook(),
            ],
          );
        },
      ),
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

class ProfileScreenRequestsHook extends HookConsumerWidget {
  const ProfileScreenRequestsHook({Key? key}) : super(key: key);

  Future<bool?> _showConfirmationDialog(BuildContext context, String action) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton.icon(
              label: const Text('Yes'),
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton.icon(
              label: const Text('No'),
              icon: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>> userRequestsStream =
        ref.watch(userRequestStreamControllerProvider);

    final userRequestListController =
        ref.watch(userRequestListControllerProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Your Sent Requests',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          userRequestsStream.when(
              loading: () =>
                  const CircularProgressIndicator(color: Colors.indigo),
              error: (error, stacktrace) =>
                  Center(child: Text('Error: $error')),
              data: (requestsStreamData) {
                return StreamBuilder(
                  stream: requestsStreamData,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        // 1
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            // controller: scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            reverse: true,
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  userRequestListController.deleteRequest(
                                      requestId: snapshot.data!.docs[index].id);
                                },
                                confirmDismiss: (DismissDirection direction) =>
                                    _showConfirmationDialog(context, 'delete'),
                                child: UserRequestCard(
                                    requestId: snapshot.data!.docs[index].id,
                                    snap: snapshot.data!.docs[index].data()),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text(
                        'Whyyy',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                );
              })
        ],
      ),
    );
  }
}
