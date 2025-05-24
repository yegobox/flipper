import 'package:flipper_models/sync/core/core_sync_base.dart';
import 'package:flipper_models/sync/interfaces/base_sync_interface.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/mixins/category_mixin.dart';
import 'package:flipper_models/sync/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/mixins/product_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_mixin.dart';
import 'package:flipper_models/sync/mixins/variant_mixin.dart';
import 'package:flipper_models/sync/mixins/favorite_mixin.dart';
import 'package:flipper_models/sync/mixins/conversation_mixin.dart';
import 'package:flipper_models/sync/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/mixins/business_mixin.dart';
import 'package:flipper_models/sync/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/mixins/stock_mixin.dart';
import 'package:flipper_models/sync/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/mixins/drawer_mixin.dart';
import 'package:flipper_models/sync/mixins/composite_mixin.dart';
import 'package:flipper_models/sync/mixins/system_mixin.dart';
import 'package:flipper_models/sync/mixins/receipt_mixin.dart';
import 'package:flipper_models/sync/mixins/default_mixin.dart';
import 'package:flipper_models/sync/mixins/delete_mixin.dart';
import 'package:flipper_models/sync/mixins/delete_operations_mixin.dart';
import 'package:flipper_models/sync/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/mixins/getter_operations_mixin.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/secrets.dart';
import 'package:talker/src/talker.dart';
import '../mixins/asset_mixin.dart';
import '../mixins/collection_mixin.dart';
import '../mixins/purchase_mixin.dart';
import '../mixins/log_mixin.dart';

class CoreSync extends CoreSyncBase
    with
        AuthMixin,
        SystemMixin,
        CustomerMixin,
        VariantMixin,
        StockMixin,
        BranchMixin,
        BusinessMixin,
        AssetMixin,
        CollectionMixin,
        TenantMixin,
        ProductMixin,
        TransactionMixin,
        CoreMiscellaneous,
        FavoriteMixin,
        ConversationMixin,
        TransactionItemMixin,
        DrawerMixin,
        CompositeMixin,
        ReceiptMixin,
        DefaultMixin,
        DeleteMixin,
        DeleteOperationsMixin,
        EbmMixin,
        GetterOperationsMixin,
        PurchaseMixin,
        CategoryMixin,
        LogMixin {
  CoreSync() : super(AppSecrets.apihubProd);

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
    // Delegate to CollectionMixin
    return super.configureLocal(useInMemory: useInMemory, box: box);
  }

  @override
  Future<void> initCollections() async {
    // Delegate to CollectionMixin
    await super.initCollections();
  }

  @override
  Future<Stream<double>> downloadAsset({
    required int branchId,
    required String assetName,
    required String subPath,
  }) async {
    // Delegate to AssetMixin
    return super.downloadAsset(
      branchId: branchId,
      assetName: assetName,
      subPath: subPath,
    );
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    // Delegate to AssetMixin
    return super.downloadAssetSave(
      assetName: assetName,
      subPath: subPath,
    );
  }

  @override
  Future<void> startReplicator() async {
    // Implementation needed
    throw UnimplementedError('startReplicator needs to be implemented');
  }

  @override
  Future<BaseSyncInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box}) {
    // TODO: implement configureCapella
    throw UnimplementedError();
  }
}
