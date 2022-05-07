import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/repositories/entertainer_repository.dart';
import 'package:request_live_riverpods/widgets/entertainer_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchScreenHook();
  }
}

class SearchScreenHook extends StatefulHookConsumerWidget {
  const SearchScreenHook({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchScreenHookState();
}

class _SearchScreenHookState extends ConsumerState<SearchScreenHook> {
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final searchController = useTextEditingController();

    AsyncValue<Future<QuerySnapshot<Map<String, dynamic>>>>
        entertainerSearchFuture = ref.watch(
            entertainerRepositorySearchFutureProvider(
                searchController.text.trim()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 4,
                child: TextFormField(
                  textCapitalization: TextCapitalization.none,
                  controller: searchController,
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.white,
                    labelText: 'Search Here!',
                  ),
                  onFieldSubmitted: (String _) {
                    if (searchController.text.trim().isNotEmpty) {
                      setState(() {
                        isShowUsers = true;
                        print('isShowUsers: $isShowUsers');
                      });
                    }
                  },
                  onChanged: (_) {
                    if (!isShowUsers) {
                      if (searchController.text.trim().isNotEmpty) {
                        setState(() {
                          isShowUsers = true;
                        });
                      }
                    }
                    if (isShowUsers) {
                      if (searchController.text.trim().isEmpty) {
                        setState(() {
                          isShowUsers = false;
                        });
                      }
                    }
                  },
                ),
              ),
              const Flexible(
                  child: Icon(
                Icons.search,
                color: Colors.blue,
              )),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            isShowUsers
                ? entertainerSearchFuture.when(
                    loading: () => const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    error: (error, stacktrace) => Center(
                      child: Text('Error: $error'),
                    ),
                    data: (futureData) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: FutureBuilder(
                          future: futureData,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.yellow),
                              );
                            }
                            return SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount:
                                      (snapshot.data! as dynamic).docs.length,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: EntertainerCard(
                                      snap: snapshot.hasData
                                          ? (snapshot.data! as dynamic)
                                              .docs[index]
                                              .data()
                                          : {},
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Search for an entertainer!',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
