// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetReceiptCollection on Isar {
  IsarCollection<Receipt> get receipts => getCollection();
}

const ReceiptSchema = CollectionSchema(
  name: 'Receipt',
  schema:
      '{"name":"Receipt","idName":"id","properties":[{"name":"intrlData","type":"String"},{"name":"mrcNo","type":"String"},{"name":"orderId","type":"Long"},{"name":"rcptNo","type":"Long"},{"name":"rcptSign","type":"String"},{"name":"resultCd","type":"String"},{"name":"resultDt","type":"String"},{"name":"resultMsg","type":"String"},{"name":"sdcId","type":"String"},{"name":"totRcptNo","type":"Long"},{"name":"vsdcRcptPbctDate","type":"String"}],"indexes":[{"name":"orderId","unique":false,"properties":[{"name":"orderId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'intrlData': 0,
    'mrcNo': 1,
    'orderId': 2,
    'rcptNo': 3,
    'rcptSign': 4,
    'resultCd': 5,
    'resultDt': 6,
    'resultMsg': 7,
    'sdcId': 8,
    'totRcptNo': 9,
    'vsdcRcptPbctDate': 10
  },
  listProperties: {},
  indexIds: {'orderId': 0},
  indexValueTypes: {
    'orderId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _receiptGetId,
  setId: _receiptSetId,
  getLinks: _receiptGetLinks,
  attachLinks: _receiptAttachLinks,
  serializeNative: _receiptSerializeNative,
  deserializeNative: _receiptDeserializeNative,
  deserializePropNative: _receiptDeserializePropNative,
  serializeWeb: _receiptSerializeWeb,
  deserializeWeb: _receiptDeserializeWeb,
  deserializePropWeb: _receiptDeserializePropWeb,
  version: 3,
);

int? _receiptGetId(Receipt object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _receiptSetId(Receipt object, int id) {
  object.id = id;
}

List<IsarLinkBase> _receiptGetLinks(Receipt object) {
  return [];
}

void _receiptSerializeNative(
    IsarCollection<Receipt> collection,
    IsarRawObject rawObj,
    Receipt object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.intrlData;
  final _intrlData = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_intrlData.length) as int;
  final value1 = object.mrcNo;
  final _mrcNo = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_mrcNo.length) as int;
  final value2 = object.orderId;
  final _orderId = value2;
  final value3 = object.rcptNo;
  final _rcptNo = value3;
  final value4 = object.rcptSign;
  final _rcptSign = IsarBinaryWriter.utf8Encoder.convert(value4);
  dynamicSize += (_rcptSign.length) as int;
  final value5 = object.resultCd;
  final _resultCd = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_resultCd.length) as int;
  final value6 = object.resultDt;
  final _resultDt = IsarBinaryWriter.utf8Encoder.convert(value6);
  dynamicSize += (_resultDt.length) as int;
  final value7 = object.resultMsg;
  final _resultMsg = IsarBinaryWriter.utf8Encoder.convert(value7);
  dynamicSize += (_resultMsg.length) as int;
  final value8 = object.sdcId;
  final _sdcId = IsarBinaryWriter.utf8Encoder.convert(value8);
  dynamicSize += (_sdcId.length) as int;
  final value9 = object.totRcptNo;
  final _totRcptNo = value9;
  final value10 = object.vsdcRcptPbctDate;
  final _vsdcRcptPbctDate = IsarBinaryWriter.utf8Encoder.convert(value10);
  dynamicSize += (_vsdcRcptPbctDate.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _intrlData);
  writer.writeBytes(offsets[1], _mrcNo);
  writer.writeLong(offsets[2], _orderId);
  writer.writeLong(offsets[3], _rcptNo);
  writer.writeBytes(offsets[4], _rcptSign);
  writer.writeBytes(offsets[5], _resultCd);
  writer.writeBytes(offsets[6], _resultDt);
  writer.writeBytes(offsets[7], _resultMsg);
  writer.writeBytes(offsets[8], _sdcId);
  writer.writeLong(offsets[9], _totRcptNo);
  writer.writeBytes(offsets[10], _vsdcRcptPbctDate);
}

Receipt _receiptDeserializeNative(IsarCollection<Receipt> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Receipt();
  object.id = id;
  object.intrlData = reader.readString(offsets[0]);
  object.mrcNo = reader.readString(offsets[1]);
  object.orderId = reader.readLong(offsets[2]);
  object.rcptNo = reader.readLong(offsets[3]);
  object.rcptSign = reader.readString(offsets[4]);
  object.resultCd = reader.readString(offsets[5]);
  object.resultDt = reader.readString(offsets[6]);
  object.resultMsg = reader.readString(offsets[7]);
  object.sdcId = reader.readString(offsets[8]);
  object.totRcptNo = reader.readLong(offsets[9]);
  object.vsdcRcptPbctDate = reader.readString(offsets[10]);
  return object;
}

P _receiptDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _receiptSerializeWeb(
    IsarCollection<Receipt> collection, Receipt object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'intrlData', object.intrlData);
  IsarNative.jsObjectSet(jsObj, 'mrcNo', object.mrcNo);
  IsarNative.jsObjectSet(jsObj, 'orderId', object.orderId);
  IsarNative.jsObjectSet(jsObj, 'rcptNo', object.rcptNo);
  IsarNative.jsObjectSet(jsObj, 'rcptSign', object.rcptSign);
  IsarNative.jsObjectSet(jsObj, 'resultCd', object.resultCd);
  IsarNative.jsObjectSet(jsObj, 'resultDt', object.resultDt);
  IsarNative.jsObjectSet(jsObj, 'resultMsg', object.resultMsg);
  IsarNative.jsObjectSet(jsObj, 'sdcId', object.sdcId);
  IsarNative.jsObjectSet(jsObj, 'totRcptNo', object.totRcptNo);
  IsarNative.jsObjectSet(jsObj, 'vsdcRcptPbctDate', object.vsdcRcptPbctDate);
  return jsObj;
}

Receipt _receiptDeserializeWeb(
    IsarCollection<Receipt> collection, dynamic jsObj) {
  final object = Receipt();
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.intrlData = IsarNative.jsObjectGet(jsObj, 'intrlData') ?? '';
  object.mrcNo = IsarNative.jsObjectGet(jsObj, 'mrcNo') ?? '';
  object.orderId =
      IsarNative.jsObjectGet(jsObj, 'orderId') ?? double.negativeInfinity;
  object.rcptNo =
      IsarNative.jsObjectGet(jsObj, 'rcptNo') ?? double.negativeInfinity;
  object.rcptSign = IsarNative.jsObjectGet(jsObj, 'rcptSign') ?? '';
  object.resultCd = IsarNative.jsObjectGet(jsObj, 'resultCd') ?? '';
  object.resultDt = IsarNative.jsObjectGet(jsObj, 'resultDt') ?? '';
  object.resultMsg = IsarNative.jsObjectGet(jsObj, 'resultMsg') ?? '';
  object.sdcId = IsarNative.jsObjectGet(jsObj, 'sdcId') ?? '';
  object.totRcptNo =
      IsarNative.jsObjectGet(jsObj, 'totRcptNo') ?? double.negativeInfinity;
  object.vsdcRcptPbctDate =
      IsarNative.jsObjectGet(jsObj, 'vsdcRcptPbctDate') ?? '';
  return object;
}

P _receiptDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'intrlData':
      return (IsarNative.jsObjectGet(jsObj, 'intrlData') ?? '') as P;
    case 'mrcNo':
      return (IsarNative.jsObjectGet(jsObj, 'mrcNo') ?? '') as P;
    case 'orderId':
      return (IsarNative.jsObjectGet(jsObj, 'orderId') ??
          double.negativeInfinity) as P;
    case 'rcptNo':
      return (IsarNative.jsObjectGet(jsObj, 'rcptNo') ??
          double.negativeInfinity) as P;
    case 'rcptSign':
      return (IsarNative.jsObjectGet(jsObj, 'rcptSign') ?? '') as P;
    case 'resultCd':
      return (IsarNative.jsObjectGet(jsObj, 'resultCd') ?? '') as P;
    case 'resultDt':
      return (IsarNative.jsObjectGet(jsObj, 'resultDt') ?? '') as P;
    case 'resultMsg':
      return (IsarNative.jsObjectGet(jsObj, 'resultMsg') ?? '') as P;
    case 'sdcId':
      return (IsarNative.jsObjectGet(jsObj, 'sdcId') ?? '') as P;
    case 'totRcptNo':
      return (IsarNative.jsObjectGet(jsObj, 'totRcptNo') ??
          double.negativeInfinity) as P;
    case 'vsdcRcptPbctDate':
      return (IsarNative.jsObjectGet(jsObj, 'vsdcRcptPbctDate') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _receiptAttachLinks(IsarCollection col, int id, Receipt object) {}

extension ReceiptQueryWhereSort on QueryBuilder<Receipt, Receipt, QWhere> {
  QueryBuilder<Receipt, Receipt, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Receipt, Receipt, QAfterWhere> anyOrderId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'orderId'));
  }
}

extension ReceiptQueryWhere on QueryBuilder<Receipt, Receipt, QWhereClause> {
  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdEqualTo(
      int orderId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'orderId',
      value: [orderId],
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdNotEqualTo(
      int orderId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'orderId',
        upper: [orderId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'orderId',
        lower: [orderId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'orderId',
        lower: [orderId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'orderId',
        upper: [orderId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdGreaterThan(
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'orderId',
      lower: [orderId],
      includeLower: include,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdLessThan(
    int orderId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'orderId',
      upper: [orderId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdBetween(
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'orderId',
      lower: [lowerOrderId],
      includeLower: includeLower,
      upper: [upperOrderId],
      includeUpper: includeUpper,
    ));
  }
}

extension ReceiptQueryFilter
    on QueryBuilder<Receipt, Receipt, QFilterCondition> {
  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'intrlData',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'intrlData',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'intrlData',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'mrcNo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'mrcNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'mrcNo',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orderId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'rcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'rcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'rcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'rcptNo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'rcptSign',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'rcptSign',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'rcptSign',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'resultCd',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'resultCd',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'resultCd',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'resultDt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'resultDt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'resultDt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'resultMsg',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'resultMsg',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'resultMsg',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sdcId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'sdcId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'sdcId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'totRcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'totRcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'totRcptNo',
      value: value,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totRcptNo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'vsdcRcptPbctDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'vsdcRcptPbctDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'vsdcRcptPbctDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension ReceiptQueryLinks
    on QueryBuilder<Receipt, Receipt, QFilterCondition> {}

extension ReceiptQueryWhereSortBy on QueryBuilder<Receipt, Receipt, QSortBy> {
  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByIntrlData() {
    return addSortByInternal('intrlData', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByIntrlDataDesc() {
    return addSortByInternal('intrlData', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByMrcNo() {
    return addSortByInternal('mrcNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByMrcNoDesc() {
    return addSortByInternal('mrcNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptNo() {
    return addSortByInternal('rcptNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptNoDesc() {
    return addSortByInternal('rcptNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptSign() {
    return addSortByInternal('rcptSign', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptSignDesc() {
    return addSortByInternal('rcptSign', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultCd() {
    return addSortByInternal('resultCd', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultCdDesc() {
    return addSortByInternal('resultCd', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultDt() {
    return addSortByInternal('resultDt', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultDtDesc() {
    return addSortByInternal('resultDt', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultMsg() {
    return addSortByInternal('resultMsg', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultMsgDesc() {
    return addSortByInternal('resultMsg', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortBySdcId() {
    return addSortByInternal('sdcId', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortBySdcIdDesc() {
    return addSortByInternal('sdcId', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByTotRcptNo() {
    return addSortByInternal('totRcptNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByTotRcptNoDesc() {
    return addSortByInternal('totRcptNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByVsdcRcptPbctDate() {
    return addSortByInternal('vsdcRcptPbctDate', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByVsdcRcptPbctDateDesc() {
    return addSortByInternal('vsdcRcptPbctDate', Sort.desc);
  }
}

extension ReceiptQueryWhereSortThenBy
    on QueryBuilder<Receipt, Receipt, QSortThenBy> {
  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIntrlData() {
    return addSortByInternal('intrlData', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIntrlDataDesc() {
    return addSortByInternal('intrlData', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByMrcNo() {
    return addSortByInternal('mrcNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByMrcNoDesc() {
    return addSortByInternal('mrcNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptNo() {
    return addSortByInternal('rcptNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptNoDesc() {
    return addSortByInternal('rcptNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptSign() {
    return addSortByInternal('rcptSign', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptSignDesc() {
    return addSortByInternal('rcptSign', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultCd() {
    return addSortByInternal('resultCd', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultCdDesc() {
    return addSortByInternal('resultCd', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultDt() {
    return addSortByInternal('resultDt', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultDtDesc() {
    return addSortByInternal('resultDt', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultMsg() {
    return addSortByInternal('resultMsg', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultMsgDesc() {
    return addSortByInternal('resultMsg', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenBySdcId() {
    return addSortByInternal('sdcId', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenBySdcIdDesc() {
    return addSortByInternal('sdcId', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByTotRcptNo() {
    return addSortByInternal('totRcptNo', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByTotRcptNoDesc() {
    return addSortByInternal('totRcptNo', Sort.desc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByVsdcRcptPbctDate() {
    return addSortByInternal('vsdcRcptPbctDate', Sort.asc);
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByVsdcRcptPbctDateDesc() {
    return addSortByInternal('vsdcRcptPbctDate', Sort.desc);
  }
}

extension ReceiptQueryWhereDistinct
    on QueryBuilder<Receipt, Receipt, QDistinct> {
  QueryBuilder<Receipt, Receipt, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByIntrlData(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('intrlData', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByMrcNo(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('mrcNo', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByOrderId() {
    return addDistinctByInternal('orderId');
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByRcptNo() {
    return addDistinctByInternal('rcptNo');
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByRcptSign(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('rcptSign', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultCd(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('resultCd', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultDt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('resultDt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultMsg(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('resultMsg', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctBySdcId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('sdcId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByTotRcptNo() {
    return addDistinctByInternal('totRcptNo');
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByVsdcRcptPbctDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('vsdcRcptPbctDate',
        caseSensitive: caseSensitive);
  }
}

extension ReceiptQueryProperty
    on QueryBuilder<Receipt, Receipt, QQueryProperty> {
  QueryBuilder<Receipt, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Receipt, String, QQueryOperations> intrlDataProperty() {
    return addPropertyNameInternal('intrlData');
  }

  QueryBuilder<Receipt, String, QQueryOperations> mrcNoProperty() {
    return addPropertyNameInternal('mrcNo');
  }

  QueryBuilder<Receipt, int, QQueryOperations> orderIdProperty() {
    return addPropertyNameInternal('orderId');
  }

  QueryBuilder<Receipt, int, QQueryOperations> rcptNoProperty() {
    return addPropertyNameInternal('rcptNo');
  }

  QueryBuilder<Receipt, String, QQueryOperations> rcptSignProperty() {
    return addPropertyNameInternal('rcptSign');
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultCdProperty() {
    return addPropertyNameInternal('resultCd');
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultDtProperty() {
    return addPropertyNameInternal('resultDt');
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultMsgProperty() {
    return addPropertyNameInternal('resultMsg');
  }

  QueryBuilder<Receipt, String, QQueryOperations> sdcIdProperty() {
    return addPropertyNameInternal('sdcId');
  }

  QueryBuilder<Receipt, int, QQueryOperations> totRcptNoProperty() {
    return addPropertyNameInternal('totRcptNo');
  }

  QueryBuilder<Receipt, String, QQueryOperations> vsdcRcptPbctDateProperty() {
    return addPropertyNameInternal('vsdcRcptPbctDate');
  }
}
