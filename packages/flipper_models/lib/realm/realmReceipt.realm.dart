// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmReceipt.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmReceipt extends _RealmReceipt
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmReceipt(
    ObjectId realmId,
    int branchId, {
    int? id,
    String? resultCd,
    String? resultMsg,
    String? resultDt,
    int? rcptNo,
    String? intrlData,
    String? rcptSign,
    int? totRcptNo,
    String? vsdcRcptPbctDate,
    String? sdcId,
    String? mrcNo,
    String? qrCode,
    String? receiptType,
    int? transactionId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'resultCd', resultCd);
    RealmObjectBase.set(this, 'resultMsg', resultMsg);
    RealmObjectBase.set(this, 'resultDt', resultDt);
    RealmObjectBase.set(this, 'rcptNo', rcptNo);
    RealmObjectBase.set(this, 'intrlData', intrlData);
    RealmObjectBase.set(this, 'rcptSign', rcptSign);
    RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
    RealmObjectBase.set(this, 'vsdcRcptPbctDate', vsdcRcptPbctDate);
    RealmObjectBase.set(this, 'sdcId', sdcId);
    RealmObjectBase.set(this, 'mrcNo', mrcNo);
    RealmObjectBase.set(this, 'qrCode', qrCode);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'transactionId', transactionId);
    RealmObjectBase.set(this, 'branchId', branchId);
  }

  RealmReceipt._();

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
  String? get resultCd =>
      RealmObjectBase.get<String>(this, 'resultCd') as String?;
  @override
  set resultCd(String? value) => RealmObjectBase.set(this, 'resultCd', value);

  @override
  String? get resultMsg =>
      RealmObjectBase.get<String>(this, 'resultMsg') as String?;
  @override
  set resultMsg(String? value) => RealmObjectBase.set(this, 'resultMsg', value);

  @override
  String? get resultDt =>
      RealmObjectBase.get<String>(this, 'resultDt') as String?;
  @override
  set resultDt(String? value) => RealmObjectBase.set(this, 'resultDt', value);

  @override
  int? get rcptNo => RealmObjectBase.get<int>(this, 'rcptNo') as int?;
  @override
  set rcptNo(int? value) => RealmObjectBase.set(this, 'rcptNo', value);

  @override
  String? get intrlData =>
      RealmObjectBase.get<String>(this, 'intrlData') as String?;
  @override
  set intrlData(String? value) => RealmObjectBase.set(this, 'intrlData', value);

  @override
  String? get rcptSign =>
      RealmObjectBase.get<String>(this, 'rcptSign') as String?;
  @override
  set rcptSign(String? value) => RealmObjectBase.set(this, 'rcptSign', value);

  @override
  int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
  @override
  set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

  @override
  String? get vsdcRcptPbctDate =>
      RealmObjectBase.get<String>(this, 'vsdcRcptPbctDate') as String?;
  @override
  set vsdcRcptPbctDate(String? value) =>
      RealmObjectBase.set(this, 'vsdcRcptPbctDate', value);

  @override
  String? get sdcId => RealmObjectBase.get<String>(this, 'sdcId') as String?;
  @override
  set sdcId(String? value) => RealmObjectBase.set(this, 'sdcId', value);

  @override
  String? get mrcNo => RealmObjectBase.get<String>(this, 'mrcNo') as String?;
  @override
  set mrcNo(String? value) => RealmObjectBase.set(this, 'mrcNo', value);

  @override
  String? get qrCode => RealmObjectBase.get<String>(this, 'qrCode') as String?;
  @override
  set qrCode(String? value) => RealmObjectBase.set(this, 'qrCode', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  int? get transactionId =>
      RealmObjectBase.get<int>(this, 'transactionId') as int?;
  @override
  set transactionId(int? value) =>
      RealmObjectBase.set(this, 'transactionId', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  Stream<RealmObjectChanges<RealmReceipt>> get changes =>
      RealmObjectBase.getChanges<RealmReceipt>(this);

  @override
  RealmReceipt freeze() => RealmObjectBase.freezeObject<RealmReceipt>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'resultCd': resultCd.toEJson(),
      'resultMsg': resultMsg.toEJson(),
      'resultDt': resultDt.toEJson(),
      'rcptNo': rcptNo.toEJson(),
      'intrlData': intrlData.toEJson(),
      'rcptSign': rcptSign.toEJson(),
      'totRcptNo': totRcptNo.toEJson(),
      'vsdcRcptPbctDate': vsdcRcptPbctDate.toEJson(),
      'sdcId': sdcId.toEJson(),
      'mrcNo': mrcNo.toEJson(),
      'qrCode': qrCode.toEJson(),
      'receiptType': receiptType.toEJson(),
      'transactionId': transactionId.toEJson(),
      'branchId': branchId.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmReceipt value) => value.toEJson();
  static RealmReceipt _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'resultCd': EJsonValue resultCd,
        'resultMsg': EJsonValue resultMsg,
        'resultDt': EJsonValue resultDt,
        'rcptNo': EJsonValue rcptNo,
        'intrlData': EJsonValue intrlData,
        'rcptSign': EJsonValue rcptSign,
        'totRcptNo': EJsonValue totRcptNo,
        'vsdcRcptPbctDate': EJsonValue vsdcRcptPbctDate,
        'sdcId': EJsonValue sdcId,
        'mrcNo': EJsonValue mrcNo,
        'qrCode': EJsonValue qrCode,
        'receiptType': EJsonValue receiptType,
        'transactionId': EJsonValue transactionId,
        'branchId': EJsonValue branchId,
      } =>
        RealmReceipt(
          fromEJson(realmId),
          fromEJson(branchId),
          id: fromEJson(id),
          resultCd: fromEJson(resultCd),
          resultMsg: fromEJson(resultMsg),
          resultDt: fromEJson(resultDt),
          rcptNo: fromEJson(rcptNo),
          intrlData: fromEJson(intrlData),
          rcptSign: fromEJson(rcptSign),
          totRcptNo: fromEJson(totRcptNo),
          vsdcRcptPbctDate: fromEJson(vsdcRcptPbctDate),
          sdcId: fromEJson(sdcId),
          mrcNo: fromEJson(mrcNo),
          qrCode: fromEJson(qrCode),
          receiptType: fromEJson(receiptType),
          transactionId: fromEJson(transactionId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmReceipt._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmReceipt, 'RealmReceipt', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('resultCd', RealmPropertyType.string, optional: true),
      SchemaProperty('resultMsg', RealmPropertyType.string, optional: true),
      SchemaProperty('resultDt', RealmPropertyType.string, optional: true),
      SchemaProperty('rcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('intrlData', RealmPropertyType.string, optional: true),
      SchemaProperty('rcptSign', RealmPropertyType.string, optional: true),
      SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('vsdcRcptPbctDate', RealmPropertyType.string,
          optional: true),
      SchemaProperty('sdcId', RealmPropertyType.string, optional: true),
      SchemaProperty('mrcNo', RealmPropertyType.string, optional: true),
      SchemaProperty('qrCode', RealmPropertyType.string, optional: true),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
