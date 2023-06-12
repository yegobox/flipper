library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'stock.g.dart';

@JsonSerializable()
@Collection()
class Stock extends IJsonSerializable {
  Id? id;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late int variantId;
  double? lowStock;
  late double currentStock;

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
  double? supplyPrice;
  @Index()
  double? retailPrice;
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;
  String? action;
  Stock(
      {required this.branchId,
      required this.variantId,
      required this.currentStock,
      required this.productId,
      required this.action,
      this.id,
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
      this.localId});

  factory Stock.fromRecord(RecordModel record) =>
      Stock.fromJson(record.toJson());

  factory Stock.fromJson(Map<String, dynamic> json) {
    json['remoteID'] = json['id'];
    json.remove('id');
    return _$StockFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$StockToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
