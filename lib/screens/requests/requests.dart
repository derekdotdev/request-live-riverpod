import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:request_live_riverpods/screens/requests/request_tile.dart';

class Requests extends StatelessWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .orderBy(
            'timestamp',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> requestsSnapshot) {
        if (requestsSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        final List<QueryDocumentSnapshot<dynamic>> requestDocs =
            requestsSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: requestDocs.length,
          itemBuilder: (ctx, index) => RequestTile(
            requestDocs[index].data()['artist'],
            requestDocs[index].data()['title'],
            requestDocs[index].data()['notes'],
            requestDocs[index].data()['username'],
            requestDocs[index].data()['userEmail'],
            requestDocs[index].data()['userId'] == user?.uid,
            requestDocs[index].data()['entertainerId'],
            key: ValueKey(requestDocs[index].id),
          ),
        );
      },
    );
  }
}
