// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Variant> _$VariantFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Variant(
    id: data['id'] as String?,
    purchaseId:
        data['purchase_id'] == null ? null : data['purchase_id'] as String?,
    stock: data['stock'] == null
        ? null
        : await StockAdapter().fromSupabase(
            data['stock'],
            provider: provider,
            repository: repository,
          ),
    stockId: data['stock_id'] == null ? null : data['stock_id'] as String?,
    taxPercentage: data['tax_percentage'] == null
        ? null
        : data['tax_percentage'] as num? ?? 18.0,
    name: data['name'] as String,
    color: data['color'] == null ? null : data['color'] as String?,
    sku: data['sku'] == null ? null : data['sku'] as String?,
    productId:
        data['product_id'] == null ? null : data['product_id'] as String?,
    unit: data['unit'] == null ? null : data['unit'] as String?,
    productName:
        data['product_name'] == null ? null : data['product_name'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
    categoryName:
        data['category_name'] == null ? null : data['category_name'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    taxName: data['tax_name'] == null ? null : data['tax_name'] as String?,
    itemSeq: data['item_seq'] == null ? null : data['item_seq'] as int?,
    isrccCd: data['isrcc_cd'] == null ? null : data['isrcc_cd'] as String?,
    isrccNm: data['isrcc_nm'] == null ? null : data['isrcc_nm'] as String?,
    isrcRt: data['isrc_rt'] == null ? null : data['isrc_rt'] as int?,
    isrcAmt: data['isrc_amt'] == null ? null : data['isrc_amt'] as int?,
    taxTyCd: data['tax_ty_cd'] == null ? null : data['tax_ty_cd'] as String?,
    bcd: data['bcd'] == null ? null : data['bcd'] as String?,
    itemClsCd:
        data['item_cls_cd'] == null ? null : data['item_cls_cd'] as String?,
    itemTyCd: data['item_ty_cd'] == null ? null : data['item_ty_cd'] as String?,
    itemStdNm:
        data['item_std_nm'] == null ? null : data['item_std_nm'] as String?,
    orgnNatCd:
        data['orgn_nat_cd'] == null ? null : data['orgn_nat_cd'] as String?,
    pkg: data['pkg'] == null ? null : data['pkg'] as int?,
    itemCd: data['item_cd'] == null ? null : data['item_cd'] as String?,
    pkgUnitCd:
        data['pkg_unit_cd'] == null ? null : data['pkg_unit_cd'] as String?,
    qtyUnitCd:
        data['qty_unit_cd'] == null ? null : data['qty_unit_cd'] as String?,
    itemNm: data['item_nm'] == null ? null : data['item_nm'] as String?,
    prc: data['prc'] == null ? null : data['prc'] as double? ?? 0.0,
    splyAmt: data['sply_amt'] == null ? null : data['sply_amt'] as double?,
    tin: data['tin'] == null ? null : data['tin'] as int?,
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    dftPrc: data['dft_prc'] == null ? null : data['dft_prc'] as double? ?? 0.0,
    addInfo: data['add_info'] == null ? null : data['add_info'] as String?,
    isrcAplcbYn:
        data['isrc_aplcb_yn'] == null ? null : data['isrc_aplcb_yn'] as String?,
    useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
    regrId: data['regr_id'] == null ? null : data['regr_id'] as String?,
    regrNm: data['regr_nm'] == null ? null : data['regr_nm'] as String?,
    modrId: data['modr_id'] == null ? null : data['modr_id'] as String?,
    modrNm: data['modr_nm'] == null ? null : data['modr_nm'] as String?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    supplyPrice:
        data['supply_price'] == null ? null : data['supply_price'] as double?,
    retailPrice:
        data['retail_price'] == null ? null : data['retail_price'] as double?,
    spplrItemClsCd: data['spplr_item_cls_cd'] == null
        ? null
        : data['spplr_item_cls_cd'] as String?,
    spplrItemCd:
        data['spplr_item_cd'] == null ? null : data['spplr_item_cd'] as String?,
    spplrItemNm:
        data['spplr_item_nm'] == null ? null : data['spplr_item_nm'] as String?,
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] as bool?,
    dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as double?,
    expirationDate: data['expiration_date'] == null
        ? null
        : data['expiration_date'] == null
            ? null
            : DateTime.tryParse(data['expiration_date'] as String),
    totWt: data['tot_wt'] == null ? null : data['tot_wt'] as int?,
    netWt: data['net_wt'] == null ? null : data['net_wt'] as int?,
    spplrNm: data['spplr_nm'] == null ? null : data['spplr_nm'] as String?,
    agntNm: data['agnt_nm'] == null ? null : data['agnt_nm'] as String?,
    invcFcurAmt:
        data['invc_fcur_amt'] == null ? null : data['invc_fcur_amt'] as int?,
    invcFcurCd:
        data['invc_fcur_cd'] == null ? null : data['invc_fcur_cd'] as String?,
    invcFcurExcrt: data['invc_fcur_excrt'] == null
        ? null
        : data['invc_fcur_excrt'] as double?,
    exptNatCd:
        data['expt_nat_cd'] == null ? null : data['expt_nat_cd'] as String?,
    dclNo: data['dcl_no'] == null ? null : data['dcl_no'] as String?,
    taskCd: data['task_cd'] == null ? null : data['task_cd'] as String?,
    dclDe: data['dcl_de'] == null ? null : data['dcl_de'] as String?,
    hsCd: data['hs_cd'] == null ? null : data['hs_cd'] as String?,
    imptItemSttsCd: data['impt_item_stts_cd'] == null
        ? null
        : data['impt_item_stts_cd'] as String?,
    taxblAmt: data['taxbl_amt'] == null ? null : data['taxbl_amt'] as double?,
    taxAmt: data['tax_amt'] == null ? null : data['tax_amt'] as double?,
    totAmt: data['tot_amt'] == null ? null : data['tot_amt'] as double?,
    pchsSttsCd:
        data['pchs_stts_cd'] == null ? null : data['pchs_stts_cd'] as String?,
    isShared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    assigned:
        data['assigned'] == null ? null : data['assigned'] as bool? ?? false,
  );
}

Future<Map<String, dynamic>> _$VariantToSupabase(
  Variant instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'purchase_id': instance.purchaseId,
    'stock': instance.stock != null
        ? await StockAdapter().toSupabase(
            instance.stock!,
            provider: provider,
            repository: repository,
          )
        : null,
    'stock_id': instance.stockId,
    'tax_percentage': instance.taxPercentage,
    'name': instance.name,
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'branch_id': instance.branchId,
    'tax_name': instance.taxName,
    'item_seq': instance.itemSeq,
    'isrcc_cd': instance.isrccCd,
    'isrcc_nm': instance.isrccNm,
    'isrc_rt': instance.isrcRt,
    'isrc_amt': instance.isrcAmt,
    'tax_ty_cd': instance.taxTyCd,
    'bcd': instance.bcd,
    'item_cls_cd': instance.itemClsCd,
    'item_ty_cd': instance.itemTyCd,
    'item_std_nm': instance.itemStdNm,
    'orgn_nat_cd': instance.orgnNatCd,
    'pkg': instance.pkg,
    'item_cd': instance.itemCd,
    'pkg_unit_cd': instance.pkgUnitCd,
    'qty_unit_cd': instance.qtyUnitCd,
    'item_nm': instance.itemNm,
    'prc': instance.prc,
    'sply_amt': instance.splyAmt,
    'tin': instance.tin,
    'bhf_id': instance.bhfId,
    'dft_prc': instance.dftPrc,
    'add_info': instance.addInfo,
    'isrc_aplcb_yn': instance.isrcAplcbYn,
    'use_yn': instance.useYn,
    'regr_id': instance.regrId,
    'regr_nm': instance.regrNm,
    'modr_id': instance.modrId,
    'modr_nm': instance.modrNm,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'spplr_item_cls_cd': instance.spplrItemClsCd,
    'spplr_item_cd': instance.spplrItemCd,
    'spplr_item_nm': instance.spplrItemNm,
    'ebm_synced': instance.ebmSynced,
    'dc_rt': instance.dcRt,
    'expiration_date': instance.expirationDate?.toIso8601String(),
    'tot_wt': instance.totWt,
    'net_wt': instance.netWt,
    'spplr_nm': instance.spplrNm,
    'agnt_nm': instance.agntNm,
    'invc_fcur_amt': instance.invcFcurAmt,
    'invc_fcur_cd': instance.invcFcurCd,
    'invc_fcur_excrt': instance.invcFcurExcrt,
    'expt_nat_cd': instance.exptNatCd,
    'dcl_no': instance.dclNo,
    'task_cd': instance.taskCd,
    'dcl_de': instance.dclDe,
    'hs_cd': instance.hsCd,
    'impt_item_stts_cd': instance.imptItemSttsCd,
    'taxbl_amt': instance.taxblAmt,
    'tax_amt': instance.taxAmt,
    'tot_amt': instance.totAmt,
    'pchs_stts_cd': instance.pchsSttsCd,
    'is_shared': instance.isShared,
    'assigned': instance.assigned,
  };
}

Future<Variant> _$VariantFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Variant(
    id: data['id'] as String,
    purchaseId:
        data['purchase_id'] == null ? null : data['purchase_id'] as String?,
    stock: data['stock_Stock_brick_id'] == null
        ? null
        : (data['stock_Stock_brick_id'] > -1
            ? (await repository?.getAssociation<Stock>(
                Query.where(
                  'primaryKey',
                  data['stock_Stock_brick_id'] as int,
                  limit1: true,
                ),
              ))
                ?.first
            : null),
    stockId: data['stock_id'] == null ? null : data['stock_id'] as String?,
    taxPercentage:
        data['tax_percentage'] == null ? null : data['tax_percentage'],
    name: data['name'] as String,
    color: data['color'] == null ? null : data['color'] as String?,
    sku: data['sku'] == null ? null : data['sku'] as String?,
    productId:
        data['product_id'] == null ? null : data['product_id'] as String?,
    unit: data['unit'] == null ? null : data['unit'] as String?,
    productName:
        data['product_name'] == null ? null : data['product_name'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
    categoryName:
        data['category_name'] == null ? null : data['category_name'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    taxName: data['tax_name'] == null ? null : data['tax_name'] as String?,
    itemSeq: data['item_seq'] == null ? null : data['item_seq'] as int?,
    isrccCd: data['isrcc_cd'] == null ? null : data['isrcc_cd'] as String?,
    isrccNm: data['isrcc_nm'] == null ? null : data['isrcc_nm'] as String?,
    isrcRt: data['isrc_rt'] == null ? null : data['isrc_rt'] as int?,
    isrcAmt: data['isrc_amt'] == null ? null : data['isrc_amt'] as int?,
    taxTyCd: data['tax_ty_cd'] == null ? null : data['tax_ty_cd'] as String?,
    bcd: data['bcd'] == null ? null : data['bcd'] as String?,
    itemClsCd:
        data['item_cls_cd'] == null ? null : data['item_cls_cd'] as String?,
    itemTyCd: data['item_ty_cd'] == null ? null : data['item_ty_cd'] as String?,
    itemStdNm:
        data['item_std_nm'] == null ? null : data['item_std_nm'] as String?,
    orgnNatCd:
        data['orgn_nat_cd'] == null ? null : data['orgn_nat_cd'] as String?,
    pkg: data['pkg'] == null ? null : data['pkg'] as int?,
    itemCd: data['item_cd'] == null ? null : data['item_cd'] as String?,
    pkgUnitCd:
        data['pkg_unit_cd'] == null ? null : data['pkg_unit_cd'] as String?,
    qtyUnitCd:
        data['qty_unit_cd'] == null ? null : data['qty_unit_cd'] as String?,
    itemNm: data['item_nm'] == null ? null : data['item_nm'] as String?,
    prc: data['prc'] == null ? null : data['prc'] as double?,
    splyAmt: data['sply_amt'] == null ? null : data['sply_amt'] as double?,
    tin: data['tin'] == null ? null : data['tin'] as int?,
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    dftPrc: data['dft_prc'] == null ? null : data['dft_prc'] as double?,
    addInfo: data['add_info'] == null ? null : data['add_info'] as String?,
    isrcAplcbYn:
        data['isrc_aplcb_yn'] == null ? null : data['isrc_aplcb_yn'] as String?,
    useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
    regrId: data['regr_id'] == null ? null : data['regr_id'] as String?,
    regrNm: data['regr_nm'] == null ? null : data['regr_nm'] as String?,
    modrId: data['modr_id'] == null ? null : data['modr_id'] as String?,
    modrNm: data['modr_nm'] == null ? null : data['modr_nm'] as String?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    supplyPrice:
        data['supply_price'] == null ? null : data['supply_price'] as double?,
    retailPrice:
        data['retail_price'] == null ? null : data['retail_price'] as double?,
    spplrItemClsCd: data['spplr_item_cls_cd'] == null
        ? null
        : data['spplr_item_cls_cd'] as String?,
    spplrItemCd:
        data['spplr_item_cd'] == null ? null : data['spplr_item_cd'] as String?,
    spplrItemNm:
        data['spplr_item_nm'] == null ? null : data['spplr_item_nm'] as String?,
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
    dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as double?,
    expirationDate: data['expiration_date'] == null
        ? null
        : data['expiration_date'] == null
            ? null
            : DateTime.tryParse(data['expiration_date'] as String),
    totWt: data['tot_wt'] == null ? null : data['tot_wt'] as int?,
    netWt: data['net_wt'] == null ? null : data['net_wt'] as int?,
    spplrNm: data['spplr_nm'] == null ? null : data['spplr_nm'] as String?,
    agntNm: data['agnt_nm'] == null ? null : data['agnt_nm'] as String?,
    invcFcurAmt:
        data['invc_fcur_amt'] == null ? null : data['invc_fcur_amt'] as int?,
    invcFcurCd:
        data['invc_fcur_cd'] == null ? null : data['invc_fcur_cd'] as String?,
    invcFcurExcrt: data['invc_fcur_excrt'] == null
        ? null
        : data['invc_fcur_excrt'] as double?,
    exptNatCd:
        data['expt_nat_cd'] == null ? null : data['expt_nat_cd'] as String?,
    dclNo: data['dcl_no'] == null ? null : data['dcl_no'] as String?,
    taskCd: data['task_cd'] == null ? null : data['task_cd'] as String?,
    dclDe: data['dcl_de'] == null ? null : data['dcl_de'] as String?,
    hsCd: data['hs_cd'] == null ? null : data['hs_cd'] as String?,
    imptItemSttsCd: data['impt_item_stts_cd'] == null
        ? null
        : data['impt_item_stts_cd'] as String?,
    taxblAmt: data['taxbl_amt'] == null ? null : data['taxbl_amt'] as double?,
    taxAmt: data['tax_amt'] == null ? null : data['tax_amt'] as double?,
    totAmt: data['tot_amt'] == null ? null : data['tot_amt'] as double?,
    pchsSttsCd:
        data['pchs_stts_cd'] == null ? null : data['pchs_stts_cd'] as String?,
    isShared: data['is_shared'] == null ? null : data['is_shared'] == 1,
    assigned: data['assigned'] == null ? null : data['assigned'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$VariantToSqlite(
  Variant instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'purchase_id': instance.purchaseId,
    'stock_Stock_brick_id': instance.stock != null
        ? instance.stock!.primaryKey ??
            await provider.upsert<Stock>(
              instance.stock!,
              repository: repository,
            )
        : null,
    'stock_id': instance.stockId,
    'tax_percentage': instance.taxPercentage,
    'name': instance.name,
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'branch_id': instance.branchId,
    'tax_name': instance.taxName,
    'item_seq': instance.itemSeq,
    'isrcc_cd': instance.isrccCd,
    'isrcc_nm': instance.isrccNm,
    'isrc_rt': instance.isrcRt,
    'isrc_amt': instance.isrcAmt,
    'tax_ty_cd': instance.taxTyCd,
    'bcd': instance.bcd,
    'item_cls_cd': instance.itemClsCd,
    'item_ty_cd': instance.itemTyCd,
    'item_std_nm': instance.itemStdNm,
    'orgn_nat_cd': instance.orgnNatCd,
    'pkg': instance.pkg,
    'item_cd': instance.itemCd,
    'pkg_unit_cd': instance.pkgUnitCd,
    'qty_unit_cd': instance.qtyUnitCd,
    'item_nm': instance.itemNm,
    'prc': instance.prc,
    'sply_amt': instance.splyAmt,
    'tin': instance.tin,
    'bhf_id': instance.bhfId,
    'dft_prc': instance.dftPrc,
    'add_info': instance.addInfo,
    'isrc_aplcb_yn': instance.isrcAplcbYn,
    'use_yn': instance.useYn,
    'regr_id': instance.regrId,
    'regr_nm': instance.regrNm,
    'modr_id': instance.modrId,
    'modr_nm': instance.modrNm,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'spplr_item_cls_cd': instance.spplrItemClsCd,
    'spplr_item_cd': instance.spplrItemCd,
    'spplr_item_nm': instance.spplrItemNm,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'dc_rt': instance.dcRt,
    'expiration_date': instance.expirationDate?.toIso8601String(),
    'tot_wt': instance.totWt,
    'net_wt': instance.netWt,
    'spplr_nm': instance.spplrNm,
    'agnt_nm': instance.agntNm,
    'invc_fcur_amt': instance.invcFcurAmt,
    'invc_fcur_cd': instance.invcFcurCd,
    'invc_fcur_excrt': instance.invcFcurExcrt,
    'expt_nat_cd': instance.exptNatCd,
    'dcl_no': instance.dclNo,
    'task_cd': instance.taskCd,
    'dcl_de': instance.dclDe,
    'hs_cd': instance.hsCd,
    'impt_item_stts_cd': instance.imptItemSttsCd,
    'taxbl_amt': instance.taxblAmt,
    'tax_amt': instance.taxAmt,
    'tot_amt': instance.totAmt,
    'pchs_stts_cd': instance.pchsSttsCd,
    'is_shared':
        instance.isShared == null ? null : (instance.isShared! ? 1 : 0),
    'assigned': instance.assigned == null ? null : (instance.assigned! ? 1 : 0),
  };
}

/// Construct a [Variant]
class VariantAdapter extends OfflineFirstWithSupabaseAdapter<Variant> {
  VariantAdapter();

  @override
  final supabaseTableName = 'variants';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'purchaseId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'purchase_id',
    ),
    'stock': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'stock',
      associationType: Stock,
      associationIsNullable: true,
    ),
    'stockId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_id',
    ),
    'taxPercentage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'color': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'color',
    ),
    'sku': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sku',
    ),
    'productId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_id',
    ),
    'unit': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'unit',
    ),
    'productName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_name',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'categoryName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_name',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'taxName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_name',
    ),
    'itemSeq': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_seq',
    ),
    'isrccCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrcc_cd',
    ),
    'isrccNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrcc_nm',
    ),
    'isrcRt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrc_rt',
    ),
    'isrcAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrc_amt',
    ),
    'taxTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_ty_cd',
    ),
    'bcd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bcd',
    ),
    'itemClsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_cls_cd',
    ),
    'itemTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_ty_cd',
    ),
    'itemStdNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_std_nm',
    ),
    'orgnNatCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'orgn_nat_cd',
    ),
    'pkg': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pkg',
    ),
    'itemCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_cd',
    ),
    'pkgUnitCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pkg_unit_cd',
    ),
    'qtyUnitCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'qty_unit_cd',
    ),
    'itemNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_nm',
    ),
    'prc': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'prc',
    ),
    'splyAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sply_amt',
    ),
    'tin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tin',
    ),
    'bhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bhf_id',
    ),
    'dftPrc': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dft_prc',
    ),
    'addInfo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'add_info',
    ),
    'isrcAplcbYn': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrc_aplcb_yn',
    ),
    'useYn': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'use_yn',
    ),
    'regrId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'regr_id',
    ),
    'regrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'regr_nm',
    ),
    'modrId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'modr_id',
    ),
    'modrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'modr_nm',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'supplyPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'supply_price',
    ),
    'retailPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'retail_price',
    ),
    'spplrItemClsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_cls_cd',
    ),
    'spplrItemCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_cd',
    ),
    'spplrItemNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_nm',
    ),
    'ebmSynced': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
    ),
    'dcRt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dc_rt',
    ),
    'expirationDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'expiration_date',
    ),
    'totWt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_wt',
    ),
    'netWt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'net_wt',
    ),
    'spplrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
    ),
    'agntNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'agnt_nm',
    ),
    'invcFcurAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invc_fcur_amt',
    ),
    'invcFcurCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invc_fcur_cd',
    ),
    'invcFcurExcrt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invc_fcur_excrt',
    ),
    'exptNatCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'expt_nat_cd',
    ),
    'dclNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dcl_no',
    ),
    'taskCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'task_cd',
    ),
    'dclDe': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dcl_de',
    ),
    'hsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'hs_cd',
    ),
    'imptItemSttsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'impt_item_stts_cd',
    ),
    'taxblAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'taxbl_amt',
    ),
    'taxAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amt',
    ),
    'totAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_amt',
    ),
    'pchsSttsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pchs_stts_cd',
    ),
    'isShared': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_shared',
    ),
    'assigned': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'assigned',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'purchaseId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'purchase_id',
      iterable: false,
      type: String,
    ),
    'stock': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'stock_Stock_brick_id',
      iterable: false,
      type: Stock,
    ),
    'stockId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_id',
      iterable: false,
      type: String,
    ),
    'taxPercentage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
      iterable: false,
      type: num,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'color': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'color',
      iterable: false,
      type: String,
    ),
    'sku': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sku',
      iterable: false,
      type: String,
    ),
    'productId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_id',
      iterable: false,
      type: String,
    ),
    'unit': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unit',
      iterable: false,
      type: String,
    ),
    'productName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_name',
      iterable: false,
      type: String,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
    'categoryName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_name',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'taxName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_name',
      iterable: false,
      type: String,
    ),
    'itemSeq': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_seq',
      iterable: false,
      type: int,
    ),
    'isrccCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrcc_cd',
      iterable: false,
      type: String,
    ),
    'isrccNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrcc_nm',
      iterable: false,
      type: String,
    ),
    'isrcRt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrc_rt',
      iterable: false,
      type: int,
    ),
    'isrcAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrc_amt',
      iterable: false,
      type: int,
    ),
    'taxTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_ty_cd',
      iterable: false,
      type: String,
    ),
    'bcd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bcd',
      iterable: false,
      type: String,
    ),
    'itemClsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_cls_cd',
      iterable: false,
      type: String,
    ),
    'itemTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_ty_cd',
      iterable: false,
      type: String,
    ),
    'itemStdNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_std_nm',
      iterable: false,
      type: String,
    ),
    'orgnNatCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'orgn_nat_cd',
      iterable: false,
      type: String,
    ),
    'pkg': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pkg',
      iterable: false,
      type: int,
    ),
    'itemCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_cd',
      iterable: false,
      type: String,
    ),
    'pkgUnitCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pkg_unit_cd',
      iterable: false,
      type: String,
    ),
    'qtyUnitCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'qty_unit_cd',
      iterable: false,
      type: String,
    ),
    'itemNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_nm',
      iterable: false,
      type: String,
    ),
    'prc': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'prc',
      iterable: false,
      type: double,
    ),
    'splyAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sply_amt',
      iterable: false,
      type: double,
    ),
    'tin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tin',
      iterable: false,
      type: int,
    ),
    'bhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bhf_id',
      iterable: false,
      type: String,
    ),
    'dftPrc': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dft_prc',
      iterable: false,
      type: double,
    ),
    'addInfo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'add_info',
      iterable: false,
      type: String,
    ),
    'isrcAplcbYn': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrc_aplcb_yn',
      iterable: false,
      type: String,
    ),
    'useYn': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'use_yn',
      iterable: false,
      type: String,
    ),
    'regrId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'regr_id',
      iterable: false,
      type: String,
    ),
    'regrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'regr_nm',
      iterable: false,
      type: String,
    ),
    'modrId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'modr_id',
      iterable: false,
      type: String,
    ),
    'modrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'modr_nm',
      iterable: false,
      type: String,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'supplyPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'supply_price',
      iterable: false,
      type: double,
    ),
    'retailPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'retail_price',
      iterable: false,
      type: double,
    ),
    'spplrItemClsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_item_cls_cd',
      iterable: false,
      type: String,
    ),
    'spplrItemCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_item_cd',
      iterable: false,
      type: String,
    ),
    'spplrItemNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_item_nm',
      iterable: false,
      type: String,
    ),
    'ebmSynced': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
      iterable: false,
      type: bool,
    ),
    'dcRt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dc_rt',
      iterable: false,
      type: double,
    ),
    'expirationDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'expiration_date',
      iterable: false,
      type: DateTime,
    ),
    'totWt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_wt',
      iterable: false,
      type: int,
    ),
    'netWt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'net_wt',
      iterable: false,
      type: int,
    ),
    'spplrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
      iterable: false,
      type: String,
    ),
    'agntNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'agnt_nm',
      iterable: false,
      type: String,
    ),
    'invcFcurAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invc_fcur_amt',
      iterable: false,
      type: int,
    ),
    'invcFcurCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invc_fcur_cd',
      iterable: false,
      type: String,
    ),
    'invcFcurExcrt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invc_fcur_excrt',
      iterable: false,
      type: double,
    ),
    'exptNatCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'expt_nat_cd',
      iterable: false,
      type: String,
    ),
    'dclNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dcl_no',
      iterable: false,
      type: String,
    ),
    'taskCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'task_cd',
      iterable: false,
      type: String,
    ),
    'dclDe': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dcl_de',
      iterable: false,
      type: String,
    ),
    'hsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'hs_cd',
      iterable: false,
      type: String,
    ),
    'imptItemSttsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'impt_item_stts_cd',
      iterable: false,
      type: String,
    ),
    'taxblAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt',
      iterable: false,
      type: double,
    ),
    'taxAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt',
      iterable: false,
      type: double,
    ),
    'totAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_amt',
      iterable: false,
      type: double,
    ),
    'pchsSttsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pchs_stts_cd',
      iterable: false,
      type: String,
    ),
    'isShared': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_shared',
      iterable: false,
      type: bool,
    ),
    'assigned': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'assigned',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Variant instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Variant` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Variant';

  @override
  Future<Variant> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$VariantFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Variant input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$VariantToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Variant> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$VariantFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Variant input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$VariantToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
