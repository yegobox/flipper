// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmVariant.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmVariant extends _RealmVariant
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmVariant(
    ObjectId realmId,
    String name,
    String color,
    String sku,
    String productId,
    String unit,
    String productName,
    int branchId,
    bool isTaxExempted,
    String action,
    String id,
    double retailPrice,
    double supplyPrice, {
    double? dftPrc,
    String? taxName,
    double? taxPercentage,
    String? isrcAplcbYn,
    String? modrId,
    double? rsdQty,
    String? taxTyCd,
    String? bcd,
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm,
    String? addInfo,
    String? pkg,
    String? useYn,
    String? regrNm,
    String? modrNm,
    String? itemNm,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? tin,
    String? bhfId,
    String? regrId,
    String? orgnNatCd,
    String? itemSeq,
    String? itemCd,
    String? isrccCd,
    String? pkgUnitCd,
    String? qtyUnitCd,
    String? isrccNm,
    double? qty,
    String? isrcRt,
    double? prc,
    String? isrcAmt,
    double? splyAmt,
  }) {
    RealmObjectBase.set(this, 'dftPrc', dftPrc);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'sku', sku);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'productName', productName);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'taxName', taxName);
    RealmObjectBase.set(this, 'taxPercentage', taxPercentage);
    RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
    RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'rsdQty', rsdQty);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
    RealmObjectBase.set(this, 'bcd', bcd);
    RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
    RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
    RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
    RealmObjectBase.set(this, 'addInfo', addInfo);
    RealmObjectBase.set(this, 'pkg', pkg);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, 'itemNm', itemNm);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'retailPrice', retailPrice);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
    RealmObjectBase.set(this, 'itemSeq', itemSeq);
    RealmObjectBase.set(this, 'itemCd', itemCd);
    RealmObjectBase.set(this, 'isrccCd', isrccCd);
    RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
    RealmObjectBase.set(this, 'supplyPrice', supplyPrice);
    RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
    RealmObjectBase.set(this, 'isrccNm', isrccNm);
    RealmObjectBase.set(this, 'qty', qty);
    RealmObjectBase.set(this, 'isrcRt', isrcRt);
    RealmObjectBase.set(this, 'prc', prc);
    RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
    RealmObjectBase.set(this, 'splyAmt', splyAmt);
  }

  RealmVariant._();

  @override
  double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
  @override
  set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get color => RealmObjectBase.get<String>(this, 'color') as String;
  @override
  set color(String value) => RealmObjectBase.set(this, 'color', value);

  @override
  String get sku => RealmObjectBase.get<String>(this, 'sku') as String;
  @override
  set sku(String value) => RealmObjectBase.set(this, 'sku', value);

  @override
  String get productId =>
      RealmObjectBase.get<String>(this, 'productId') as String;
  @override
  set productId(String value) => RealmObjectBase.set(this, 'productId', value);

  @override
  String get unit => RealmObjectBase.get<String>(this, 'unit') as String;
  @override
  set unit(String value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String get productName =>
      RealmObjectBase.get<String>(this, 'productName') as String;
  @override
  set productName(String value) =>
      RealmObjectBase.set(this, 'productName', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get taxName =>
      RealmObjectBase.get<String>(this, 'taxName') as String?;
  @override
  set taxName(String? value) => RealmObjectBase.set(this, 'taxName', value);

  @override
  double? get taxPercentage =>
      RealmObjectBase.get<double>(this, 'taxPercentage') as double?;
  @override
  set taxPercentage(double? value) =>
      RealmObjectBase.set(this, 'taxPercentage', value);

  @override
  bool get isTaxExempted =>
      RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
  @override
  set isTaxExempted(bool value) =>
      RealmObjectBase.set(this, 'isTaxExempted', value);

  @override
  String? get isrcAplcbYn =>
      RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
  @override
  set isrcAplcbYn(String? value) =>
      RealmObjectBase.set(this, 'isrcAplcbYn', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  double? get rsdQty => RealmObjectBase.get<double>(this, 'rsdQty') as double?;
  @override
  set rsdQty(double? value) => RealmObjectBase.set(this, 'rsdQty', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get taxTyCd =>
      RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
  @override
  set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

  @override
  String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
  @override
  set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

  @override
  String? get itemClsCd =>
      RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
  @override
  set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

  @override
  String? get itemTyCd =>
      RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
  @override
  set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

  @override
  String? get itemStdNm =>
      RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
  @override
  set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

  @override
  String? get addInfo =>
      RealmObjectBase.get<String>(this, 'addInfo') as String?;
  @override
  set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

  @override
  String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
  @override
  set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
  @override
  set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

  @override
  String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
  @override
  set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  double get retailPrice =>
      RealmObjectBase.get<double>(this, 'retailPrice') as double;
  @override
  set retailPrice(double value) =>
      RealmObjectBase.set(this, 'retailPrice', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  String? get orgnNatCd =>
      RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
  @override
  set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

  @override
  String? get itemSeq =>
      RealmObjectBase.get<String>(this, 'itemSeq') as String?;
  @override
  set itemSeq(String? value) => RealmObjectBase.set(this, 'itemSeq', value);

  @override
  String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
  @override
  set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

  @override
  String? get isrccCd =>
      RealmObjectBase.get<String>(this, 'isrccCd') as String?;
  @override
  set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

  @override
  String? get pkgUnitCd =>
      RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
  @override
  set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

  @override
  double get supplyPrice =>
      RealmObjectBase.get<double>(this, 'supplyPrice') as double;
  @override
  set supplyPrice(double value) =>
      RealmObjectBase.set(this, 'supplyPrice', value);

  @override
  String? get qtyUnitCd =>
      RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
  @override
  set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

  @override
  String? get isrccNm =>
      RealmObjectBase.get<String>(this, 'isrccNm') as String?;
  @override
  set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

  @override
  double? get qty => RealmObjectBase.get<double>(this, 'qty') as double?;
  @override
  set qty(double? value) => RealmObjectBase.set(this, 'qty', value);

  @override
  String? get isrcRt => RealmObjectBase.get<String>(this, 'isrcRt') as String?;
  @override
  set isrcRt(String? value) => RealmObjectBase.set(this, 'isrcRt', value);

  @override
  double? get prc => RealmObjectBase.get<double>(this, 'prc') as double?;
  @override
  set prc(double? value) => RealmObjectBase.set(this, 'prc', value);

  @override
  String? get isrcAmt =>
      RealmObjectBase.get<String>(this, 'isrcAmt') as String?;
  @override
  set isrcAmt(String? value) => RealmObjectBase.set(this, 'isrcAmt', value);

  @override
  double? get splyAmt =>
      RealmObjectBase.get<double>(this, 'splyAmt') as double?;
  @override
  set splyAmt(double? value) => RealmObjectBase.set(this, 'splyAmt', value);

  @override
  Stream<RealmObjectChanges<RealmVariant>> get changes =>
      RealmObjectBase.getChanges<RealmVariant>(this);

  @override
  RealmVariant freeze() => RealmObjectBase.freezeObject<RealmVariant>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmVariant._);
    return const SchemaObject(
        ObjectType.realmObject, RealmVariant, 'RealmVariant', [
      SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('color', RealmPropertyType.string),
      SchemaProperty('sku', RealmPropertyType.string),
      SchemaProperty('productId', RealmPropertyType.string),
      SchemaProperty('unit', RealmPropertyType.string),
      SchemaProperty('productName', RealmPropertyType.string),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('taxName', RealmPropertyType.string, optional: true),
      SchemaProperty('taxPercentage', RealmPropertyType.double, optional: true),
      SchemaProperty('isTaxExempted', RealmPropertyType.bool),
      SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('rsdQty', RealmPropertyType.double, optional: true),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('bcd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
      SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
      SchemaProperty('pkg', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('retailPrice', RealmPropertyType.double),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemSeq', RealmPropertyType.string, optional: true),
      SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
      SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
      SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('supplyPrice', RealmPropertyType.double),
      SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
      SchemaProperty('qty', RealmPropertyType.double, optional: true),
      SchemaProperty('isrcRt', RealmPropertyType.string, optional: true),
      SchemaProperty('prc', RealmPropertyType.double, optional: true),
      SchemaProperty('isrcAmt', RealmPropertyType.string, optional: true),
      SchemaProperty('splyAmt', RealmPropertyType.double, optional: true),
    ]);
  }
}
