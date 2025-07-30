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
import 'package:flipper_models/helperModels/random.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/transactionItem.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/finance_provider.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/stock.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:flipper_services/proxy.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/variant.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/branch.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/financing.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/composite.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:supabase_models/brick/models/plan_addon.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/itemCode.model.dart';
import '../brick/models/import_purchase_dates.model.dart';
import '../brick/models/stock.model.dart';
import '../brick/models/sars.model.dart';
import '../brick/models/counter.model.dart';
import '../brick/models/retryable.model.dart';
import '../brick/models/category.model.dart';
import '../brick/models/business_analytic.model.dart';
import '../brick/models/universalProduct.model.dart';
import '../brick/models/conversation.model.dart';
import '../brick/models/customer_payments.model.dart';
import '../brick/models/notice.model.dart';
import '../brick/models/transaction.model.dart';
import '../brick/models/message.model.dart';
import '../brick/models/financing.model.dart';
import '../brick/models/configuration.model.dart';
import '../brick/models/branch.model.dart';
import '../brick/models/plan_addon.model.dart';
import '../brick/models/color.model.dart';
import '../brick/models/branch_sms_config.model.dart';
import '../brick/models/country.model.dart';
import '../brick/models/BranchPaymentIntegration.model.dart';
import '../brick/models/transactionItem.model.dart';
import '../brick/models/permission.model.dart';
import '../brick/models/credit.model.dart';
import '../brick/models/variant.model.dart';
import '../brick/models/purchase.model.dart';
import '../brick/models/device.model.dart';
import '../brick/models/variant_branch.model.dart';
import '../brick/models/favorite.model.dart';
import '../brick/models/composite.model.dart';
import '../brick/models/transaction_payment_record.model.dart';
import '../brick/models/setting.model.dart';
import '../brick/models/tenant.model.dart';
import '../brick/models/inventory_request.model.dart';
import '../brick/models/pin.model.dart';
import '../brick/models/access.model.dart';
import '../brick/models/customer.model.dart';
import '../brick/models/log.model.dart';
import '../brick/models/report.model.dart';
import '../brick/models/appNotification.model.dart';
import '../brick/models/discount.model.dart';
import '../brick/models/business.model.dart';
import '../brick/models/user.model.dart';
import '../brick/models/sku.model.dart';
import '../brick/models/unit.model.dart';
import '../brick/models/location.model.dart';
import '../brick/models/receipt.model.dart';
import '../brick/models/token.model.dart';
import '../brick/models/finance_provider.model.dart';
import '../brick/models/ebm.model.dart';
import '../brick/models/product.model.dart';
import '../brick/models/asset.model.dart';
import '../brick/models/shift.model.dart';
import '../brick/models/ai_conversation.model.dart';
import '../brick/models/plans.model.dart';

part 'adapters/item_code_adapter.g.dart';
part 'adapters/import_purchase_dates_adapter.g.dart';
part 'adapters/stock_adapter.g.dart';
part 'adapters/sar_adapter.g.dart';
part 'adapters/counter_adapter.g.dart';
part 'adapters/retryable_adapter.g.dart';
part 'adapters/category_adapter.g.dart';
part 'adapters/business_analytic_adapter.g.dart';
part 'adapters/unversal_product_adapter.g.dart';
part 'adapters/conversation_adapter.g.dart';
part 'adapters/customer_payments_adapter.g.dart';
part 'adapters/notice_adapter.g.dart';
part 'adapters/i_transaction_adapter.g.dart';
part 'adapters/message_adapter.g.dart';
part 'adapters/financing_adapter.g.dart';
part 'adapters/configurations_adapter.g.dart';
part 'adapters/branch_adapter.g.dart';
part 'adapters/plan_addon_adapter.g.dart';
part 'adapters/p_color_adapter.g.dart';
part 'adapters/branch_sms_config_adapter.g.dart';
part 'adapters/country_adapter.g.dart';
part 'adapters/branch_payment_integration_adapter.g.dart';
part 'adapters/transaction_item_adapter.g.dart';
part 'adapters/l_permission_adapter.g.dart';
part 'adapters/credit_adapter.g.dart';
part 'adapters/variant_adapter.g.dart';
part 'adapters/purchase_adapter.g.dart';
part 'adapters/device_adapter.g.dart';
part 'adapters/variant_branch_adapter.g.dart';
part 'adapters/favorite_adapter.g.dart';
part 'adapters/composite_adapter.g.dart';
part 'adapters/transaction_payment_record_adapter.g.dart';
part 'adapters/setting_adapter.g.dart';
part 'adapters/tenant_adapter.g.dart';
part 'adapters/inventory_request_adapter.g.dart';
part 'adapters/pin_adapter.g.dart';
part 'adapters/access_adapter.g.dart';
part 'adapters/customer_adapter.g.dart';
part 'adapters/log_adapter.g.dart';
part 'adapters/report_adapter.g.dart';
part 'adapters/app_notification_adapter.g.dart';
part 'adapters/discount_adapter.g.dart';
part 'adapters/business_adapter.g.dart';
part 'adapters/user_adapter.g.dart';
part 'adapters/s_k_u_adapter.g.dart';
part 'adapters/i_unit_adapter.g.dart';
part 'adapters/location_adapter.g.dart';
part 'adapters/receipt_adapter.g.dart';
part 'adapters/token_adapter.g.dart';
part 'adapters/finance_provider_adapter.g.dart';
part 'adapters/ebm_adapter.g.dart';
part 'adapters/product_adapter.g.dart';
part 'adapters/assets_adapter.g.dart';
part 'adapters/shift_adapter.g.dart';
part 'adapters/ai_conversation_adapter.g.dart';
part 'adapters/plan_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  ItemCode: ItemCodeAdapter(),
  ImportPurchaseDates: ImportPurchaseDatesAdapter(),
  Stock: StockAdapter(),
  Sar: SarAdapter(),
  Counter: CounterAdapter(),
  Retryable: RetryableAdapter(),
  Category: CategoryAdapter(),
  BusinessAnalytic: BusinessAnalyticAdapter(),
  UnversalProduct: UnversalProductAdapter(),
  Conversation: ConversationAdapter(),
  CustomerPayments: CustomerPaymentsAdapter(),
  Notice: NoticeAdapter(),
  ITransaction: ITransactionAdapter(),
  Message: MessageAdapter(),
  Financing: FinancingAdapter(),
  Configurations: ConfigurationsAdapter(),
  Branch: BranchAdapter(),
  PlanAddon: PlanAddonAdapter(),
  PColor: PColorAdapter(),
  BranchSmsConfig: BranchSmsConfigAdapter(),
  Country: CountryAdapter(),
  BranchPaymentIntegration: BranchPaymentIntegrationAdapter(),
  TransactionItem: TransactionItemAdapter(),
  LPermission: LPermissionAdapter(),
  Credit: CreditAdapter(),
  Variant: VariantAdapter(),
  Purchase: PurchaseAdapter(),
  Device: DeviceAdapter(),
  VariantBranch: VariantBranchAdapter(),
  Favorite: FavoriteAdapter(),
  Composite: CompositeAdapter(),
  TransactionPaymentRecord: TransactionPaymentRecordAdapter(),
  Setting: SettingAdapter(),
  Tenant: TenantAdapter(),
  InventoryRequest: InventoryRequestAdapter(),
  Pin: PinAdapter(),
  Access: AccessAdapter(),
  Customer: CustomerAdapter(),
  Log: LogAdapter(),
  Report: ReportAdapter(),
  AppNotification: AppNotificationAdapter(),
  Discount: DiscountAdapter(),
  Business: BusinessAdapter(),
  User: UserAdapter(),
  SKU: SKUAdapter(),
  IUnit: IUnitAdapter(),
  Location: LocationAdapter(),
  Receipt: ReceiptAdapter(),
  Token: TokenAdapter(),
  FinanceProvider: FinanceProviderAdapter(),
  Ebm: EbmAdapter(),
  Product: ProductAdapter(),
  Assets: AssetsAdapter(),
  Shift: ShiftAdapter(),
  AiConversation: AiConversationAdapter(),
  Plan: PlanAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  ItemCode: ItemCodeAdapter(),
  ImportPurchaseDates: ImportPurchaseDatesAdapter(),
  Stock: StockAdapter(),
  Sar: SarAdapter(),
  Counter: CounterAdapter(),
  Retryable: RetryableAdapter(),
  Category: CategoryAdapter(),
  BusinessAnalytic: BusinessAnalyticAdapter(),
  UnversalProduct: UnversalProductAdapter(),
  Conversation: ConversationAdapter(),
  CustomerPayments: CustomerPaymentsAdapter(),
  Notice: NoticeAdapter(),
  ITransaction: ITransactionAdapter(),
  Message: MessageAdapter(),
  Financing: FinancingAdapter(),
  Configurations: ConfigurationsAdapter(),
  Branch: BranchAdapter(),
  PlanAddon: PlanAddonAdapter(),
  PColor: PColorAdapter(),
  BranchSmsConfig: BranchSmsConfigAdapter(),
  Country: CountryAdapter(),
  BranchPaymentIntegration: BranchPaymentIntegrationAdapter(),
  TransactionItem: TransactionItemAdapter(),
  LPermission: LPermissionAdapter(),
  Credit: CreditAdapter(),
  Variant: VariantAdapter(),
  Purchase: PurchaseAdapter(),
  Device: DeviceAdapter(),
  VariantBranch: VariantBranchAdapter(),
  Favorite: FavoriteAdapter(),
  Composite: CompositeAdapter(),
  TransactionPaymentRecord: TransactionPaymentRecordAdapter(),
  Setting: SettingAdapter(),
  Tenant: TenantAdapter(),
  InventoryRequest: InventoryRequestAdapter(),
  Pin: PinAdapter(),
  Access: AccessAdapter(),
  Customer: CustomerAdapter(),
  Log: LogAdapter(),
  Report: ReportAdapter(),
  AppNotification: AppNotificationAdapter(),
  Discount: DiscountAdapter(),
  Business: BusinessAdapter(),
  User: UserAdapter(),
  SKU: SKUAdapter(),
  IUnit: IUnitAdapter(),
  Location: LocationAdapter(),
  Receipt: ReceiptAdapter(),
  Token: TokenAdapter(),
  FinanceProvider: FinanceProviderAdapter(),
  Ebm: EbmAdapter(),
  Product: ProductAdapter(),
  Assets: AssetsAdapter(),
  Shift: ShiftAdapter(),
  AiConversation: AiConversationAdapter(),
  Plan: PlanAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
