import 'package:flipper_models/db_model_export.dart';
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ParkTransactionService.park(
        ticketName: ticketName,
        ticketNote: ticketNote,
        transaction: transaction,
        customerId: customerId,
      ),
    );
  }
}
