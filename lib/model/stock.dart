import 'package:built_value/built_value.dart';

part 'stock.g.dart';

abstract class Stock implements Built<Stock, StockBuilder> {
  String get value;
  int get id;
  int get branchId;
  int get variantId;
  int get lowStock;
  int get currentStock;
  int get supplyPrice;
  int get retailPrice;
  bool get canTrackingStock;
  bool get showLowStockAlert;

  Stock._();

  factory Stock([void Function(StockBuilder) updates]) = _$Stock;
}
