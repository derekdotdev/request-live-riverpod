import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/entertainer/entertainer_screen.dart';

class EntertainerCard extends HookConsumerWidget {
  final Map<dynamic, dynamic> snap;

  const EntertainerCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.read(authControllerProvider);
    // Do not display current user's EntertainerCard
    return snap['id'] == authProvider?.uid
        ? Container()
        : snap['isEntertainer'] == false
            ? Container()
            : snap['isLive'] == false
                ? Container()
                : GestureDetector(
                    key: ValueKey(snap['uid']),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(
                                snap['photoUrl'],
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              children: [
                                Text(
                                  snap['username'].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Navigate to entertainer's page!
                    onTap: () {
                      // TODO Navigate to entertainer's page!
                      Navigator.pushNamed(
                        context,
                        Routes.entertainer,
                        arguments: EntertainerScreenArgs(
                          // TODO figure this out!
                          snap['id'].toString(),
                          snap['username'].toString(),
                        ),
                      );
                    },
                  );
  }
}
