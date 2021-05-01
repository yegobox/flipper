library flipper_models;

import 'product.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/app_service.dart';

final id = Uuid().v1();
final AppService _appService = locator<AppService>();

final productMock = new Product(
  id: id,
  draft: true,
  currentUpdate: true,
  taxId: "XX",
  imageLocal: false,
  businessId: _appService.businessId!,
  name: "temp",
  description: "L",
  active: true,
  hasPicture: false,
  table: "products",
  color: "#e74c3c",
  supplierId: "XXX",
  categoryId: "XXX",
  unit: "kg",
  channels: [_appService.userid!],
  createdAt: DateTime.now().toIso8601String(),
  variants: [
    AllVariant(
      name: "Regular",
      sku: "sku",
      retailPrice: 0,
      canTrackingStock: false,
      supplyPrice: 0,
      branchId: _appService.branchId!,
      currentStock: 0,
      unit: "kg",
      table: "variants",
      channels: [_appService.userid!],
      // updatedAt: DateTime.now().toIso8601String()
    )
  ],
);
