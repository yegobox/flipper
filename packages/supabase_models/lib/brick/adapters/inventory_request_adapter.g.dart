// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<InventoryRequest> _$InventoryRequestFromSupabase(
    Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return InventoryRequest(
      id: data['id'] as String?,
      mainBranchId: data['main_branch_id'] == null
          ? null
          : data['main_branch_id'] as int?,
      subBranchId:
          data['sub_branch_id'] == null ? null : data['sub_branch_id'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      status: data['status'] == null ? null : data['status'] as String?,
      deliveryDate: data['delivery_date'] == null
          ? null
          : data['delivery_date'] == null
              ? null
              : DateTime.tryParse(data['delivery_date'] as String),
      deliveryNote: data['delivery_note'] == null
          ? null
          : data['delivery_note'] as String?,
      orderNote:
          data['order_note'] == null ? null : data['order_note'] as String?,
      customerReceivedOrder: data['customer_received_order'] == null
          ? null
          : data['customer_received_order'] as bool?,
      driverRequestDeliveryConfirmation:
          data['driver_request_delivery_confirmation'] == null
              ? null
              : data['driver_request_delivery_confirmation'] as bool?,
      driverId: data['driver_id'] == null ? null : data['driver_id'] as int?,
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String),
      itemCounts:
          data['item_counts'] == null ? null : data['item_counts'] as num?);
}

Future<Map<String, dynamic>> _$InventoryRequestToSupabase(
    InventoryRequest instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'main_branch_id': instance.mainBranchId,
    'sub_branch_id': instance.subBranchId,
    'created_at': instance.createdAt?.toIso8601String(),
    'status': instance.status,
    'delivery_date': instance.deliveryDate?.toIso8601String(),
    'delivery_note': instance.deliveryNote,
    'order_note': instance.orderNote,
    'customer_received_order': instance.customerReceivedOrder,
    'driver_request_delivery_confirmation':
        instance.driverRequestDeliveryConfirmation,
    'driver_id': instance.driverId,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'item_counts': instance.itemCounts
  };
}

Future<InventoryRequest> _$InventoryRequestFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return InventoryRequest(
      id: data['id'] as String,
      mainBranchId: data['main_branch_id'] == null
          ? null
          : data['main_branch_id'] as int?,
      subBranchId:
          data['sub_branch_id'] == null ? null : data['sub_branch_id'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      status: data['status'] == null ? null : data['status'] as String?,
      deliveryDate: data['delivery_date'] == null
          ? null
          : data['delivery_date'] == null
              ? null
              : DateTime.tryParse(data['delivery_date'] as String),
      deliveryNote: data['delivery_note'] == null
          ? null
          : data['delivery_note'] as String?,
      orderNote:
          data['order_note'] == null ? null : data['order_note'] as String?,
      customerReceivedOrder: data['customer_received_order'] == null
          ? null
          : data['customer_received_order'] == 1,
      driverRequestDeliveryConfirmation:
          data['driver_request_delivery_confirmation'] == null
              ? null
              : data['driver_request_delivery_confirmation'] == 1,
      driverId: data['driver_id'] == null ? null : data['driver_id'] as int?,
      transactionItems: (await provider.rawQuery(
              'SELECT DISTINCT `f_TransactionItem_brick_id` FROM `_brick_InventoryRequest_transaction_items` WHERE l_InventoryRequest_brick_id = ?',
              [
            data['_brick_id'] as int
          ]).then((results) {
        final ids = results.map((r) => r['f_TransactionItem_brick_id']);
        return Future.wait<TransactionItem>(ids.map((primaryKey) => repository!
            .getAssociation<TransactionItem>(
              Query.where('primaryKey', primaryKey, limit1: true),
            )
            .then((r) => r!.first)));
      }))
          .toList()
          .cast<TransactionItem>(),
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String),
      itemCounts:
          data['item_counts'] == null ? null : data['item_counts'] as num?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$InventoryRequestToSqlite(
    InventoryRequest instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'main_branch_id': instance.mainBranchId,
    'sub_branch_id': instance.subBranchId,
    'created_at': instance.createdAt?.toIso8601String(),
    'status': instance.status,
    'delivery_date': instance.deliveryDate?.toIso8601String(),
    'delivery_note': instance.deliveryNote,
    'order_note': instance.orderNote,
    'customer_received_order': instance.customerReceivedOrder == null
        ? null
        : (instance.customerReceivedOrder! ? 1 : 0),
    'driver_request_delivery_confirmation':
        instance.driverRequestDeliveryConfirmation == null
            ? null
            : (instance.driverRequestDeliveryConfirmation! ? 1 : 0),
    'driver_id': instance.driverId,
    'transaction_items': jsonEncode(instance.transactionItems),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'item_counts': instance.itemCounts
  };
}

/// Construct a [InventoryRequest]
class InventoryRequestAdapter
    extends OfflineFirstWithSupabaseAdapter<InventoryRequest> {
  InventoryRequestAdapter();

  @override
  final supabaseTableName = 'stock_requests';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'mainBranchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'main_branch_id',
    ),
    'subBranchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sub_branch_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'deliveryDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delivery_date',
    ),
    'deliveryNote': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delivery_note',
    ),
    'orderNote': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'order_note',
    ),
    'customerReceivedOrder': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_received_order',
    ),
    'driverRequestDeliveryConfirmation': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'driver_request_delivery_confirmation',
    ),
    'driverId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'driver_id',
    ),
    'transactionItems': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'transaction_items',
      associationType: Map,
      associationIsNullable: false,
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'itemCounts': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_counts',
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
    'mainBranchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'main_branch_id',
      iterable: false,
      type: int,
    ),
    'subBranchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sub_branch_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'deliveryDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delivery_date',
      iterable: false,
      type: DateTime,
    ),
    'deliveryNote': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delivery_note',
      iterable: false,
      type: String,
    ),
    'orderNote': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'order_note',
      iterable: false,
      type: String,
    ),
    'customerReceivedOrder': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_received_order',
      iterable: false,
      type: bool,
    ),
    'driverRequestDeliveryConfirmation': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'driver_request_delivery_confirmation',
      iterable: false,
      type: bool,
    ),
    'driverId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'driver_id',
      iterable: false,
      type: int,
    ),
    'transactionItems': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'transaction_items',
      iterable: true,
      type: Map,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'itemCounts': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_counts',
      iterable: false,
      type: num,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      InventoryRequest instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `InventoryRequest` WHERE id = ? LIMIT 1''',
        [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'InventoryRequest';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final transactionItemsOldColumns = await provider.rawQuery(
          'SELECT `f_TransactionItem_brick_id` FROM `_brick_InventoryRequest_transaction_items` WHERE `l_InventoryRequest_brick_id` = ?',
          [instance.primaryKey]);
      final transactionItemsOldIds = transactionItemsOldColumns
          .map((a) => a['f_TransactionItem_brick_id']);
      final transactionItemsNewIds =
          instance.transactionItems.map((s) => s.primaryKey).whereType<int>();
      final transactionItemsIdsToDelete = transactionItemsOldIds
          .where((id) => !transactionItemsNewIds.contains(id));

      await Future.wait<void>(transactionItemsIdsToDelete.map((id) async {
        return await provider.rawExecute(
            'DELETE FROM `_brick_InventoryRequest_transaction_items` WHERE `l_InventoryRequest_brick_id` = ? AND `f_TransactionItem_brick_id` = ?',
            [instance.primaryKey, id]).catchError((e) => null);
      }));

      await Future.wait<int?>(instance.transactionItems.map((s) async {
        final id = s.primaryKey ??
            await provider.upsert<TransactionItem>(s, repository: repository);
        return await provider.rawInsert(
            'INSERT OR IGNORE INTO `_brick_InventoryRequest_transaction_items` (`l_InventoryRequest_brick_id`, `f_TransactionItem_brick_id`) VALUES (?, ?)',
            [instance.primaryKey, id]);
      }));
    }
  }

  @override
  Future<InventoryRequest> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InventoryRequestFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(InventoryRequest input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InventoryRequestToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<InventoryRequest> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InventoryRequestFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(InventoryRequest input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InventoryRequestToSqlite(input,
          provider: provider, repository: repository);
}
