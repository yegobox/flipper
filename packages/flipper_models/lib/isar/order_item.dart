import 'package:isar/isar.dart';

part 'order_item.g.dart';

@Collection()
class OrderItem {
  late int id = Isar.autoIncrement;
  late String name;
  late int orderId;
  late int variantId;
  // quantity
  late double qty;
  late double price;
  late double? discount;

  String? type;
  late bool reported;

  late double remainingStock;
  late String createdAt;
  late String updatedAt;
  // discount rate
  double? dcRt;
  // discount amount
  double? dcAmt;

  double? taxblAmt;
  double? taxAmt;

  double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to orderItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  String? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  String? isrcRt;
  // insurance amount
  String? isrcAmt;
  // taxation type code.
  String? taxTyCd;
  // bar code
  String? bcd;
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm;
  // Item origin
  String? orgnNatCd;
  // packaging unit code
  String? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  // unit price
  double? prc;
  // supply amount
  double? splyAmt;
}
