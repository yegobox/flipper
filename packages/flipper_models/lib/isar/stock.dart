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

  double? supplyPrice;
  double? retailPrice;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  @Index()
  DateTime? deletedAt;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced;
  Stock({
    required this.branchId,
    required this.variantId,
    required this.currentStock,
    required this.productId,
    required this.action,
    required this.id,
    this.ebmSynced = false,
    this.lowStock = 10.0,
    this.supplyPrice = 0.0,
    this.retailPrice = 0.0,
    this.canTrackingStock = true,
    this.showLowStockAlert = true,
    this.active,
    this.value,
    this.rsdQty = 0.0,
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
