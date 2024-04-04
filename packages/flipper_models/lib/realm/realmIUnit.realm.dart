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

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': realmId.toEJson(),
      'id': id.toEJson(),
      'branchId': branchId.toEJson(),
      'name': name.toEJson(),
      'value': value.toEJson(),
      'active': active.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmIUnit value) => value.toEJson();
  static RealmIUnit _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue realmId,
        'id': EJsonValue id,
        'branchId': EJsonValue branchId,
        'name': EJsonValue name,
        'value': EJsonValue value,
        'active': EJsonValue active,
      } =>
        RealmIUnit(
          fromEJson(realmId),
          fromEJson(id),
          fromEJson(branchId),
          fromEJson(name),
          fromEJson(value),
          fromEJson(active),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmIUnit._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmIUnit, 'RealmIUnit', [
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('value', RealmPropertyType.string),
      SchemaProperty('active', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
