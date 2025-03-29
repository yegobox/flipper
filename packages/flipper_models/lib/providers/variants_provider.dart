import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'variants_provider.g.dart';

@riverpod
Future<List<Variant>> variant(
  Ref ref, {
  required int branchId,
  String? key,
}) async {
  print('Fetching variants for branchId: $branchId');
  final variants = await ProxyService.strategy.variants(
    name: key,
    branchId: branchId,
  );
  print('Fetched ${variants.length} variants for branchId: $branchId');
  return variants;
}

@riverpod
Future<List<Variant>> purchaseVariant(
  Ref ref, {
  required int branchId,
  String? purchaseId,
}) async {
  print('Fetching variants for branchId: $branchId');
  final variants = await ProxyService.strategy.variants(
    purchaseId: purchaseId,
    branchId: branchId,
  );
  print('Fetched!! ${variants.length} variants for branchId: $branchId');

  return variants;
}
