import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
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
    // final userControllerNotifier = ref.watch(userControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: false,
        title: const Text(
          'Profile',
          style: TextStyle(
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
                              ),
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
                      child: const Text(
                        'Insert userData.bio here!',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: userData.id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data! as dynamic).docs[index];

                      return Container(
                        child: Image(
                          image: NetworkImage(snap['postUrl']),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              )
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
