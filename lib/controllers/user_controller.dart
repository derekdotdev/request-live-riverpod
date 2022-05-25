import 'dart:typed_data';

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/models/models.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/user_repository.dart';

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

  // TODO see if this (and other) methods can be removed...
  Future<void> updateUser({required User user}) async {
    try {
      final updatedUser = user.copyWith(isLive: !user.isLive);

      await _read(userRepositoryProvider)
          .updateUserProfile(localUser: updatedUser);

      if (mounted) {
        state = AsyncValue.data(updatedUser);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print(e);
    }
  }

  Future<void> setUserOffline({required User user}) async {
    try {
      final updatedUser = user.copyWith(
          isLive: false,
          isOnStage: false,
          location: user.location.copyWith(venueName: ''));

      await _read(userRepositoryProvider)
          .updateUserProfile(localUser: updatedUser);

      if (mounted) {
        state = AsyncValue.data(updatedUser);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print(e);
    }
  }

  Future<void> setUserLiveAtLocation(
      {required User user,
      required UserLocation location,
      required bool isOnStage}) async {
    try {
      final updatedUser =
          user.copyWith(isLive: true, location: location, isOnStage: isOnStage);

      await _read(userRepositoryProvider)
          .updateUserProfile(localUser: updatedUser);

      if (mounted) {
        state = AsyncValue.data(updatedUser);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
      print(e);
    }
  }

  Future<void> updateUserPodcastMode() async {}

  Future<void> updateUserLocation(
      {required User user, required UserLocation location}) async {
    try {
      final userWithUpdatedLocation = user.copyWith(location: location);

      await _read(userRepositoryProvider).updateUserProfile(localUser: user);

      if (mounted) {
        state = AsyncValue.data(userWithUpdatedLocation);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
    }
  }

  Future<void> updateUserProfile(
      {required User user,
      required String username,
      required String website,
      required String bio}) async {
    try {
      final userWithUpdatedProfile =
          user.copyWith(username: username, bio: bio, website: website);

      await _read(userRepositoryProvider)
          .updateUserProfile(localUser: userWithUpdatedProfile);

      if (mounted) {
        state = AsyncValue.data(userWithUpdatedProfile);
      }
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
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
    }
  }

  Future<void> createNewUser(
      {required String userId,
      required String email,
      required bool isEntertainer}) async {
    try {
      // Create User from fields
      final newUser = User(
          id: userId,
          email: email,
          username: '',
          bio: '',
          photoUrl: 'https://i.stack.imgur.com/l60Hf.png',
          isEntertainer: isEntertainer,
          location: UserLocation.empty(),
          website: '');

      // Persist newUser to firestore repo users/userId/
      await _read(userRepositoryProvider).createUser(
        userId: userId,
        localUser: newUser,
      );
    } on CustomException catch (e) {
      _read(userExceptionProvider.notifier).state = e;
    }
  }
}
