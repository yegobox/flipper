import 'package:dart_mappable/dart_mappable.dart';
import 'package:realm/realm.dart';

part 'realmTransactionItem.realm.dart';
part 'realmTransactionItem.mapper.dart';

@MappableClass()
@RealmModel()
class $RealmITransactionItem with $RealmITransactionItemMappable {
  late int id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  late String name;
  late int transactionId;
  late int variantId;
  // quantity
  late double qty;
  late double price;
  late String action;

  late int branchId;

  late double remainingStock;
  late String createdAt;
  late String updatedAt;
  late bool isTaxExempted;
  bool? isRefunded;

  double? discount;
  String? type;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double? dcRt;
  // discount amount
  double? dcAmt;

  double? taxblAmt;
  double? taxAmt;

  double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
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
  DateTime? lastTouched;
  DateTime? deletedAt;
  void updateProperties(RealmITransactionItem other) {
    id = other.id;
    name = other.name;
    transactionId = other.transactionId;
    variantId = other.variantId;
    qty = other.qty;
    price = other.price;
    action = other.action;
    branchId = other.branchId;
    remainingStock = other.remainingStock;
    createdAt = other.createdAt;
    updatedAt = other.updatedAt;
    isTaxExempted = other.isTaxExempted;
    isRefunded = other.isRefunded;
    discount = other.discount;
    type = other.type;
    doneWithTransaction = other.doneWithTransaction;
    active = other.active;
    dcRt = other.dcRt;
    dcAmt = other.dcAmt;
    taxblAmt = other.taxblAmt;
    taxAmt = other.taxAmt;
    totAmt = other.totAmt;
    itemSeq = other.itemSeq;
    isrccCd = other.isrccCd;
    isrccNm = other.isrccNm;
    isrcRt = other.isrcRt;
    isrcAmt = other.isrcAmt;
    taxTyCd = other.taxTyCd;
    bcd = other.bcd;
    itemClsCd = other.itemClsCd;
    itemTyCd = other.itemTyCd;
    itemStdNm = other.itemStdNm;
    orgnNatCd = other.orgnNatCd;
    pkg = other.pkg;
    itemCd = other.itemCd;
    pkgUnitCd = other.pkgUnitCd;
    qtyUnitCd = other.qtyUnitCd;
    itemNm = other.itemNm;
    prc = other.prc;
    splyAmt = other.splyAmt;
    tin = other.tin;
    bhfId = other.bhfId;
    dftPrc = other.dftPrc;
    addInfo = other.addInfo;
    isrcAplcbYn = other.isrcAplcbYn;
    useYn = other.useYn;
    regrId = other.regrId;
    regrNm = other.regrNm;
    modrId = other.modrId;
    modrNm = other.modrNm;
    lastTouched = other.lastTouched;
    deletedAt = other.deletedAt;
  }
}
