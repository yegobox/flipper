import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/sale_device_id.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

/// Resumes a parked POS sale on Capella (Ditto) with a minimal write path.
class ResumeTransactionService {
  static Future<void> resume({
    required ITransaction ticket,
    required String branchId,
    required String agentId,
  }) async {
    talker.info('resume (Capella fast) txn=${ticket.id}');

    final saleDeviceId = await resolveSaleDeviceId();
    ticket.status = PENDING;
    ticket.agentId = agentId;
    ticket.deviceId = saleDeviceId;

    await ProxyService.getStrategy(Strategy.capella).resumeSaleTicketFast(
      ticket: ticket,
      agentId: agentId,
      deviceId: saleDeviceId,
      branchId: branchId,
    );
  }
}
