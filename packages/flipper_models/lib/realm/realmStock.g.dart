// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmStock.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmStock extends _RealmStock
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmStock(
    String id,
    ObjectId realmId,
    int branchId,
    String variantId,
    double currentStock,
    String productId,
    String action, {
    double? lowStock,
    bool? canTrackingStock,
    bool? showLowStockAlert,
    bool? active,
    double? value,
    double? rsdQty,
    double? supplyPrice,
    double? retailPrice,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'variantId', variantId);
    RealmObjectBase.set(this, 'lowStock', lowStock);
    RealmObjectBase.set(this, 'currentStock', currentStock);
    RealmObjectBase.set(this, 'canTrackingStock', canTrackingStock);
    RealmObjectBase.set(this, 'showLowStockAlert', showLowStockAlert);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'rsdQty', rsdQty);
    RealmObjectBase.set(this, 'supplyPrice', supplyPrice);
    RealmObjectBase.set(this, 'retailPrice', retailPrice);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  RealmStock._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String get variantId =>
      RealmObjectBase.get<String>(this, 'variantId') as String;
  @override
  set variantId(String value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  double? get lowStock =>
      RealmObjectBase.get<double>(this, 'lowStock') as double?;
  @override
  set lowStock(double? value) => RealmObjectBase.set(this, 'lowStock', value);

  @override
  double get currentStock =>
      RealmObjectBase.get<double>(this, 'currentStock') as double;
  @override
  set currentStock(double value) =>
      RealmObjectBase.set(this, 'currentStock', value);

  @override
  bool? get canTrackingStock =>
      RealmObjectBase.get<bool>(this, 'canTrackingStock') as bool?;
  @override
  set canTrackingStock(bool? value) =>
      RealmObjectBase.set(this, 'canTrackingStock', value);

  @override
  bool? get showLowStockAlert =>
      RealmObjectBase.get<bool>(this, 'showLowStockAlert') as bool?;
  @override
  set showLowStockAlert(bool? value) =>
      RealmObjectBase.set(this, 'showLowStockAlert', value);

  @override
  String get productId =>
      RealmObjectBase.get<String>(this, 'productId') as String;
  @override
  set productId(String value) => RealmObjectBase.set(this, 'productId', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  double? get value => RealmObjectBase.get<double>(this, 'value') as double?;
  @override
  set value(double? value) => RealmObjectBase.set(this, 'value', value);

  @override
  double? get rsdQty => RealmObjectBase.get<double>(this, 'rsdQty') as double?;
  @override
  set rsdQty(double? value) => RealmObjectBase.set(this, 'rsdQty', value);

  @override
  double? get supplyPrice =>
      RealmObjectBase.get<double>(this, 'supplyPrice') as double?;
  @override
  set supplyPrice(double? value) =>
      RealmObjectBase.set(this, 'supplyPrice', value);

  @override
  double? get retailPrice =>
      RealmObjectBase.get<double>(this, 'retailPrice') as double?;
  @override
  set retailPrice(double? value) =>
      RealmObjectBase.set(this, 'retailPrice', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<RealmStock>> get changes =>
      RealmObjectBase.getChanges<RealmStock>(this);

  @override
  RealmStock freeze() => RealmObjectBase.freezeObject<RealmStock>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmStock._);
    return const SchemaObject(
        ObjectType.realmObject, RealmStock, 'RealmStock', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('variantId', RealmPropertyType.string),
      SchemaProperty('lowStock', RealmPropertyType.double, optional: true),
      SchemaProperty('currentStock', RealmPropertyType.double),
      SchemaProperty('canTrackingStock', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('showLowStockAlert', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('productId', RealmPropertyType.string),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('value', RealmPropertyType.double, optional: true),
      SchemaProperty('rsdQty', RealmPropertyType.double, optional: true),
      SchemaProperty('supplyPrice', RealmPropertyType.double, optional: true),
      SchemaProperty('retailPrice', RealmPropertyType.double, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }
}
