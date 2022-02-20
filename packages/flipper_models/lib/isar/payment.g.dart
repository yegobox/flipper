// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetPaymentCollection on Isar {
  IsarCollection<Payment> get payments {
    return getCollection('Payment');
  }
}

final PaymentSchema = CollectionSchema(
  name: 'Payment',
  schema:
      '{"name":"Payment","idName":"id","properties":[{"name":"amount","type":"Long"},{"name":"createdAt","type":"Long"},{"name":"interval","type":"Long"},{"name":"itemName","type":"String"},{"name":"note","type":"String"},{"name":"paymentType","type":"String"},{"name":"phoneNumber","type":"String"},{"name":"requestGuid","type":"String"},{"name":"userId","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _PaymentNativeAdapter(),
  webAdapter: const _PaymentWebAdapter(),
  idName: 'id',
  propertyIds: {
    'amount': 0,
    'createdAt': 1,
    'interval': 2,
    'itemName': 3,
    'note': 4,
    'paymentType': 5,
    'phoneNumber': 6,
    'requestGuid': 7,
    'userId': 8
  },
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _PaymentWebAdapter extends IsarWebTypeAdapter<Payment> {
  const _PaymentWebAdapter();

  @override
  Object serialize(IsarCollection<Payment> collection, Payment object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'amount', object.amount);
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'interval', object.interval);
    IsarNative.jsObjectSet(jsObj, 'itemName', object.itemName);
    IsarNative.jsObjectSet(jsObj, 'note', object.note);
    IsarNative.jsObjectSet(jsObj, 'paymentType', object.paymentType);
    IsarNative.jsObjectSet(jsObj, 'phoneNumber', object.phoneNumber);
    IsarNative.jsObjectSet(jsObj, 'requestGuid', object.requestGuid);
    IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
    return jsObj;
  }

  @override
  Payment deserialize(IsarCollection<Payment> collection, dynamic jsObj) {
    final object = Payment(
      amount:
          IsarNative.jsObjectGet(jsObj, 'amount') ?? double.negativeInfinity,
      createdAt:
          IsarNative.jsObjectGet(jsObj, 'createdAt') ?? double.negativeInfinity,
      id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      interval:
          IsarNative.jsObjectGet(jsObj, 'interval') ?? double.negativeInfinity,
      itemName: IsarNative.jsObjectGet(jsObj, 'itemName') ?? '',
      note: IsarNative.jsObjectGet(jsObj, 'note') ?? '',
      paymentType: IsarNative.jsObjectGet(jsObj, 'paymentType') ?? '',
      phoneNumber: IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '',
      requestGuid: IsarNative.jsObjectGet(jsObj, 'requestGuid') ?? '',
      userId:
          IsarNative.jsObjectGet(jsObj, 'userId') ?? double.negativeInfinity,
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'amount':
        return (IsarNative.jsObjectGet(jsObj, 'amount') ??
            double.negativeInfinity) as P;
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt') ??
            double.negativeInfinity) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'interval':
        return (IsarNative.jsObjectGet(jsObj, 'interval') ??
            double.negativeInfinity) as P;
      case 'itemName':
        return (IsarNative.jsObjectGet(jsObj, 'itemName') ?? '') as P;
      case 'note':
        return (IsarNative.jsObjectGet(jsObj, 'note') ?? '') as P;
      case 'paymentType':
        return (IsarNative.jsObjectGet(jsObj, 'paymentType') ?? '') as P;
      case 'phoneNumber':
        return (IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '') as P;
      case 'requestGuid':
        return (IsarNative.jsObjectGet(jsObj, 'requestGuid') ?? '') as P;
      case 'userId':
        return (IsarNative.jsObjectGet(jsObj, 'userId') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Payment object) {}
}

class _PaymentNativeAdapter extends IsarNativeTypeAdapter<Payment> {
  const _PaymentNativeAdapter();

  @override
  void serialize(IsarCollection<Payment> collection, IsarRawObject rawObj,
      Payment object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.amount;
    final _amount = value0;
    final value1 = object.createdAt;
    final _createdAt = value1;
    final value2 = object.interval;
    final _interval = value2;
    final value3 = object.itemName;
    final _itemName = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_itemName.length) as int;
    final value4 = object.note;
    final _note = IsarBinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += (_note.length) as int;
    final value5 = object.paymentType;
    final _paymentType = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_paymentType.length) as int;
    final value6 = object.phoneNumber;
    final _phoneNumber = IsarBinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += (_phoneNumber.length) as int;
    final value7 = object.requestGuid;
    final _requestGuid = IsarBinaryWriter.utf8Encoder.convert(value7);
    dynamicSize += (_requestGuid.length) as int;
    final value8 = object.userId;
    final _userId = value8;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeLong(offsets[0], _amount);
    writer.writeLong(offsets[1], _createdAt);
    writer.writeLong(offsets[2], _interval);
    writer.writeBytes(offsets[3], _itemName);
    writer.writeBytes(offsets[4], _note);
    writer.writeBytes(offsets[5], _paymentType);
    writer.writeBytes(offsets[6], _phoneNumber);
    writer.writeBytes(offsets[7], _requestGuid);
    writer.writeLong(offsets[8], _userId);
  }

  @override
  Payment deserialize(IsarCollection<Payment> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Payment(
      amount: reader.readLong(offsets[0]),
      createdAt: reader.readLong(offsets[1]),
      id: id,
      interval: reader.readLong(offsets[2]),
      itemName: reader.readString(offsets[3]),
      note: reader.readString(offsets[4]),
      paymentType: reader.readString(offsets[5]),
      phoneNumber: reader.readString(offsets[6]),
      requestGuid: reader.readString(offsets[7]),
      userId: reader.readLong(offsets[8]),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      case 7:
        return (reader.readString(offset)) as P;
      case 8:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Payment object) {}
}

extension PaymentQueryWhereSort on QueryBuilder<Payment, Payment, QWhere> {
  QueryBuilder<Payment, Payment, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension PaymentQueryWhere on QueryBuilder<Payment, Payment, QWhereClause> {
  QueryBuilder<Payment, Payment, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Payment, Payment, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension PaymentQueryFilter
    on QueryBuilder<Payment, Payment, QFilterCondition> {
  QueryBuilder<Payment, Payment, QAfterFilterCondition> amountEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> amountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> amountLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> amountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'amount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> createdAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Payment, Payment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Payment, Payment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Payment, Payment, QAfterFilterCondition> intervalEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'interval',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'itemName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'itemName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> itemNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'itemName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'note',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'note',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'paymentType',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> paymentTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'paymentType',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'phoneNumber',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> phoneNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'phoneNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'requestGuid',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'requestGuid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> requestGuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'requestGuid',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Payment, Payment, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension PaymentQueryWhereSortBy on QueryBuilder<Payment, Payment, QSortBy> {
  QueryBuilder<Payment, Payment, QAfterSortBy> sortByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByItemName() {
    return addSortByInternal('itemName', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByItemNameDesc() {
    return addSortByInternal('itemName', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByRequestGuid() {
    return addSortByInternal('requestGuid', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByRequestGuidDesc() {
    return addSortByInternal('requestGuid', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension PaymentQueryWhereSortThenBy
    on QueryBuilder<Payment, Payment, QSortThenBy> {
  QueryBuilder<Payment, Payment, QAfterSortBy> thenByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByItemName() {
    return addSortByInternal('itemName', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByItemNameDesc() {
    return addSortByInternal('itemName', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByRequestGuid() {
    return addSortByInternal('requestGuid', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByRequestGuidDesc() {
    return addSortByInternal('requestGuid', Sort.desc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Payment, Payment, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension PaymentQueryWhereDistinct
    on QueryBuilder<Payment, Payment, QDistinct> {
  QueryBuilder<Payment, Payment, QDistinct> distinctByAmount() {
    return addDistinctByInternal('amount');
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByCreatedAt() {
    return addDistinctByInternal('createdAt');
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByInterval() {
    return addDistinctByInternal('interval');
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByItemName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('itemName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('note', caseSensitive: caseSensitive);
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByPaymentType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('paymentType', caseSensitive: caseSensitive);
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByPhoneNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('phoneNumber', caseSensitive: caseSensitive);
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByRequestGuid(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('requestGuid', caseSensitive: caseSensitive);
  }

  QueryBuilder<Payment, Payment, QDistinct> distinctByUserId() {
    return addDistinctByInternal('userId');
  }
}

extension PaymentQueryProperty
    on QueryBuilder<Payment, Payment, QQueryProperty> {
  QueryBuilder<Payment, int, QQueryOperations> amountProperty() {
    return addPropertyNameInternal('amount');
  }

  QueryBuilder<Payment, int, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Payment, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Payment, int, QQueryOperations> intervalProperty() {
    return addPropertyNameInternal('interval');
  }

  QueryBuilder<Payment, String, QQueryOperations> itemNameProperty() {
    return addPropertyNameInternal('itemName');
  }

  QueryBuilder<Payment, String, QQueryOperations> noteProperty() {
    return addPropertyNameInternal('note');
  }

  QueryBuilder<Payment, String, QQueryOperations> paymentTypeProperty() {
    return addPropertyNameInternal('paymentType');
  }

  QueryBuilder<Payment, String, QQueryOperations> phoneNumberProperty() {
    return addPropertyNameInternal('phoneNumber');
  }

  QueryBuilder<Payment, String, QQueryOperations> requestGuidProperty() {
    return addPropertyNameInternal('requestGuid');
  }

  QueryBuilder<Payment, int, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
