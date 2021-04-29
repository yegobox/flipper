String appFont = 'HelveticaNeuea';
String dbName = 'main';

// ignore: avoid_classes_with_only_static_members
// @Deprecated use app_services constants
class AppTables {
  //table name used to query couchbase_lite data
  static const String business = 'businesses';
  static const String branch = 'branches';
  static const String tax = 'taxes';
  static const String category = 'categories';
  static const String variation = 'variants';
  static const String product = 'products';
  static const String stockHistories = 'stocks_histories';
  static const String order = 'orders';
  static const String orderDetail = 'orderDetails';
  static const String branchProduct = 'branchProducts';
  static const String unit = 'units';
  static const String stock = 'stocks';
  static const String drawerHistories = 'drawerHistories';
  static const String cart = 'cart';
  static const String color = 'colors';

  static const String user = 'users';

  static const String tickets = 'tickets';
}
