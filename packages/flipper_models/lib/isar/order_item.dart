import 'package:isar/isar.dart';

part 'order_item.g.dart';

@Collection()
class OrderItem {
  late int id = Isar.autoIncrement;
  late String name;
  @Index()
  late int orderId;
  @Index(composite: [CompositeIndex('orderId')])
  late int variantId;
  // quantity
  late double qty;
  late double price;
  double? discount;

  String? type;
  bool? reported;

  late double remainingStock;
  late String createdAt;
  late String updatedAt;

  // RRA fields
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
  // check if prc is saved as same as retailPrice
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

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'orderId': orderId,
        'variantId': variantId,
        'qty': qty,
        'price': price,
        'discount': discount,
        'type': type,
        'reported': reported,
        'remainingStock': remainingStock,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'dcRt': dcRt,
        'dcAmt': dcAmt,
        'taxblAmt': taxblAmt,
        'taxAmt': taxAmt,
        'totAmt': totAmt,
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
      };
}
