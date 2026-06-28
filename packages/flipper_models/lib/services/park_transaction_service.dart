import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/loan_customer_linker.dart';
import 'package:flipper_services/constants.dart';
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

    // Parking with "Mark as loan" is a credit sale: link the debtor to a
    // customer record — fire-and-forget, adds no latency. The accounting
    // journal entry is now posted server-side in data-connector (it listens on
    // parked-loan transactions). A park merged into another customer ticket
    // never reaches PARKED on this object (parkSaleTicketFast returns before
    // the status mutation), so merged carts are skipped here.
    if (transaction.isLoan == true && transaction.status == PARKED) {
      if ((transaction.customerId == null ||
              transaction.customerId!.isEmpty) &&
          customerId != null &&
          customerId.isNotEmpty) {
        transaction.customerId = customerId;
      }
      final branchId =
          transaction.branchId ?? ProxyService.box.getBranchId() ?? '';
      if (branchId.isNotEmpty) {
        unawaited(
          LoanCustomerLinker.ensureLinked(
            transaction: transaction,
            branchId: branchId,
          ),
        );
      }
    }
  }
}
