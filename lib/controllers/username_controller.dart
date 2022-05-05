import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/username_repository.dart';
import 'package:request_live_riverpods/models/username_model.dart';

final usernameExceptionProvider = StateProvider<CustomException?>((_) => null);

final usernameControllerProvider =
    StateNotifierProvider<UsernameController, AsyncValue<Username>>((ref) {
  final user = ref.watch(authControllerProvider);
  return UsernameController(ref.read, user?.uid);
});

class UsernameController extends StateNotifier<AsyncValue<Username>> {
  final Reader _read;
  final String? _userId;

  UsernameController(this._read, this._userId)
      : super(const AsyncValue.loading());

  Future<bool> checkUsernameAvailable({required String username}) async {
    try {
      final available = await _read(usernameRepositoryProvider)
          .checkUsernameAvailable(username: username);
      return available;
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, stackTrace: st);
      return false;
    }
  }

  Future<void> reserveUsername({
    required String username,
  }) async {
    try {
      final newUsername = Username(
        id: _userId!,
        username: username,
      );

      await _read(usernameRepositoryProvider)
          .reserveUsername(username: newUsername);
    } on CustomException catch (e) {
      // print(e.message);
      _read(usernameExceptionProvider.notifier).state = e;
    }
  }
}
