import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'digital_payment_provider.g.dart';

@riverpod
Future<bool> isDigialPaymentEnabled(Ref ref) async {
  final String branchId = (await ProxyService.strategy.activeBranch()).id;
  return await ProxyService.strategy
      .isBranchEnableForPayment(currentBranchId: branchId);
}
