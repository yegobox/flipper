import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flipper_models/SyncStrategy.dart';

part 'variants_provider.g.dart';

@riverpod
Future<List<Variant>> variant(
  Ref ref, {
  required String branchId,
  String? key,
  bool forImportScreen = false,
  bool forPurchaseScreen = false,
}) async {
  print('Fetching variants for branchId: $branchId');
  final paged = await ProxyService.strategy.variants(
    taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
    name: key,
    branchId: branchId,
    forImportScreen: forImportScreen,
    forPurchaseScreen: forPurchaseScreen,
  );
  final variants = List<Variant>.from(paged.variants);
  print('Fetched ${variants.length} variants for branchId: $branchId');
  return variants;
}

@riverpod
Future<List<Variant>> purchaseVariant(
  Ref ref, {
  required String branchId,
  String? purchaseId,
}) async {
  print('Fetching variants for branchId: $branchId');
  final paged = await ProxyService.strategy.variants(
    taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
    purchaseId: purchaseId,
    branchId: branchId,
  );
  final variants = List<Variant>.from(paged.variants);
  print('Fetched!! ${variants.length} variants for branchId: $branchId');

  return variants;
}

@riverpod
Future<Stock?> stockById(
  Ref ref, {
  required String stockId,
}) async {
  return await ProxyService.getStrategy(Strategy.capella)
      .getStockById(id: stockId);
}
