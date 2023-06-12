import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'order_item.g.dart';

@JsonSerializable()
@Collection()
class OrderItem extends IJsonSerializable {
  Id? id;
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
  late bool isTaxExempted;
  bool? isRefunded;

  /// property to help us adding new item to order
  bool? doneWithOrder;

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

  OrderItem({
    this.id,
    required this.name,
    required this.orderId,
    required this.variantId,
    required this.qty,
    required this.price,
    this.discount,
    this.type,
    this.reported,
    required this.remainingStock,
    required this.createdAt,
    required this.updatedAt,
    required this.isTaxExempted,
    this.isRefunded,
    this.doneWithOrder,
    this.dcRt,
    this.dcAmt,
    this.taxblAmt,
    this.taxAmt,
    this.totAmt,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm,
    this.isrcRt,
    this.isrcAmt,
    this.taxTyCd,
    this.bcd,
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm,
    this.orgnNatCd,
    this.pkg,
    this.itemCd,
    this.pkgUnitCd,
    this.qtyUnitCd,
    this.itemNm,
    this.prc,
    this.splyAmt,
    this.tin,
    this.bhfId,
    this.dftPrc,
    this.addInfo,
    this.isrcAplcbYn,
    this.useYn,
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
  });
  //sync String? remoteID;
  String? action;
  int? localId;

  factory OrderItem.fromRecord(RecordModel record) =>
      OrderItem.fromJson(record.toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$OrderItemFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$OrderItemToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
