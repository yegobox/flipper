// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'package:isar/isar.dart';
part 'variant.g.dart';

@Collection()
class Variant {
  Id id = Isar.autoIncrement;
  @Index(caseSensitive: true)
  late String name;
  late String sku;
  @Index()
  late int productId;
  late String unit;
  late String table;
  late String productName;
  late int branchId;
  late String? taxName;
  double? taxPercentage;
  late double supplyPrice;
  late double retailPrice;
  late bool isTaxExempted;

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
  String? modrNm;

  /// property for stock but presented here for easy
  double? rsdQty;
  // toJson helper
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'productId': productId,
        'unit': unit,
        'table': table,
        'productName': productName,
        'branchId': branchId,
        'taxName': taxName,
        'taxPercentage': taxPercentage,
        'supplyPrice': supplyPrice,
        'retailPrice': retailPrice,
        'itemSeq': itemSeq,
        'isrccCd': isrccCd,
        'isrccNm': isrccNm,
        'isrcRt': isrcRt,
        'isrcAmt': isrcAmt,
        'taxTyCd': taxTyCd,
        'bcd': bcd,
        'itemClsCd': itemClsCd,
        'itemTyCd': itemTyCd,
        'itemStdNm': itemStdNm,
        'orgnNatCd': orgnNatCd,
        'pkg': pkg,
        'itemCd': itemCd,
        'pkgUnitCd': pkgUnitCd,
        'qtyUnitCd': qtyUnitCd,
        'itemNm': itemNm,
        'qty': qty,
        'prc': prc,
        'splyAmt': splyAmt,
        'tin': tin,
        'bhfId': bhfId,
        'dftPrc': dftPrc,
        'addInfo': addInfo,
        'isrcAplcbYn': isrcAplcbYn,
        'useYn': useYn,
        'regrId': regrId,
        'regrNm': regrNm,
        'modrId': modrId,
        'modrNm': modrNm,
        "rsdQty": rsdQty,
      };
}
