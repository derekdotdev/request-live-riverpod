import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:request_live_riverpods/controllers/auth_controller.dart';
import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';
import 'package:request_live_riverpods/models/request_model.dart';

final userRequestListExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final userRequestListControllerProvider =
    StateNotifierProvider<UserRequestListController, AsyncValue<List<Request>>>(
        (ref) {
  final user = ref.watch(authControllerProvider);
  return UserRequestListController(ref.read, user?.uid);
});

class UserRequestListController
    extends StateNotifier<AsyncValue<List<Request>>> {
  final Reader _read;
  final String? _userId;

  UserRequestListController(this._read, this._userId)
      : super(const AsyncValue.loading()) {
    if (_userId != null) {
      retrieveRequests();
    }
  }

  // Future<void> createRequest({
  //   required String artist,
  //   required String title,
  //   required String notes,
  //   required String requesterId,
  //   required String requesterUsername,
  //   required String requesterPhotoUrl,
  //   required String entertainerUsername,
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
  //       entertainerUsername: entertainerUsername,
  //       timestamp: DateTime.now(),
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

  Future<void> retrieveRequests({bool isRefreshing = false}) async {
    if (isRefreshing) {
      state = const AsyncValue.loading();
    }
    try {
      final requests = await _read(requestRepositoryProvider)
          .retrieveUserRequests(userId: _userId!);

      if (mounted) {
        state = AsyncValue.data(requests);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, stackTrace: st);
    }
  }

  // Future<void> updateRequestPlayed({required Request updateRequest}) async {
  //   try {
  //     await _read(requestRepositoryProvider).updateRequestPlayed(
  //         entertainerId: _userId!, request: updateRequest);
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

  Future<void> deleteRequest({required String requestId}) async {
    try {
      await _read(requestRepositoryProvider).deleteUserRequest(
        userId: _userId!,
        requestId: requestId,
      );
      state.whenData((requests) => state = AsyncValue.data(
          requests..removeWhere((request) => request.id == requestId)));
    } on CustomException catch (e) {
      _read(userRequestListExceptionProvider.notifier).state = e;
    }
  }
}
