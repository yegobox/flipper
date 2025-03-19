import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/sync/interfaces/storage_interface.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/sync/interfaces/delete_operations_interface.dart';
import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:flipper_models/sync/interfaces/getter_operations_interface.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/sync/interfaces/receipt_interface.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/sync/interfaces/system_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
import 'package:supabase_models/brick/repository.dart';

abstract class CoreSyncBase extends AiStrategyImpl
    implements
        AuthInterface,
        TenantInterface,
        StorageInterface,
        DatabaseSyncInterface,
        BranchInterface,
        BusinessInterface,
        ConversationInterface,
        CustomerInterface,
        DeleteOperationsInterface,
        EbmInterface,
        FavoriteInterface,
        GetterOperationsInterface,
        ProductInterface,
        PurchaseInterface,
        ReceiptInterface,
        StockInterface,
        SystemInterface,
        CoreMiscellaneousInterface,
        TransactionInterface,
        TransactionItemInterface,
        VariantInterface {
  final Repository repository = Repository();
  bool offlineLogin = false;
  final String apihub;

  CoreSyncBase(this.apihub);

  // Common functionality that will be shared across all implementations
  Future<void> initialize() async {
    // Add initialization logic here
  }

  Future<void> dispose() async {
    // Add cleanup logic here
  }
}
