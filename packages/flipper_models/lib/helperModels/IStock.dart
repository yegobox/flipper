import 'package:freezed_annotation/freezed_annotation.dart';

part 'IStock.g.dart';

@JsonSerializable()
class IStock {
  int? id;

  int? tin;
  String? bhfId;

  int? branchId;
  int? variantId;
  double lowStock = 0;
  double currentStock = 0.0;

  bool? canTrackingStock = true;
  bool? showLowStockAlert = true;

  int? productId;
  bool? active;
  double value = 0.0;
  double rsdQty = 0.0;

  double supplyPrice = 0.0;
  double retailPrice = 0.0;

  DateTime? lastTouched;

  String? action;

  DateTime? deletedAt;

  bool ebmSynced = false;
  IStock({
    this.id,
    this.tin,
    this.bhfId,
    this.branchId,
    this.variantId,
    this.lowStock = 0,
    this.currentStock = 0.0,
    this.canTrackingStock = true,
    this.showLowStockAlert = true,
    this.productId,
    this.active,
    this.value = 0.0,
    this.rsdQty = 0.0,
    this.supplyPrice = 0.0,
    this.retailPrice = 0.0,
    this.lastTouched,
    this.action,
    this.deletedAt,
    this.ebmSynced = false,
  });
  Map<String, dynamic> toJson() => _$IStockToJson(this);
}
