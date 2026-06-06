import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Parks a sale on **Capella (Ditto)** only — no Brick/repository paths.
class ParkTransactionService {
  static Future<void> park({
    required String ticketName,
    required String ticketNote,
    required ITransaction transaction,
    String? customerId,
  }) async {
    if (ticketName.trim().isEmpty) return;

    talker.info(
      'park (Capella fast) ticketName=$ticketName customerId=$customerId txn=${transaction.id}',
    );

    await ProxyService.getStrategy(Strategy.capella).parkSaleTicketFast(
      transaction: transaction,
      ticketName: ticketName,
      ticketNote: ticketNote,
      customerId: customerId,
    );
  }
}
