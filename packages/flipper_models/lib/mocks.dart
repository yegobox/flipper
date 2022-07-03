import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final List<Map<String, dynamic>> mockUnits = [
  {'name': 'Per Item', 'value': '', 'active': true},
  {'name': 'Per Kilogram (kg)', 'value': 'kg', 'active': false},
  {'name': 'Per Cup (c)', 'value': 'c', 'active': false},
  {'name': 'Per Liter (l)', 'value': 'l', 'active': false},
  {'name': 'Per Pound (lb)', 'value': 'lb', 'active': false},
  {'name': 'Per Pint (pt)', 'value': 'pt', 'active': false},
  {'name': 'Per Acre (ac)', 'value': 'ac', 'active': false},
  {'name': 'Per Centimeter (cm)', 'value': 'cm', 'active': false},
  {'name': 'Per Cubic Footer (cu ft)', 'value': 'cu ft', 'active': false},
  {'name': 'Per Day (day)', 'value': 'day', 'active': false},
  {'name': 'Footer (ft)', 'value': 'ft', 'active': false},
  {'name': 'Per Gram (g)', 'value': 'g', 'active': false},
  {'name': 'Per Hour (hr)', 'value': 'hr', 'active': false},
  {'name': 'Per Minute (min)', 'value': 'min', 'active': false},
  {'name': 'Per Acre (ac)', 'value': 'ac', 'active': false},
  {'name': 'Per Cubic Inch (cu in)', 'value': 'cu in', 'active': false},
  {'name': 'Per Cubic Yard (cu yd)', 'value': 'cu yd', 'active': false},
  {'name': 'Per Fluid Ounce (fl oz)', 'value': 'fl oz', 'active': false},
  {'name': 'Per Gallon (gal)', 'value': 'gal', 'active': false},
  {'name': 'Per Inch (in)', 'value': 'in', 'active': false},
  {'name': 'Per Kilometer (km)', 'value': 'km', 'active': false},
  {'name': 'Per Meter (m)', 'value': 'm', 'active': false},
  {'name': 'Per Mile (mi)', 'value': 'mi', 'active': false},
  {'name': 'Per Milligram (mg)', 'value': 'mg', 'active': false},
  {'name': 'Per Milliliter (mL)', 'value': 'mL', 'active': false},
  {'name': 'Per Millimeter (mm)', 'value': 'mm', 'active': false},
  {'name': 'Per Millisecond (ms)', 'value': 'ms', 'active': false},
  {'name': 'Per Ounce (oz)', 'value': 'oz', 'active': false},
  {'name': 'Per  Quart (qt)', 'value': 'qt', 'active': false},
  {'name': 'Per Second (sec)', 'value': 'sec', 'active': false},
  {'name': 'Per Shot (sh)', 'value': 'sh', 'active': false},
  {'name': 'Per Square Centimeter (sq cm)', 'value': 'sq cm', 'active': false},
  {'name': 'Per Square Foot (sq ft)', 'value': 'sq ft', 'active': false},
  {'name': 'Per Square Inch (sq in)', 'value': 'sq in', 'active': false},
  {'name': 'Per Square Kilometer (sq km)', 'value': 'sq km', 'active': false},
  {'name': 'Per Square Meter (sq m)', 'value': 'sq m', 'active': false},
  {'name': 'Per Square Mile (sq mi)', 'value': 'sq mi', 'active': false},
  {'name': 'Per Square Yard (sq yd)', 'value': 'sq yd', 'active': false},
  {'name': 'Per Stone (st)', 'value': 'st', 'active': false},
  {'name': 'Per Yard (yd)', 'value': 'yd', 'active': false}
];

// variation mock
final variationMock = Variant()
  ..id = DateTime.now().millisecondsSinceEpoch
  ..name = 'Regular'
  ..sku = 'sku'
  ..productId = 2
  ..unit = 'Per Item'
  ..table = 'variants'
  ..productName = 'Custom Amount'
  ..branchId = 11
  ..taxName = 'N/A'
  ..taxPercentage = 0.0
  ..retailPrice = 0.0
  ..supplyPrice = 0.0;

// stock
final stockMock = Stock()
  ..id = DateTime.now().millisecondsSinceEpoch
  ..branchId = 11
  ..variantId = 1
  ..lowStock = 0.0
  ..currentStock = 0.0
  ..supplyPrice = 0.0
  ..retailPrice = 0.0
  ..canTrackingStock = false
  ..value = 0
  ..showLowStockAlert = false
  ..productId = 2
  ..active = false;

// order mock
Order? OrderFMock = Order()
  ..id = DateTime.now().millisecondsSinceEpoch
  ..reference = 'caa5cbf1-b3c3-11'
  ..orderNumber = 'caa5cbf1-b3c3-'
  ..branchId = 11
  ..status = 'pending'
  ..orderType = 'local'
  ..active = true
  ..draft = true
  ..subTotal = 300
  ..cashReceived = 300
  ..customerChangeDue = 0.0
  ..createdAt = DateTime.now().toIso8601String()
  ..paymentType = 'Cash';

final AppService _appService = locator<AppService>();

final customProductMock = Product()
  ..draft = true
  ..currentUpdate = true
  ..taxId = "XX"
  ..imageLocal = false
  ..businessId = _appService.businessId!
  ..name = "Custom Amount"
  ..branchId = _appService.branchId!
  ..description = "L"
  ..active = true
  ..hasPicture = false
  ..table = "products"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = "XXX"
  ..unit = "kg"
  ..createdAt = DateTime.now().toIso8601String();

final productMock = Product()
  ..draft = true
  ..currentUpdate = true
  ..taxId = "XX"
  ..imageLocal = false
  ..businessId = _appService.businessId!
  ..name = "temp"
  ..branchId = _appService.branchId!
  ..description = "L"
  ..active = true
  ..hasPicture = false
  ..table = "products"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = "XXX"
  ..unit = "kg"
  ..createdAt = DateTime.now().toIso8601String();

final branchMock = Branch(
  id: DateTime.now().millisecondsSinceEpoch,
  active: false,
  description: 'desc',
  businessId: 10,
  latitude: '0',
  longitude: '2',
  name: 'name',
  table: 'branches',
  isDefault: false,
);
