import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/constants/constants.dart';
import 'package:request_live_riverpods/controllers/request_state_controller.dart';
import 'package:request_live_riverpods/models/request_model.dart';
import 'package:request_live_riverpods/resources/conversions.dart';

class RequestDetailScreenArgs {
  final Request request;
  RequestDetailScreenArgs(this.request);
}

class RequestDetailScreen extends HookConsumerWidget {
  const RequestDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final width = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailScreenArgs;
    print('Request Detail Screen > args.request.id: ');
    print(args.request.id);

    final requestStateController =
        ref.watch(requestStateControllerProvider(args.request.id!).notifier);

    final requestState =
        ref.watch(requestStateControllerProvider(args.request.id!));

    void updatePlayedStatus({required Request request}) {
      // final updateRequest = request.copyWith(played: !request.played);
      requestStateController.updateRequestPlayed(request: request);
    }

    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Request Details',
        ),
      ),
      // drawer: AppDrawer(),
      body: requestState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        error: (error, stacktrace) => Text('Error: $error'),
        data: (requestData) {
          var _isPlayed = requestData.played;

          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          margin: const EdgeInsets.only(top: 16),
                          elevation: 4,
                          color: kCardBackgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: NetworkImage(
                                    args.request.requesterPhotoUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  args.request.requesterUsername,
                                  style: kRequestDetailStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Card(
                        elevation: 4,
                        color: kCardBackgroundColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RequestRowOld(
                                section: 'Artist: ',
                                details: args.request.artist,
                                maxLines: 1,
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RequestRowOld(
                                section: 'Title: ',
                                details: args.request.title,
                                maxLines: 1,
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RequestColumn(
                                section: 'Notes: ',
                                details: args.request.notes,
                                maxLines: 3,
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RequestRowOld(
                                section: 'Time: ',
                                details: Conversions.convertTimestamp(
                                    args.request.timestamp),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Card(
                        elevation: 4,
                        color: kCardBackgroundColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                              ),
                              child: Text(
                                _isPlayed
                                    ? 'You played it!'
                                    : 'Did you play it??',
                                style: kRequestDetailStyle,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Switch.adaptive(
                                value: _isPlayed,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
                                  updatePlayedStatus(request: requestData);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RequestColumn extends StatelessWidget {
  final String section;
  final String details;
  final int maxLines;

  const RequestColumn({
    Key? key,
    required this.section,
    required this.details,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            section,
            style: kRequestDetailStyle,
          ),
        ),
        Flexible(
          // flex: 2,
          child: Text(
            details == '' ? 'none' : details,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestRowOld extends StatelessWidget {
  final String section;
  final String details;
  final int maxLines;

  const RequestRowOld({
    Key? key,
    required this.section,
    required this.details,
    required this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Text(
            section,
            style: kRequestDetailStyle,
          ),
        ),
        Flexible(
          flex: 2,
          child: Text(
            details == '' ? 'none' : details,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

//
// Future<void> _updateRequest(
//     String artist,
//     String title,
//     String notes,
//     BuildContext ctx,
//     ) async {
//   final authUser = authProvider.user.map((event) => event.uid);
//   final user = FirebaseAuth.instance.currentUser;
//   // Hide soft keyboard
//   FocusScope.of(context).unfocus();
//
//   // Persist request to database
//   try {
//     if (user == null) {
//       print('authProvider.user == null!');
//     } else {
//       await FirebaseFirestore.instance
//           .collection('entertainers')
//           .doc(args.entertainerUid)
//           .collection('requests')
//           .add(
//         {
//           'artist': artist,
//           'title': title,
//           'notes': notes,
//           'requested_by': user.uid,
//           'entertainer_id': args.entertainerUid,
//           'timestamp': Timestamp.now(),
//         },
//       );
//
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('Your request has been sent!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   } catch (err) {
//     ScaffoldMessenger.of(ctx).showSnackBar(
//       SnackBar(
//         content: Text('Something went wrong: ' + err.toString()),
//         backgroundColor: Theme.of(ctx).errorColor,
//       ),
//     );
//     print(err);
//     return;
//   }
// }
