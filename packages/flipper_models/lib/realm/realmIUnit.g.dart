// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmIUnit.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmIUnit extends _RealmIUnit
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmIUnit(
    ObjectId realmId,
    String id,
    int branchId,
    String name,
    String value,
    bool active,
  ) {
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'active', active);
  }

  RealmIUnit._();

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get value => RealmObjectBase.get<String>(this, 'value') as String;
  @override
  set value(String value) => RealmObjectBase.set(this, 'value', value);

  @override
  bool get active => RealmObjectBase.get<bool>(this, 'active') as bool;
  @override
  set active(bool value) => RealmObjectBase.set(this, 'active', value);

  @override
  Stream<RealmObjectChanges<RealmIUnit>> get changes =>
      RealmObjectBase.getChanges<RealmIUnit>(this);

  @override
  RealmIUnit freeze() => RealmObjectBase.freezeObject<RealmIUnit>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmIUnit._);
    return const SchemaObject(
        ObjectType.realmObject, RealmIUnit, 'RealmIUnit', [
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('value', RealmPropertyType.string),
      SchemaProperty('active', RealmPropertyType.bool),
    ]);
  }
}
