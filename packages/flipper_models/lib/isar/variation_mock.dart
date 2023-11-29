import 'package:flipper_models/isar/random.dart';

import 'variant.dart';

final variationMock = Variant(
    id: randomString(),
    name: 'Regular',
    color: '#cc',
    sku: 'sku',
    action: 'create',
    lastTouched: DateTime.now(),
    productId: '2',
    unit: 'Per Item',
    productName: 'Custom Amount',
    branchId: 11,
    supplyPrice: 0.0,
    retailPrice: 0.0,
    isTaxExempted: false)
  ..name = 'Regular'
  ..sku = 'sku'
  ..productId = '2'
  ..unit = 'Per Item'
  ..productName = 'Custom Amount'
  ..branchId = 11
  ..taxName = 'N/A'
  ..taxPercentage = 0.0
  ..retailPrice = 0.0
  ..supplyPrice = 0.0;
