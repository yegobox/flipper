// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmTransactionItem.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmITransactionItem extends _RealmITransactionItem
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmITransactionItem(
    ObjectId realmId,
    String name,
    String transactionId,
    String variantId,
    double qty,
    double price,
    String action,
    int branchId,
    double remainingStock,
    String createdAt,
    String updatedAt,
    String id,
    bool isTaxExempted, {
    String? modrNm,
    String? itemCd,
    double? prc,
    int? tin,
    String? isrcAplcbYn,
    String? regrId,
    DateTime? lastTouched,
    double? dcAmt,
    double? taxblAmt,
    double? taxAmt,
    DateTime? deletedAt,
    String? itemSeq,
    String? pkgUnitCd,
    String? itemNm,
    double? splyAmt,
    String? isrcAmt,
    String? bhfId,
    String? addInfo,
    String? useYn,
    String? itemTyCd,
    String? regrNm,
    String? qtyUnitCd,
    double? totAmt,
    String? isrccCd,
    bool? isRefunded,
    String? isrccNm,
    double? dftPrc,
    String? isrcRt,
    double? discount,
    String? taxTyCd,
    String? type,
    String? bcd,
    String? modrId,
    String? itemClsCd,
    bool? doneWithTransaction,
    String? itemStdNm,
    bool? active,
    String? orgnNatCd,
    double? dcRt,
    String? pkg,
  }) {
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'transactionId', transactionId);
    RealmObjectBase.set(this, 'variantId', variantId);
    RealmObjectBase.set(this, 'qty', qty);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'remainingStock', remainingStock);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'itemCd', itemCd);
    RealmObjectBase.set(this, 'prc', prc);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'dcAmt', dcAmt);
    RealmObjectBase.set(this, 'taxblAmt', taxblAmt);
    RealmObjectBase.set(this, 'taxAmt', taxAmt);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'itemSeq', itemSeq);
    RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
    RealmObjectBase.set(this, 'itemNm', itemNm);
    RealmObjectBase.set(this, 'splyAmt', splyAmt);
    RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'addInfo', addInfo);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
    RealmObjectBase.set(this, 'totAmt', totAmt);
    RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
    RealmObjectBase.set(this, 'isrccCd', isrccCd);
    RealmObjectBase.set(this, 'isRefunded', isRefunded);
    RealmObjectBase.set(this, 'isrccNm', isrccNm);
    RealmObjectBase.set(this, 'dftPrc', dftPrc);
    RealmObjectBase.set(this, 'isrcRt', isrcRt);
    RealmObjectBase.set(this, 'discount', discount);
    RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'bcd', bcd);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
    RealmObjectBase.set(this, 'doneWithTransaction', doneWithTransaction);
    RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
    RealmObjectBase.set(this, 'dcRt', dcRt);
    RealmObjectBase.set(this, 'pkg', pkg);
  }

  RealmITransactionItem._();

  @override
  String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
  @override
  set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

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
  String get transactionId =>
      RealmObjectBase.get<String>(this, 'transactionId') as String;
  @override
  set transactionId(String value) =>
      RealmObjectBase.set(this, 'transactionId', value);

  @override
  String get variantId =>
      RealmObjectBase.get<String>(this, 'variantId') as String;
  @override
  set variantId(String value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  double get qty => RealmObjectBase.get<double>(this, 'qty') as double;
  @override
  set qty(double value) => RealmObjectBase.set(this, 'qty', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  double get remainingStock =>
      RealmObjectBase.get<double>(this, 'remainingStock') as double;
  @override
  set remainingStock(double value) =>
      RealmObjectBase.set(this, 'remainingStock', value);

  @override
  String get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String;
  @override
  set createdAt(String value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String get updatedAt =>
      RealmObjectBase.get<String>(this, 'updatedAt') as String;
  @override
  set updatedAt(String value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
  @override
  set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

  @override
  double? get prc => RealmObjectBase.get<double>(this, 'prc') as double?;
  @override
  set prc(double? value) => RealmObjectBase.set(this, 'prc', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get isrcAplcbYn =>
      RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
  @override
  set isrcAplcbYn(String? value) =>
      RealmObjectBase.set(this, 'isrcAplcbYn', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  double? get dcAmt => RealmObjectBase.get<double>(this, 'dcAmt') as double?;
  @override
  set dcAmt(double? value) => RealmObjectBase.set(this, 'dcAmt', value);

  @override
  double? get taxblAmt =>
      RealmObjectBase.get<double>(this, 'taxblAmt') as double?;
  @override
  set taxblAmt(double? value) => RealmObjectBase.set(this, 'taxblAmt', value);

  @override
  double? get taxAmt => RealmObjectBase.get<double>(this, 'taxAmt') as double?;
  @override
  set taxAmt(double? value) => RealmObjectBase.set(this, 'taxAmt', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get itemSeq =>
      RealmObjectBase.get<String>(this, 'itemSeq') as String?;
  @override
  set itemSeq(String? value) => RealmObjectBase.set(this, 'itemSeq', value);

  @override
  String? get pkgUnitCd =>
      RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
  @override
  set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

  @override
  String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
  @override
  set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

  @override
  double? get splyAmt =>
      RealmObjectBase.get<double>(this, 'splyAmt') as double?;
  @override
  set splyAmt(double? value) => RealmObjectBase.set(this, 'splyAmt', value);

  @override
  String? get isrcAmt =>
      RealmObjectBase.get<String>(this, 'isrcAmt') as String?;
  @override
  set isrcAmt(String? value) => RealmObjectBase.set(this, 'isrcAmt', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  String? get addInfo =>
      RealmObjectBase.get<String>(this, 'addInfo') as String?;
  @override
  set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get itemTyCd =>
      RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
  @override
  set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get qtyUnitCd =>
      RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
  @override
  set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

  @override
  double? get totAmt => RealmObjectBase.get<double>(this, 'totAmt') as double?;
  @override
  set totAmt(double? value) => RealmObjectBase.set(this, 'totAmt', value);

  @override
  bool get isTaxExempted =>
      RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
  @override
  set isTaxExempted(bool value) =>
      RealmObjectBase.set(this, 'isTaxExempted', value);

  @override
  String? get isrccCd =>
      RealmObjectBase.get<String>(this, 'isrccCd') as String?;
  @override
  set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

  @override
  bool? get isRefunded =>
      RealmObjectBase.get<bool>(this, 'isRefunded') as bool?;
  @override
  set isRefunded(bool? value) => RealmObjectBase.set(this, 'isRefunded', value);

  @override
  String? get isrccNm =>
      RealmObjectBase.get<String>(this, 'isrccNm') as String?;
  @override
  set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

  @override
  double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
  @override
  set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

  @override
  String? get isrcRt => RealmObjectBase.get<String>(this, 'isrcRt') as String?;
  @override
  set isrcRt(String? value) => RealmObjectBase.set(this, 'isrcRt', value);

  @override
  double? get discount =>
      RealmObjectBase.get<double>(this, 'discount') as double?;
  @override
  set discount(double? value) => RealmObjectBase.set(this, 'discount', value);

  @override
  String? get taxTyCd =>
      RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
  @override
  set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
  @override
  set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  String? get itemClsCd =>
      RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
  @override
  set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

  @override
  bool? get doneWithTransaction =>
      RealmObjectBase.get<bool>(this, 'doneWithTransaction') as bool?;
  @override
  set doneWithTransaction(bool? value) =>
      RealmObjectBase.set(this, 'doneWithTransaction', value);

  @override
  String? get itemStdNm =>
      RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
  @override
  set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  String? get orgnNatCd =>
      RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
  @override
  set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

  @override
  double? get dcRt => RealmObjectBase.get<double>(this, 'dcRt') as double?;
  @override
  set dcRt(double? value) => RealmObjectBase.set(this, 'dcRt', value);

  @override
  String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
  @override
  set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

  @override
  Stream<RealmObjectChanges<RealmITransactionItem>> get changes =>
      RealmObjectBase.getChanges<RealmITransactionItem>(this);

  @override
  RealmITransactionItem freeze() =>
      RealmObjectBase.freezeObject<RealmITransactionItem>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmITransactionItem._);
    return const SchemaObject(ObjectType.realmObject, RealmITransactionItem,
        'RealmITransactionItem', [
      SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('transactionId', RealmPropertyType.string),
      SchemaProperty('variantId', RealmPropertyType.string),
      SchemaProperty('qty', RealmPropertyType.double),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('remainingStock', RealmPropertyType.double),
      SchemaProperty('createdAt', RealmPropertyType.string),
      SchemaProperty('updatedAt', RealmPropertyType.string),
      SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
      SchemaProperty('prc', RealmPropertyType.double, optional: true),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('dcAmt', RealmPropertyType.double, optional: true),
      SchemaProperty('taxblAmt', RealmPropertyType.double, optional: true),
      SchemaProperty('taxAmt', RealmPropertyType.double, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('itemSeq', RealmPropertyType.string, optional: true),
      SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
      SchemaProperty('splyAmt', RealmPropertyType.double, optional: true),
      SchemaProperty('isrcAmt', RealmPropertyType.string, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('totAmt', RealmPropertyType.double, optional: true),
      SchemaProperty('isTaxExempted', RealmPropertyType.bool),
      SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
      SchemaProperty('isRefunded', RealmPropertyType.bool, optional: true),
      SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
      SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
      SchemaProperty('isrcRt', RealmPropertyType.string, optional: true),
      SchemaProperty('discount', RealmPropertyType.double, optional: true),
      SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('bcd', RealmPropertyType.string, optional: true),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
      SchemaProperty('doneWithTransaction', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
      SchemaProperty('dcRt', RealmPropertyType.double, optional: true),
      SchemaProperty('pkg', RealmPropertyType.string, optional: true),
    ]);
  }
}
