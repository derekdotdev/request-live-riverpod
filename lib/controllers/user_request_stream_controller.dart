import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';

final userRequestStreamExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final userRequestStreamControllerProvider = StateNotifierProvider<
    UserRequestStreamController,
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>>>((ref) {
  final user = ref.watch(authControllerProvider);
  return UserRequestStreamController(ref.read, user?.uid);
});

class UserRequestStreamController extends StateNotifier<
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>>> {
  final Reader _read;
  final String? _userId;

  UserRequestStreamController(this._read, this._userId)
      : super(const AsyncValue.loading()) {
    if (_userId != null) {
      requestsSnapshotStream(userId: _userId!);
    }
  }

  void requestsSnapshotStream(
      {required String userId, bool isRefreshing = false}) {
    if (isRefreshing) {
      state = const AsyncValue.loading();
    }
    try {
      final requests = _read(requestRepositoryProvider)
          .userRequestsSnapshotStream(userId: _userId!);

      if (mounted) {
        state = AsyncValue.data(requests);
      }
    } on CustomException catch (e) {
      _read(userRequestStreamExceptionProvider.notifier).state = e;
    }
  }
}
