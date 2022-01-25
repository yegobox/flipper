import 'package:flipper_models/models/html/feature.dart';

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
);
