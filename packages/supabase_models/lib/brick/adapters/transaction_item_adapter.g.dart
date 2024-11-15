// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<TransactionItem> _$TransactionItemFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return TransactionItem(
      id: data['id'] as int,
      name: data['name'] as String?,
      quantityRequested: data['quantity_requested'] as int?,
      quantityApproved: data['quantity_approved'] as int?,
      quantityShipped: data['quantity_shipped'] as int?,
      transactionId: data['transaction_id'] as int?,
      variantId: data['variant_id'] as int?,
      qty: data['qty'] as double?,
      price: data['price'] as double?,
      discount: data['discount'] as double?,
      type: data['type'] as String?,
      remainingStock: data['remaining_stock'] as double?,
      createdAt: data['created_at'] as String?,
      updatedAt: data['updated_at'] as String?,
      isTaxExempted: data['is_tax_exempted'] as bool?,
      isRefunded: data['is_refunded'] as bool?,
      doneWithTransaction: data['done_with_transaction'] as bool?,
      active: data['active'] as bool?,
      dcRt: data['dc_rt'] as double?,
      dcAmt: data['dc_amt'] as double?,
      taxblAmt: data['taxbl_amt'] as double?,
      taxAmt: data['tax_amt'] as double?,
      totAmt: data['tot_amt'] as double?,
      itemSeq: data['item_seq'] as int?,
      isrccCd: data['isrcc_cd'] as String?,
      isrccNm: data['isrcc_nm'] as String?,
      isrcR: data['isrc_r'] as int?,
      isrcAm: data['isrc_am'] as int?,
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
      prc: data['prc'] as double,
      splyAmt: data['sply_amt'] as double,
      tin: data['tin'] as int?,
      bhfId: data['bhf_id'] as String?,
      dftPrc: data['dft_prc'] as double?,
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
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      branchId: data['branch_id'] as int?,
      ebmSynced: data['ebm_synced'] as bool?,
      partOfComposite: data['part_of_composite'] as bool?,
      compositePrice: data['composite_price'] as double?);
}

Future<Map<String, dynamic>> _$TransactionItemToSupabase(
    TransactionItem instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'quantity_requested': instance.quantityRequested,
    'quantity_approved': instance.quantityApproved,
    'quantity_shipped': instance.quantityShipped,
    'transaction_id': instance.transactionId,
    'variant_id': instance.variantId,
    'qty': instance.qty,
    'price': instance.price,
    'discount': instance.discount,
    'type': instance.type,
    'remaining_stock': instance.remainingStock,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'is_tax_exempted': instance.isTaxExempted,
    'is_refunded': instance.isRefunded,
    'done_with_transaction': instance.doneWithTransaction,
    'active': instance.active,
    'dc_rt': instance.dcRt,
    'dc_amt': instance.dcAmt,
    'taxbl_amt': instance.taxblAmt,
    'tax_amt': instance.taxAmt,
    'tot_amt': instance.totAmt,
    'item_seq': instance.itemSeq,
    'isrcc_cd': instance.isrccCd,
    'isrcc_nm': instance.isrccNm,
    'isrc_r': instance.isrcR,
    'isrc_am': instance.isrcAm,
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
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'branch_id': instance.branchId,
    'ebm_synced': instance.ebmSynced,
    'part_of_composite': instance.partOfComposite,
    'composite_price': instance.compositePrice
  };
}

Future<TransactionItem> _$TransactionItemFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return TransactionItem(
      id: data['id'] as int,
      name: data['name'] == null ? null : data['name'] as String?,
      quantityRequested: data['quantity_requested'] == null
          ? null
          : data['quantity_requested'] as int?,
      quantityApproved: data['quantity_approved'] == null
          ? null
          : data['quantity_approved'] as int?,
      quantityShipped: data['quantity_shipped'] == null
          ? null
          : data['quantity_shipped'] as int?,
      transactionId: data['transaction_id'] == null
          ? null
          : data['transaction_id'] as int?,
      variantId: data['variant_id'] == null ? null : data['variant_id'] as int?,
      qty: data['qty'] == null ? null : data['qty'] as double?,
      price: data['price'] == null ? null : data['price'] as double?,
      discount: data['discount'] == null ? null : data['discount'] as double?,
      type: data['type'] == null ? null : data['type'] as String?,
      remainingStock: data['remaining_stock'] == null
          ? null
          : data['remaining_stock'] as double?,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
      updatedAt:
          data['updated_at'] == null ? null : data['updated_at'] as String?,
      isTaxExempted:
          data['is_tax_exempted'] == null ? null : data['is_tax_exempted'] == 1,
      isRefunded: data['is_refunded'] == null ? null : data['is_refunded'] == 1,
      doneWithTransaction: data['done_with_transaction'] == null
          ? null
          : data['done_with_transaction'] == 1,
      active: data['active'] == null ? null : data['active'] == 1,
      dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as double?,
      dcAmt: data['dc_amt'] == null ? null : data['dc_amt'] as double?,
      taxblAmt: data['taxbl_amt'] == null ? null : data['taxbl_amt'] as double?,
      taxAmt: data['tax_amt'] == null ? null : data['tax_amt'] as double?,
      totAmt: data['tot_amt'] == null ? null : data['tot_amt'] as double?,
      itemSeq: data['item_seq'] == null ? null : data['item_seq'] as int?,
      isrccCd: data['isrcc_cd'] == null ? null : data['isrcc_cd'] as String?,
      isrccNm: data['isrcc_nm'] == null ? null : data['isrcc_nm'] as String?,
      isrcR: data['isrc_r'] == null ? null : data['isrc_r'] as int?,
      isrcAm: data['isrc_am'] == null ? null : data['isrc_am'] as int?,
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
      prc: data['prc'] as double,
      splyAmt: data['sply_amt'] as double,
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
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
      partOfComposite: data['part_of_composite'] == null
          ? null
          : data['part_of_composite'] == 1,
      compositePrice: data['composite_price'] == null
          ? null
          : data['composite_price'] as double?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionItemToSqlite(TransactionItem instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'quantity_requested': instance.quantityRequested,
    'quantity_approved': instance.quantityApproved,
    'quantity_shipped': instance.quantityShipped,
    'transaction_id': instance.transactionId,
    'variant_id': instance.variantId,
    'qty': instance.qty,
    'price': instance.price,
    'discount': instance.discount,
    'type': instance.type,
    'remaining_stock': instance.remainingStock,
    'created_at': instance.createdAt,
    'updated_at': instance.updatedAt,
    'is_tax_exempted': instance.isTaxExempted == null
        ? null
        : (instance.isTaxExempted! ? 1 : 0),
    'is_refunded':
        instance.isRefunded == null ? null : (instance.isRefunded! ? 1 : 0),
    'done_with_transaction': instance.doneWithTransaction == null
        ? null
        : (instance.doneWithTransaction! ? 1 : 0),
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'dc_rt': instance.dcRt,
    'dc_amt': instance.dcAmt,
    'taxbl_amt': instance.taxblAmt,
    'tax_amt': instance.taxAmt,
    'tot_amt': instance.totAmt,
    'item_seq': instance.itemSeq,
    'isrcc_cd': instance.isrccCd,
    'isrcc_nm': instance.isrccNm,
    'isrc_r': instance.isrcR,
    'isrc_am': instance.isrcAm,
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
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'branch_id': instance.branchId,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'part_of_composite': instance.partOfComposite == null
        ? null
        : (instance.partOfComposite! ? 1 : 0),
    'composite_price': instance.compositePrice
  };
}

/// Construct a [TransactionItem]
class TransactionItemAdapter
    extends OfflineFirstWithSupabaseAdapter<TransactionItem> {
  TransactionItemAdapter();

  @override
  final supabaseTableName = 'transaction_items';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'quantityRequested': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'quantity_requested',
    ),
    'quantityApproved': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'quantity_approved',
    ),
    'quantityShipped': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'quantity_shipped',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'variantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_id',
    ),
    'qty': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'qty',
    ),
    'price': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'price',
    ),
    'discount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'remainingStock': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remaining_stock',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'isTaxExempted': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_tax_exempted',
    ),
    'isRefunded': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_refunded',
    ),
    'doneWithTransaction': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'done_with_transaction',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'dcRt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dc_rt',
    ),
    'dcAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dc_amt',
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
    'isrcR': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrc_r',
    ),
    'isrcAm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'isrc_am',
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
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'ebmSynced': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
    ),
    'partOfComposite': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'part_of_composite',
    ),
    'compositePrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'composite_price',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'quantityRequested': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'quantity_requested',
      iterable: false,
      type: int,
    ),
    'quantityApproved': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'quantity_approved',
      iterable: false,
      type: int,
    ),
    'quantityShipped': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'quantity_shipped',
      iterable: false,
      type: int,
    ),
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: int,
    ),
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: int,
    ),
    'qty': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'qty',
      iterable: false,
      type: double,
    ),
    'price': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'price',
      iterable: false,
      type: double,
    ),
    'discount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount',
      iterable: false,
      type: double,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'remainingStock': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remaining_stock',
      iterable: false,
      type: double,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: String,
    ),
    'isTaxExempted': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_tax_exempted',
      iterable: false,
      type: bool,
    ),
    'isRefunded': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_refunded',
      iterable: false,
      type: bool,
    ),
    'doneWithTransaction': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'done_with_transaction',
      iterable: false,
      type: bool,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'dcRt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dc_rt',
      iterable: false,
      type: double,
    ),
    'dcAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dc_amt',
      iterable: false,
      type: double,
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
    'isrcR': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrc_r',
      iterable: false,
      type: int,
    ),
    'isrcAm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'isrc_am',
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
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'ebmSynced': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
      iterable: false,
      type: bool,
    ),
    'partOfComposite': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'part_of_composite',
      iterable: false,
      type: bool,
    ),
    'compositePrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'composite_price',
      iterable: false,
      type: double,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      TransactionItem instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `TransactionItem` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'TransactionItem';

  @override
  Future<TransactionItem> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TransactionItemFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(TransactionItem input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TransactionItemToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<TransactionItem> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TransactionItemFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(TransactionItem input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TransactionItemToSqlite(input,
          provider: provider, repository: repository);
}
