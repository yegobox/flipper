import "realm_model_export.dart";

final realmModels = [
  Variant.schema,
  Product.schema,
  Stock.schema,
  Customer.schema,
  Receipt.schema,
  IUnit.schema,
  Pin.schema,
  Category.schema,
  Tenant.schema,
  PColor.schema,
  Device.schema,
  Conversation.schema,
  Counter.schema,
  Favorite.schema,
  EBM.schema,
  Drawers.schema,
  TransactionItem.schema,
  ITransaction.schema,
  Discount.schema,
  LPermission.schema,
  Setting.schema,
  Voucher.schema,
  Token.schema,
  Configurations.schema,
  Assets.schema,
  Composite.schema,
  SKU.schema,
  Report.schema,
  Computed.schema,
  Access.schema,
  StockRequest.schema,
  PaymentPlan.schema,
  FlipperSaleCompaign.schema,
  Location.schema,

  /// because we want to expose branch or location to public so ordering can be done even outside within a business
  Branch.schema,
];

/// for local db
final localModels = [
  UserActivity.schema,
  Business.schema,
  Branch.schema,
  UnversalProduct.schema,
  AppNotification.schema,
  Drawers.schema
];
