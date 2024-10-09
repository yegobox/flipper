// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ITransactionItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ITransactionItem _$ITransactionItemFromJson(Map<String, dynamic> json) =>
    ITransactionItem(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      transactionId: (json['transactionId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String?,
      remainingStock: (json['remainingStock'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isTaxExempted: json['isTaxExempted'] as bool? ?? false,
      isRefunded: json['isRefunded'] as bool? ?? false,
      doneWithTransaction: json['doneWithTransaction'] as bool?,
      active: json['active'] as bool?,
      dcRt: (json['dcRt'] as num?)?.toDouble() ?? 0.0,
      dcAmt: (json['dcAmt'] as num?)?.toDouble() ?? 0.0,
      taxblAmt: (json['taxblAmt'] as num?)?.toDouble() ?? 0.0,
      taxAmt: (json['taxAmt'] as num?)?.toDouble() ?? 0.0,
      totAmt: (json['totAmt'] as num?)?.toDouble() ?? 0.0,
      itemSeq: (json['itemSeq'] as num?)?.toInt(),
      isrccCd: json['isrccCd'] as String?,
      isrccNm: json['isrccNm'] as String?,
      isrcRt: (json['isrcRt'] as num?)?.toInt(),
      isrcAmt: (json['isrcAmt'] as num?)?.toInt(),
      taxTyCd: json['taxTyCd'] as String?,
      bcd: json['bcd'] as String?,
      itemClsCd: json['itemClsCd'] as String?,
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String?,
      orgnNatCd: json['orgnNatCd'] as String?,
      pkg: json['pkg'] as int?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      prc: (json['prc'] as num?)?.toDouble() ?? 0.0,
      splyAmt: (json['splyAmt'] as num?)?.toDouble() ?? 0.0,
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
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      action: json['action'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
    );

const _$ITransactionItemFieldMap = <String, String>{
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
abstract class _$ITransactionItemPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? transactionId(int? instance) => instance;
  // ignore: unused_element
  static Object? variantId(int? instance) => instance;
  // ignore: unused_element
  static Object? qty(double instance) => instance;
  // ignore: unused_element
  static Object? price(double instance) => instance;
  // ignore: unused_element
  static Object? discount(double instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? remainingStock(double instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(String? instance) => instance;
  // ignore: unused_element
  static Object? isTaxExempted(bool instance) => instance;
  // ignore: unused_element
  static Object? isRefunded(bool instance) => instance;
  // ignore: unused_element
  static Object? doneWithTransaction(bool? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? dcRt(double instance) => instance;
  // ignore: unused_element
  static Object? dcAmt(double instance) => instance;
  // ignore: unused_element
  static Object? taxblAmt(double instance) => instance;
  // ignore: unused_element
  static Object? taxAmt(double instance) => instance;
  // ignore: unused_element
  static Object? totAmt(double instance) => instance;
  // ignore: unused_element
  static Object? itemSeq(int? instance) => instance;
  // ignore: unused_element
  static Object? isrccCd(String? instance) => instance;
  // ignore: unused_element
  static Object? isrccNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcRt(int? instance) => instance;
  // ignore: unused_element
  static Object? isrcAmt(int? instance) => instance;
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
  static Object? splyAmt(double instance) => instance;
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
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
}

Map<String, dynamic> _$ITransactionItemToJson(ITransactionItem instance) =>
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
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'branchId': instance.branchId,
    };
