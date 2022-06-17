// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetDrawersCollection on Isar {
  IsarCollection<Drawers> get drawerss => getCollection();
}

const DrawersSchema = CollectionSchema(
  name: 'Drawers',
  schema:
      '{"name":"Drawers","idName":"id","properties":[{"name":"cashierId","type":"Long"},{"name":"closingBalance","type":"Double"},{"name":"closingDateTime","type":"String"},{"name":"csSaleCount","type":"Long"},{"name":"incompleteSale","type":"Long"},{"name":"nrSaleCount","type":"Long"},{"name":"nsSaleCount","type":"Long"},{"name":"open","type":"Bool"},{"name":"openingBalance","type":"Double"},{"name":"openingDateTime","type":"String"},{"name":"otherTransactions","type":"Long"},{"name":"paymentMode","type":"String"},{"name":"psSaleCount","type":"Long"},{"name":"totalCsSaleIncome","type":"Double"},{"name":"totalNsSaleIncome","type":"Double"},{"name":"trSaleCount","type":"Long"},{"name":"tradeName","type":"String"}],"indexes":[{"name":"cashierId","unique":false,"replace":false,"properties":[{"name":"cashierId","type":"Value","caseSensitive":false}]},{"name":"open_cashierId","unique":false,"replace":false,"properties":[{"name":"open","type":"Value","caseSensitive":false},{"name":"cashierId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'cashierId': 0,
    'closingBalance': 1,
    'closingDateTime': 2,
    'csSaleCount': 3,
    'incompleteSale': 4,
    'nrSaleCount': 5,
    'nsSaleCount': 6,
    'open': 7,
    'openingBalance': 8,
    'openingDateTime': 9,
    'otherTransactions': 10,
    'paymentMode': 11,
    'psSaleCount': 12,
    'totalCsSaleIncome': 13,
    'totalNsSaleIncome': 14,
    'trSaleCount': 15,
    'tradeName': 16
  },
  listProperties: {},
  indexIds: {'cashierId': 0, 'open_cashierId': 1},
  indexValueTypes: {
    'cashierId': [
      IndexValueType.long,
    ],
    'open_cashierId': [
      IndexValueType.bool,
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _drawersGetId,
  setId: _drawersSetId,
  getLinks: _drawersGetLinks,
  attachLinks: _drawersAttachLinks,
  serializeNative: _drawersSerializeNative,
  deserializeNative: _drawersDeserializeNative,
  deserializePropNative: _drawersDeserializePropNative,
  serializeWeb: _drawersSerializeWeb,
  deserializeWeb: _drawersDeserializeWeb,
  deserializePropWeb: _drawersDeserializePropWeb,
  version: 4,
);

int? _drawersGetId(Drawers object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _drawersSetId(Drawers object, int id) {
  object.id = id;
}

List<IsarLinkBase> _drawersGetLinks(Drawers object) {
  return [];
}

void _drawersSerializeNative(
    IsarCollection<Drawers> collection,
    IsarCObject cObj,
    Drawers object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.cashierId;
  final _cashierId = value0;
  final value1 = object.closingBalance;
  final _closingBalance = value1;
  final value2 = object.closingDateTime;
  IsarUint8List? _closingDateTime;
  if (value2 != null) {
    _closingDateTime = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_closingDateTime?.length ?? 0) as int;
  final value3 = object.csSaleCount;
  final _csSaleCount = value3;
  final value4 = object.incompleteSale;
  final _incompleteSale = value4;
  final value5 = object.nrSaleCount;
  final _nrSaleCount = value5;
  final value6 = object.nsSaleCount;
  final _nsSaleCount = value6;
  final value7 = object.open;
  final _open = value7;
  final value8 = object.openingBalance;
  final _openingBalance = value8;
  final value9 = object.openingDateTime;
  IsarUint8List? _openingDateTime;
  if (value9 != null) {
    _openingDateTime = IsarBinaryWriter.utf8Encoder.convert(value9);
  }
  dynamicSize += (_openingDateTime?.length ?? 0) as int;
  final value10 = object.otherTransactions;
  final _otherTransactions = value10;
  final value11 = object.paymentMode;
  IsarUint8List? _paymentMode;
  if (value11 != null) {
    _paymentMode = IsarBinaryWriter.utf8Encoder.convert(value11);
  }
  dynamicSize += (_paymentMode?.length ?? 0) as int;
  final value12 = object.psSaleCount;
  final _psSaleCount = value12;
  final value13 = object.totalCsSaleIncome;
  final _totalCsSaleIncome = value13;
  final value14 = object.totalNsSaleIncome;
  final _totalNsSaleIncome = value14;
  final value15 = object.trSaleCount;
  final _trSaleCount = value15;
  final value16 = object.tradeName;
  IsarUint8List? _tradeName;
  if (value16 != null) {
    _tradeName = IsarBinaryWriter.utf8Encoder.convert(value16);
  }
  dynamicSize += (_tradeName?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _cashierId);
  writer.writeDouble(offsets[1], _closingBalance);
  writer.writeBytes(offsets[2], _closingDateTime);
  writer.writeLong(offsets[3], _csSaleCount);
  writer.writeLong(offsets[4], _incompleteSale);
  writer.writeLong(offsets[5], _nrSaleCount);
  writer.writeLong(offsets[6], _nsSaleCount);
  writer.writeBool(offsets[7], _open);
  writer.writeDouble(offsets[8], _openingBalance);
  writer.writeBytes(offsets[9], _openingDateTime);
  writer.writeLong(offsets[10], _otherTransactions);
  writer.writeBytes(offsets[11], _paymentMode);
  writer.writeLong(offsets[12], _psSaleCount);
  writer.writeDouble(offsets[13], _totalCsSaleIncome);
  writer.writeDouble(offsets[14], _totalNsSaleIncome);
  writer.writeLong(offsets[15], _trSaleCount);
  writer.writeBytes(offsets[16], _tradeName);
}

Drawers _drawersDeserializeNative(IsarCollection<Drawers> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Drawers();
  object.cashierId = reader.readLong(offsets[0]);
  object.closingBalance = reader.readDouble(offsets[1]);
  object.closingDateTime = reader.readStringOrNull(offsets[2]);
  object.csSaleCount = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.incompleteSale = reader.readLongOrNull(offsets[4]);
  object.nrSaleCount = reader.readLongOrNull(offsets[5]);
  object.nsSaleCount = reader.readLongOrNull(offsets[6]);
  object.open = reader.readBool(offsets[7]);
  object.openingBalance = reader.readDouble(offsets[8]);
  object.openingDateTime = reader.readStringOrNull(offsets[9]);
  object.otherTransactions = reader.readLongOrNull(offsets[10]);
  object.paymentMode = reader.readStringOrNull(offsets[11]);
  object.psSaleCount = reader.readLongOrNull(offsets[12]);
  object.totalCsSaleIncome = reader.readDoubleOrNull(offsets[13]);
  object.totalNsSaleIncome = reader.readDoubleOrNull(offsets[14]);
  object.trSaleCount = reader.readLongOrNull(offsets[15]);
  object.tradeName = reader.readStringOrNull(offsets[16]);
  return object;
}

P _drawersDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readDoubleOrNull(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _drawersSerializeWeb(
    IsarCollection<Drawers> collection, Drawers object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'cashierId', object.cashierId);
  IsarNative.jsObjectSet(jsObj, 'closingBalance', object.closingBalance);
  IsarNative.jsObjectSet(jsObj, 'closingDateTime', object.closingDateTime);
  IsarNative.jsObjectSet(jsObj, 'csSaleCount', object.csSaleCount);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'incompleteSale', object.incompleteSale);
  IsarNative.jsObjectSet(jsObj, 'nrSaleCount', object.nrSaleCount);
  IsarNative.jsObjectSet(jsObj, 'nsSaleCount', object.nsSaleCount);
  IsarNative.jsObjectSet(jsObj, 'open', object.open);
  IsarNative.jsObjectSet(jsObj, 'openingBalance', object.openingBalance);
  IsarNative.jsObjectSet(jsObj, 'openingDateTime', object.openingDateTime);
  IsarNative.jsObjectSet(jsObj, 'otherTransactions', object.otherTransactions);
  IsarNative.jsObjectSet(jsObj, 'paymentMode', object.paymentMode);
  IsarNative.jsObjectSet(jsObj, 'psSaleCount', object.psSaleCount);
  IsarNative.jsObjectSet(jsObj, 'totalCsSaleIncome', object.totalCsSaleIncome);
  IsarNative.jsObjectSet(jsObj, 'totalNsSaleIncome', object.totalNsSaleIncome);
  IsarNative.jsObjectSet(jsObj, 'trSaleCount', object.trSaleCount);
  IsarNative.jsObjectSet(jsObj, 'tradeName', object.tradeName);
  return jsObj;
}

Drawers _drawersDeserializeWeb(
    IsarCollection<Drawers> collection, dynamic jsObj) {
  final object = Drawers();
  object.cashierId =
      IsarNative.jsObjectGet(jsObj, 'cashierId') ?? double.negativeInfinity;
  object.closingBalance = IsarNative.jsObjectGet(jsObj, 'closingBalance') ??
      double.negativeInfinity;
  object.closingDateTime = IsarNative.jsObjectGet(jsObj, 'closingDateTime');
  object.csSaleCount = IsarNative.jsObjectGet(jsObj, 'csSaleCount');
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.incompleteSale = IsarNative.jsObjectGet(jsObj, 'incompleteSale');
  object.nrSaleCount = IsarNative.jsObjectGet(jsObj, 'nrSaleCount');
  object.nsSaleCount = IsarNative.jsObjectGet(jsObj, 'nsSaleCount');
  object.open = IsarNative.jsObjectGet(jsObj, 'open') ?? false;
  object.openingBalance = IsarNative.jsObjectGet(jsObj, 'openingBalance') ??
      double.negativeInfinity;
  object.openingDateTime = IsarNative.jsObjectGet(jsObj, 'openingDateTime');
  object.otherTransactions = IsarNative.jsObjectGet(jsObj, 'otherTransactions');
  object.paymentMode = IsarNative.jsObjectGet(jsObj, 'paymentMode');
  object.psSaleCount = IsarNative.jsObjectGet(jsObj, 'psSaleCount');
  object.totalCsSaleIncome = IsarNative.jsObjectGet(jsObj, 'totalCsSaleIncome');
  object.totalNsSaleIncome = IsarNative.jsObjectGet(jsObj, 'totalNsSaleIncome');
  object.trSaleCount = IsarNative.jsObjectGet(jsObj, 'trSaleCount');
  object.tradeName = IsarNative.jsObjectGet(jsObj, 'tradeName');
  return object;
}

P _drawersDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'cashierId':
      return (IsarNative.jsObjectGet(jsObj, 'cashierId') ??
          double.negativeInfinity) as P;
    case 'closingBalance':
      return (IsarNative.jsObjectGet(jsObj, 'closingBalance') ??
          double.negativeInfinity) as P;
    case 'closingDateTime':
      return (IsarNative.jsObjectGet(jsObj, 'closingDateTime')) as P;
    case 'csSaleCount':
      return (IsarNative.jsObjectGet(jsObj, 'csSaleCount')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'incompleteSale':
      return (IsarNative.jsObjectGet(jsObj, 'incompleteSale')) as P;
    case 'nrSaleCount':
      return (IsarNative.jsObjectGet(jsObj, 'nrSaleCount')) as P;
    case 'nsSaleCount':
      return (IsarNative.jsObjectGet(jsObj, 'nsSaleCount')) as P;
    case 'open':
      return (IsarNative.jsObjectGet(jsObj, 'open') ?? false) as P;
    case 'openingBalance':
      return (IsarNative.jsObjectGet(jsObj, 'openingBalance') ??
          double.negativeInfinity) as P;
    case 'openingDateTime':
      return (IsarNative.jsObjectGet(jsObj, 'openingDateTime')) as P;
    case 'otherTransactions':
      return (IsarNative.jsObjectGet(jsObj, 'otherTransactions')) as P;
    case 'paymentMode':
      return (IsarNative.jsObjectGet(jsObj, 'paymentMode')) as P;
    case 'psSaleCount':
      return (IsarNative.jsObjectGet(jsObj, 'psSaleCount')) as P;
    case 'totalCsSaleIncome':
      return (IsarNative.jsObjectGet(jsObj, 'totalCsSaleIncome')) as P;
    case 'totalNsSaleIncome':
      return (IsarNative.jsObjectGet(jsObj, 'totalNsSaleIncome')) as P;
    case 'trSaleCount':
      return (IsarNative.jsObjectGet(jsObj, 'trSaleCount')) as P;
    case 'tradeName':
      return (IsarNative.jsObjectGet(jsObj, 'tradeName')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _drawersAttachLinks(IsarCollection col, int id, Drawers object) {}

extension DrawersQueryWhereSort on QueryBuilder<Drawers, Drawers, QWhere> {
  QueryBuilder<Drawers, Drawers, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Drawers, Drawers, QAfterWhere> anyCashierId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'cashierId'));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhere> anyOpenCashierId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'open_cashierId'));
  }
}

extension DrawersQueryWhere on QueryBuilder<Drawers, Drawers, QWhereClause> {
  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idBetween(
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

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdEqualTo(
      int cashierId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'cashierId',
      value: [cashierId],
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdNotEqualTo(
      int cashierId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'cashierId',
        upper: [cashierId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'cashierId',
        lower: [cashierId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'cashierId',
        lower: [cashierId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'cashierId',
        upper: [cashierId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdGreaterThan(
    int cashierId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'cashierId',
      lower: [cashierId],
      includeLower: include,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdLessThan(
    int cashierId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'cashierId',
      upper: [cashierId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdBetween(
    int lowerCashierId,
    int upperCashierId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'cashierId',
      lower: [lowerCashierId],
      includeLower: includeLower,
      upper: [upperCashierId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openEqualTo(bool open) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'open_cashierId',
      value: [open],
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openNotEqualTo(bool open) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'open_cashierId',
        upper: [open],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'open_cashierId',
        lower: [open],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'open_cashierId',
        lower: [open],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'open_cashierId',
        upper: [open],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openCashierIdEqualTo(
      bool open, int cashierId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'open_cashierId',
      value: [open, cashierId],
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openCashierIdNotEqualTo(
      bool open, int cashierId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'open_cashierId',
        upper: [open, cashierId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'open_cashierId',
        lower: [open, cashierId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'open_cashierId',
        lower: [open, cashierId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'open_cashierId',
        upper: [open, cashierId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause>
      openEqualToCashierIdGreaterThan(
    bool open,
    int cashierId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'open_cashierId',
      lower: [open, cashierId],
      includeLower: include,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause>
      openEqualToCashierIdLessThan(
    bool open,
    int cashierId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'open_cashierId',
      upper: [open, cashierId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openEqualToCashierIdBetween(
    bool open,
    int lowerCashierId,
    int upperCashierId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'open_cashierId',
      lower: [open, lowerCashierId],
      includeLower: includeLower,
      upper: [open, upperCashierId],
      includeUpper: includeUpper,
    ));
  }
}

extension DrawersQueryFilter
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {
  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'cashierId',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'cashierId',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'cashierId',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'cashierId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingBalanceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'closingBalance',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'closingBalance',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'closingBalance',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'closingDateTime',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'closingDateTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'closingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'closingDateTime',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'csSaleCount',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'csSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'csSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'csSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'csSaleCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'incompleteSale',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'incompleteSale',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'incompleteSale',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'incompleteSale',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'incompleteSale',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'nrSaleCount',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'nrSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'nrSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'nrSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'nrSaleCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'nsSaleCount',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'nsSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'nsSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'nsSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'nsSaleCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'open',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingBalanceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'openingBalance',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'openingBalance',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'openingBalance',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'openingDateTime',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'openingDateTime',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'openingDateTime',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'openingDateTime',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'otherTransactions',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'otherTransactions',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'otherTransactions',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'otherTransactions',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'otherTransactions',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'paymentMode',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'paymentMode',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'paymentMode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'paymentMode',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'psSaleCount',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'psSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'psSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'psSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'psSaleCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'totalCsSaleIncome',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'totalCsSaleIncome',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeLessThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'totalCsSaleIncome',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeBetween(double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalCsSaleIncome',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'totalNsSaleIncome',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'totalNsSaleIncome',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeLessThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'totalNsSaleIncome',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeBetween(double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalNsSaleIncome',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'trSaleCount',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'trSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'trSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'trSaleCount',
      value: value,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'trSaleCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'tradeName',
      value: null,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'tradeName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'tradeName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'tradeName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension DrawersQueryLinks
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {}

extension DrawersQueryWhereSortBy on QueryBuilder<Drawers, Drawers, QSortBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierId() {
    return addSortByInternal('cashierId', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierIdDesc() {
    return addSortByInternal('cashierId', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalance() {
    return addSortByInternal('closingBalance', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalanceDesc() {
    return addSortByInternal('closingBalance', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTime() {
    return addSortByInternal('closingDateTime', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTimeDesc() {
    return addSortByInternal('closingDateTime', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCount() {
    return addSortByInternal('csSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCountDesc() {
    return addSortByInternal('csSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSale() {
    return addSortByInternal('incompleteSale', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSaleDesc() {
    return addSortByInternal('incompleteSale', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCount() {
    return addSortByInternal('nrSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCountDesc() {
    return addSortByInternal('nrSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCount() {
    return addSortByInternal('nsSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCountDesc() {
    return addSortByInternal('nsSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpen() {
    return addSortByInternal('open', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpenDesc() {
    return addSortByInternal('open', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalance() {
    return addSortByInternal('openingBalance', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalanceDesc() {
    return addSortByInternal('openingBalance', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTime() {
    return addSortByInternal('openingDateTime', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTimeDesc() {
    return addSortByInternal('openingDateTime', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactions() {
    return addSortByInternal('otherTransactions', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactionsDesc() {
    return addSortByInternal('otherTransactions', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentMode() {
    return addSortByInternal('paymentMode', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentModeDesc() {
    return addSortByInternal('paymentMode', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCount() {
    return addSortByInternal('psSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCountDesc() {
    return addSortByInternal('psSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncome() {
    return addSortByInternal('totalCsSaleIncome', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncomeDesc() {
    return addSortByInternal('totalCsSaleIncome', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncome() {
    return addSortByInternal('totalNsSaleIncome', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncomeDesc() {
    return addSortByInternal('totalNsSaleIncome', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCount() {
    return addSortByInternal('trSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCountDesc() {
    return addSortByInternal('trSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeName() {
    return addSortByInternal('tradeName', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeNameDesc() {
    return addSortByInternal('tradeName', Sort.desc);
  }
}

extension DrawersQueryWhereSortThenBy
    on QueryBuilder<Drawers, Drawers, QSortThenBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierId() {
    return addSortByInternal('cashierId', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierIdDesc() {
    return addSortByInternal('cashierId', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalance() {
    return addSortByInternal('closingBalance', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalanceDesc() {
    return addSortByInternal('closingBalance', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTime() {
    return addSortByInternal('closingDateTime', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTimeDesc() {
    return addSortByInternal('closingDateTime', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCount() {
    return addSortByInternal('csSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCountDesc() {
    return addSortByInternal('csSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSale() {
    return addSortByInternal('incompleteSale', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSaleDesc() {
    return addSortByInternal('incompleteSale', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCount() {
    return addSortByInternal('nrSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCountDesc() {
    return addSortByInternal('nrSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCount() {
    return addSortByInternal('nsSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCountDesc() {
    return addSortByInternal('nsSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpen() {
    return addSortByInternal('open', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpenDesc() {
    return addSortByInternal('open', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalance() {
    return addSortByInternal('openingBalance', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalanceDesc() {
    return addSortByInternal('openingBalance', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTime() {
    return addSortByInternal('openingDateTime', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTimeDesc() {
    return addSortByInternal('openingDateTime', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactions() {
    return addSortByInternal('otherTransactions', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactionsDesc() {
    return addSortByInternal('otherTransactions', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentMode() {
    return addSortByInternal('paymentMode', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentModeDesc() {
    return addSortByInternal('paymentMode', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCount() {
    return addSortByInternal('psSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCountDesc() {
    return addSortByInternal('psSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncome() {
    return addSortByInternal('totalCsSaleIncome', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncomeDesc() {
    return addSortByInternal('totalCsSaleIncome', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncome() {
    return addSortByInternal('totalNsSaleIncome', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncomeDesc() {
    return addSortByInternal('totalNsSaleIncome', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCount() {
    return addSortByInternal('trSaleCount', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCountDesc() {
    return addSortByInternal('trSaleCount', Sort.desc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeName() {
    return addSortByInternal('tradeName', Sort.asc);
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeNameDesc() {
    return addSortByInternal('tradeName', Sort.desc);
  }
}

extension DrawersQueryWhereDistinct
    on QueryBuilder<Drawers, Drawers, QDistinct> {
  QueryBuilder<Drawers, Drawers, QDistinct> distinctByCashierId() {
    return addDistinctByInternal('cashierId');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByClosingBalance() {
    return addDistinctByInternal('closingBalance');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByClosingDateTime(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('closingDateTime',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByCsSaleCount() {
    return addDistinctByInternal('csSaleCount');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByIncompleteSale() {
    return addDistinctByInternal('incompleteSale');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByNrSaleCount() {
    return addDistinctByInternal('nrSaleCount');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByNsSaleCount() {
    return addDistinctByInternal('nsSaleCount');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpen() {
    return addDistinctByInternal('open');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpeningBalance() {
    return addDistinctByInternal('openingBalance');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpeningDateTime(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('openingDateTime',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOtherTransactions() {
    return addDistinctByInternal('otherTransactions');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByPaymentMode(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('paymentMode', caseSensitive: caseSensitive);
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByPsSaleCount() {
    return addDistinctByInternal('psSaleCount');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTotalCsSaleIncome() {
    return addDistinctByInternal('totalCsSaleIncome');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTotalNsSaleIncome() {
    return addDistinctByInternal('totalNsSaleIncome');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTrSaleCount() {
    return addDistinctByInternal('trSaleCount');
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTradeName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('tradeName', caseSensitive: caseSensitive);
  }
}

extension DrawersQueryProperty
    on QueryBuilder<Drawers, Drawers, QQueryProperty> {
  QueryBuilder<Drawers, int, QQueryOperations> cashierIdProperty() {
    return addPropertyNameInternal('cashierId');
  }

  QueryBuilder<Drawers, double, QQueryOperations> closingBalanceProperty() {
    return addPropertyNameInternal('closingBalance');
  }

  QueryBuilder<Drawers, String?, QQueryOperations> closingDateTimeProperty() {
    return addPropertyNameInternal('closingDateTime');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> csSaleCountProperty() {
    return addPropertyNameInternal('csSaleCount');
  }

  QueryBuilder<Drawers, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> incompleteSaleProperty() {
    return addPropertyNameInternal('incompleteSale');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> nrSaleCountProperty() {
    return addPropertyNameInternal('nrSaleCount');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> nsSaleCountProperty() {
    return addPropertyNameInternal('nsSaleCount');
  }

  QueryBuilder<Drawers, bool, QQueryOperations> openProperty() {
    return addPropertyNameInternal('open');
  }

  QueryBuilder<Drawers, double, QQueryOperations> openingBalanceProperty() {
    return addPropertyNameInternal('openingBalance');
  }

  QueryBuilder<Drawers, String?, QQueryOperations> openingDateTimeProperty() {
    return addPropertyNameInternal('openingDateTime');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> otherTransactionsProperty() {
    return addPropertyNameInternal('otherTransactions');
  }

  QueryBuilder<Drawers, String?, QQueryOperations> paymentModeProperty() {
    return addPropertyNameInternal('paymentMode');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> psSaleCountProperty() {
    return addPropertyNameInternal('psSaleCount');
  }

  QueryBuilder<Drawers, double?, QQueryOperations> totalCsSaleIncomeProperty() {
    return addPropertyNameInternal('totalCsSaleIncome');
  }

  QueryBuilder<Drawers, double?, QQueryOperations> totalNsSaleIncomeProperty() {
    return addPropertyNameInternal('totalNsSaleIncome');
  }

  QueryBuilder<Drawers, int?, QQueryOperations> trSaleCountProperty() {
    return addPropertyNameInternal('trSaleCount');
  }

  QueryBuilder<Drawers, String?, QQueryOperations> tradeNameProperty() {
    return addPropertyNameInternal('tradeName');
  }
}
