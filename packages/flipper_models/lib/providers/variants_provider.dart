import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'variants_provider.g.dart';

@riverpod
Future<List<Variant>> variant(
  Ref ref, {
  required String transactionId,
  required int branchId,
  String? key,
}) async {
  return await ProxyService.strategy.variants(
    name: key,
    branchId: branchId,
  );
}
