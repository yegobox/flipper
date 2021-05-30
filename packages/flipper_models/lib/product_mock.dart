library flipper_models;

import 'product.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final AppService _appService = locator<AppService>();
final customProductMock = new Product(
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
  // variants: [
  //   AllVariant(
  //     name: "Regular",
  //     sku: "sku",
  //     retailPrice: 0,
  //     canTrackingStock: false,
  //     supplyPrice: 0,
  //     branchId: _appService.branchId!,
  //     currentStock: 0,
  //     unit: "kg",
  //     table: "variants",
  //     channels: [_appService.userid!],
  //     // updatedAt: DateTime.now().toIso8601String()
  //   )
  // ],
);

final productMock = new Product(
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
  channels: [_appService.userid!],
  createdAt: DateTime.now().toIso8601String(),
  // variants: [
  //   AllVariant(
  //     name: "Regular",
  //     sku: "sku",
  //     retailPrice: 0,
  //     canTrackingStock: false,
  //     supplyPrice: 0,
  //     branchId: _appService.branchId!,
  //     currentStock: 0,
  //     unit: "kg",
  //     table: "variants",
  //     channels: [_appService.userid!],
  //     // updatedAt: DateTime.now().toIso8601String()
  //   )
  // ],
);
