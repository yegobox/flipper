library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'stock.g.dart';

@JsonSerializable()
@Collection()
class Stock extends IJsonSerializable {
  late String id;
  @Index()
  late int branchId;
  late String variantId;
  double? lowStock;
  late double currentStock;

  bool? canTrackingStock;
  bool? showLowStockAlert;
  @Index()
  late String productId;
  bool? active;
  // the value of stock is currentStock * retailPrice
  double? value;
  // RRA fields
  double? rsdQty;

  double? supplyPrice;
  double? retailPrice;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  @Index()
  DateTime? deletedAt;
  Stock({
    required this.branchId,
    required this.variantId,
    required this.currentStock,
    required this.productId,
    required this.action,
    required this.id,
    this.lowStock,
    this.supplyPrice,
    this.retailPrice,
    this.canTrackingStock,
    this.showLowStockAlert,
    this.active,
    this.value,
    this.rsdQty,
    required this.lastTouched,
    this.deletedAt,
  });

  factory Stock.fromRecord(RecordModel record) =>
      Stock.fromJson(record.toJson());

  factory Stock.fromJson(Map<String, dynamic> json) {
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$StockFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$StockToJson(this);
}
