// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<SaleList> _$SaleListFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return SaleList(
      id: data['id'] as String?,
      spplrTin: data['spplr_tin'] as String,
      spplrNm: data['spplr_nm'] as String,
      spplrBhfId: data['spplr_bhf_id'] as String,
      spplrInvcNo: data['spplr_invc_no'] as int,
      rcptTyCd: data['rcpt_ty_cd'] as String,
      pmtTyCd: data['pmt_ty_cd'] as String,
      cfmDt: data['cfm_dt'] as String,
      salesDt: data['sales_dt'] as String,
      stockRlsDt: data['stock_rls_dt'] as String?,
      totItemCnt: data['tot_item_cnt'] as int,
      taxblAmtA: data['taxbl_amt_a'] as double,
      taxblAmtB: data['taxbl_amt_b'] as double,
      taxblAmtC: data['taxbl_amt_c'] as double,
      taxblAmtD: data['taxbl_amt_d'] as double,
      taxRtA: data['tax_rt_a'] as double,
      taxRtB: data['tax_rt_b'] as double,
      taxRtC: data['tax_rt_c'] as double,
      taxRtD: data['tax_rt_d'] as double,
      taxAmtA: data['tax_amt_a'] as double,
      taxAmtB: data['tax_amt_b'] as double,
      taxAmtC: data['tax_amt_c'] as double,
      taxAmtD: data['tax_amt_d'] as double,
      totTaxblAmt: data['tot_taxbl_amt'] as double,
      totTaxAmt: data['tot_tax_amt'] as double,
      totAmt: data['tot_amt'] as double,
      remark: data['remark'] as String?);
}

Future<Map<String, dynamic>> _$SaleListToSupabase(SaleList instance,
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
    'remark': instance.remark
  };
}

Future<SaleList> _$SaleListFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return SaleList(
      id: data['id'] as String,
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
      taxblAmtA: data['taxbl_amt_a'] as double,
      taxblAmtB: data['taxbl_amt_b'] as double,
      taxblAmtC: data['taxbl_amt_c'] as double,
      taxblAmtD: data['taxbl_amt_d'] as double,
      taxRtA: data['tax_rt_a'] as double,
      taxRtB: data['tax_rt_b'] as double,
      taxRtC: data['tax_rt_c'] as double,
      taxRtD: data['tax_rt_d'] as double,
      taxAmtA: data['tax_amt_a'] as double,
      taxAmtB: data['tax_amt_b'] as double,
      taxAmtC: data['tax_amt_c'] as double,
      taxAmtD: data['tax_amt_d'] as double,
      totTaxblAmt: data['tot_taxbl_amt'] as double,
      totTaxAmt: data['tot_tax_amt'] as double,
      totAmt: data['tot_amt'] as double,
      remark: data['remark'] == null ? null : data['remark'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SaleListToSqlite(SaleList instance,
    {required SqliteProvider provider,
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
    'remark': instance.remark
  };
}

/// Construct a [SaleList]
class SaleListAdapter extends OfflineFirstWithSupabaseAdapter<SaleList> {
  SaleListAdapter();

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
    'remark': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remark',
    ),
    'itemList': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'item_list',
      associationType: Map,
      associationIsNullable: true,
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
      type: double,
    ),
    'taxblAmtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_b',
      iterable: false,
      type: double,
    ),
    'taxblAmtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_c',
      iterable: false,
      type: double,
    ),
    'taxblAmtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'taxbl_amt_d',
      iterable: false,
      type: double,
    ),
    'taxRtA': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_a',
      iterable: false,
      type: double,
    ),
    'taxRtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_b',
      iterable: false,
      type: double,
    ),
    'taxRtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_c',
      iterable: false,
      type: double,
    ),
    'taxRtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rt_d',
      iterable: false,
      type: double,
    ),
    'taxAmtA': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_a',
      iterable: false,
      type: double,
    ),
    'taxAmtB': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_b',
      iterable: false,
      type: double,
    ),
    'taxAmtC': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_c',
      iterable: false,
      type: double,
    ),
    'taxAmtD': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amt_d',
      iterable: false,
      type: double,
    ),
    'totTaxblAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_taxbl_amt',
      iterable: false,
      type: double,
    ),
    'totTaxAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_tax_amt',
      iterable: false,
      type: double,
    ),
    'totAmt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_amt',
      iterable: false,
      type: double,
    ),
    'remark': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remark',
      iterable: false,
      type: String,
    ),
    'itemList': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'item_list',
      iterable: true,
      type: Map,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      SaleList instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `SaleList` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'SaleList';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final itemListOldColumns = await provider.rawQuery(
          'SELECT `f_Variant_brick_id` FROM `_brick_SaleList_item_list` WHERE `l_SaleList_brick_id` = ?',
          [instance.primaryKey]);
      final itemListOldIds =
          itemListOldColumns.map((a) => a['f_Variant_brick_id']);
      final itemListNewIds =
          instance.itemList?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final itemListIdsToDelete =
          itemListOldIds.where((id) => !itemListNewIds.contains(id));

      await Future.wait<void>(itemListIdsToDelete.map((id) async {
        return await provider.rawExecute(
            'DELETE FROM `_brick_SaleList_item_list` WHERE `l_SaleList_brick_id` = ? AND `f_Variant_brick_id` = ?',
            [instance.primaryKey, id]).catchError((e) => null);
      }));

      await Future.wait<int?>(instance.itemList?.map((s) async {
            final id = s.primaryKey ??
                await provider.upsert<Variant>(s, repository: repository);
            return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_SaleList_item_list` (`l_SaleList_brick_id`, `f_Variant_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id]);
          }) ??
          []);
    }
  }

  @override
  Future<SaleList> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SaleListFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(SaleList input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SaleListToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<SaleList> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SaleListFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(SaleList input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SaleListToSqlite(input,
          provider: provider, repository: repository);
}
