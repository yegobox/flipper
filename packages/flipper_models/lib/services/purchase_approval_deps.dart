import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/proxy.dart';

/// What approving a purchase needs: the stock-in, its RRA report and the
/// expense row take this instead of reaching for [ProxyService], so each can
/// be tested with fakes. Build it once per approval.
class PurchaseApprovalDeps {
  const PurchaseApprovalDeps({
    required this.strategy,
    required this.capella,
    required this.tax,
    this.branchId,
    this.businessId,
    this.userId,
  });

  /// The app's live services and the signed-in session.
  factory PurchaseApprovalDeps.fromProxy() {
    final box = ProxyService.box;
    return PurchaseApprovalDeps(
      strategy: ProxyService.strategy,
      capella: ProxyService.getStrategy(Strategy.capella),
      tax: ProxyService.tax,
      branchId: box.getBranchId(),
      businessId: box.getBusinessId(),
      userId: box.getUserId(),
    );
  }

  final DatabaseSyncInterface strategy;
  final DatabaseSyncInterface capella;
  final TaxApi tax;

  /// Fallbacks for a purchase that doesn't carry its own branch.
  final String? branchId;
  final String? businessId;
  final String? userId;
}
