import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:request_live_riverpods/controllers/auth_controller.dart';

import 'package:request_live_riverpods/repositories/custom_exception.dart';
import 'package:request_live_riverpods/repositories/request_repository.dart';

final requestStreamExceptionProvider =
    StateProvider<CustomException?>((_) => null);

final requestStreamControllerProvider = StateNotifierProvider<
    RequestStreamController,
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>>>((ref) {
  final entertainer = ref.watch(authControllerProvider);
  return RequestStreamController(ref.read, entertainer?.uid);
});

class RequestStreamController extends StateNotifier<
    AsyncValue<Stream<QuerySnapshot<Map<String, dynamic>>>>> {
  final Reader _read;
  final String? _entertainerId;

  RequestStreamController(this._read, this._entertainerId)
      : super(const AsyncValue.loading()) {
    if (_entertainerId != null) {
      requestsSnapshotStream(entertainerId: _entertainerId!);
    }
  }

  void requestsSnapshotStream(
      {required String entertainerId, bool isRefreshing = false}) {
    if (isRefreshing) {
      state = const AsyncValue.loading();
    }
    try {
      final requests = _read(requestRepositoryProvider)
          .requestsSnapshotStream(entertainerId: entertainerId);

      if (mounted) {
        state = AsyncValue.data(requests);
      }
    } on CustomException catch (e) {
      _read(requestStreamExceptionProvider.notifier).state = e;
    }
  }
}
