// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetOrderItemSyncCollection on Isar {
  IsarCollection<OrderItemSync> get orderItemSyncs {
    return getCollection('OrderItemSync');
  }
}

final OrderItemSyncSchema = CollectionSchema(
  name: 'OrderItemSync',
  schema:
      '{"name":"OrderItemSync","idName":"id","properties":[{"name":"count","type":"Double"},{"name":"createdAt","type":"String"},{"name":"discount","type":"Double"},{"name":"name","type":"String"},{"name":"orderId","type":"Long"},{"name":"price","type":"Double"},{"name":"remainingStock","type":"Double"},{"name":"reported","type":"Bool"},{"name":"type","type":"String"},{"name":"updatedAt","type":"String"},{"name":"variantId","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _OrderItemSyncNativeAdapter(),
  webAdapter: const _OrderItemSyncWebAdapter(),
  idName: 'id',
  propertyIds: {
    'count': 0,
    'createdAt': 1,
    'discount': 2,
    'name': 3,
    'orderId': 4,
    'price': 5,
    'remainingStock': 6,
    'reported': 7,
    'type': 8,
    'updatedAt': 9,
    'variantId': 10
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

class _OrderItemSyncWebAdapter extends IsarWebTypeAdapter<OrderItemSync> {
  const _OrderItemSyncWebAdapter();

  @override
  Object serialize(
      IsarCollection<OrderItemSync> collection, OrderItemSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'count', object.count);
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'discount', object.discount);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'orderId', object.orderId);
    IsarNative.jsObjectSet(jsObj, 'price', object.price);
    IsarNative.jsObjectSet(jsObj, 'remainingStock', object.remainingStock);
    IsarNative.jsObjectSet(jsObj, 'reported', object.reported);
    IsarNative.jsObjectSet(jsObj, 'type', object.type);
    IsarNative.jsObjectSet(jsObj, 'updatedAt', object.updatedAt);
    IsarNative.jsObjectSet(jsObj, 'variantId', object.variantId);
    return jsObj;
  }

  @override
  OrderItemSync deserialize(
      IsarCollection<OrderItemSync> collection, dynamic jsObj) {
    final object = OrderItemSync();
    object.count =
        IsarNative.jsObjectGet(jsObj, 'count') ?? double.negativeInfinity;
    object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '';
    object.discount = IsarNative.jsObjectGet(jsObj, 'discount');
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
    object.orderId =
        IsarNative.jsObjectGet(jsObj, 'orderId') ?? double.negativeInfinity;
    object.price =
        IsarNative.jsObjectGet(jsObj, 'price') ?? double.negativeInfinity;
    object.remainingStock = IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
        double.negativeInfinity;
    object.reported = IsarNative.jsObjectGet(jsObj, 'reported') ?? false;
    object.type = IsarNative.jsObjectGet(jsObj, 'type');
    object.updatedAt = IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '';
    object.variantId =
        IsarNative.jsObjectGet(jsObj, 'variantId') ?? double.negativeInfinity;
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'count':
        return (IsarNative.jsObjectGet(jsObj, 'count') ??
            double.negativeInfinity) as P;
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '') as P;
      case 'discount':
        return (IsarNative.jsObjectGet(jsObj, 'discount')) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'orderId':
        return (IsarNative.jsObjectGet(jsObj, 'orderId') ??
            double.negativeInfinity) as P;
      case 'price':
        return (IsarNative.jsObjectGet(jsObj, 'price') ??
            double.negativeInfinity) as P;
      case 'remainingStock':
        return (IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
            double.negativeInfinity) as P;
      case 'reported':
        return (IsarNative.jsObjectGet(jsObj, 'reported') ?? false) as P;
      case 'type':
        return (IsarNative.jsObjectGet(jsObj, 'type')) as P;
      case 'updatedAt':
        return (IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '') as P;
      case 'variantId':
        return (IsarNative.jsObjectGet(jsObj, 'variantId') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, OrderItemSync object) {}
}

class _OrderItemSyncNativeAdapter extends IsarNativeTypeAdapter<OrderItemSync> {
  const _OrderItemSyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<OrderItemSync> collection,
      IsarRawObject rawObj,
      OrderItemSync object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.count;
    final _count = value0;
    final value1 = object.createdAt;
    final _createdAt = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_createdAt.length) as int;
    final value2 = object.discount;
    final _discount = value2;
    final value3 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_name.length) as int;
    final value4 = object.orderId;
    final _orderId = value4;
    final value5 = object.price;
    final _price = value5;
    final value6 = object.remainingStock;
    final _remainingStock = value6;
    final value7 = object.reported;
    final _reported = value7;
    final value8 = object.type;
    IsarUint8List? _type;
    if (value8 != null) {
      _type = IsarBinaryWriter.utf8Encoder.convert(value8);
    }
    dynamicSize += (_type?.length ?? 0) as int;
    final value9 = object.updatedAt;
    final _updatedAt = IsarBinaryWriter.utf8Encoder.convert(value9);
    dynamicSize += (_updatedAt.length) as int;
    final value10 = object.variantId;
    final _variantId = value10;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeDouble(offsets[0], _count);
    writer.writeBytes(offsets[1], _createdAt);
    writer.writeDouble(offsets[2], _discount);
    writer.writeBytes(offsets[3], _name);
    writer.writeLong(offsets[4], _orderId);
    writer.writeDouble(offsets[5], _price);
    writer.writeDouble(offsets[6], _remainingStock);
    writer.writeBool(offsets[7], _reported);
    writer.writeBytes(offsets[8], _type);
    writer.writeBytes(offsets[9], _updatedAt);
    writer.writeLong(offsets[10], _variantId);
  }

  @override
  OrderItemSync deserialize(IsarCollection<OrderItemSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = OrderItemSync();
    object.count = reader.readDouble(offsets[0]);
    object.createdAt = reader.readString(offsets[1]);
    object.discount = reader.readDoubleOrNull(offsets[2]);
    object.id = id;
    object.name = reader.readString(offsets[3]);
    object.orderId = reader.readLong(offsets[4]);
    object.price = reader.readDouble(offsets[5]);
    object.remainingStock = reader.readDouble(offsets[6]);
    object.reported = reader.readBool(offsets[7]);
    object.type = reader.readStringOrNull(offsets[8]);
    object.updatedAt = reader.readString(offsets[9]);
    object.variantId = reader.readLong(offsets[10]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readDouble(offset)) as P;
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readDoubleOrNull(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readLong(offset)) as P;
      case 5:
        return (reader.readDouble(offset)) as P;
      case 6:
        return (reader.readDouble(offset)) as P;
      case 7:
        return (reader.readBool(offset)) as P;
      case 8:
        return (reader.readStringOrNull(offset)) as P;
      case 9:
        return (reader.readString(offset)) as P;
      case 10:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, OrderItemSync object) {}
}

extension OrderItemSyncQueryWhereSort
    on QueryBuilder<OrderItemSync, OrderItemSync, QWhere> {
  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension OrderItemSyncQueryWhere
    on QueryBuilder<OrderItemSync, OrderItemSync, QWhereClause> {
  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterWhereClause> idBetween(
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

extension OrderItemSyncQueryFilter
    on QueryBuilder<OrderItemSync, OrderItemSync, QFilterCondition> {
  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      countGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'count',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      countLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'count',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      countBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'count',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      discountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'discount',
      value: null,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      discountGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      discountLessThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      discountBetween(double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'discount',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      orderIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      orderIdGreaterThan(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      orderIdLessThan(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      orderIdBetween(
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

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      priceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      priceLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      priceBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'price',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      remainingStockGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      remainingStockLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      remainingStockBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'remainingStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      reportedEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reported',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'type',
      value: null,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'updatedAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      updatedAtMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'updatedAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      variantIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      variantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      variantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterFilterCondition>
      variantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'variantId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension OrderItemSyncQueryWhereSortBy
    on QueryBuilder<OrderItemSync, OrderItemSync, QSortBy> {
  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByCount() {
    return addSortByInternal('count', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByCountDesc() {
    return addSortByInternal('count', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> sortByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      sortByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension OrderItemSyncQueryWhereSortThenBy
    on QueryBuilder<OrderItemSync, OrderItemSync, QSortThenBy> {
  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByCount() {
    return addSortByInternal('count', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByCountDesc() {
    return addSortByInternal('count', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy> thenByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QAfterSortBy>
      thenByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension OrderItemSyncQueryWhereDistinct
    on QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> {
  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByCount() {
    return addDistinctByInternal('count');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByDiscount() {
    return addDistinctByInternal('discount');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByOrderId() {
    return addDistinctByInternal('orderId');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct>
      distinctByRemainingStock() {
    return addDistinctByInternal('remainingStock');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByReported() {
    return addDistinctByInternal('reported');
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItemSync, OrderItemSync, QDistinct> distinctByVariantId() {
    return addDistinctByInternal('variantId');
  }
}

extension OrderItemSyncQueryProperty
    on QueryBuilder<OrderItemSync, OrderItemSync, QQueryProperty> {
  QueryBuilder<OrderItemSync, double, QQueryOperations> countProperty() {
    return addPropertyNameInternal('count');
  }

  QueryBuilder<OrderItemSync, String, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<OrderItemSync, double?, QQueryOperations> discountProperty() {
    return addPropertyNameInternal('discount');
  }

  QueryBuilder<OrderItemSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<OrderItemSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<OrderItemSync, int, QQueryOperations> orderIdProperty() {
    return addPropertyNameInternal('orderId');
  }

  QueryBuilder<OrderItemSync, double, QQueryOperations> priceProperty() {
    return addPropertyNameInternal('price');
  }

  QueryBuilder<OrderItemSync, double, QQueryOperations>
      remainingStockProperty() {
    return addPropertyNameInternal('remainingStock');
  }

  QueryBuilder<OrderItemSync, bool, QQueryOperations> reportedProperty() {
    return addPropertyNameInternal('reported');
  }

  QueryBuilder<OrderItemSync, String?, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<OrderItemSync, String, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }

  QueryBuilder<OrderItemSync, int, QQueryOperations> variantIdProperty() {
    return addPropertyNameInternal('variantId');
  }
}
