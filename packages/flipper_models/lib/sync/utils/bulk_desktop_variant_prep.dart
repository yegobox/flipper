import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:uuid/uuid.dart';

/// Builds a [Variant] with the same EBM/RRA fields as
/// [ProductMixin.addVariant] in `view_models/mixins/_product.dart` (DesktopProductAdd).
Future<Variant> prepareBulkVariantLikeDesktopAdd({
  required Product product,
  required String productName,
  required String branchId,
  required String taxTyCd,
  required String itemClsCd,
  required String itemTyCd,
  required double retailPrice,
  required double supplyPrice,
  required String? barCode,
  required int sku,
  String countryCode = 'RW',
  String packagingUnitCode = 'CT',
  String? categoryId,
  String? categoryName,
  Business? business,
}) async {
  final registrar = randomNumber().toString().substring(0, 5);
  final regr = randomNumber().toString().substring(0, 5);
  final effectiveBcd = (barCode != null && barCode.trim().isNotEmpty)
      ? barCode.trim()
      : productName;

  double taxPercentage = 18;
  try {
    final taxConfig =
        await ProxyService.strategy.getByTaxType(taxtype: taxTyCd);
    taxPercentage = taxConfig?.taxPercentage ?? taxPercentage;
  } catch (_) {}

  final tin = await effectiveTin(business: business);

  final variant = Variant(
    id: const Uuid().v4(),
    branchId: branchId,
    name: productName,
    itemNm: productName,
    productId: product.id,
    productName: productName,
    color: product.color,
    unit: 'Per Item',
    categoryId: categoryId,
    categoryName: categoryName,
    retailPrice: retailPrice,
    supplyPrice: supplyPrice,
    prc: retailPrice,
    dftPrc: retailPrice,
    splyAmt: supplyPrice,
    sku: sku.toString(),
    bcd: effectiveBcd,
    barCode: barCode?.trim().isNotEmpty == true ? barCode!.trim() : null,
    itemClsCd: itemClsCd,
    itemTyCd: itemTyCd,
    taxTyCd: taxTyCd,
    taxName: taxTyCd,
    taxPercentage: taxPercentage,
    orgnNatCd: countryCode,
    pkgUnitCd: packagingUnitCode,
    qtyUnitCd: 'U',
    pkg: 1,
    itemSeq: 0,
    isrcAplcbYn: 'N',
    useYn: 'N',
    isrccNm: '',
    isrcRt: 0,
    dcRt: 0,
    addInfo: 'A',
    itemStdNm: productName,
    regrNm: productName,
    regrId: regr,
    modrId: registrar,
    modrNm: registrar,
    spplrItemCd: '',
    spplrItemClsCd: '',
    spplrItemNm: productName,
    ebmSynced: false,
    tin: tin,
    bhfId: business?.bhfId ?? '00',
  );

  // Match DesktopProductAdd itemCode args (packagingUnit code + quantityUnit CT).
  variant.itemCd = await ProxyService.strategy.itemCode(
    countryCode: countryCode,
    productType: itemTyCd,
    branchId: branchId,
    packagingUnit: packagingUnitCode,
    quantityUnit: 'CT',
  );

  return variant;
}
