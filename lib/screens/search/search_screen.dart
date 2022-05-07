import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/repositories/entertainer_repository.dart';
import 'package:request_live_riverpods/widgets/drawer.dart';
import 'package:request_live_riverpods/widgets/entertainer_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchScreenHook();
  }
}

class SearchScreenHook extends HookConsumerWidget {
  const SearchScreenHook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isShowUsers = false;
    final searchController = useTextEditingController();

    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>> entertainersStream =
        ref.watch(
            entertainerRepositorySearchProvider(searchController.text.trim()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
              labelText: 'Select an entertainer to make a request!'),
          onFieldSubmitted: (String _) {
            isShowUsers = true;
          },
        ),
      ),
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      body: isShowUsers
          ? entertainersStream.when(
              loading: () => const CircularProgressIndicator(
                color: Colors.white,
              ),
              error: (error, stacktrace) => Text('Error: $error'),
              data: (entertainerStreamData) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: StreamBuilder(
                    stream: entertainerStreamData,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.yellow),
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
                );
              },
            )
          : const Text(
              'Search for an entertainer!',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
    );
  }
}
