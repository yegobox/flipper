// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Variant> _$VariantFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Variant(
      id: data['id'] as int,
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      name: data['name'] as String?,
      color: data['color'] as String?,
      sku: data['sku'] as String?,
      productId: data['product_id'] as int?,
      unit: data['unit'] as String?,
      productName: data['product_name'] as String?,
      branchId: data['branch_id'] as int?,
      taxName: data['tax_name'] as String?,
      taxPercentage: data['tax_percentage'] as double? ?? 18.0,
      itemSeq: data['item_seq'] as int?,
      isrccCd: data['isrcc_cd'] as String?,
      isrccNm: data['isrcc_nm'] as String?,
      isrcRt: data['isrc_rt'] as int?,
      isrcAmt: data['isrc_amt'] as int?,
      taxTyCd: data['tax_ty_cd'] as String?,
      bcd: data['bcd'] as String?,
      itemClsCd: data['item_cls_cd'] as String?,
      itemTyCd: data['item_ty_cd'] as String?,
      itemStdNm: data['item_std_nm'] as String?,
      orgnNatCd: data['orgn_nat_cd'] as String?,
      pkg: data['pkg'] as String?,
      itemCd: data['item_cd'] as String?,
      pkgUnitCd: data['pkg_unit_cd'] as String?,
      qtyUnitCd: data['qty_unit_cd'] as String?,
      itemNm: data['item_nm'] as String?,
      prc: data['prc'] as double? ?? 0.0,
      splyAmt: data['sply_amt'] as double?,
      tin: data['tin'] as int?,
      bhfId: data['bhf_id'] as String?,
      dftPrc: data['dft_prc'] as double? ?? 0.0,
      addInfo: data['add_info'] as String?,
      isrcAplcbYn: data['isrc_aplcb_yn'] as String?,
      useYn: data['use_yn'] as String?,
      regrId: data['regr_id'] as String?,
      regrNm: data['regr_nm'] as String?,
      modrId: data['modr_id'] as String?,
      modrNm: data['modr_nm'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      supplyPrice: data['supply_price'] as double?,
      retailPrice: data['retail_price'] as double?,
      spplrItemClsCd: data['spplr_item_cls_cd'] as String?,
      spplrItemCd: data['spplr_item_cd'] as String?,
      spplrItemNm: data['spplr_item_nm'] as String?,
      ebmSynced: data['ebm_synced'] as bool?,
      dcRt: data['dc_rt'] as double?,
      expirationDate: data['expiration_date'] == null
          ? null
          : DateTime.tryParse(data['expiration_date'] as String),
      stockId: data['stock_id'] as int?);
}

Future<Map<String, dynamic>> _$VariantToSupabase(Variant instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'name': instance.name,
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'branch_id': instance.branchId,
    'tax_name': instance.taxName,
    'tax_percentage': instance.taxPercentage,
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
    'stock_id': instance.stockId
  };
}

Future<Variant> _$VariantFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Variant(
      id: data['id'] as int,
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      name: data['name'] == null ? null : data['name'] as String?,
      color: data['color'] == null ? null : data['color'] as String?,
      sku: data['sku'] == null ? null : data['sku'] as String?,
      productId: data['product_id'] == null ? null : data['product_id'] as int?,
      unit: data['unit'] == null ? null : data['unit'] as String?,
      productName:
          data['product_name'] == null ? null : data['product_name'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      taxName: data['tax_name'] == null ? null : data['tax_name'] as String?,
      taxPercentage: data['tax_percentage'] == null
          ? null
          : data['tax_percentage'] as double?,
      itemSeq: data['item_seq'] == null ? null : data['item_seq'] as int?,
      isrccCd: data['isrcc_cd'] == null ? null : data['isrcc_cd'] as String?,
      isrccNm: data['isrcc_nm'] == null ? null : data['isrcc_nm'] as String?,
      isrcRt: data['isrc_rt'] == null ? null : data['isrc_rt'] as int?,
      isrcAmt: data['isrc_amt'] == null ? null : data['isrc_amt'] as int?,
      taxTyCd: data['tax_ty_cd'] == null ? null : data['tax_ty_cd'] as String?,
      bcd: data['bcd'] == null ? null : data['bcd'] as String?,
      itemClsCd:
          data['item_cls_cd'] == null ? null : data['item_cls_cd'] as String?,
      itemTyCd:
          data['item_ty_cd'] == null ? null : data['item_ty_cd'] as String?,
      itemStdNm:
          data['item_std_nm'] == null ? null : data['item_std_nm'] as String?,
      orgnNatCd:
          data['orgn_nat_cd'] == null ? null : data['orgn_nat_cd'] as String?,
      pkg: data['pkg'] == null ? null : data['pkg'] as String?,
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
      isrcAplcbYn: data['isrc_aplcb_yn'] == null
          ? null
          : data['isrc_aplcb_yn'] as String?,
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
      spplrItemCd: data['spplr_item_cd'] == null
          ? null
          : data['spplr_item_cd'] as String?,
      spplrItemNm: data['spplr_item_nm'] == null
          ? null
          : data['spplr_item_nm'] as String?,
      ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
      dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as double?,
      expirationDate: data['expiration_date'] == null
          ? null
          : data['expiration_date'] == null
              ? null
              : DateTime.tryParse(data['expiration_date'] as String),
      stockId: data['stock_id'] == null ? null : data['stock_id'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$VariantToSqlite(Variant instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'name': instance.name,
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'branch_id': instance.branchId,
    'tax_name': instance.taxName,
    'tax_percentage': instance.taxPercentage,
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
    'stock_id': instance.stockId
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
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'taxName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_name',
    ),
    'taxPercentage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
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
    'stockId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_id',
    )
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
      type: int,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
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
      type: int,
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
    'taxPercentage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
      iterable: false,
      type: double,
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
      type: String,
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
    'stockId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_id',
      iterable: false,
      type: int,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Variant instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Variant` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Variant';

  @override
  Future<Variant> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Variant input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Variant> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Variant input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantToSqlite(input,
          provider: provider, repository: repository);
}
