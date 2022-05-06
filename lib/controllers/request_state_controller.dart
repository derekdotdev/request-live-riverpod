import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/user_controller.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/models/request_model.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';

/*
 This class is used to manage the state of individual requests for the
 requests_detail_screen to allow isPlayed to be toggled in a stateless
 hook consumer widget.
 */
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

    print('RequestStateController before whenData');
    // Only load request if user is an entertainer!
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
