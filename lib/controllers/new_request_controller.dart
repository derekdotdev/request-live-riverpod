import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';
import 'package:request_live_riverpods/models/request_model.dart';

final newRequestExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final newRequestControllerProvider =
    StateNotifierProvider<NewRequestController, AsyncValue<Request>>((ref) {
  final user = ref.watch(authControllerProvider);
  return NewRequestController(ref.read, user?.uid);
});

class NewRequestController extends StateNotifier<AsyncValue<Request>> {
  final Reader _read;
  final String? _userId;

  NewRequestController(this._read, this._userId)
      : super(const AsyncValue.loading());

  Future<void> createRequest({
    required String artist,
    required String title,
    required String notes,
    required String entertainerId,
    required String entertainerUsername,
    required String requesterUsername,
    required String requesterPhotoUrl,
  }) async {
    try {
      final request = Request(
        artist: artist,
        title: title,
        notes: notes,
        requesterId: _userId!,
        requesterUsername: requesterUsername,
        requesterPhotoUrl: requesterPhotoUrl,
        entertainerId: entertainerId,
        entertainerUsername: entertainerUsername,
        entertainerPhotoUrl:
            'from old create request method in new request controller',
        requesterDeleted: false,
        entertainerDeleted: false,
        timestamp: DateTime.now(),
      );

      await _read(requestRepositoryProvider).createRequest(
        entertainerId: entertainerId,
        request: request,
      );
      await _read(requestRepositoryProvider).createUserRequest(
        request: request,
      );
    } on CustomException catch (e) {
      _read(newRequestExceptionProvider.notifier).state = e;
    }
  }
}
