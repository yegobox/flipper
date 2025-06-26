// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<TransactionItem> _$TransactionItemFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionItem(
    id: data['id'] as String?,
    name: data['name'] as String,
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
        : data['transaction_id'] as String?,
    variantId:
        data['variant_id'] == null ? null : data['variant_id'] as String?,
    qty: data['qty'] as num,
    price: data['price'] as num,
    discount: data['discount'] as num,
    remainingStock: data['remaining_stock'] == null
        ? null
        : data['remaining_stock'] as num?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    isRefunded:
        data['is_refunded'] == null ? null : data['is_refunded'] as bool?,
    doneWithTransaction: data['done_with_transaction'] == null
        ? null
        : data['done_with_transaction'] as bool?,
    active: data['active'] == null ? null : data['active'] as bool?,
    dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as num?,
    dcAmt: data['dc_amt'] == null ? null : data['dc_amt'] as num?,
    taxblAmt: data['taxbl_amt'] == null ? null : data['taxbl_amt'] as num?,
    taxAmt: data['tax_amt'] == null ? null : data['tax_amt'] as num?,
    totAmt: data['tot_amt'] == null ? null : data['tot_amt'] as num?,
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
    prc: data['prc'] as num,
    splyAmt: data['sply_amt'] == null ? null : data['sply_amt'] as num?,
    tin: data['tin'] == null ? null : data['tin'] as int?,
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    dftPrc: data['dft_prc'] == null ? null : data['dft_prc'] as num?,
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
    taxPercentage:
        data['tax_percentage'] == null ? null : data['tax_percentage'] as num?,
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
    taxName: data['tax_name'] == null ? null : data['tax_name'] as String?,
    supplyPrice:
        data['supply_price'] == null ? null : data['supply_price'] as num?,
    retailPrice:
        data['retail_price'] == null ? null : data['retail_price'] as num?,
    spplrItemNm:
        data['spplr_item_nm'] == null ? null : data['spplr_item_nm'] as String?,
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
        : data['invc_fcur_excrt'] as num?,
    exptNatCd:
        data['expt_nat_cd'] == null ? null : data['expt_nat_cd'] as String?,
    dclNo: data['dcl_no'] == null ? null : data['dcl_no'] as String?,
    taskCd: data['task_cd'] == null ? null : data['task_cd'] as String?,
    dclDe: data['dcl_de'] == null ? null : data['dcl_de'] as String?,
    hsCd: data['hs_cd'] == null ? null : data['hs_cd'] as String?,
    imptItemSttsCd: data['impt_item_stts_cd'] == null
        ? null
        : data['impt_item_stts_cd'] as String?,
    isShared: data['is_shared'] == null ? null : data['is_shared'] as bool?,
    assigned: data['assigned'] == null ? null : data['assigned'] as bool?,
    spplrItemClsCd: data['spplr_item_cls_cd'] == null
        ? null
        : data['spplr_item_cls_cd'] as String?,
    spplrItemCd:
        data['spplr_item_cd'] == null ? null : data['spplr_item_cd'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] as bool?,
    partOfComposite: data['part_of_composite'] == null
        ? null
        : data['part_of_composite'] as bool?,
    compositePrice: data['composite_price'] == null
        ? null
        : data['composite_price'] as num?,
    inventoryRequest: data['inventory_request'] == null
        ? null
        : await InventoryRequestAdapter().fromSupabase(
            data['inventory_request'],
            provider: provider,
            repository: repository,
          ),
    inventoryRequestId: data['inventory_request_id'] == null
        ? null
        : data['inventory_request_id'] as String?,
    ignoreForReport: data['ignore_for_report'] as bool?,
  );
}

Future<Map<String, dynamic>> _$TransactionItemToSupabase(
  TransactionItem instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'remaining_stock': instance.remainingStock,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
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
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'tax_name': instance.taxName,
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'spplr_item_nm': instance.spplrItemNm,
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
    'is_shared': instance.isShared,
    'assigned': instance.assigned,
    'spplr_item_cls_cd': instance.spplrItemClsCd,
    'spplr_item_cd': instance.spplrItemCd,
    'branch_id': instance.branchId,
    'ebm_synced': instance.ebmSynced,
    'part_of_composite': instance.partOfComposite,
    'composite_price': instance.compositePrice,
    'inventory_request': instance.inventoryRequest != null
        ? await InventoryRequestAdapter().toSupabase(
            instance.inventoryRequest!,
            provider: provider,
            repository: repository,
          )
        : null,
    'inventory_request_id': instance.inventoryRequestId,
    'ignore_for_report': instance.ignoreForReport,
  };
}

Future<TransactionItem> _$TransactionItemFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionItem(
    id: data['id'] as String,
    name: data['name'] as String,
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
        : data['transaction_id'] as String?,
    variantId:
        data['variant_id'] == null ? null : data['variant_id'] as String?,
    qty: data['qty'] as num,
    price: data['price'] as num,
    discount: data['discount'] as num,
    remainingStock: data['remaining_stock'] == null
        ? null
        : data['remaining_stock'] as num?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    isRefunded: data['is_refunded'] == null ? null : data['is_refunded'] == 1,
    doneWithTransaction: data['done_with_transaction'] == null
        ? null
        : data['done_with_transaction'] == 1,
    active: data['active'] == null ? null : data['active'] == 1,
    dcRt: data['dc_rt'] == null ? null : data['dc_rt'] as num?,
    dcAmt: data['dc_amt'] == null ? null : data['dc_amt'] as num?,
    taxblAmt: data['taxbl_amt'] == null ? null : data['taxbl_amt'] as num?,
    taxAmt: data['tax_amt'] == null ? null : data['tax_amt'] as num?,
    totAmt: data['tot_amt'] == null ? null : data['tot_amt'] as num?,
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
    prc: data['prc'] as num,
    splyAmt: data['sply_amt'] == null ? null : data['sply_amt'] as num?,
    tin: data['tin'] == null ? null : data['tin'] as int?,
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    dftPrc: data['dft_prc'] == null ? null : data['dft_prc'] as num?,
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
        data['tax_percentage'] == null ? null : data['tax_percentage'] as num?,
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
    taxName: data['tax_name'] == null ? null : data['tax_name'] as String?,
    supplyPrice:
        data['supply_price'] == null ? null : data['supply_price'] as num?,
    retailPrice:
        data['retail_price'] == null ? null : data['retail_price'] as num?,
    spplrItemNm:
        data['spplr_item_nm'] == null ? null : data['spplr_item_nm'] as String?,
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
        : data['invc_fcur_excrt'] as num?,
    exptNatCd:
        data['expt_nat_cd'] == null ? null : data['expt_nat_cd'] as String?,
    dclNo: data['dcl_no'] == null ? null : data['dcl_no'] as String?,
    taskCd: data['task_cd'] == null ? null : data['task_cd'] as String?,
    dclDe: data['dcl_de'] == null ? null : data['dcl_de'] as String?,
    hsCd: data['hs_cd'] == null ? null : data['hs_cd'] as String?,
    imptItemSttsCd: data['impt_item_stts_cd'] == null
        ? null
        : data['impt_item_stts_cd'] as String?,
    isShared: data['is_shared'] == null ? null : data['is_shared'] == 1,
    assigned: data['assigned'] == null ? null : data['assigned'] == 1,
    spplrItemClsCd: data['spplr_item_cls_cd'] == null
        ? null
        : data['spplr_item_cls_cd'] as String?,
    spplrItemCd:
        data['spplr_item_cd'] == null ? null : data['spplr_item_cd'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
    partOfComposite: data['part_of_composite'] == null
        ? null
        : data['part_of_composite'] == 1,
    compositePrice: data['composite_price'] == null
        ? null
        : data['composite_price'] as num?,
    inventoryRequest: data['inventory_request_InventoryRequest_brick_id'] ==
            null
        ? null
        : (data['inventory_request_InventoryRequest_brick_id'] > -1
            ? (await repository?.getAssociation<InventoryRequest>(
                Query.where(
                  'primaryKey',
                  data['inventory_request_InventoryRequest_brick_id'] as int,
                  limit1: true,
                ),
              ))
                ?.first
            : null),
    inventoryRequestId: data['inventory_request_id'] == null
        ? null
        : data['inventory_request_id'] as String?,
    ignoreForReport: data['ignore_for_report'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionItemToSqlite(
  TransactionItem instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'remaining_stock': instance.remainingStock,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
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
    'color': instance.color,
    'sku': instance.sku,
    'product_id': instance.productId,
    'unit': instance.unit,
    'product_name': instance.productName,
    'category_id': instance.categoryId,
    'category_name': instance.categoryName,
    'tax_name': instance.taxName,
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'spplr_item_nm': instance.spplrItemNm,
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
    'is_shared':
        instance.isShared == null ? null : (instance.isShared! ? 1 : 0),
    'assigned': instance.assigned == null ? null : (instance.assigned! ? 1 : 0),
    'spplr_item_cls_cd': instance.spplrItemClsCd,
    'spplr_item_cd': instance.spplrItemCd,
    'branch_id': instance.branchId,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'part_of_composite': instance.partOfComposite == null
        ? null
        : (instance.partOfComposite! ? 1 : 0),
    'composite_price': instance.compositePrice,
    'inventory_request_InventoryRequest_brick_id':
        instance.inventoryRequest != null
            ? instance.inventoryRequest!.primaryKey ??
                await provider.upsert<InventoryRequest>(
                  instance.inventoryRequest!,
                  repository: repository,
                )
            : null,
    'inventory_request_id': instance.inventoryRequestId,
    'ignore_for_report': instance.ignoreForReport ? 1 : 0,
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
    'taxName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_name',
    ),
    'supplyPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'supply_price',
    ),
    'retailPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'retail_price',
    ),
    'spplrItemNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_nm',
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
    'isShared': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_shared',
    ),
    'assigned': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'assigned',
    ),
    'spplrItemClsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_cls_cd',
    ),
    'spplrItemCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_item_cd',
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
    ),
    'inventoryRequest': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'inventory_request',
      associationType: InventoryRequest,
      associationIsNullable: true,
      foreignKey: 'inventory_request_id',
    ),
    'inventoryRequestId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'inventory_request_id',
    ),
    'ignoreForReport': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ignore_for_report',
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
      type: String,
    ),
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: String,
    ),
    'qty': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'qty',
      iterable: false,
      type: num,
    ),
    'price': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'price',
      iterable: false,
      type: num,
    ),
    'discount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount',
      iterable: false,
      type: num,
    ),
    'remainingStock': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remaining_stock',
      iterable: false,
      type: num,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
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
      type: num,
    ),
    'dcAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dc_amt',
      iterable: false,
      type: num,
    ),
    'taxblAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt',
      iterable: false,
      type: num,
    ),
    'taxAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt',
      iterable: false,
      type: num,
    ),
    'totAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_amt',
      iterable: false,
      type: num,
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
      type: num,
    ),
    'splyAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sply_amt',
      iterable: false,
      type: num,
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
      type: num,
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
    'taxName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_name',
      iterable: false,
      type: String,
    ),
    'supplyPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'supply_price',
      iterable: false,
      type: num,
    ),
    'retailPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'retail_price',
      iterable: false,
      type: num,
    ),
    'spplrItemNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_item_nm',
      iterable: false,
      type: String,
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
      type: num,
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
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
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
      type: num,
    ),
    'inventoryRequest': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'inventory_request_InventoryRequest_brick_id',
      iterable: false,
      type: InventoryRequest,
    ),
    'inventoryRequestId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'inventory_request_id',
      iterable: false,
      type: String,
    ),
    'ignoreForReport': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ignore_for_report',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    TransactionItem instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `TransactionItem` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'TransactionItem';

  @override
  Future<TransactionItem> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionItemFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    TransactionItem input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionItemToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<TransactionItem> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionItemFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    TransactionItem input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionItemToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
