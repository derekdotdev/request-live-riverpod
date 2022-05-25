import 'package:flutter/material.dart';

import 'package:request_live_riverpods/models/models.dart';
import 'package:request_live_riverpods/resources/conversions.dart';

class UserRequestCard extends StatefulWidget {
  final String requestId;
  final dynamic snap;

  const UserRequestCard({
    Key? key,
    required this.requestId,
    required this.snap,
  }) : super(key: key);

  @override
  State<UserRequestCard> createState() => _UserRequestCardState();
}

class _UserRequestCardState extends State<UserRequestCard> {
  late Request request = Request(
    id: widget.requestId,
    artist: widget.snap['artist'],
    title: widget.snap['title'],
    notes: widget.snap['notes'],
    requesterId: widget.snap['requesterId'],
    requesterUsername: widget.snap['requesterUsername'],
    requesterPhotoUrl: widget.snap['requesterPhotoUrl'],
    entertainerId: widget.snap['entertainerId'],
    entertainerUsername: widget.snap['entertainerUsername'],
    entertainerPhotoUrl: widget.snap['entertainerPhotoUrl'],
    requesterDeleted: widget.snap['requesterDeleted'],
    entertainerDeleted: widget.snap['entertainerDeleted'],
    played: widget.snap['played'],
    timestamp: widget.snap['timestamp'].toDate(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
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
                widget.snap['entertainerPhotoUrl'],
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      RequestRowOld(
                          section: 'Entertainer:   ',
                          details:
                              widget.snap['entertainerUsername'].toString()),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              section,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Text(
              details,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
