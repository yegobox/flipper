import 'package:flipper_models/realm_model_export.dart';

final variationMock = Variant(
  name: 'Regular',
  color: '#cc',
  itemCd: "",
  sku: 'sku',
  lastTouched: DateTime.now(),
  productId: "2",
  unit: 'Per Item',
  productName: 'Custom Amount',
  branchId: 11,
  supplyPrice: 0.0,
  retailPrice: 0.0,
)
  ..sku = 'sku'
  ..productId = "2"
  ..unit = 'Per Item'
  ..productName = 'Custom Amount'
  ..branchId = 11
  ..taxName = 'N/A'
  ..taxPercentage = 0.0
  ..retailPrice = 0.0
  ..supplyPrice = 0.0;
