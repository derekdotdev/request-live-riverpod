import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/request_list_controller.dart';
import 'package:request_live_riverpods/controllers/request_stream_controller.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';
import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/requests/request_card.dart';
import 'package:request_live_riverpods/screens/screens.dart';
import 'package:request_live_riverpods/widgets/widgets.dart';

class RequestsScreenArgs {
  final String entertainerUid;
  final String entertainerUserName;
  RequestsScreenArgs(this.entertainerUid, this.entertainerUserName);
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  static const routeName = '/requests/';

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

// Keeping StatefulWidget for FBM capabilities in initState().
// Is there a way around this?
class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // print('User granted permission: ${settings.authorizationStatus}');

    // Enable FirebaseMessaging
    final fbm = FirebaseMessaging.instance;

    // Ask for push notification permission (iOS)
    fbm.requestPermission();

    // Handle notifications which call back from background (resume)
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });

    // Handle notifications which re-open (launch) the app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });

    // fbm.subscribeToTopic('requests/entertainer.uid/all');
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return const RequestsScreenHook();
  }
}

class RequestsScreenHook extends HookConsumerWidget {
  const RequestsScreenHook({Key? key}) : super(key: key);

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
    final userControllerNotifier = ref.watch(userControllerProvider.notifier);
    final user = ref.watch(userControllerProvider);

    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>> requestsStream =
        ref.watch(requestStreamControllerProvider);

    final requestListController =
        ref.watch(requestListControllerProvider.notifier);

    Future<void> updateLiveStatus({required User user}) async {
      await userControllerNotifier.updateUser(user: user);
    }

    Future<void> updateUserLocation(
        {required User user, required UserLocation location}) async {
      await userControllerNotifier.updateUserLocation(
          user: user, location: location);
    }

    Future<void> _goLiveOnStage(User userData) async {
      // await updateLiveStatus(user: userData);

      final userLocation = await Navigator.pushNamed(
        context,
        Routes.goLiveOnStage,
        arguments: GoLiveScreenArgs(
            entertainerId: userData.id, entertainerUsername: userData.username),
      ) as UserLocation;

      if (userLocation.venueName.isNotEmpty) {
        await userControllerNotifier.setUserLiveAtLocation(
            user: userData, location: userLocation, isOnStage: true);
      }
    }

    Future<void> _goLiveOnAir(User userData) async {
      // await updateLiveStatus(user: userData);

      final UserLocation userLocation = await Navigator.pushNamed(
        context,
        Routes.goLiveOnAir,
        arguments: GoLiveScreenArgs(
            entertainerId: userData.id, entertainerUsername: userData.username),
      ) as UserLocation;

      await userControllerNotifier.setUserLiveAtLocation(
          user: userData, location: userLocation, isOnStage: false);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          'Your Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user.when(
        loading: () => const CircularProgressIndicator(
          color: Colors.white,
        ),
        error: (error, stacktrace) => Text('Error: $error'),
        data: (userData) {
          if (!userData.isEntertainer) {
            print('You\'re not an entertainer! How did you get here?');
            Navigator.of(context).pushReplacementNamed(Routes.welcome);
          }
          var _isLive = userData.isLive;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _isLive ? 'You\'re Live!' : 'Toggle Switch To Go Live!',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _isLive,
                  activeColor: Colors.indigo,
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.red,
                  onChanged: (value) async {
                    await updateLiveStatus(user: userData);
                  },
                ),
                TextButton.icon(
                    onPressed: () async {
                      await _goLiveOnStage(userData);
                    },
                    icon: const Icon(Icons.speaker),
                    label: Text(_isLive ? 'Go Offline' : 'Go Live!')),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Current Location
                      TextButton.icon(
                        onPressed: () async {
                          _goLiveOnStage(userData);
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text(
                          'Go Live on Stage',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Select Location
                      TextButton.icon(
                        onPressed: () async {
                          _goLiveOnAir(userData);
                        },
                        icon: const Icon(Icons.radio),
                        label: const Text(
                          'Go Live on Air',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                requestsStream.when(
                  loading: (() => const CircularProgressIndicator(
                        color: Colors.white,
                      )),
                  error: (error, stacktrace) => Text('Error: $error'),
                  data: (requestsStreamData) {
                    return StreamBuilder(
                      stream: requestsStreamData,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: const [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 16.0),
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
                                      requestListController.deleteRequest(
                                          requestId:
                                              snapshot.data!.docs[index].id);
                                    },
                                    confirmDismiss:
                                        (DismissDirection direction) =>
                                            _showConfirmationDialog(
                                                context, 'delete'),
                                    child: RequestCard(
                                        requestId:
                                            snapshot.data!.docs[index].id,
                                        snap:
                                            snapshot.data!.docs[index].data()),
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
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
