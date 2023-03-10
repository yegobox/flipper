library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:flipper_services/proxy.dart';
part 'stock.g.dart';

@Collection()
class Stock extends JsonSerializable {
  Id id = Isar.autoIncrement;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late int variantId;
  double? lowStock;
  late double currentStock;
  double? supplyPrice;
  double? retailPrice;
  bool? canTrackingStock;
  bool? showLowStockAlert;
  @Index()
  late int productId;
  bool? active;
  // the value of stock is currentStock * retailPrice
  double? value;
  // RRA fields
  double? rsdQty;
  @Index()
  DateTime? lastTouched;
  @Index()
  String? remoteID;

  Stock({
    required this.branchId,
    required this.variantId,
    required this.currentStock,
    required this.productId,
    this.lowStock,
    this.supplyPrice,
    this.retailPrice,
    this.canTrackingStock,
    this.showLowStockAlert,
    this.active,
    this.value,
    this.rsdQty,
    this.lastTouched,
    this.remoteID,
  });

  @override
  Map<String, dynamic> toJson({required String remoteId}) => {
        'id': remoteID,
        'branchId': branchId,
        'variantId': variantId,
        'lowStock': lowStock,
        'currentStock': currentStock,
        'supplyPrice': supplyPrice,
        'retailPrice': retailPrice,
        'canTrackingStock': canTrackingStock,
        'showLowStockAlert': showLowStockAlert,
        'productId': productId,
        'active': active,
        'value': value,
        'rsdQty': rsdQty,
        'lastTouched': Hlc.fromDate(
            DateTime.now(), ProxyService.box.getBranchId()!.toString()),
        'remoteID': remoteID
      };
  factory Stock.fromRecord(RecordModel record) =>
      Stock.fromJson(record.toJson());
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        branchId: json['branchId'],
        variantId: json['variantId'],
        lowStock: json['lowStock'],
        currentStock: json['currentStock'],
        supplyPrice: json['supplyPrice'],
        retailPrice: json['retailPrice'],
        canTrackingStock: json['canTrackingStock'],
        showLowStockAlert: json['showLowStockAlert'],
        productId: json['productId'],
        active: json['active'],
        value: json['value'],
        rsdQty: json['rsdQty'],
        lastTouched: json['lastTouched'],
        remoteID: json['remoteID']);
  }
}
