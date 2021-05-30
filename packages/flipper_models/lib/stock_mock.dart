import 'package:flipper_models/stock.dart';

final stockMock = new Stock(
  id: DateTime.now().millisecondsSinceEpoch,
  branchId: 11,
  variantId: 1,
  lowStock: 0.0,
  currentStock: 0.0,
  supplyPrice: 0.0,
  retailPrice: 0.0,
  canTrackingStock: false,
  value: 0,
  showLowStockAlert: false,
  channels: ['300'],
  table: 'stocks',
  productId: 2,
  active: false,
);
