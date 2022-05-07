import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/repositories/entertainer_repository.dart';
import 'package:request_live_riverpods/widgets/drawer.dart';
import 'package:request_live_riverpods/widgets/entertainer_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreenHook();
  }
}

class WelcomeScreenHook extends HookConsumerWidget {
  const WelcomeScreenHook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>> entertainersStream =
        ref.watch(entertainerRepositoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Select an entertainer to make a request!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
      ),
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            entertainersStream.when(
              loading: () => const CircularProgressIndicator(
                color: Colors.white,
              ),
              error: (error, stacktrace) => Text('Error: $error'),
              data: (entertainerStreamData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: entertainerStreamData,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.yellow),
                            );
                          }
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
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
                                    child: EntertainerCard(
                                      snap: snapshot.hasData
                                          ? snapshot.data!.docs[index].data()
                                          : {},
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Looks like there aren\'t any entertainers nearby...\nPlease try again later!',
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
