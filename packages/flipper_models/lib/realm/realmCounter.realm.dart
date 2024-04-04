// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmCounter.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmCounter extends _RealmCounter
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmCounter(
    ObjectId realmId, {
    int? id,
    int? businessId,
    int? branchId,
    String? receiptType,
    int? totRcptNo,
    int? curRcptNo,
    DateTime? lastTouched,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
    RealmObjectBase.set(this, 'curRcptNo', curRcptNo);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
  }

  RealmCounter._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
  @override
  set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

  @override
  int? get curRcptNo => RealmObjectBase.get<int>(this, 'curRcptNo') as int?;
  @override
  set curRcptNo(int? value) => RealmObjectBase.set(this, 'curRcptNo', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  Stream<RealmObjectChanges<RealmCounter>> get changes =>
      RealmObjectBase.getChanges<RealmCounter>(this);

  @override
  RealmCounter freeze() => RealmObjectBase.freezeObject<RealmCounter>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
      'receiptType': receiptType.toEJson(),
      'totRcptNo': totRcptNo.toEJson(),
      'curRcptNo': curRcptNo.toEJson(),
      'lastTouched': lastTouched.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmCounter value) => value.toEJson();
  static RealmCounter _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
        'receiptType': EJsonValue receiptType,
        'totRcptNo': EJsonValue totRcptNo,
        'curRcptNo': EJsonValue curRcptNo,
        'lastTouched': EJsonValue lastTouched,
      } =>
        RealmCounter(
          fromEJson(realmId),
          id: fromEJson(id),
          businessId: fromEJson(businessId),
          branchId: fromEJson(branchId),
          receiptType: fromEJson(receiptType),
          totRcptNo: fromEJson(totRcptNo),
          curRcptNo: fromEJson(curRcptNo),
          lastTouched: fromEJson(lastTouched),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmCounter._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmCounter, 'RealmCounter', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('curRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
