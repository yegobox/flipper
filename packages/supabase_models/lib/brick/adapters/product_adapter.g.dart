// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Product> _$ProductFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Product(
      id: data['id'] as int,
      name: data['name'] as String?,
      description: data['description'] as String?,
      taxId: data['tax_id'] as String?,
      color: data['color'] as String,
      businessId: data['business_id'] as int?,
      branchId: data['branch_id'] as int?,
      supplierId: data['supplier_id'] as String?,
      categoryId: data['category_id'] as int?,
      createdAt: data['created_at'] as String?,
      unit: data['unit'] as String?,
      imageUrl: data['image_url'] as String?,
      expiryDate: data['expiry_date'] as String?,
      barCode: data['bar_code'] as String?,
      nfcEnabled: data['nfc_enabled'] as bool,
      bindedToTenantId: data['binded_to_tenant_id'] as int?,
      isFavorite: data['is_favorite'] as bool,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      searchMatch: data['search_match'] as bool,
      spplrNm: data['spplr_nm'] as String?,
      isComposite: data['is_composite'] as bool?);
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
    'created_at': instance.createdAt,
    'unit': instance.unit,
    'image_url': instance.imageUrl,
    'expiry_date': instance.expiryDate,
    'bar_code': instance.barCode,
    'nfc_enabled': instance.nfcEnabled,
    'binded_to_tenant_id': instance.bindedToTenantId,
    'is_favorite': instance.isFavorite,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'search_match': instance.searchMatch,
    'spplr_nm': instance.spplrNm,
    'is_composite': instance.isComposite
  };
}

Future<Product> _$ProductFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Product(
      id: data['id'] as int,
      name: data['name'] == null ? null : data['name'] as String?,
      description:
          data['description'] == null ? null : data['description'] as String?,
      taxId: data['tax_id'] == null ? null : data['tax_id'] as String?,
      color: data['color'] as String,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      supplierId:
          data['supplier_id'] == null ? null : data['supplier_id'] as String?,
      categoryId:
          data['category_id'] == null ? null : data['category_id'] as int?,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
      unit: data['unit'] == null ? null : data['unit'] as String?,
      imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
      expiryDate:
          data['expiry_date'] == null ? null : data['expiry_date'] as String?,
      barCode: data['bar_code'] == null ? null : data['bar_code'] as String?,
      nfcEnabled: data['nfc_enabled'] == 1,
      bindedToTenantId: data['binded_to_tenant_id'] == null
          ? null
          : data['binded_to_tenant_id'] as int?,
      isFavorite: data['is_favorite'] == 1,
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
      searchMatch: data['search_match'] == 1,
      spplrNm: data['spplr_nm'] == null ? null : data['spplr_nm'] as String?,
      isComposite:
          data['is_composite'] == null ? null : data['is_composite'] == 1)
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
    'created_at': instance.createdAt,
    'unit': instance.unit,
    'image_url': instance.imageUrl,
    'expiry_date': instance.expiryDate,
    'bar_code': instance.barCode,
    'nfc_enabled': instance.nfcEnabled ? 1 : 0,
    'binded_to_tenant_id': instance.bindedToTenantId,
    'is_favorite': instance.isFavorite ? 1 : 0,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'search_match': instance.searchMatch ? 1 : 0,
    'spplr_nm': instance.spplrNm,
    'is_composite':
        instance.isComposite == null ? null : (instance.isComposite! ? 1 : 0)
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
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'searchMatch': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'search_match',
    ),
    'spplrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'spplr_nm',
    ),
    'isComposite': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_composite',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
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
      type: String,
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
      type: int,
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
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'searchMatch': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'search_match',
      iterable: false,
      type: bool,
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
