import 'package:flipper_models/sync/interfaces/base_sync_interface.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/sync/interfaces/favorite_interface.dart';
import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/sync/interfaces/storage_interface.dart';

abstract class DatabaseSyncInterface extends BaseSyncInterface
    implements ProductInterface,
        TransactionInterface,
        VariantInterface,
        FavoriteInterface,
        ConversationInterface,
        AuthInterface,
        TenantInterface,
        StorageInterface {}
