import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/models/user_model.dart';
import 'package:request_live_riverpods/repositories/user_repository.dart';

final entertainerExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final entertainerControllerProvider = StateNotifierProvider.family<
    EntertainerController, AsyncValue<User>, String>((ref, entertainerId) {
  return EntertainerController(ref.read, entertainerId);
});

class EntertainerController extends StateNotifier<AsyncValue<User>> {
  final Reader _read;
  final String _entertainerId;

  EntertainerController(this._read, this._entertainerId)
      : super(const AsyncValue.loading()) {
    if (_entertainerId != 'null') {
      retrieveUserInfo();
    }
  }

  Future<void> retrieveUserInfo({bool isRefreshing = false}) async {
    try {
      final localUser = await _read(userRepositoryProvider)
          .retrieveFirestoreUser(userId: _entertainerId);

      if (mounted) {
        state = AsyncValue.data(localUser);
      }
    } on CustomException catch (e) {
      _read(entertainerExceptionProvider.notifier).state = e;
    }
  }
}
