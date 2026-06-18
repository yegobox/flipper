import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/sync/utils/bulk_desktop_variant_prep.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:uuid/uuid.dart';

/// Creates a catalog variant immediately (product + itemCd + RRA saveItems),
/// matching [DesktopProductAdd] / [prepareBulkVariantLikeDesktopAdd].
Future<Variant> createIpmCatalogVariant({
  required String name,
  required double supplyPrice,
  required double retailPrice,
}) async {
  final branchId = ProxyService.box.getBranchId();
  final businessId = ProxyService.box.getBusinessId();
  if (branchId == null || businessId == null) {
    throw StateError('Branch and business must be selected');
  }

  final ebm = await ProxyService.strategy.ebm(branchId: branchId);
  final tin = ebm?.tinNumber ?? -1;
  final bhfId = (await ProxyService.box.bhfId()) ?? ebm?.bhfId ?? '00';
  final vatEnabled = ebm?.vatEnabled ?? ProxyService.box.vatEnabled();
  final taxTyCd = vatEnabled ? 'B' : 'D';
  final pkgUnitCd = RRADEFAULTS.packagingUnit.first.split(':').first;
  final bcd = name.length <= 20 ? name : name.substring(0, 20);

  final product = await ProxyService.strategy.createProduct(
    skipRRaCall: false,
    createItemCode: false,
    tinNumber: tin,
    bhFId: bhfId,
    businessId: businessId,
    branchId: branchId,
    product: Product(
      name: name,
      color: '#0984e3',
      businessId: businessId,
      branchId: branchId,
      lastTouched: DateTime.now().toUtc(),
    ),
    skipRegularVariant: true,
  );
  if (product == null) {
    throw StateError('Failed to create product for "$name"');
  }

  final business =
      await ProxyService.strategy.getBusiness(businessId: businessId);
  final category = await ProxyService.strategy.ensureUncategorizedCategory(
    branchId: branchId,
  );

  final variant = await prepareBulkVariantLikeDesktopAdd(
    product: product,
    productName: name,
    branchId: branchId,
    taxTyCd: taxTyCd,
    itemClsCd: '5020230602',
    itemTyCd: '2',
    retailPrice: retailPrice,
    supplyPrice: supplyPrice,
    barCode: bcd,
    sku: randomNumber(),
    countryCode: 'RW',
    packagingUnitCode: pkgUnitCd,
    categoryId: category.id,
    categoryName: category.name,
    business: business,
  );

  final stock = Stock(
    id: const Uuid().v4(),
    branchId: branchId,
    currentStock: 0,
    initialStock: 0,
    rsdQty: 0,
    lowStock: 0,
    tin: tin,
    value: 0,
    ebmSynced: false,
    active: false,
    showLowStockAlert: true,
    bhfId: bhfId,
    lastTouched: DateTime.now().toUtc(),
  );
  variant.stock = stock;
  variant.stockId = stock.id;

  await ProxyService.strategy.addVariant(
    variations: [variant],
    branchId: branchId,
    skipRRaCall: false,
  );

  return variant;
}
