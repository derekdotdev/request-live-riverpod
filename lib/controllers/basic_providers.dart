// import 'dart:ffi';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:request_live_riverpods/controllers/username_controller.dart';
// import 'package:request_live_riverpods/general_providers.dart';
// import 'package:request_live_riverpods/repositories/username_repository.dart';
// import 'package:state_notifier/state_notifier.dart';

// final usernameAvailableController =
//     StateNotifierProvider<UsernameAsyncAvailableNotifier>(
//         (ref) => UsernameAsyncAvailableNotifier(ref.read()));

// class UsernameAsyncAvailableNotifier extends StateNotifier<AsyncValue<bool>> {
//   UsernameAsyncAvailableNotifier(this._read : super(const AsyncLoading()) {
//     _init();
//   }

//   final Reader _read;
//   void _init() async {
//     await read(databaseProvider).initDatabase();
//     state = AsyncData(true);
//   }

//   void isAvailable({required String username}) async {
//     state = const AsyncLoading();
//     bool isAvailable = await _read(usernameControllerProvider.notifier).checkUsernameAvailable(username: username);
//     state = AsyncData(isAvailable);
//   }

//   void isNotAvailable() {
//     state = false;
//   }
// }
