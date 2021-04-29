library flipper_models;

import 'product.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';

final id = Uuid().v1();
// final time = DateTime.now();
final String? userid = ProxyService.box.read(key: 'userId');
final String? businessId = ProxyService.box.read(key: 'businessId');
final String? branchId = ProxyService.box.read(key: 'branchId');
final productMock = new Product(
  id: id,
  draft: true,
  currentUpdate: true,
  taxId: "XX",
  imageLocal: false,
  businessId: businessId!,
  name: "temp",
  description: "L",
  active: true,
  hasPicture: false,
  table: "products",
  color: "#e74c3c",
  supplierId: "XXX",
  categoryId: "XXX",
  unit: "kg",
  channels: [userid!],
  createdAt: DateTime.now().toIso8601String(),
  variants: [
    AllVariant(
      name: "Regular",
      sku: "sku",
      retailPrice: 0,
      canTrackingStock: false,
      supplyPrice: 0,
      branchId: branchId,
      currentStock: 0,
      unit: "kg",
      table: "variants",
      channels: [userid!],
      // updatedAt: DateTime.now().toIso8601String()
    )
  ],
);
