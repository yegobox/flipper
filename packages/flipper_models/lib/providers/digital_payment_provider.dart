import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'digital_payment_provider.g.dart';

@riverpod
Future<bool> isDigitalPaymentEnabled(Ref ref) async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) return false;
  return await ProxyService.getStrategy(Strategy.capella).isBranchEnableForPayment(
    currentBranchId: branchId,
    fetchRemote: true,
  );
}
