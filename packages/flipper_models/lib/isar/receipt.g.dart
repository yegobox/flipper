// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetReceiptCollection on Isar {
  IsarCollection<Receipt> get receipts => collection();
}

const ReceiptSchema = CollectionSchema(
  name: r'Receipt',
  schema:
      r'{"name":"Receipt","idName":"id","properties":[{"name":"intrlData","type":"String"},{"name":"mrcNo","type":"String"},{"name":"orderId","type":"Long"},{"name":"qrCode","type":"String"},{"name":"rcptNo","type":"Long"},{"name":"rcptSign","type":"String"},{"name":"receiptType","type":"String"},{"name":"resultCd","type":"String"},{"name":"resultDt","type":"String"},{"name":"resultMsg","type":"String"},{"name":"sdcId","type":"String"},{"name":"totRcptNo","type":"Long"},{"name":"vsdcRcptPbctDate","type":"String"}],"indexes":[{"name":"orderId","unique":false,"replace":false,"properties":[{"name":"orderId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'intrlData': 0,
    r'mrcNo': 1,
    r'orderId': 2,
    r'qrCode': 3,
    r'rcptNo': 4,
    r'rcptSign': 5,
    r'receiptType': 6,
    r'resultCd': 7,
    r'resultDt': 8,
    r'resultMsg': 9,
    r'sdcId': 10,
    r'totRcptNo': 11,
    r'vsdcRcptPbctDate': 12
  },
  listProperties: {},
  indexIds: {r'orderId': 0},
  indexValueTypes: {
    r'orderId': [
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
  version: 4,
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

List<IsarLinkBase<dynamic>> _receiptGetLinks(Receipt object) {
  return [];
}

void _receiptSerializeNative(
    IsarCollection<Receipt> collection,
    IsarCObject cObj,
    Receipt object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final intrlData$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.intrlData);
  final mrcNo$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.mrcNo);
  final qrCode$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.qrCode);
  final rcptSign$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.rcptSign);
  final receiptType$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.receiptType);
  final resultCd$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.resultCd);
  final resultDt$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.resultDt);
  final resultMsg$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.resultMsg);
  final sdcId$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.sdcId);
  final vsdcRcptPbctDate$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.vsdcRcptPbctDate);
  final size = (staticSize +
      3 +
      (intrlData$Bytes.length) +
      3 +
      (mrcNo$Bytes.length) +
      3 +
      (qrCode$Bytes.length) +
      3 +
      (rcptSign$Bytes.length) +
      3 +
      (receiptType$Bytes.length) +
      3 +
      (resultCd$Bytes.length) +
      3 +
      (resultDt$Bytes.length) +
      3 +
      (resultMsg$Bytes.length) +
      3 +
      (sdcId$Bytes.length) +
      3 +
      (vsdcRcptPbctDate$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeByteList(offsets[0], intrlData$Bytes);
  writer.writeByteList(offsets[1], mrcNo$Bytes);
  writer.writeLong(offsets[2], object.orderId);
  writer.writeByteList(offsets[3], qrCode$Bytes);
  writer.writeLong(offsets[4], object.rcptNo);
  writer.writeByteList(offsets[5], rcptSign$Bytes);
  writer.writeByteList(offsets[6], receiptType$Bytes);
  writer.writeByteList(offsets[7], resultCd$Bytes);
  writer.writeByteList(offsets[8], resultDt$Bytes);
  writer.writeByteList(offsets[9], resultMsg$Bytes);
  writer.writeByteList(offsets[10], sdcId$Bytes);
  writer.writeLong(offsets[11], object.totRcptNo);
  writer.writeByteList(offsets[12], vsdcRcptPbctDate$Bytes);
}

Receipt _receiptDeserializeNative(IsarCollection<Receipt> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Receipt();
  object.id = id;
  object.intrlData = reader.readString(offsets[0]);
  object.mrcNo = reader.readString(offsets[1]);
  object.orderId = reader.readLong(offsets[2]);
  object.qrCode = reader.readString(offsets[3]);
  object.rcptNo = reader.readLong(offsets[4]);
  object.rcptSign = reader.readString(offsets[5]);
  object.receiptType = reader.readString(offsets[6]);
  object.resultCd = reader.readString(offsets[7]);
  object.resultDt = reader.readString(offsets[8]);
  object.resultMsg = reader.readString(offsets[9]);
  object.sdcId = reader.readString(offsets[10]);
  object.totRcptNo = reader.readLong(offsets[11]);
  object.vsdcRcptPbctDate = reader.readString(offsets[12]);
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _receiptSerializeWeb(
    IsarCollection<Receipt> collection, Receipt object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'intrlData', object.intrlData);
  IsarNative.jsObjectSet(jsObj, r'mrcNo', object.mrcNo);
  IsarNative.jsObjectSet(jsObj, r'orderId', object.orderId);
  IsarNative.jsObjectSet(jsObj, r'qrCode', object.qrCode);
  IsarNative.jsObjectSet(jsObj, r'rcptNo', object.rcptNo);
  IsarNative.jsObjectSet(jsObj, r'rcptSign', object.rcptSign);
  IsarNative.jsObjectSet(jsObj, r'receiptType', object.receiptType);
  IsarNative.jsObjectSet(jsObj, r'resultCd', object.resultCd);
  IsarNative.jsObjectSet(jsObj, r'resultDt', object.resultDt);
  IsarNative.jsObjectSet(jsObj, r'resultMsg', object.resultMsg);
  IsarNative.jsObjectSet(jsObj, r'sdcId', object.sdcId);
  IsarNative.jsObjectSet(jsObj, r'totRcptNo', object.totRcptNo);
  IsarNative.jsObjectSet(jsObj, r'vsdcRcptPbctDate', object.vsdcRcptPbctDate);
  return jsObj;
}

Receipt _receiptDeserializeWeb(
    IsarCollection<Receipt> collection, Object jsObj) {
  final object = Receipt();
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.intrlData = IsarNative.jsObjectGet(jsObj, r'intrlData') ?? '';
  object.mrcNo = IsarNative.jsObjectGet(jsObj, r'mrcNo') ?? '';
  object.orderId = IsarNative.jsObjectGet(jsObj, r'orderId') ??
      (double.negativeInfinity as int);
  object.qrCode = IsarNative.jsObjectGet(jsObj, r'qrCode') ?? '';
  object.rcptNo = IsarNative.jsObjectGet(jsObj, r'rcptNo') ??
      (double.negativeInfinity as int);
  object.rcptSign = IsarNative.jsObjectGet(jsObj, r'rcptSign') ?? '';
  object.receiptType = IsarNative.jsObjectGet(jsObj, r'receiptType') ?? '';
  object.resultCd = IsarNative.jsObjectGet(jsObj, r'resultCd') ?? '';
  object.resultDt = IsarNative.jsObjectGet(jsObj, r'resultDt') ?? '';
  object.resultMsg = IsarNative.jsObjectGet(jsObj, r'resultMsg') ?? '';
  object.sdcId = IsarNative.jsObjectGet(jsObj, r'sdcId') ?? '';
  object.totRcptNo = IsarNative.jsObjectGet(jsObj, r'totRcptNo') ??
      (double.negativeInfinity as int);
  object.vsdcRcptPbctDate =
      IsarNative.jsObjectGet(jsObj, r'vsdcRcptPbctDate') ?? '';
  return object;
}

P _receiptDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'intrlData':
      return (IsarNative.jsObjectGet(jsObj, r'intrlData') ?? '') as P;
    case r'mrcNo':
      return (IsarNative.jsObjectGet(jsObj, r'mrcNo') ?? '') as P;
    case r'orderId':
      return (IsarNative.jsObjectGet(jsObj, r'orderId') ??
          (double.negativeInfinity as int)) as P;
    case r'qrCode':
      return (IsarNative.jsObjectGet(jsObj, r'qrCode') ?? '') as P;
    case r'rcptNo':
      return (IsarNative.jsObjectGet(jsObj, r'rcptNo') ??
          (double.negativeInfinity as int)) as P;
    case r'rcptSign':
      return (IsarNative.jsObjectGet(jsObj, r'rcptSign') ?? '') as P;
    case r'receiptType':
      return (IsarNative.jsObjectGet(jsObj, r'receiptType') ?? '') as P;
    case r'resultCd':
      return (IsarNative.jsObjectGet(jsObj, r'resultCd') ?? '') as P;
    case r'resultDt':
      return (IsarNative.jsObjectGet(jsObj, r'resultDt') ?? '') as P;
    case r'resultMsg':
      return (IsarNative.jsObjectGet(jsObj, r'resultMsg') ?? '') as P;
    case r'sdcId':
      return (IsarNative.jsObjectGet(jsObj, r'sdcId') ?? '') as P;
    case r'totRcptNo':
      return (IsarNative.jsObjectGet(jsObj, r'totRcptNo') ??
          (double.negativeInfinity as int)) as P;
    case r'vsdcRcptPbctDate':
      return (IsarNative.jsObjectGet(jsObj, r'vsdcRcptPbctDate') ?? '') as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _receiptAttachLinks(IsarCollection<dynamic> col, int id, Receipt object) {}

extension ReceiptQueryWhereSort on QueryBuilder<Receipt, Receipt, QWhere> {
  QueryBuilder<Receipt, Receipt, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhere> anyOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'orderId'),
      );
    });
  }
}

extension ReceiptQueryWhere on QueryBuilder<Receipt, Receipt, QWhereClause> {
  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdEqualTo(
      int orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderId',
        value: [orderId],
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdNotEqualTo(
      int orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdGreaterThan(
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [orderId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdLessThan(
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [],
        upper: [orderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterWhereClause> orderIdBetween(
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [lowerOrderId],
        includeLower: includeLower,
        upper: [upperOrderId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReceiptQueryFilter
    on QueryBuilder<Receipt, Receipt, QFilterCondition> {
  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intrlData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'intrlData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> intrlDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'intrlData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mrcNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mrcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> mrcNoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mrcNo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> orderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qrCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qrCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> qrCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qrCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rcptSign',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rcptSign',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> rcptSignMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rcptSign',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> receiptTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resultCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resultCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resultDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resultDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultMsg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resultMsg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> resultMsgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resultMsg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sdcId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sdcId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> sdcIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sdcId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> totRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totRcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vsdcRcptPbctDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition>
      vsdcRcptPbctDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vsdcRcptPbctDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterFilterCondition> vsdcRcptPbctDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vsdcRcptPbctDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension ReceiptQueryLinks
    on QueryBuilder<Receipt, Receipt, QFilterCondition> {}

extension ReceiptQueryWhereSortBy on QueryBuilder<Receipt, Receipt, QSortBy> {
  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByIntrlData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intrlData', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByIntrlDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intrlData', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByMrcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrcNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByMrcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrcNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptSign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptSign', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByRcptSignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptSign', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCd', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCd', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultDt', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultDt', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultMsg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultMsg', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByResultMsgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultMsg', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortBySdcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdcId', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortBySdcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdcId', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByVsdcRcptPbctDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vsdcRcptPbctDate', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> sortByVsdcRcptPbctDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vsdcRcptPbctDate', Sort.desc);
    });
  }
}

extension ReceiptQueryWhereSortThenBy
    on QueryBuilder<Receipt, Receipt, QSortThenBy> {
  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIntrlData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intrlData', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByIntrlDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intrlData', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByMrcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrcNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByMrcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mrcNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByQrCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByQrCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrCode', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptSign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptSign', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByRcptSignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptSign', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCd', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCd', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultDt', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultDt', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultMsg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultMsg', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByResultMsgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultMsg', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenBySdcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdcId', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenBySdcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sdcId', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByVsdcRcptPbctDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vsdcRcptPbctDate', Sort.asc);
    });
  }

  QueryBuilder<Receipt, Receipt, QAfterSortBy> thenByVsdcRcptPbctDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vsdcRcptPbctDate', Sort.desc);
    });
  }
}

extension ReceiptQueryWhereDistinct
    on QueryBuilder<Receipt, Receipt, QDistinct> {
  QueryBuilder<Receipt, Receipt, QDistinct> distinctByIntrlData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intrlData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByMrcNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mrcNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId');
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByQrCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rcptNo');
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByRcptSign(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rcptSign', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByReceiptType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByResultMsg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultMsg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctBySdcId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sdcId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totRcptNo');
    });
  }

  QueryBuilder<Receipt, Receipt, QDistinct> distinctByVsdcRcptPbctDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vsdcRcptPbctDate',
          caseSensitive: caseSensitive);
    });
  }
}

extension ReceiptQueryProperty
    on QueryBuilder<Receipt, Receipt, QQueryProperty> {
  QueryBuilder<Receipt, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> intrlDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intrlData');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> mrcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mrcNo');
    });
  }

  QueryBuilder<Receipt, int, QQueryOperations> orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> qrCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrCode');
    });
  }

  QueryBuilder<Receipt, int, QQueryOperations> rcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rcptNo');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> rcptSignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rcptSign');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> receiptTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptType');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultCd');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultDt');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> resultMsgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultMsg');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> sdcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sdcId');
    });
  }

  QueryBuilder<Receipt, int, QQueryOperations> totRcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totRcptNo');
    });
  }

  QueryBuilder<Receipt, String, QQueryOperations> vsdcRcptPbctDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vsdcRcptPbctDate');
    });
  }
}
