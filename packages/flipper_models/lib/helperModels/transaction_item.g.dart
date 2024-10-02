// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      id: (json['id'] as num?)?.toInt(),
      action: json['action'] as String,
      name: json['name'] as String,
      transactionId: (json['transactionId'] as num).toInt(),
      variantId: (json['variantId'] as num).toInt(),
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      branchId: (json['branchId'] as num).toInt(),
      remainingStock: (json['remainingStock'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isTaxExempted: json['isTaxExempted'] as bool,
      prc: (json['prc'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      type: json['type'] as String?,
      isRefunded: json['isRefunded'] as bool?,
      doneWithTransaction: json['doneWithTransaction'] as bool?,
      active: json['active'] as bool?,
      dcRt: (json['dcRt'] as num?)?.toDouble(),
      dcAmt: (json['dcAmt'] as num?)?.toDouble(),
      taxblAmt: (json['taxblAmt'] as num?)?.toDouble(),
      taxAmt: (json['taxAmt'] as num?)?.toDouble(),
      totAmt: (json['totAmt'] as num?)?.toDouble(),
      itemSeq: json['itemSeq'] as String?,
      isrccCd: json['isrccCd'] as String?,
      isrccNm: json['isrccNm'] as String?,
      isrcRt: json['isrcRt'] as String?,
      isrcAmt: json['isrcAmt'] as String?,
      taxTyCd: json['taxTyCd'] as String?,
      bcd: json['bcd'] as String?,
      itemClsCd: json['itemClsCd'] as String?,
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String?,
      orgnNatCd: json['orgnNatCd'] as String?,
      pkg: json['pkg'] as String?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      splyAmt: (json['splyAmt'] as num?)?.toDouble(),
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      dftPrc: (json['dftPrc'] as num?)?.toDouble(),
      addInfo: json['addInfo'] as String?,
      isrcAplcbYn: json['isrcAplcbYn'] as String?,
      useYn: json['useYn'] as String?,
      regrId: json['regrId'] as String?,
      regrNm: json['regrNm'] as String?,
      modrId: json['modrId'] as String?,
      modrNm: json['modrNm'] as String?,
      lastTouched:
          TransactionItem._dateTimeFromJson(json['lastTouched'] as String?),
      deletedAt:
          TransactionItem._dateTimeFromJson(json['deletedAt'] as String?),
    );

const _$TransactionItemFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'transactionId': 'transactionId',
  'variantId': 'variantId',
  'qty': 'qty',
  'price': 'price',
  'discount': 'discount',
  'type': 'type',
  'remainingStock': 'remainingStock',
  'createdAt': 'createdAt',
  'updatedAt': 'updatedAt',
  'isTaxExempted': 'isTaxExempted',
  'isRefunded': 'isRefunded',
  'doneWithTransaction': 'doneWithTransaction',
  'active': 'active',
  'dcRt': 'dcRt',
  'dcAmt': 'dcAmt',
  'taxblAmt': 'taxblAmt',
  'taxAmt': 'taxAmt',
  'totAmt': 'totAmt',
  'itemSeq': 'itemSeq',
  'isrccCd': 'isrccCd',
  'isrccNm': 'isrccNm',
  'isrcRt': 'isrcRt',
  'isrcAmt': 'isrcAmt',
  'taxTyCd': 'taxTyCd',
  'bcd': 'bcd',
  'itemClsCd': 'itemClsCd',
  'itemTyCd': 'itemTyCd',
  'itemStdNm': 'itemStdNm',
  'orgnNatCd': 'orgnNatCd',
  'pkg': 'pkg',
  'itemCd': 'itemCd',
  'pkgUnitCd': 'pkgUnitCd',
  'qtyUnitCd': 'qtyUnitCd',
  'itemNm': 'itemNm',
  'prc': 'prc',
  'splyAmt': 'splyAmt',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'dftPrc': 'dftPrc',
  'addInfo': 'addInfo',
  'isrcAplcbYn': 'isrcAplcbYn',
  'useYn': 'useYn',
  'regrId': 'regrId',
  'regrNm': 'regrNm',
  'modrId': 'modrId',
  'modrNm': 'modrNm',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'action': 'action',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$TransactionItemPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? transactionId(int instance) => instance;
  // ignore: unused_element
  static Object? variantId(int instance) => instance;
  // ignore: unused_element
  static Object? qty(double instance) => instance;
  // ignore: unused_element
  static Object? price(double instance) => instance;
  // ignore: unused_element
  static Object? discount(double? instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? remainingStock(double instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(String instance) => instance;
  // ignore: unused_element
  static Object? isTaxExempted(bool instance) => instance;
  // ignore: unused_element
  static Object? isRefunded(bool? instance) => instance;
  // ignore: unused_element
  static Object? doneWithTransaction(bool? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? dcRt(double? instance) => instance;
  // ignore: unused_element
  static Object? dcAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? taxblAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? taxAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? totAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? itemSeq(String? instance) => instance;
  // ignore: unused_element
  static Object? isrccCd(String? instance) => instance;
  // ignore: unused_element
  static Object? isrccNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcRt(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcAmt(String? instance) => instance;
  // ignore: unused_element
  static Object? taxTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? bcd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemClsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemStdNm(String? instance) => instance;
  // ignore: unused_element
  static Object? orgnNatCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pkg(String? instance) => instance;
  // ignore: unused_element
  static Object? itemCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pkgUnitCd(String? instance) => instance;
  // ignore: unused_element
  static Object? qtyUnitCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemNm(String? instance) => instance;
  // ignore: unused_element
  static Object? prc(double instance) => instance;
  // ignore: unused_element
  static Object? splyAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? dftPrc(double? instance) => instance;
  // ignore: unused_element
  static Object? addInfo(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcAplcbYn(String? instance) => instance;
  // ignore: unused_element
  static Object? useYn(String? instance) => instance;
  // ignore: unused_element
  static Object? regrId(String? instance) => instance;
  // ignore: unused_element
  static Object? regrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? modrId(String? instance) => instance;
  // ignore: unused_element
  static Object? modrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      TransactionItem._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) =>
      TransactionItem._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
}

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'transactionId': instance.transactionId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'price': instance.price,
      'discount': instance.discount,
      'type': instance.type,
      'remainingStock': instance.remainingStock,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isTaxExempted': instance.isTaxExempted,
      'isRefunded': instance.isRefunded,
      'doneWithTransaction': instance.doneWithTransaction,
      'active': instance.active,
      'dcRt': instance.dcRt,
      'dcAmt': instance.dcAmt,
      'taxblAmt': instance.taxblAmt,
      'taxAmt': instance.taxAmt,
      'totAmt': instance.totAmt,
      'itemSeq': instance.itemSeq,
      'isrccCd': instance.isrccCd,
      'isrccNm': instance.isrccNm,
      'isrcRt': instance.isrcRt,
      'isrcAmt': instance.isrcAmt,
      'taxTyCd': instance.taxTyCd,
      'bcd': instance.bcd,
      'itemClsCd': instance.itemClsCd,
      'itemTyCd': instance.itemTyCd,
      'itemStdNm': instance.itemStdNm,
      'orgnNatCd': instance.orgnNatCd,
      'pkg': instance.pkg,
      'itemCd': instance.itemCd,
      'pkgUnitCd': instance.pkgUnitCd,
      'qtyUnitCd': instance.qtyUnitCd,
      'itemNm': instance.itemNm,
      'prc': instance.prc,
      'splyAmt': instance.splyAmt,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'dftPrc': instance.dftPrc,
      'addInfo': instance.addInfo,
      'isrcAplcbYn': instance.isrcAplcbYn,
      'useYn': instance.useYn,
      'regrId': instance.regrId,
      'regrNm': instance.regrNm,
      'modrId': instance.modrId,
      'modrNm': instance.modrNm,
      'lastTouched': TransactionItem._dateTimeToJson(instance.lastTouched),
      'deletedAt': TransactionItem._dateTimeToJson(instance.deletedAt),
      'action': instance.action,
      'branchId': instance.branchId,
    };
