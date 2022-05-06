import 'dart:typed_data';

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/models/username_model.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/models/user_model.dart';
import 'package:request_live_riverpods/repositories/user_repository.dart';
import 'package:request_live_riverpods/repositories/username_repository.dart';

final userExceptionProvider = StateProvider<CustomException?>((_) => null);

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<User>>((ref) {
  final firebaseAuthUser = ref.watch(authControllerProvider);
  return UserController(ref.read, firebaseAuthUser?.uid);
});

class UserController extends StateNotifier<AsyncValue<User>> {
  final Reader _read;
  final String? _userId;

  UserController(this._read, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      retrieveUserInfo();
    }
  }

  Future<void> retrieveUserInfo({bool isRefreshing = false}) async {
    try {
      final localUser = await _read(userRepositoryProvider)
          .retrieveFirestoreUser(userId: _userId!);

      if (mounted) {
        state = AsyncValue.data(localUser);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
    }
  }

  Future<bool> updateUserLiveStatus({required User user}) async {
    try {
      final updatedStatus = await _read(userRepositoryProvider)
          .updateUserLiveStatus(localUser: user);

      final updatedUser = user.copyWith(isLive: updatedStatus);

      if (mounted) {
        state = AsyncValue.data(updatedUser);
      }

      return updatedStatus;
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print(e);
      return false;
    }
  }

  Future<void> updateUserProfile(
      {required User user,
      required String bio,
      required String website}) async {
    try {
      final userWithUpdatedProfile = user.copyWith(bio: bio, website: website);

      await _read(userRepositoryProvider).updateUserProfile(localUser: user);

      if (mounted) {
        state = AsyncValue.data(userWithUpdatedProfile);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print(e);
    }
  }

  Future<void> updateUserImage(
      {required User user, required Uint8List image}) async {
    try {
      final userWithUpdatedPhoto = await _read(userRepositoryProvider)
          .updateUserPhoto(
              localUser: user, image: image, childName: 'profilePics');

      if (mounted) {
        state = AsyncValue.data(userWithUpdatedPhoto);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print('Error uploading new profile image!');
      print(e);
    }
  }

  Future<void> createNewUser(
      {required String userId,
      required String email,
      required String username,
      required bool isEntertainer}) async {
    try {
      // Create User from fields
      final newUser = User(
        id: userId,
        email: email,
        username: username,
        photoUrl: 'https://i.stack.imgur.com/l60Hf.png',
        isEntertainer: isEntertainer,
      );

      // Persist newUser to firestore repo users/userId/
      await _read(userRepositoryProvider).createUser(
        userId: userId,
        localUser: newUser,
      );

      // Persist username to firestore repo usernames/username/
      final newUsername = Username(id: userId, username: username);
      await _read(usernameRepositoryProvider)
          .reserveUsername(username: newUsername);
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
    }
  }

  // Future<void> createRequest({
  //   required String artist,
  //   required String title,
  //   required String notes,
  //   required String requesterId,
  //   required String requesterUsername,
  //   required String requesterPhotoUrl,
  // }) async {
  //   try {
  //     final request = Request(
  //       artist: artist,
  //       title: title,
  //       notes: notes,
  //       requesterId: requesterId,
  //       requesterUsername: requesterUsername,
  //       requesterPhotoUrl: requesterPhotoUrl,
  //       entertainerId: _entertainerId!,
  //       timestamp: Conversions.convertTimeStamp(Timestamp.now()),
  //     );
  //     final requestId = await _read(requestRepositoryProvider).createRequest(
  //       entertainerId: _entertainerId!,
  //       request: request,
  //     );

  //     state.whenData((requests) => state =
  //         AsyncValue.data(requests..add(request.copyWith(id: requestId))));
  //   } on CustomException catch (e) {
  //     // print(e.message);
  //     _read(requestListExceptionProvider.notifier).state = e;
  //   }
  // }

  // Future<void> retrieveRequests({bool isRefreshing = false}) async {
  //   if (isRefreshing) {
  //     state = const AsyncValue.loading();
  //   }
  //   try {
  //     final requests = await _read(requestRepositoryProvider)
  //         .retrieveRequests(entertainerId: _entertainerId!);

  //     if (mounted) {
  //       state = AsyncValue.data(requests);
  //     }
  //   } on CustomException catch (e, st) {
  //     state = AsyncValue.error(e, stackTrace: st);
  //   }
  // }

  // Future<void> updateRequestPlayed({required Request updateRequest}) async {
  //   try {
  //     await _read(requestRepositoryProvider).updateRequestPlayed(
  //         entertainerId: _entertainerId!, request: updateRequest);
  //     state.whenData((requests) {
  //       state = AsyncValue.data([
  //         for (final request in requests)
  //           if (request.id == updateRequest.id) updateRequest else request
  //       ]);
  //     });
  //   } on CustomException catch (e) {
  //     // print(e.message);
  //     _read(requestListExceptionProvider.notifier).state = e;
  //   }
  // }

  // Future<void> deleteRequest({required String requestId}) async {
  //   try {
  //     await _read(requestRepositoryProvider).deleteRequest(
  //       entertainerId: _entertainerId!,
  //       requestId: requestId,
  //     );
  //     state.whenData((requests) => state = AsyncValue.data(
  //         requests..removeWhere((request) => request.id == requestId)));
  //   } on CustomException catch (e) {
  //     // print(e.message);
  //     _read(requestListExceptionProvider.notifier).state = e;
  //   }
  // }
}
