// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IVariant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IVariant _$IVariantFromJson(Map<String, dynamic> json) => IVariant(
      id: (json['id'] as num?)?.toInt(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      name: json['name'] as String?,
      color: json['color'] as String?,
      sku: json['sku'] as String?,
      productId: (json['productId'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      productName: json['productName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      taxName: json['taxName'] as String?,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0.0,
      isTaxExempted: json['isTaxExempted'] as bool? ?? false,
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
      pkg: json['pkg'] as String?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
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
      rsdQty: (json['rsdQty'] as num?)?.toDouble() ?? 0.0,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      supplyPrice: (json['supplyPrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      action: json['action'] as String?,
      spplrItemClsCd: json['spplrItemClsCd'] as String?,
      spplrItemCd: json['spplrItemCd'] as String?,
      spplrItemNm: json['spplrItemNm'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
    );

const _$IVariantFieldMap = <String, String>{
  'id': 'id',
  'deletedAt': 'deletedAt',
  'name': 'name',
  'color': 'color',
  'sku': 'sku',
  'productId': 'productId',
  'unit': 'unit',
  'productName': 'productName',
  'branchId': 'branchId',
  'taxName': 'taxName',
  'taxPercentage': 'taxPercentage',
  'isTaxExempted': 'isTaxExempted',
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
  'qty': 'qty',
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
  'rsdQty': 'rsdQty',
  'lastTouched': 'lastTouched',
  'supplyPrice': 'supplyPrice',
  'retailPrice': 'retailPrice',
  'action': 'action',
  'spplrItemClsCd': 'spplrItemClsCd',
  'spplrItemCd': 'spplrItemCd',
  'spplrItemNm': 'spplrItemNm',
  'ebmSynced': 'ebmSynced',
};

// ignore: unused_element
abstract class _$IVariantPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? color(String? instance) => instance;
  // ignore: unused_element
  static Object? sku(String? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? unit(String? instance) => instance;
  // ignore: unused_element
  static Object? productName(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? taxName(String? instance) => instance;
  // ignore: unused_element
  static Object? taxPercentage(double instance) => instance;
  // ignore: unused_element
  static Object? isTaxExempted(bool instance) => instance;
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
  static Object? qty(double instance) => instance;
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
  static Object? rsdQty(double instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? supplyPrice(double instance) => instance;
  // ignore: unused_element
  static Object? retailPrice(double instance) => instance;
  // ignore: unused_element
  static Object? action(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrItemClsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrItemCd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrItemNm(String? instance) => instance;
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
}

Map<String, dynamic> _$IVariantToJson(IVariant instance) => <String, dynamic>{
      'id': instance.id,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'name': instance.name,
      'color': instance.color,
      'sku': instance.sku,
      'productId': instance.productId,
      'unit': instance.unit,
      'productName': instance.productName,
      'branchId': instance.branchId,
      'taxName': instance.taxName,
      'taxPercentage': instance.taxPercentage,
      'isTaxExempted': instance.isTaxExempted,
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
      'qty': instance.qty,
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
      'rsdQty': instance.rsdQty,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
      'action': instance.action,
      'spplrItemClsCd': instance.spplrItemClsCd,
      'spplrItemCd': instance.spplrItemCd,
      'spplrItemNm': instance.spplrItemNm,
      'ebmSynced': instance.ebmSynced,
    };
