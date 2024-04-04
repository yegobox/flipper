// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmCustomer.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmCustomer extends _RealmCustomer
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  RealmCustomer(
    String id,
    ObjectId realmId, {
    String? custNm,
    String? email,
    String? telNo,
    String? adrs,
    int? branchId,
    DateTime? updatedAt,
    String? custNo,
    String? custTin,
    String? regrNm,
    String? regrId,
    String? modrNm,
    String? modrId,
    bool ebmSynced = false,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
    String? tin,
    String? bhfId,
    String? useYn,
    String? customerType,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<RealmCustomer>({
        'ebmSynced': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'custNm', custNm);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'telNo', telNo);
    RealmObjectBase.set(this, 'adrs', adrs);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'custNo', custNo);
    RealmObjectBase.set(this, 'custTin', custTin);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'customerType', customerType);
  }

  RealmCustomer._();

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
  String? get custNm => RealmObjectBase.get<String>(this, 'custNm') as String?;
  @override
  set custNm(String? value) => RealmObjectBase.set(this, 'custNm', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get telNo => RealmObjectBase.get<String>(this, 'telNo') as String?;
  @override
  set telNo(String? value) => RealmObjectBase.set(this, 'telNo', value);

  @override
  String? get adrs => RealmObjectBase.get<String>(this, 'adrs') as String?;
  @override
  set adrs(String? value) => RealmObjectBase.set(this, 'adrs', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  String? get custNo => RealmObjectBase.get<String>(this, 'custNo') as String?;
  @override
  set custNo(String? value) => RealmObjectBase.set(this, 'custNo', value);

  @override
  String? get custTin =>
      RealmObjectBase.get<String>(this, 'custTin') as String?;
  @override
  set custTin(String? value) => RealmObjectBase.set(this, 'custTin', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
  @override
  set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get tin => RealmObjectBase.get<String>(this, 'tin') as String?;
  @override
  set tin(String? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get customerType =>
      RealmObjectBase.get<String>(this, 'customerType') as String?;
  @override
  set customerType(String? value) =>
      RealmObjectBase.set(this, 'customerType', value);

  @override
  Stream<RealmObjectChanges<RealmCustomer>> get changes =>
      RealmObjectBase.getChanges<RealmCustomer>(this);

  @override
  RealmCustomer freeze() => RealmObjectBase.freezeObject<RealmCustomer>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'custNm': custNm.toEJson(),
      'email': email.toEJson(),
      'telNo': telNo.toEJson(),
      'adrs': adrs.toEJson(),
      'branchId': branchId.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'custNo': custNo.toEJson(),
      'custTin': custTin.toEJson(),
      'regrNm': regrNm.toEJson(),
      'regrId': regrId.toEJson(),
      'modrNm': modrNm.toEJson(),
      'modrId': modrId.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'useYn': useYn.toEJson(),
      'customerType': customerType.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmCustomer value) => value.toEJson();
  static RealmCustomer _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'custNm': EJsonValue custNm,
        'email': EJsonValue email,
        'telNo': EJsonValue telNo,
        'adrs': EJsonValue adrs,
        'branchId': EJsonValue branchId,
        'updatedAt': EJsonValue updatedAt,
        'custNo': EJsonValue custNo,
        'custTin': EJsonValue custTin,
        'regrNm': EJsonValue regrNm,
        'regrId': EJsonValue regrId,
        'modrNm': EJsonValue modrNm,
        'modrId': EJsonValue modrId,
        'ebmSynced': EJsonValue ebmSynced,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'tin': EJsonValue tin,
        'bhfId': EJsonValue bhfId,
        'useYn': EJsonValue useYn,
        'customerType': EJsonValue customerType,
      } =>
        RealmCustomer(
          fromEJson(id),
          fromEJson(realmId),
          custNm: fromEJson(custNm),
          email: fromEJson(email),
          telNo: fromEJson(telNo),
          adrs: fromEJson(adrs),
          branchId: fromEJson(branchId),
          updatedAt: fromEJson(updatedAt),
          custNo: fromEJson(custNo),
          custTin: fromEJson(custTin),
          regrNm: fromEJson(regrNm),
          regrId: fromEJson(regrId),
          modrNm: fromEJson(modrNm),
          modrId: fromEJson(modrId),
          ebmSynced: fromEJson(ebmSynced),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
          tin: fromEJson(tin),
          bhfId: fromEJson(bhfId),
          useYn: fromEJson(useYn),
          customerType: fromEJson(customerType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmCustomer._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, RealmCustomer, 'RealmCustomer', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('custNm', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('telNo', RealmPropertyType.string, optional: true),
      SchemaProperty('adrs', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('custNo', RealmPropertyType.string, optional: true),
      SchemaProperty('custTin', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('tin', RealmPropertyType.string, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('customerType', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
