import 'package:flipper_services/proxy.dart';

/// Checks if the current branch has digital payment enabled.
Future<bool> isCurrentBranchDigitalPaymentEnabled() async {
  final branch = await ProxyService.strategy.activeBranch();
  return await ProxyService.strategy.isBranchEnableForPayment(currentBranchId: branch.id);
}
