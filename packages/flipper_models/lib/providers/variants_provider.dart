import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'variants_provider.g.dart';

@riverpod
Future<List<Variant>> variant(
  Ref ref, {
  required int branchId,
  String? key,
  bool forImportScreen = false,
  bool forPurchaseScreen = false,
}) async {
  print('Fetching variants for branchId: $branchId');
  final variants = await ProxyService.strategy.variants(
    name: key,
    branchId: branchId,
    forImportScreen: forImportScreen,
    forPurchaseScreen: forPurchaseScreen,
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
