// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Purchase> _$PurchaseFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Purchase(
      id: data['id'] as String?,
      spplrTin: data['spplr_tin'] as String,
      spplrNm: data['spplr_nm'] as String,
      spplrBhfId: data['spplr_bhf_id'] as String,
      spplrInvcNo: data['spplr_invc_no'] as int,
      rcptTyCd: data['rcpt_ty_cd'] as String,
      pmtTyCd: data['pmt_ty_cd'] as String,
      cfmDt: data['cfm_dt'] as String,
      salesDt: data['sales_dt'] as String,
      stockRlsDt:
          data['stock_rls_dt'] == null ? null : data['stock_rls_dt'] as String?,
      totItemCnt: data['tot_item_cnt'] as int,
      taxblAmtA: data['taxbl_amt_a'] as num,
      taxblAmtB: data['taxbl_amt_b'] as num,
      taxblAmtC: data['taxbl_amt_c'] as num,
      taxblAmtD: data['taxbl_amt_d'] as num,
      taxRtA: data['tax_rt_a'] as num,
      taxRtB: data['tax_rt_b'] as num,
      taxRtC: data['tax_rt_c'] as num,
      taxRtD: data['tax_rt_d'] as num,
      taxAmtA: data['tax_amt_a'] as num,
      taxAmtB: data['tax_amt_b'] as num,
      taxAmtC: data['tax_amt_c'] as num,
      taxAmtD: data['tax_amt_d'] as num,
      totTaxblAmt: data['tot_taxbl_amt'] as num,
      totTaxAmt: data['tot_tax_amt'] as num,
      totAmt: data['tot_amt'] as num,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      remark: data['remark'] == null ? null : data['remark'] as String?);
}

Future<Map<String, dynamic>> _$PurchaseToSupabase(Purchase instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'spplr_tin': instance.spplrTin,
    'spplr_nm': instance.spplrNm,
    'spplr_bhf_id': instance.spplrBhfId,
    'spplr_invc_no': instance.spplrInvcNo,
    'rcpt_ty_cd': instance.rcptTyCd,
    'pmt_ty_cd': instance.pmtTyCd,
    'cfm_dt': instance.cfmDt,
    'sales_dt': instance.salesDt,
    'stock_rls_dt': instance.stockRlsDt,
    'tot_item_cnt': instance.totItemCnt,
    'taxbl_amt_a': instance.taxblAmtA,
    'taxbl_amt_b': instance.taxblAmtB,
    'taxbl_amt_c': instance.taxblAmtC,
    'taxbl_amt_d': instance.taxblAmtD,
    'tax_rt_a': instance.taxRtA,
    'tax_rt_b': instance.taxRtB,
    'tax_rt_c': instance.taxRtC,
    'tax_rt_d': instance.taxRtD,
    'tax_amt_a': instance.taxAmtA,
    'tax_amt_b': instance.taxAmtB,
    'tax_amt_c': instance.taxAmtC,
    'tax_amt_d': instance.taxAmtD,
    'tot_taxbl_amt': instance.totTaxblAmt,
    'tot_tax_amt': instance.totTaxAmt,
    'tot_amt': instance.totAmt,
    'branch_id': instance.branchId,
    'remark': instance.remark
  };
}

Future<Purchase> _$PurchaseFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Purchase(
      id: data['id'] as String,
      variants: (await provider.rawQuery(
              'SELECT DISTINCT `f_Variant_brick_id` FROM `_brick_Purchase_variants` WHERE l_Purchase_brick_id = ?',
              [
            data['_brick_id'] as int
          ]).then((results) {
        final ids = results.map((r) => r['f_Variant_brick_id']);
        return Future.wait<Variant>(ids.map((primaryKey) => repository!
            .getAssociation<Variant>(
              Query.where('primaryKey', primaryKey, limit1: true),
            )
            .then((r) => r!.first)));
      }))
          .toList()
          .cast<Variant>(),
      spplrTin: data['spplr_tin'] as String,
      spplrNm: data['spplr_nm'] as String,
      spplrBhfId: data['spplr_bhf_id'] as String,
      spplrInvcNo: data['spplr_invc_no'] as int,
      rcptTyCd: data['rcpt_ty_cd'] as String,
      pmtTyCd: data['pmt_ty_cd'] as String,
      cfmDt: data['cfm_dt'] as String,
      salesDt: data['sales_dt'] as String,
      stockRlsDt:
          data['stock_rls_dt'] == null ? null : data['stock_rls_dt'] as String?,
      totItemCnt: data['tot_item_cnt'] as int,
      taxblAmtA: data['taxbl_amt_a'] as num,
      taxblAmtB: data['taxbl_amt_b'] as num,
      taxblAmtC: data['taxbl_amt_c'] as num,
      taxblAmtD: data['taxbl_amt_d'] as num,
      taxRtA: data['tax_rt_a'] as num,
      taxRtB: data['tax_rt_b'] as num,
      taxRtC: data['tax_rt_c'] as num,
      taxRtD: data['tax_rt_d'] as num,
      taxAmtA: data['tax_amt_a'] as num,
      taxAmtB: data['tax_amt_b'] as num,
      taxAmtC: data['tax_amt_c'] as num,
      taxAmtD: data['tax_amt_d'] as num,
      totTaxblAmt: data['tot_taxbl_amt'] as num,
      totTaxAmt: data['tot_tax_amt'] as num,
      totAmt: data['tot_amt'] as num,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      remark: data['remark'] == null ? null : data['remark'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PurchaseToSqlite(Purchase instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'variants':
        instance.variants != null ? jsonEncode(instance.variants) : null,
    'spplr_tin': instance.spplrTin,
    'spplr_nm': instance.spplrNm,
    'spplr_bhf_id': instance.spplrBhfId,
    'spplr_invc_no': instance.spplrInvcNo,
    'rcpt_ty_cd': instance.rcptTyCd,
    'pmt_ty_cd': instance.pmtTyCd,
    'cfm_dt': instance.cfmDt,
    'sales_dt': instance.salesDt,
    'stock_rls_dt': instance.stockRlsDt,
    'tot_item_cnt': instance.totItemCnt,
    'taxbl_amt_a': instance.taxblAmtA,
    'taxbl_amt_b': instance.taxblAmtB,
    'taxbl_amt_c': instance.taxblAmtC,
    'taxbl_amt_d': instance.taxblAmtD,
    'tax_rt_a': instance.taxRtA,
    'tax_rt_b': instance.taxRtB,
    'tax_rt_c': instance.taxRtC,
    'tax_rt_d': instance.taxRtD,
    'tax_amt_a': instance.taxAmtA,
    'tax_amt_b': instance.taxAmtB,
    'tax_amt_c': instance.taxAmtC,
    'tax_amt_d': instance.taxAmtD,
    'tot_taxbl_amt': instance.totTaxblAmt,
    'tot_tax_amt': instance.totTaxAmt,
    'tot_amt': instance.totAmt,
    'branch_id': instance.branchId,
    'remark': instance.remark
  };
}

/// Construct a [Purchase]
class PurchaseAdapter extends OfflineFirstWithSupabaseAdapter<Purchase> {
  PurchaseAdapter();

  @override
  final supabaseTableName = 'purchases';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'variants': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'variants',
      associationType: Map,
      associationIsNullable: true,
    ),
    'spplrTin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_tin',
    ),
    'spplrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
    ),
    'spplrBhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_bhf_id',
    ),
    'spplrInvcNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_invc_no',
    ),
    'rcptTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rcpt_ty_cd',
    ),
    'pmtTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pmt_ty_cd',
    ),
    'cfmDt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cfm_dt',
    ),
    'salesDt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sales_dt',
    ),
    'stockRlsDt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_rls_dt',
    ),
    'totItemCnt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_item_cnt',
    ),
    'taxblAmtA': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_a',
    ),
    'taxblAmtB': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_b',
    ),
    'taxblAmtC': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_c',
    ),
    'taxblAmtD': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_d',
    ),
    'taxRtA': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_rt_a',
    ),
    'taxRtB': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_rt_b',
    ),
    'taxRtC': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_rt_c',
    ),
    'taxRtD': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_rt_d',
    ),
    'taxAmtA': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amt_a',
    ),
    'taxAmtB': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amt_b',
    ),
    'taxAmtC': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amt_c',
    ),
    'taxAmtD': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amt_d',
    ),
    'totTaxblAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_taxbl_amt',
    ),
    'totTaxAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_tax_amt',
    ),
    'totAmt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_amt',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'remark': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remark',
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
      type: String,
    ),
    'variants': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'variants',
      iterable: true,
      type: Map,
    ),
    'spplrTin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_tin',
      iterable: false,
      type: String,
    ),
    'spplrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
      iterable: false,
      type: String,
    ),
    'spplrBhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_bhf_id',
      iterable: false,
      type: String,
    ),
    'spplrInvcNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_invc_no',
      iterable: false,
      type: int,
    ),
    'rcptTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rcpt_ty_cd',
      iterable: false,
      type: String,
    ),
    'pmtTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pmt_ty_cd',
      iterable: false,
      type: String,
    ),
    'cfmDt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cfm_dt',
      iterable: false,
      type: String,
    ),
    'salesDt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sales_dt',
      iterable: false,
      type: String,
    ),
    'stockRlsDt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_rls_dt',
      iterable: false,
      type: String,
    ),
    'totItemCnt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_item_cnt',
      iterable: false,
      type: int,
    ),
    'taxblAmtA': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_a',
      iterable: false,
      type: num,
    ),
    'taxblAmtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_b',
      iterable: false,
      type: num,
    ),
    'taxblAmtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_c',
      iterable: false,
      type: num,
    ),
    'taxblAmtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_d',
      iterable: false,
      type: num,
    ),
    'taxRtA': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_a',
      iterable: false,
      type: num,
    ),
    'taxRtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_b',
      iterable: false,
      type: num,
    ),
    'taxRtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_c',
      iterable: false,
      type: num,
    ),
    'taxRtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_d',
      iterable: false,
      type: num,
    ),
    'taxAmtA': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_a',
      iterable: false,
      type: num,
    ),
    'taxAmtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_b',
      iterable: false,
      type: num,
    ),
    'taxAmtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_c',
      iterable: false,
      type: num,
    ),
    'taxAmtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_d',
      iterable: false,
      type: num,
    ),
    'totTaxblAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_taxbl_amt',
      iterable: false,
      type: num,
    ),
    'totTaxAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_tax_amt',
      iterable: false,
      type: num,
    ),
    'totAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_amt',
      iterable: false,
      type: num,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'remark': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remark',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Purchase instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Purchase` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Purchase';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final variantsOldColumns = await provider.rawQuery(
          'SELECT `f_Variant_brick_id` FROM `_brick_Purchase_variants` WHERE `l_Purchase_brick_id` = ?',
          [instance.primaryKey]);
      final variantsOldIds =
          variantsOldColumns.map((a) => a['f_Variant_brick_id']);
      final variantsNewIds =
          instance.variants?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final variantsIdsToDelete =
          variantsOldIds.where((id) => !variantsNewIds.contains(id));

      await Future.wait<void>(variantsIdsToDelete.map((id) async {
        return await provider.rawExecute(
            'DELETE FROM `_brick_Purchase_variants` WHERE `l_Purchase_brick_id` = ? AND `f_Variant_brick_id` = ?',
            [instance.primaryKey, id]).catchError((e) => null);
      }));

      await Future.wait<int?>(instance.variants?.map((s) async {
            final id = s.primaryKey ??
                await provider.upsert<Variant>(s, repository: repository);
            return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_Purchase_variants` (`l_Purchase_brick_id`, `f_Variant_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id]);
          }) ??
          []);
    }
  }

  @override
  Future<Purchase> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PurchaseFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Purchase input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PurchaseToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Purchase> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PurchaseFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Purchase input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PurchaseToSqlite(input,
          provider: provider, repository: repository);
}
