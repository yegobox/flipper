// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_realm_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class StockRealm extends _StockRealm
    with RealmEntity, RealmObjectBase, RealmObject {
  StockRealm(
    String id, {
    int? tin,
    String? bhfId,
    int? branchId,
    double? currentStock,
    double? lowStock,
    bool? canTrackingStock,
    bool? showLowStockAlert,
    bool? active,
    double? value,
    double? rsdQty,
    String? lastTouched,
    bool? ebmSynced,
    double? initialStock,
    String? variantId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'currentStock', currentStock);
    RealmObjectBase.set(this, 'lowStock', lowStock);
    RealmObjectBase.set(this, 'canTrackingStock', canTrackingStock);
    RealmObjectBase.set(this, 'showLowStockAlert', showLowStockAlert);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'rsdQty', rsdQty);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
    RealmObjectBase.set(this, 'initialStock', initialStock);
    RealmObjectBase.set(this, 'variantId', variantId);
  }

  StockRealm._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  double? get currentStock =>
      RealmObjectBase.get<double>(this, 'currentStock') as double?;
  @override
  set currentStock(double? value) =>
      RealmObjectBase.set(this, 'currentStock', value);

  @override
  double? get lowStock =>
      RealmObjectBase.get<double>(this, 'lowStock') as double?;
  @override
  set lowStock(double? value) => RealmObjectBase.set(this, 'lowStock', value);

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
  String? get lastTouched =>
      RealmObjectBase.get<String>(this, 'lastTouched') as String?;
  @override
  set lastTouched(String? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  bool? get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool?;
  @override
  set ebmSynced(bool? value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  double? get initialStock =>
      RealmObjectBase.get<double>(this, 'initialStock') as double?;
  @override
  set initialStock(double? value) =>
      RealmObjectBase.set(this, 'initialStock', value);

  @override
  String? get variantId =>
      RealmObjectBase.get<String>(this, 'variantId') as String?;
  @override
  set variantId(String? value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  Stream<RealmObjectChanges<StockRealm>> get changes =>
      RealmObjectBase.getChanges<StockRealm>(this);

  @override
  Stream<RealmObjectChanges<StockRealm>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<StockRealm>(this, keyPaths);

  @override
  StockRealm freeze() => RealmObjectBase.freezeObject<StockRealm>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'branchId': branchId.toEJson(),
      'currentStock': currentStock.toEJson(),
      'lowStock': lowStock.toEJson(),
      'canTrackingStock': canTrackingStock.toEJson(),
      'showLowStockAlert': showLowStockAlert.toEJson(),
      'active': active.toEJson(),
      'value': value.toEJson(),
      'rsdQty': rsdQty.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
      'initialStock': initialStock.toEJson(),
      'variantId': variantId.toEJson(),
    };
  }

  static EJsonValue _toEJson(StockRealm value) => value.toEJson();
  static StockRealm _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
      } =>
        StockRealm(
          fromEJson(id),
          tin: fromEJson(ejson['tin']),
          bhfId: fromEJson(ejson['bhfId']),
          branchId: fromEJson(ejson['branchId']),
          currentStock: fromEJson(ejson['currentStock']),
          lowStock: fromEJson(ejson['lowStock']),
          canTrackingStock: fromEJson(ejson['canTrackingStock']),
          showLowStockAlert: fromEJson(ejson['showLowStockAlert']),
          active: fromEJson(ejson['active']),
          value: fromEJson(ejson['value']),
          rsdQty: fromEJson(ejson['rsdQty']),
          lastTouched: fromEJson(ejson['lastTouched']),
          ebmSynced: fromEJson(ejson['ebmSynced']),
          initialStock: fromEJson(ejson['initialStock']),
          variantId: fromEJson(ejson['variantId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(StockRealm._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, StockRealm, 'StockRealm', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('currentStock', RealmPropertyType.double, optional: true),
      SchemaProperty('lowStock', RealmPropertyType.double, optional: true),
      SchemaProperty('canTrackingStock', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('showLowStockAlert', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('value', RealmPropertyType.double, optional: true),
      SchemaProperty('rsdQty', RealmPropertyType.double, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.string, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool, optional: true),
      SchemaProperty('initialStock', RealmPropertyType.double, optional: true),
      SchemaProperty('variantId', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
