import './stock_sync.dart';

final stockMock = new StockSync(
  id: DateTime.now().millisecondsSinceEpoch,
  fbranchId: 11,
  fvariantId: 1,
  lowStock: 0.0,
  currentStock: 0.0,
  supplyPrice: 0.0,
  retailPrice: 0.0,
  canTrackingStock: false,
  value: 0,
  showLowStockAlert: false,
  channels: ['300'],
  table: 'stocks',
  fproductId: 2,
  active: false,
);
