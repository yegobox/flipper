import 'package:flipper_models/models/html/stock_sync.dart';

import './variant_sync.dart';

final variationMock = new VariantSync(
  id: DateTime.now().millisecondsSinceEpoch,
  name: 'Regular',
  sku: 'sku',
  fproductId: 2,
  unit: 'Per Item',
  table: 'variants',
  channels: ['300'],
  productName: 'Custom Amount',
  fbranchId: 11,
  taxName: 'N/A',
  taxPercentage: 0.0,
  retailPrice: 0.0,
  supplyPrice: 0.0,
  stock: StockSync(
    canTrackingStock: false,
    currentStock: 200,
    fproductId: 1,
    fvariantId: 1,
    lowStock: 1,
    retailPrice: 1,
    showLowStockAlert: true,
    supplyPrice: 2,
    table: '',
    target: null,
    value: 1,
  ),
);
