library flipper_models;

import 'package:flipper_models/models/html/branch.dart';
import 'package:flipper_models/models/html/product_sync.dart';
import 'package:flipper_models/models/html/stock_sync.dart';
// import 'package:flipper_services/locator.dart';
// import 'package:flipper_services/app_service.dart';

// final AppService _appService = locator<AppService>();
final customProductMock = new ProductSync(
  id: DateTime.now().millisecondsSinceEpoch,
  draft: true,
  currentUpdate: true,
  ftaxId: "XX",
  imageLocal: false,
  fbusinessId: 10,
  name: "Custom Amount",
  fbranchId: 11,
  description: "L",
  active: true,
  hasPicture: false,
  table: "products",
  color: "#e74c3c",
  fsupplierId: "XXX",
  fcategoryId: "XXX",
  unit: "kg",
  channels: ["300"],
  createdAt: DateTime.now().toIso8601String(),
  variations: [],
  stock: StockSync(
      fbranchId: 1,
      fvariantId: 1,
      lowStock: 0,
      currentStock: 20,
      supplyPrice: 12,
      retailPrice: 12,
      canTrackingStock: true,
      showLowStockAlert: false,
      channels: [],
      fproductId: 1,
      active: false,
      value: 1,
      table: '',
      target: ''),
);

final productMock = new ProductSync(
  fbranchId: 10,
  draft: true,
  currentUpdate: true,
  ftaxId: "XX",
  imageLocal: false,
  fbusinessId: 11,
  name: "temp",
  description: "L",
  active: true,
  hasPicture: false,
  table: "products",
  color: "#e74c3c",
  fsupplierId: "XXX",
  fcategoryId: "XXX",
  unit: "kg",
  synced: false,
  channels: ["300"],
  createdAt: DateTime.now().toIso8601String(),
  variations: [],
  stock: StockSync(
      fbranchId: 1,
      fvariantId: 1,
      lowStock: 0,
      currentStock: 20,
      supplyPrice: 12,
      retailPrice: 12,
      canTrackingStock: true,
      showLowStockAlert: false,
      channels: [],
      fproductId: 1,
      active: false,
      value: 1,
      table: '',
      target: ''),
);

final branchMock = BranchSync(
  id: DateTime.now().millisecondsSinceEpoch,
  active: false,
  description: 'desc',
  fbusinessId: 10,
  latitude: '0',
  longitude: '2',
  name: 'name',
  table: 'branches',
);
