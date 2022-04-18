// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'package:isar/isar.dart';
part 'variant.g.dart';

@Collection()
class Variant {
  late int id = Isar.autoIncrement;
  late String name;
  late String sku;
  late int productId;
  late String unit;
  late String table;
  late List<String>? channels;
  late String productName;
  late int branchId;
  late String? taxName;
  late double? taxPercentage;
  late double supplyPrice;
  late double retailPrice;
  late bool? synced;
  late bool? migrated;

  // add RRA fields
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
  double? qty;
  // unit price
  double? prc;
  // supply amount
  double? splyAmt;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
}
