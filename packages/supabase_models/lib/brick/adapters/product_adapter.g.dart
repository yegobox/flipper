// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Product> _$ProductFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Product(
      id: data['id'] as String?,
      name: data['name'] as String,
      description:
          data['description'] == null ? null : data['description'] as String?,
      taxId: data['tax_id'] == null ? null : data['tax_id'] as String?,
      color: data['color'] as String,
      businessId: data['business_id'] as int,
      branchId: data['branch_id'] as int,
      supplierId:
          data['supplier_id'] == null ? null : data['supplier_id'] as String?,
      categoryId:
          data['category_id'] == null ? null : data['category_id'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      unit: data['unit'] == null ? null : data['unit'] as String?,
      imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
      expiryDate:
          data['expiry_date'] == null ? null : data['expiry_date'] as String?,
      barCode: data['bar_code'] == null ? null : data['bar_code'] as String?,
      nfcEnabled: data['nfc_enabled'] == null
          ? null
          : data['nfc_enabled'] as bool? ?? false,
      bindedToTenantId: data['binded_to_tenant_id'] == null
          ? null
          : data['binded_to_tenant_id'] as String?,
      isFavorite: data['is_favorite'] == null
          ? null
          : data['is_favorite'] as bool? ?? false,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      spplrNm: data['spplr_nm'] == null ? null : data['spplr_nm'] as String?,
      isComposite: data['is_composite'] == null
          ? null
          : data['is_composite'] as bool? ?? false,
      composites: data['composites'] == null
          ? null
          : await Future.wait<Composite>(data['composites']
                  ?.map((d) => CompositeAdapter().fromSupabase(d,
                      provider: provider, repository: repository))
                  .toList()
                  .cast<Future<Composite>>() ??
              []));
}

Future<Map<String, dynamic>> _$ProductToSupabase(Product instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'tax_id': instance.taxId,
    'color': instance.color,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'supplier_id': instance.supplierId,
    'category_id': instance.categoryId,
    'created_at': instance.createdAt?.toIso8601String(),
    'unit': instance.unit,
    'image_url': instance.imageUrl,
    'expiry_date': instance.expiryDate,
    'bar_code': instance.barCode,
    'nfc_enabled': instance.nfcEnabled,
    'binded_to_tenant_id': instance.bindedToTenantId,
    'is_favorite': instance.isFavorite,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'spplr_nm': instance.spplrNm,
    'is_composite': instance.isComposite,
    'composites': await Future.wait<Map<String, dynamic>>(instance.composites
            ?.map((s) => CompositeAdapter()
                .toSupabase(s, provider: provider, repository: repository))
            .toList() ??
        [])
  };
}

Future<Product> _$ProductFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      description:
          data['description'] == null ? null : data['description'] as String?,
      taxId: data['tax_id'] == null ? null : data['tax_id'] as String?,
      color: data['color'] as String,
      businessId: data['business_id'] as int,
      branchId: data['branch_id'] as int,
      supplierId:
          data['supplier_id'] == null ? null : data['supplier_id'] as String?,
      categoryId:
          data['category_id'] == null ? null : data['category_id'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      unit: data['unit'] == null ? null : data['unit'] as String?,
      imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
      expiryDate:
          data['expiry_date'] == null ? null : data['expiry_date'] as String?,
      barCode: data['bar_code'] == null ? null : data['bar_code'] as String?,
      nfcEnabled: data['nfc_enabled'] == null ? null : data['nfc_enabled'] == 1,
      bindedToTenantId: data['binded_to_tenant_id'] == null
          ? null
          : data['binded_to_tenant_id'] as String?,
      isFavorite: data['is_favorite'] == null ? null : data['is_favorite'] == 1,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      spplrNm: data['spplr_nm'] == null ? null : data['spplr_nm'] as String?,
      isComposite:
          data['is_composite'] == null ? null : data['is_composite'] == 1,
      composites: (await provider.rawQuery(
              'SELECT DISTINCT `f_Composite_brick_id` FROM `_brick_Product_composites` WHERE l_Product_brick_id = ?',
              [
            data['_brick_id'] as int
          ]).then((results) {
        final ids = results.map((r) => r['f_Composite_brick_id']);
        return Future.wait<Composite>(ids.map((primaryKey) => repository!
            .getAssociation<Composite>(
              Query.where('primaryKey', primaryKey, limit1: true),
            )
            .then((r) => r!.first)));
      }))
          .toList()
          .cast<Composite>(),
      searchMatch:
          data['search_match'] == null ? null : data['search_match'] == 1)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ProductToSqlite(Product instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'tax_id': instance.taxId,
    'color': instance.color,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'supplier_id': instance.supplierId,
    'category_id': instance.categoryId,
    'created_at': instance.createdAt?.toIso8601String(),
    'unit': instance.unit,
    'image_url': instance.imageUrl,
    'expiry_date': instance.expiryDate,
    'bar_code': instance.barCode,
    'nfc_enabled':
        instance.nfcEnabled == null ? null : (instance.nfcEnabled! ? 1 : 0),
    'binded_to_tenant_id': instance.bindedToTenantId,
    'is_favorite':
        instance.isFavorite == null ? null : (instance.isFavorite! ? 1 : 0),
    'last_touched': instance.lastTouched?.toIso8601String(),
    'spplr_nm': instance.spplrNm,
    'is_composite':
        instance.isComposite == null ? null : (instance.isComposite! ? 1 : 0),
    'search_match':
        instance.searchMatch == null ? null : (instance.searchMatch! ? 1 : 0)
  };
}

/// Construct a [Product]
class ProductAdapter extends OfflineFirstWithSupabaseAdapter<Product> {
  ProductAdapter();

  @override
  final supabaseTableName = 'products';
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
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'taxId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_id',
    ),
    'color': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'color',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'supplierId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'supplier_id',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'unit': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'unit',
    ),
    'imageUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_url',
    ),
    'expiryDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'expiry_date',
    ),
    'barCode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bar_code',
    ),
    'nfcEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'nfc_enabled',
    ),
    'bindedToTenantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'binded_to_tenant_id',
    ),
    'isFavorite': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_favorite',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'spplrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
    ),
    'isComposite': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_composite',
    ),
    'composites': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'composites',
      associationType: Composite,
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'taxId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_id',
      iterable: false,
      type: String,
    ),
    'color': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'color',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'supplierId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'supplier_id',
      iterable: false,
      type: String,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'unit': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unit',
      iterable: false,
      type: String,
    ),
    'imageUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_url',
      iterable: false,
      type: String,
    ),
    'expiryDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'expiry_date',
      iterable: false,
      type: String,
    ),
    'barCode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bar_code',
      iterable: false,
      type: String,
    ),
    'nfcEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'nfc_enabled',
      iterable: false,
      type: bool,
    ),
    'bindedToTenantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'binded_to_tenant_id',
      iterable: false,
      type: String,
    ),
    'isFavorite': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_favorite',
      iterable: false,
      type: bool,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'spplrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
      iterable: false,
      type: String,
    ),
    'isComposite': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_composite',
      iterable: false,
      type: bool,
    ),
    'composites': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'composites',
      iterable: true,
      type: Composite,
    ),
    'searchMatch': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'search_match',
      iterable: false,
      type: bool,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Product instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Product` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Product';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final compositesOldColumns = await provider.rawQuery(
          'SELECT `f_Composite_brick_id` FROM `_brick_Product_composites` WHERE `l_Product_brick_id` = ?',
          [instance.primaryKey]);
      final compositesOldIds =
          compositesOldColumns.map((a) => a['f_Composite_brick_id']);
      final compositesNewIds =
          instance.composites?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final compositesIdsToDelete =
          compositesOldIds.where((id) => !compositesNewIds.contains(id));

      await Future.wait<void>(compositesIdsToDelete.map((id) async {
        return await provider.rawExecute(
            'DELETE FROM `_brick_Product_composites` WHERE `l_Product_brick_id` = ? AND `f_Composite_brick_id` = ?',
            [instance.primaryKey, id]).catchError((e) => null);
      }));

      await Future.wait<int?>(instance.composites?.map((s) async {
            final id = s.primaryKey ??
                await provider.upsert<Composite>(s, repository: repository);
            return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_Product_composites` (`l_Product_brick_id`, `f_Composite_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id]);
          }) ??
          []);
    }
  }

  @override
  Future<Product> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProductFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Product input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProductToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Product> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProductFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Product input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProductToSqlite(input,
          provider: provider, repository: repository);
}
