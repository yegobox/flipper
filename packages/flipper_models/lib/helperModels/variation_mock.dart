import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:realm/realm.dart';

final variationMock = Variant(ObjectId(),
    id: randomNumber(),
    name: 'Regular',
    color: '#cc',
    sku: 'sku',
    action: 'create',
    lastTouched: DateTime.now(),
    productId: 2,
    unit: 'Per Item',
    productName: 'Custom Amount',
    branchId: 11,
    supplyPrice: 0.0,
    retailPrice: 0.0,
    isTaxExempted: false)
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
