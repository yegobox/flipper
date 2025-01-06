import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

@riverpod
Stream<List<ITransaction>> transactions(Ref ref) {
  return ProxyService.strategy.transactionsStream(
      status: PARKED, branchId: ProxyService.box.getBranchId()!);
}
