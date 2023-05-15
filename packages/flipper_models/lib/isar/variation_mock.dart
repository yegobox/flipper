import 'variant.dart';

final variationMock = Variant(
    name: 'Regular',
    sku: 'sku',
    action: 'create',
    productId: 2,
    unit: 'Per Item',
    productName: 'Custom Amount',
    branchId: 11,
    supplyPrice: 0.0,
    retailPrice: 0.0,
    isTaxExempted: false)
  ..id = DateTime.now().millisecondsSinceEpoch
  ..name = 'Regular'
  ..sku = 'sku'
  ..productId = 2
  ..unit = 'Per Item'
  ..productName = 'Custom Amount'
  ..branchId = 11
  ..taxName = 'N/A'
  ..taxPercentage = 0.0
  ..retailPrice = 0.0
  ..supplyPrice = 0.0;
