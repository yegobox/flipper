import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/sync/capella/capella_sync_base.dart';
import 'package:flipper_models/sync/interfaces/base_sync_interface.dart';
import 'package:flipper_models/sync/mixins/category_mixin.dart';

import 'package:flipper_services/Miscellaneous.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:talker/talker.dart';
import 'package:flipper_models/sync/capella/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/business_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/conversation_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/delete_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/favorite_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/getter_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/product_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/receipt_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/stock_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/storage_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/system_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/variant_mixin.dart';

class CapellaSync extends CapellaSyncBase
    with
        CapellaAuthMixin,
        CapellaBranchMixin,
        CapellaBusinessMixin,
        CapellaConversationMixin,
        CapellaCustomerMixin,
        CapellaDeleteOperationsMixin,
        CapellaEbmMixin,
        CapellaFavoriteMixin,
        CoreMiscellaneous,
        CapellaGetterOperationsMixin,
        CapellaProductMixin,
        CapellaPurchaseMixin,
        CapellaReceiptMixin,
        CapellaStockMixin,
        CapellaStorageMixin,
        CapellaSystemMixin,
        CapellaEbmMixin,
        CapellaTenantMixin,
        CapellaTransactionItemMixin,
        CapellaTransactionMixin,
        CapellaVariantMixin,
        CategoryMixin {
  CapellaSync() : super(AppSecrets.apihubProd);

  final Talker _talker = Talker();

  @override
  Talker get talker => _talker;

  @override
  Future<void> initialize() async {
    await super.initialize();
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
  }

  @override
  Future<BaseSyncInterface> configureLocal({
    required bool useInMemory,
    required LocalStorage box,
  }) async {
    throw UnimplementedError('configureLocal needs to be implemented');
  }

  @override
  Future<void> initCollections() async {
    throw UnimplementedError('initCollections needs to be implemented');
  }

  @override
  Future<Stream<double>> downloadAsset({
    required int branchId,
    required String assetName,
    required String subPath,
  }) async {
    throw UnimplementedError('downloadAsset needs to be implemented');
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    throw UnimplementedError('downloadAssetSave needs to be implemented');
  }

  @override
  Future<void> startReplicator() async {
    throw UnimplementedError('startReplicator needs to be implemented');
  }

  @override
  Future<BaseSyncInterface> configureCapella({
    required bool useInMemory,
    required LocalStorage box,
  }) async {
    throw UnimplementedError('configureCapella needs to be implemented');
  }

  @override
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      String? id,
      FilterType? filterType,
      bool includePending = false,
      DateTime? startDate,
      bool removeAdjustmentTransactions = false,
      bool forceRealData = true,
      DateTime? endDate}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> tenant(
      {int? businessId, int? userId, String? id, required bool fetchRemote}) {
    // TODO: implement tenant
    throw UnimplementedError();
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement tenantsFromOnline
    throw UnimplementedError();
  }

  @override
  Stream<ITransaction> pendingTransaction(
      {int? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) {
    // TODO: implement pendingTransaction
    throw UnimplementedError();
  }
}
