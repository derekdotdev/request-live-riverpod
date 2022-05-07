import 'package:flutter/material.dart';

import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/resources/conversions.dart';
import 'package:request_live_riverpods/routes.dart';
import 'package:request_live_riverpods/screens/requests/request_detail_screen.dart';

class RequestCard extends StatefulWidget {
  final String requestId;
  final dynamic snap;

  const RequestCard({
    Key? key,
    required this.requestId,
    required this.snap,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late Request request = Request(
    id: widget.requestId,
    artist: widget.snap["artist"],
    title: widget.snap["title"],
    notes: widget.snap["notes"],
    requesterId: widget.snap["requesterId"],
    requesterUsername: widget.snap['requesterUsername'],
    requesterPhotoUrl: widget.snap['requesterPhotoUrl'],
    entertainerId: widget.snap["entertainerId"],
    entertainerUsername: widget.snap["entertainerUsername"],
    played: widget.snap["played"],
    timestamp: widget.snap["timestamp"].toDate(),
  );

  @override
  Widget build(BuildContext context) {
    // Do not display current user's EntertainerCard
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  widget.snap['requesterPhotoUrl'],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        RequestRowOld(
                            section: 'User:   ',
                            details:
                                widget.snap['requesterUsername'].toString()),
                        RequestRowOld(
                            section: 'Artist: ',
                            details: widget.snap['artist'].toString()),
                        RequestRowOld(
                            section: 'Title:   ',
                            details: widget.snap['title'].toString()),
                        RequestRowOld(
                            section: 'Notes: ',
                            details: widget.snap['notes'].toString()),
                        RequestRowOld(
                            section: 'Time:  ',
                            details: Conversions.convertTimestamp(
                                widget.snap['timestamp'].toDate())),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.requestDetail,
          arguments: RequestDetailScreenArgs(
            request,
          ),
        );
      },
    );
  }
}

class RequestRowOld extends StatelessWidget {
  final String section;
  final String details;

  const RequestRowOld({
    Key? key,
    required this.section,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              section,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              details,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class RequestRow extends StatelessWidget {
//   final String username;
//   final String artist;
//   final String title;
//   final String notes;
//   final String time;

//   const RequestRow({
//     Key? key,
//     required this.username,
//     required this.artist,
//     required this.title,
//     required this.notes,
//     required this.time,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'User: ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Artist: ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Title: ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Notes: ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Time: ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2),
//                 child: Text(
//                   username,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2),
//                 child: Text(
//                   artist,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2),
//                 child: Text(
//                   title,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2),
//                 child: Text(
//                   notes,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//             Flexible(
//               fit: FlexFit.loose,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 2),
//                 child: Text(
//                   time,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                   style: const TextStyle(fontSize: 12, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
