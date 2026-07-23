import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/services/park_transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'park_transaction_provider.g.dart';

/// Riverpod wrapper for [ParkTransactionService] with explicit loading state.
@riverpod
class ParkTransaction extends _$ParkTransaction {
  @override
  FutureOr<void> build() {}

  Future<void> park({
    required String ticketName,
    required String ticketNote,
    required ITransaction transaction,
    String? customerId,
  }) async {
    // Park can take several seconds (Ditto); keep alive until complete so
    // autoDispose does not tear down [ref] mid-flight.
    final keepAliveLink = ref.keepAlive();
    try {
      if (ref.mounted) {
        state = const AsyncLoading();
      }
      final result = await AsyncValue.guard(
        () => ParkTransactionService.park(
          ticketName: ticketName,
          ticketNote: ticketNote,
          transaction: transaction,
          customerId: customerId,
        ),
      );
      if (!ref.mounted) {
        if (result.hasError) throw result.error!;
        return;
      }
      state = result;
      if (result.hasError) throw result.error!;

      // Ensure badge/list pick up the park even if the Ditto observer missed the
      // first onChange (e.g. stream was idle or mid-resubscribe). Prefer
      // invalidate over refresh so an existing live subscription rebuilds once.
      ref.invalidate(ticketsStreamProvider);
    } finally {
      keepAliveLink.close();
    }
  }
}
