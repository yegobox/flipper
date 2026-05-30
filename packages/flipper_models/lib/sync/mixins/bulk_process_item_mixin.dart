import 'dart:math';

import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/bulk_desktop_variant_prep.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';

/// Shared bulk-import row handler for legacy (non data-connector) saves.
///
/// Each Excel row becomes a product + variant and runs the same RRA sequence as
/// DesktopProductAdd (`saveItems` → SAR → `saveStockItems` 06 → `saveStockMaster`).
mixin BulkProcessItemMixin {
  Repository get repository;

  Future<void> processItem({
    required Variant item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  }) {
    return runBulkProcessItem(
      this,
      repository: repository,
      item: item,
      quantitis: quantitis,
      taxTypes: taxTypes,
      itemClasses: itemClasses,
      itemTypes: itemTypes,
    );
  }
}

Future<void> runBulkProcessItem(
  Object syncHost, {
  required Repository repository,
  required Variant item,
  required Map<String, String> quantitis,
  required Map<String, String> taxTypes,
  required Map<String, String> itemClasses,
  required Map<String, String> itemTypes,
}) async {
  final host = syncHost as dynamic;
  try {
    final branchId = ProxyService.box.getBranchId()!;
    final vatEnabled = await isVatEnabledForBranch(branchId: branchId);
    final defaultTaxTyCd = defaultTaxTyCdForVat(vatEnabled);
    String bulkTaxFor(String? barCode) =>
        taxTypes[barCode ?? ''] ?? defaultTaxTyCd;

    final tin = await effectiveTin(branchId: branchId);
    if (tin == null) {
      throw Exception('TIN is required for bulk product registration');
    }

    if (item.bcdU != null && item.bcdU!.isNotEmpty) {
      final variant = await host.getVariant(bcd: item.barCode) as Variant?;
      if (variant == null) {
        throw Exception('no variant found with modrId:${item.barCode}');
      }
      variant.bcd = item.bcdU!.endsWith('.0')
          ? item.bcdU!.substring(0, item.bcdU!.length - 2)
          : item.bcdU;
      variant.name = item.name;
      variant.itemNm = item.name;
      variant.itemClsCd =
          itemClasses[item.barCode] ?? variant.itemClsCd ?? '5020230602';
      variant.itemTyCd = itemTypes[item.barCode] ?? variant.itemTyCd ?? '2';
      variant.taxTyCd = bulkTaxFor(item.barCode);
      variant.taxName = variant.taxTyCd;

      if (item.retailPrice != null) {
        variant.retailPrice = item.retailPrice;
        variant.prc = item.retailPrice;
        variant.dftPrc = item.retailPrice;
      }
      if (item.supplyPrice != null) {
        variant.supplyPrice = item.supplyPrice;
        variant.splyAmt = item.supplyPrice;
      }

      final stock = await host.getStockById(id: variant.stock!.id) as Stock;
      final qty = _bulkItemQuantity(item, quantitis);
      stock.currentStock = qty;
      stock.rsdQty = qty;
      stock.initialStock = qty;
      stock.value = qty * variant.retailPrice!;
      await repository.upsert(stock);
      variant.stock = stock;

      await host.addVariant(
        skipRRaCall: false,
        variations: [variant],
        branchId: branchId,
      );
      return;
    }

    final businessId = ProxyService.box.getBusinessId()!;
    final bhfId = await ProxyService.box.bhfId();

    final barCodeKey = item.barCode ?? '';
    if (barCodeKey.isNotEmpty) {
      final existingByBcd =
          await host.getVariant(bcd: barCodeKey) as Variant?;
      if (existingByBcd != null) {
        final variant = existingByBcd;
        variant.name = item.name;
        variant.itemNm = item.name;
        variant.itemClsCd =
            itemClasses[item.barCode] ?? variant.itemClsCd ?? '5020230602';
        variant.itemTyCd = itemTypes[item.barCode] ?? variant.itemTyCd ?? '2';
        variant.taxTyCd = bulkTaxFor(item.barCode);
        variant.taxName = variant.taxTyCd;
        if (item.retailPrice != null) {
          variant.retailPrice = item.retailPrice;
          variant.prc = item.retailPrice;
          variant.dftPrc = item.retailPrice;
        }
        if (item.supplyPrice != null) {
          variant.supplyPrice = item.supplyPrice;
          variant.splyAmt = item.supplyPrice;
        }
        final stock =
            await host.getStockById(id: variant.stock!.id) as Stock;
        final qty = _bulkItemQuantity(item, quantitis);
        stock.currentStock = qty;
        stock.rsdQty = qty;
        stock.initialStock = qty;
        stock.value = qty * variant.retailPrice!;
        await repository.upsert(stock);
        variant.stock = stock;
        await host.addVariant(
          variations: [variant],
          branchId: branchId,
          skipRRaCall: false,
        );
        return;
      }
    }

    final existingByName = await host.getVariant(name: item.name) as Variant?;
    if (existingByName != null &&
        item.bcdU != null &&
        item.bcdU!.trim().isNotEmpty) {
      final variant = existingByName;
      variant.bcd = item.bcdU;
      variant.name = item.name;
      variant.itemNm = item.name;
      variant.color = _randomizeColor();
      variant.lastTouched = DateTime.now();
      variant.itemClsCd =
          itemClasses[item.barCode] ?? variant.itemClsCd ?? '5020230602';
      variant.itemTyCd = itemTypes[item.barCode] ?? variant.itemTyCd ?? '2';
      variant.taxTyCd = bulkTaxFor(item.barCode);
      variant.taxName = variant.taxTyCd;
      if (item.retailPrice != null) {
        variant.retailPrice = item.retailPrice;
        variant.prc = item.retailPrice;
        variant.dftPrc = item.retailPrice;
      }
      if (item.supplyPrice != null) {
        variant.supplyPrice = item.supplyPrice;
        variant.splyAmt = item.supplyPrice;
      }

      final stock = await host.getStockById(id: variant.stock!.id) as Stock;
      final qty = _bulkItemQuantity(item, quantitis);
      stock.currentStock = qty;
      stock.rsdQty = qty;
      stock.initialStock = qty;
      stock.value = qty * variant.retailPrice!;
      await repository.upsert(stock);
      variant.stock = stock;

      await host.addVariant(
        variations: [variant],
        branchId: branchId,
        skipRRaCall: false,
      );
      return;
    }

    final categoryId = item.categoryId;
    final productName = item.itemNm ?? item.name;
    final qty = _bulkItemQuantity(item, quantitis);
    final retail = item.retailPrice ?? 0;
    final supply = item.supplyPrice ?? retail;
    final itemCls =
        itemClasses[item.barCode] ?? item.itemClsCd ?? '5020230602';
    final itemTy = itemTypes[item.barCode] ?? item.itemTyCd ?? '2';
    final taxTy = bulkTaxFor(item.barCode);

    final createdProduct = await host.createProduct(
      skipRRaCall: true,
      skipRegularVariant: true,
      createItemCode: false,
      bhFId: bhfId ?? '00',
      tinNumber: tin,
      businessId: businessId,
      branchId: branchId,
      product: Product(
        color: _randomizeColor(),
        name: productName,
        lastTouched: DateTime.now().toUtc(),
        branchId: branchId,
        businessId: businessId,
        createdAt: DateTime.now().toUtc(),
        barCode: item.barCode,
        categoryId: categoryId,
      ),
      supplyPrice: supply,
      retailPrice: retail,
      qty: qty,
      taxTyCd: taxTy,
    ) as Product?;
    if (createdProduct == null) {
      throw Exception('Failed to create product for bulk row $productName');
    }

    final business = await ProxyService.strategy.getBusiness(
      businessId: businessId,
    );

    final prepared = await prepareBulkVariantLikeDesktopAdd(
      product: createdProduct,
      productName: productName,
      branchId: branchId,
      taxTyCd: taxTy,
      itemClsCd: itemCls,
      itemTyCd: itemTy,
      retailPrice: retail,
      supplyPrice: supply,
      barCode: item.barCode,
      sku: randomNumber(),
      countryCode: item.orgnNatCd ?? 'RW',
      packagingUnitCode: 'CT',
      categoryId: categoryId,
      categoryName: item.categoryName ?? item.category,
      business: business,
    );

    final stock = Stock(
      id: const Uuid().v4(),
      lastTouched: DateTime.now().toUtc(),
      rsdQty: qty,
      initialStock: qty,
      value: qty * (retail > 0 ? retail : supply),
      branchId: branchId,
      currentStock: qty,
    );
    final createdStock = await repository.upsert<Stock>(stock);
    prepared.stock = createdStock;
    prepared.stockId = createdStock.id;
    prepared.qty = qty;
    prepared.rsdQty = qty;

    await host.addVariant(
      skipRRaCall: false,
      variations: [prepared],
      branchId: branchId,
    );
  } catch (e, s) {
    talker.error('bulk processItem failed', e, s);
    rethrow;
  }
}

double _bulkItemQuantity(Variant item, Map<String, String> quantitis) {
  final key = item.barCode ?? '';
  final raw = quantitis[key] ??
      (item.quantity != null && item.quantity! > 0
          ? item.quantity.toString()
          : null);
  if (raw == null || raw.trim().isEmpty) {
    return 1;
  }
  final parsed = double.tryParse(raw.trim());
  return parsed != null && parsed > 0 ? parsed : 1;
}

String _randomizeColor() {
  return '#${(Random().nextInt(0x1000000) | 0x800000).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
