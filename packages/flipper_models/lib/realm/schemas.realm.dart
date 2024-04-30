// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmBranch extends _RealmBranch
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmBranch(
    ObjectId id,
    bool isDefault,
    String action, {
    bool? active,
    String? description,
    String? name,
    int? businessId,
    String? longitude,
    String? latitude,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'isDefault', isDefault);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  RealmBranch._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  String? get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String?;
  @override
  set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String? get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String?;
  @override
  set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  bool get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool;
  @override
  set isDefault(bool value) => RealmObjectBase.set(this, 'isDefault', value);

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
  Stream<RealmObjectChanges<RealmBranch>> get changes =>
      RealmObjectBase.getChanges<RealmBranch>(this);

  @override
  RealmBranch freeze() => RealmObjectBase.freezeObject<RealmBranch>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'active': active.toEJson(),
      'description': description.toEJson(),
      'name': name.toEJson(),
      'businessId': businessId.toEJson(),
      'longitude': longitude.toEJson(),
      'latitude': latitude.toEJson(),
      'isDefault': isDefault.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmBranch value) => value.toEJson();
  static RealmBranch _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'active': EJsonValue active,
        'description': EJsonValue description,
        'name': EJsonValue name,
        'businessId': EJsonValue businessId,
        'longitude': EJsonValue longitude,
        'latitude': EJsonValue latitude,
        'isDefault': EJsonValue isDefault,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
      } =>
        RealmBranch(
          fromEJson(id),
          fromEJson(isDefault),
          fromEJson(action),
          active: fromEJson(active),
          description: fromEJson(description),
          name: fromEJson(name),
          businessId: fromEJson(businessId),
          longitude: fromEJson(longitude),
          latitude: fromEJson(latitude),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmBranch._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmBranch, 'RealmBranch', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('longitude', RealmPropertyType.string, optional: true),
      SchemaProperty('latitude', RealmPropertyType.string, optional: true),
      SchemaProperty('isDefault', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
