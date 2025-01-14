// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/uuid.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/stock.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/transactionItem.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/composite.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/plan_addon.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/variant.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/itemCode.model.dart';
import '../brick/models/stock.model.dart';
import '../brick/models/counter.model.dart';
import '../brick/models/category.model.dart';
import '../brick/models/universalProduct.model.dart';
import '../brick/models/conversation.model.dart';
import '../brick/models/transaction.model.dart';
import '../brick/models/configuration.model.dart';
import '../brick/models/branch.model.dart';
import '../brick/models/plan_addon.model.dart';
import '../brick/models/color.model.dart';
import '../brick/models/transactionItem.model.dart';
import '../brick/models/permission.model.dart';
import '../brick/models/variant.model.dart';
import '../brick/models/device.model.dart';
import '../brick/models/favorite.model.dart';
import '../brick/models/composite.model.dart';
import '../brick/models/transaction_payment_record.model.dart';
import '../brick/models/setting.model.dart';
import '../brick/models/tenant.model.dart';
import '../brick/models/pin.model.dart';
import '../brick/models/access.model.dart';
import '../brick/models/customer.model.dart';
import '../brick/models/report.model.dart';
import '../brick/models/stockRequest.model.dart';
import '../brick/models/appNotification.model.dart';
import '../brick/models/discount.model.dart';
import '../brick/models/business.model.dart';
import '../brick/models/sku.model.dart';
import '../brick/models/unit.model.dart';
import '../brick/models/location.model.dart';
import '../brick/models/receipt.model.dart';
import '../brick/models/token.model.dart';
import '../brick/models/ebm.model.dart';
import '../brick/models/product.model.dart';
import '../brick/models/asset.model.dart';
import '../brick/models/plans.model.dart';
import '../brick/models/drawer.model.dart';
import '../brick/models/import_purchase_dates.model.dart';
import '../brick/models/purchases.model.dart';

part 'adapters/item_code_adapter.g.dart';
part 'adapters/stock_adapter.g.dart';
part 'adapters/counter_adapter.g.dart';
part 'adapters/category_adapter.g.dart';
part 'adapters/unversal_product_adapter.g.dart';
part 'adapters/conversation_adapter.g.dart';
part 'adapters/i_transaction_adapter.g.dart';
part 'adapters/configurations_adapter.g.dart';
part 'adapters/branch_adapter.g.dart';
part 'adapters/plan_addon_adapter.g.dart';
part 'adapters/p_color_adapter.g.dart';
part 'adapters/transaction_item_adapter.g.dart';
part 'adapters/l_permission_adapter.g.dart';
part 'adapters/variant_adapter.g.dart';
part 'adapters/device_adapter.g.dart';
part 'adapters/favorite_adapter.g.dart';
part 'adapters/composite_adapter.g.dart';
part 'adapters/transaction_payment_record_adapter.g.dart';
part 'adapters/setting_adapter.g.dart';
part 'adapters/tenant_adapter.g.dart';
part 'adapters/pin_adapter.g.dart';
part 'adapters/access_adapter.g.dart';
part 'adapters/customer_adapter.g.dart';
part 'adapters/report_adapter.g.dart';
part 'adapters/stock_request_adapter.g.dart';
part 'adapters/app_notification_adapter.g.dart';
part 'adapters/discount_adapter.g.dart';
part 'adapters/business_adapter.g.dart';
part 'adapters/s_k_u_adapter.g.dart';
part 'adapters/i_unit_adapter.g.dart';
part 'adapters/location_adapter.g.dart';
part 'adapters/receipt_adapter.g.dart';
part 'adapters/token_adapter.g.dart';
part 'adapters/ebm_adapter.g.dart';
part 'adapters/product_adapter.g.dart';
part 'adapters/assets_adapter.g.dart';
part 'adapters/plan_adapter.g.dart';
part 'adapters/drawers_adapter.g.dart';
part 'adapters/import_purchase_dates_adapter.g.dart';
part 'adapters/sale_list_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  ItemCode: ItemCodeAdapter(),
  Stock: StockAdapter(),
  Counter: CounterAdapter(),
  Category: CategoryAdapter(),
  UnversalProduct: UnversalProductAdapter(),
  Conversation: ConversationAdapter(),
  ITransaction: ITransactionAdapter(),
  Configurations: ConfigurationsAdapter(),
  Branch: BranchAdapter(),
  PlanAddon: PlanAddonAdapter(),
  PColor: PColorAdapter(),
  TransactionItem: TransactionItemAdapter(),
  LPermission: LPermissionAdapter(),
  Variant: VariantAdapter(),
  Device: DeviceAdapter(),
  Favorite: FavoriteAdapter(),
  Composite: CompositeAdapter(),
  TransactionPaymentRecord: TransactionPaymentRecordAdapter(),
  Setting: SettingAdapter(),
  Tenant: TenantAdapter(),
  Pin: PinAdapter(),
  Access: AccessAdapter(),
  Customer: CustomerAdapter(),
  Report: ReportAdapter(),
  StockRequest: StockRequestAdapter(),
  AppNotification: AppNotificationAdapter(),
  Discount: DiscountAdapter(),
  Business: BusinessAdapter(),
  SKU: SKUAdapter(),
  IUnit: IUnitAdapter(),
  Location: LocationAdapter(),
  Receipt: ReceiptAdapter(),
  Token: TokenAdapter(),
  Ebm: EbmAdapter(),
  Product: ProductAdapter(),
  Assets: AssetsAdapter(),
  Plan: PlanAdapter(),
  Drawers: DrawersAdapter(),
  ImportPurchaseDates: ImportPurchaseDatesAdapter(),
  SaleList: SaleListAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  ItemCode: ItemCodeAdapter(),
  Stock: StockAdapter(),
  Counter: CounterAdapter(),
  Category: CategoryAdapter(),
  UnversalProduct: UnversalProductAdapter(),
  Conversation: ConversationAdapter(),
  ITransaction: ITransactionAdapter(),
  Configurations: ConfigurationsAdapter(),
  Branch: BranchAdapter(),
  PlanAddon: PlanAddonAdapter(),
  PColor: PColorAdapter(),
  TransactionItem: TransactionItemAdapter(),
  LPermission: LPermissionAdapter(),
  Variant: VariantAdapter(),
  Device: DeviceAdapter(),
  Favorite: FavoriteAdapter(),
  Composite: CompositeAdapter(),
  TransactionPaymentRecord: TransactionPaymentRecordAdapter(),
  Setting: SettingAdapter(),
  Tenant: TenantAdapter(),
  Pin: PinAdapter(),
  Access: AccessAdapter(),
  Customer: CustomerAdapter(),
  Report: ReportAdapter(),
  StockRequest: StockRequestAdapter(),
  AppNotification: AppNotificationAdapter(),
  Discount: DiscountAdapter(),
  Business: BusinessAdapter(),
  SKU: SKUAdapter(),
  IUnit: IUnitAdapter(),
  Location: LocationAdapter(),
  Receipt: ReceiptAdapter(),
  Token: TokenAdapter(),
  Ebm: EbmAdapter(),
  Product: ProductAdapter(),
  Assets: AssetsAdapter(),
  Plan: PlanAdapter(),
  Drawers: DrawersAdapter(),
  ImportPurchaseDates: ImportPurchaseDatesAdapter(),
  SaleList: SaleListAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
