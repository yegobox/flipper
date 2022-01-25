library flipper_models;

import 'package:flipper_models/models/io/branch.dart';
import 'package:flipper_models/models/io/product_sync.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final AppService _appService = locator<AppService>();
final customProductMock = new ProductSync(
  id: DateTime.now().millisecondsSinceEpoch,
  draft: true,
  currentUpdate: true,
  ftaxId: "XX",
  imageLocal: false,
  fbusinessId: _appService.businessId!,
  name: "Custom Amount",
  fbranchId: _appService.branchId!,
  description: "L",
  active: true,
  hasPicture: false,
  table: "products",
  color: "#e74c3c",
  fsupplierId: "XXX",
  fcategoryId: "XXX",
  unit: "kg",
  channels: [_appService.userid!],
  createdAt: DateTime.now().toIso8601String(),
);

final productMock = new ProductSync(
  fbranchId: _appService.branchId!,
  draft: true,
  currentUpdate: true,
  ftaxId: "XX",
  imageLocal: false,
  fbusinessId: _appService.businessId!,
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
  channels: [_appService.userid!],
  createdAt: DateTime.now().toIso8601String(),
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
