import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/models/request_model.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';

final requestExceptionProvider = StateProvider<CustomException?>((_) => null);

final requestStateControllerProvider = StateNotifierProvider.family<
    RequestStateController,
    AsyncValue<Request>,
    String>((ref, familyRequestId) {
  final firebaseAuthUser = ref.watch(authControllerProvider);
  return RequestStateController(
      ref.read, firebaseAuthUser?.uid, familyRequestId);
});

class RequestStateController extends StateNotifier<AsyncValue<Request>> {
  final Reader _read;
  final String? _userId;
  final String familyRequestId;

  RequestStateController(this._read, this._userId, this.familyRequestId)
      : super(const AsyncValue.loading()) {
    final userController = _read(userControllerProvider);
    final userControllerNotifier = _read(userControllerProvider.notifier);
    userControllerNotifier.retrieveUserInfo();
    userController.whenData((userData) {
      if (_userId != null && userData.isEntertainer) {
        retrieveRequestInfo(
            entertainerId: _userId!, requestId: familyRequestId);
      }
    });
  }

  Future<void> retrieveRequestInfo(
      {bool isRefreshing = false,
      required String entertainerId,
      required String requestId}) async {
    try {
      final request = await _read(requestRepositoryProvider)
          .retrieveRequest(entertainerId: entertainerId, requestId: requestId);

      if (mounted) {
        state = AsyncValue.data(request);
      }
    } on CustomException catch (e) {
      _read(requestExceptionProvider.notifier).state = e;
    }
  }

  Future<void> updateRequestPlayed({required Request request}) async {
    try {
      final updatedStatus = !request.played;
      final updatedRequest = request.copyWith(played: updatedStatus);

      await _read(requestRepositoryProvider).updateRequestPlayed(
          entertainerId: _userId!, request: updatedRequest);

      if (mounted) {
        state = AsyncValue.data(updatedRequest);
      }
    } on CustomException catch (e) {
      _read(requestExceptionProvider.notifier).state = e;
    }
  }
}
