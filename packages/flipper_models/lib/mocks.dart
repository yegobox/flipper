import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final List<Map<String, dynamic>> mockUnits = [
  {'id': randomNumber(), 'name': 'Per Item', 'value': '', 'active': true},
  {
    'id': randomNumber(),
    'name': 'Per Kilogram (kg)',
    'value': 'kg',
    'active': false
  },
  {'id': randomNumber(), 'name': 'Per Cup (c)', 'value': 'c', 'active': false},
  {
    'id': randomNumber(),
    'name': 'Per Liter (l)',
    'value': 'l',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Pound (lb)',
    'value': 'lb',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Pint (pt)',
    'value': 'pt',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Acre (ac)',
    'value': 'ac',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Centimeter (cm)',
    'value': 'cm',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Cubic Footer (cu ft)',
    'value': 'cu ft',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Day (day)',
    'value': 'day',
    'active': false
  },
  {'id': randomNumber(), 'name': 'Footer (ft)', 'value': 'ft', 'active': false},
  {'id': randomNumber(), 'name': 'Per Gram (g)', 'value': 'g', 'active': false},
  {
    'id': randomNumber(),
    'name': 'Per Hour (hr)',
    'value': 'hr',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Minute (min)',
    'value': 'min',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Acre (ac)',
    'value': 'ac',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Cubic Inch (cu in)',
    'value': 'cu in',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Cubic Yard (cu yd)',
    'value': 'cu yd',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Fluid Ounce (fl oz)',
    'value': 'fl oz',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Gallon (gal)',
    'value': 'gal',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Inch (in)',
    'value': 'in',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Kilometer (km)',
    'value': 'km',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Meter (m)',
    'value': 'm',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Mile (mi)',
    'value': 'mi',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Milligram (mg)',
    'value': 'mg',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Milliliter (mL)',
    'value': 'mL',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Millimeter (mm)',
    'value': 'mm',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Millisecond (ms)',
    'value': 'ms',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Ounce (oz)',
    'value': 'oz',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per  Quart (qt)',
    'value': 'qt',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Second (sec)',
    'value': 'sec',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Shot (sh)',
    'value': 'sh',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Centimeter (sq cm)',
    'value': 'sq cm',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Foot (sq ft)',
    'value': 'sq ft',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Inch (sq in)',
    'value': 'sq in',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Kilometer (sq km)',
    'value': 'sq km',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Meter (sq m)',
    'value': 'sq m',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Mile (sq mi)',
    'value': 'sq mi',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Square Yard (sq yd)',
    'value': 'sq yd',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Stone (st)',
    'value': 'st',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Per Yard (yd)',
    'value': 'yd',
    'active': false
  }
];

// variation mock
final variationMock = Variant(
    action: 'create',
    color: '#cc',
    name: 'Regular',
    lastTouched: DateTime.now(),
    sku: 'sku',
    id: randomNumber(),
    productId: 2,
    unit: 'Per Item',
    productName: 'Custom Amount',
    branchId: 11,
    supplyPrice: 0.0,
    retailPrice: 0.0,
    isTaxExempted: false)
  ..id = randomNumber()
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

// stock
final stockMock = Stock(
    lastTouched: DateTime.now(),
    branchId: 11,
    id: randomNumber(),
    variantId: 1,
    currentStock: 0.0,
    productId: 2,
    action: 'create')
  ..id = randomNumber()
  ..branchId = 11
  ..variantId = 1
  ..lowStock = 0.0
  ..currentStock = 0.0
  ..supplyPrice = 0.0
  ..retailPrice = 0.0
  ..canTrackingStock = false
  ..showLowStockAlert = false
  ..productId = 2
  ..active = false;

// transaction mock
ITransaction? TransactionFMock = ITransaction(
  lastTouched: DateTime.now(),
  action: AppActions.created,
  id: randomNumber(),
  supplierId: 1,
  reference: Uuid().v1(),
  transactionNumber: Uuid().v1(),
  status: "pending",
  transactionType: 'local',
  subTotal: 0,
  cashReceived: 0,
  updatedAt: DateTime.now().toIso8601String(),
  customerChangeDue: 0.0,
  paymentType: 'Cash',
  branchId: 11,
  createdAt: DateTime.now().toIso8601String(),
);

final AppService _appService = getIt<AppService>();

final customProductMock = Product(
    id: randomNumber(),
    action: 'create',
    lastTouched: DateTime.now(),
    name: "temp",
    businessId: _appService.businessId!,
    color: "#e74c3c",
    branchId: _appService.branchId!)
  ..taxId = "XX"
  ..businessId = _appService.businessId!
  ..name = "temp"
  ..branchId = _appService.branchId!
  ..description = "L"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = 1
  ..unit = "kg"
  ..createdAt = DateTime.now().toIso8601String();

final productMock = Product(
    id: randomNumber(),
    lastTouched: DateTime.now(),
    action: 'create',
    name: "temp",
    businessId: _appService.businessId!,
    color: "#e74c3c",
    branchId: _appService.branchId!)
  ..taxId = "XX"
  ..businessId = _appService.businessId!
  ..name = "temp"
  ..branchId = _appService.branchId!
  ..description = "L"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = 1
  ..unit = "kg"
  ..createdAt = DateTime.now().toIso8601String();

final branchMock = IBranch(
  action: AppActions.created,
  id: randomNumber(),
  active: false,
  description: 'desc',
  businessId: 10,
  latitude: '0',
  longitude: '2',
  name: 'name',
  isDefault: false,
);
