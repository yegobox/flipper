import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final ebmInitializationMockData = {
  "resultCd": "000",
  "resultMsg": "It is succeeded",
  "resultDt": "20250106193013",
  "data": {
    "info": {
      "tin": "999909695",
      "taxprNm": "YEGOBOX",
      "bsnsActv": null,
      "bhfId": "01",
      "bhfNm": "BHF1",
      "bhfOpenDt": "20210927",
      "prvncNm": "SOUTH",
      "dstrtNm": "KAMONYI",
      "sctrNm": "NYARUBAKA",
      "locDesc": "RRA",
      "hqYn": "Y",
      "mgrNm": "TESTING COMPANY 14 LTD",
      "mgrTelNo": "0788427097",
      "mgrEmail": "ebm@rra.gov.rw",
      "sdcId": null,
      "mrcNo": null,
      "dvcId": "1036147990050001",
      "intrlKey": null,
      "signKey": null,
      "cmcKey": null,
      "lastPchsInvcNo": 0,
      "lastSaleRcptNo": null,
      "lastInvcNo": null,
      "lastSaleInvcNo": 1254082234,
      "lastTrainInvcNo": null,
      "lastProfrmInvcNo": null,
      "lastCopyInvcNo": null,
      "vatTyCd": 1
    }
  }
};
final List<Map<String, dynamic>> mockUnits = [
  {'id': randomNumber(), 'name': 'Per Item', 'value': '', 'active': true},
  {
    'id': randomNumber(),
    'name': 'Per Kilogram (kg)',
    'value': 'kg',
    'active': false
  },
  {
    'id': randomNumber(),
    'name': 'Ampoule',
    'value': 'AM',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Barrel',
    'value': 'BA',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bottlecrate',
    'value': 'BC',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bundle',
    'value': 'BE',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Balloon, non-protected',
    'value': 'BF',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bag',
    'value': 'BG',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bucket',
    'value': 'BJ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Basket',
    'value': 'BK',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bale',
    'value': 'BL',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bottle, protected cylindrical',
    'value': 'BQ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bar',
    'value': 'BR',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bottle, bulbous',
    'value': 'BV',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bag',
    'value': 'BZ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Can',
    'value': 'CA',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Chest',
    'value': 'CH',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Coffin',
    'value': 'CJ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Coil',
    'value': 'CL',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Wooden Box, Wooden Case',
    'value': 'CR',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Cassette',
    'value': 'CS',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Carton',
    'value': 'CT',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Container',
    'value': 'CTN',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Cylinder',
    'value': 'CY',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Drum',
    'value': 'DR',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Extra Countable Item',
    'value': 'GT',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Hand Baggage',
    'value': 'HH',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Ingots',
    'value': 'IZ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Jar',
    'value': 'JR',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Jug',
    'value': 'JU',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Jerry CAN Cylindrical',
    'value': 'JY',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Canester',
    'value': 'KZ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Logs, in bundle/bunch/truss',
    'value': 'LZ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Net',
    'value': 'NT',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Non-Exterior Packaging Unit',
    'value': 'OU',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Poddon',
    'value': 'PD',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Plate',
    'value': 'PG',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Pipe',
    'value': 'PI',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Pilot',
    'value': 'PO',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Traypack',
    'value': 'PU',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Reel',
    'value': 'RL',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Roll',
    'value': 'RO',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Rods, in bundle/bunch/truss',
    'value': 'RZ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Skeletoncase',
    'value': 'SK',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Tank, cylindrical',
    'value': 'TY',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk,gas(at 1031 mbar 15 oC)',
    'value': 'VG',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk,liquid(at normal temperature/pressure)',
    'value': 'VL',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk, solid, large particles(nodules)',
    'value': 'VO',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk, gas (liquefied at abnormal temperature/pressure)',
    'value': 'VQ',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk, solid, granular particles(grains)',
    'value': 'VR',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Extra Bulk Item',
    'value': 'VT',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Bulk, fine particles(powder)',
    'value': 'VY',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'Mills cigarette',
    'value': 'ML',
    'active': false,
  },
  {
    'id': randomNumber(),
    'name': 'TAN 1TAN REFER TO 20BAGS',
    'value': 'TN',
    'active': false,
  },
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
    color: '#cc',
    name: 'Regular',
    lastTouched: DateTime.now(),
    sku: 'sku',
    productId: "2",
    itemCd: "",
    unit: 'Per Item',
    productName: 'Custom Amount',
    branchId: 11,
    supplyPrice: 0.0,
    retailPrice: 0.0)
  ..sku = 'sku'
  ..productId = "2"
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
  // variant: variationMock,
  branchId: 11,

  currentStock: 0.0,
)
  ..branchId = 11
  ..currentStock = 0.0
  ..canTrackingStock = false
  ..showLowStockAlert = false
  ..active = false;

final AppService _appService = getIt<AppService>();

final customProductMock = Product(
    lastTouched: DateTime.now(),
    name: "temp",
    businessId: _appService.businessId!,
    color: "#e74c3c",
    branchId: _appService.branchId!)
  ..taxId = "XX"
  ..name = "temp"
  ..description = "L"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = 1
  ..unit = "kg"
  ..createdAt = DateTime.now();

final productMock = Product(
    lastTouched: DateTime.now(),
    name: "temp",
    businessId: _appService.businessId!,
    color: "#e74c3c",
    branchId: _appService.branchId!)
  ..taxId = "XX"
  ..name = "temp"
  ..description = "L"
  ..color = "#e74c3c"
  ..supplierId = "XXX"
  ..categoryId = 1
  ..unit = "kg"
  ..createdAt = DateTime.now();

final branchMock = Branch(
  serverId: randomNumber(),
  active: false,
  description: 'desc',
  businessId: 10,
  latitude: '0',
  longitude: '2',
  name: 'name',
  isDefault: false,
);

final businessMock = Business(
  serverId: randomNumber(),
  active: true,
  latitude: '0',
  longitude: '2',
  name: 'name',
  isDefault: true,
);

final payStackCustomer = {
  "status": true,
  "message": "Customer created",
  "data": {
    "transactions": [],
    "subscriptions": [],
    "authorizations": [],
    "first_name": "Richard",
    "last_name": "Muragijimana",
    "email": "murag.richard@gmail.com",
    "phone": "+250783054874",
    "metadata": {},
    "domain": "live",
    "customer_code": "CUS_616yuumu6jiomwc",
    "risk_action": "default",
    "id": 165652769,
    "integration": 1142892,
    "createdAt": "2024-04-19T12:00:32.000Z",
    "updatedAt": "2024-04-19T12:34:21.000Z",
    "identified": false,
    "identifications": null
  }
};
