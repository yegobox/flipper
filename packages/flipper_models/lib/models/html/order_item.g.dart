// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetOrderItemCollection on Isar {
  IsarCollection<OrderItem> get orderItems => getCollection();
}

const OrderItemSchema = CollectionSchema(
  name: 'OrderItem',
  schema:
      '{"name":"OrderItem","idName":"id","properties":[{"name":"count","type":"Double"},{"name":"createdAt","type":"String"},{"name":"discount","type":"Double"},{"name":"forderId","type":"Long"},{"name":"fvariantId","type":"Long"},{"name":"name","type":"String"},{"name":"price","type":"Double"},{"name":"remainingStock","type":"Long"},{"name":"reported","type":"Bool"},{"name":"type","type":"String"},{"name":"updatedAt","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'count': 0,
    'createdAt': 1,
    'discount': 2,
    'forderId': 3,
    'fvariantId': 4,
    'name': 5,
    'price': 6,
    'remainingStock': 7,
    'reported': 8,
    'type': 9,
    'updatedAt': 10
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _orderItemGetId,
  setId: _orderItemSetId,
  getLinks: _orderItemGetLinks,
  attachLinks: _orderItemAttachLinks,
  serializeNative: _orderItemSerializeNative,
  deserializeNative: _orderItemDeserializeNative,
  deserializePropNative: _orderItemDeserializePropNative,
  serializeWeb: _orderItemSerializeWeb,
  deserializeWeb: _orderItemDeserializeWeb,
  deserializePropWeb: _orderItemDeserializePropWeb,
  version: 3,
);

int? _orderItemGetId(OrderItem object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _orderItemSetId(OrderItem object, int id) {
  object.id = id;
}

List<IsarLinkBase> _orderItemGetLinks(OrderItem object) {
  return [];
}

void _orderItemSerializeNative(
    IsarCollection<OrderItem> collection,
    IsarRawObject rawObj,
    OrderItem object,
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
  final value3 = object.forderId;
  final _forderId = value3;
  final value4 = object.fvariantId;
  final _fvariantId = value4;
  final value5 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_name.length) as int;
  final value6 = object.price;
  final _price = value6;
  final value7 = object.remainingStock;
  final _remainingStock = value7;
  final value8 = object.reported;
  final _reported = value8;
  final value9 = object.type;
  IsarUint8List? _type;
  if (value9 != null) {
    _type = IsarBinaryWriter.utf8Encoder.convert(value9);
  }
  dynamicSize += (_type?.length ?? 0) as int;
  final value10 = object.updatedAt;
  final _updatedAt = IsarBinaryWriter.utf8Encoder.convert(value10);
  dynamicSize += (_updatedAt.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeDouble(offsets[0], _count);
  writer.writeBytes(offsets[1], _createdAt);
  writer.writeDouble(offsets[2], _discount);
  writer.writeLong(offsets[3], _forderId);
  writer.writeLong(offsets[4], _fvariantId);
  writer.writeBytes(offsets[5], _name);
  writer.writeDouble(offsets[6], _price);
  writer.writeLong(offsets[7], _remainingStock);
  writer.writeBool(offsets[8], _reported);
  writer.writeBytes(offsets[9], _type);
  writer.writeBytes(offsets[10], _updatedAt);
}

OrderItem _orderItemDeserializeNative(IsarCollection<OrderItem> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = OrderItem(
    count: reader.readDouble(offsets[0]),
    createdAt: reader.readString(offsets[1]),
    discount: reader.readDoubleOrNull(offsets[2]),
    forderId: reader.readLong(offsets[3]),
    fvariantId: reader.readLong(offsets[4]),
    id: id,
    name: reader.readString(offsets[5]),
    price: reader.readDouble(offsets[6]),
    remainingStock: reader.readLong(offsets[7]),
    reported: reader.readBool(offsets[8]),
    type: reader.readStringOrNull(offsets[9]),
    updatedAt: reader.readString(offsets[10]),
  );
  return object;
}

P _orderItemDeserializePropNative<P>(
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _orderItemSerializeWeb(
    IsarCollection<OrderItem> collection, OrderItem object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'count', object.count);
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'discount', object.discount);
  IsarNative.jsObjectSet(jsObj, 'forderId', object.forderId);
  IsarNative.jsObjectSet(jsObj, 'fvariantId', object.fvariantId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'price', object.price);
  IsarNative.jsObjectSet(jsObj, 'remainingStock', object.remainingStock);
  IsarNative.jsObjectSet(jsObj, 'reported', object.reported);
  IsarNative.jsObjectSet(jsObj, 'type', object.type);
  IsarNative.jsObjectSet(jsObj, 'updatedAt', object.updatedAt);
  return jsObj;
}

OrderItem _orderItemDeserializeWeb(
    IsarCollection<OrderItem> collection, dynamic jsObj) {
  final object = OrderItem(
    count: IsarNative.jsObjectGet(jsObj, 'count') ?? double.negativeInfinity,
    createdAt: IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '',
    discount: IsarNative.jsObjectGet(jsObj, 'discount'),
    forderId:
        IsarNative.jsObjectGet(jsObj, 'forderId') ?? double.negativeInfinity,
    fvariantId:
        IsarNative.jsObjectGet(jsObj, 'fvariantId') ?? double.negativeInfinity,
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
    price: IsarNative.jsObjectGet(jsObj, 'price') ?? double.negativeInfinity,
    remainingStock: IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
        double.negativeInfinity,
    reported: IsarNative.jsObjectGet(jsObj, 'reported') ?? false,
    type: IsarNative.jsObjectGet(jsObj, 'type'),
    updatedAt: IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '',
  );
  return object;
}

P _orderItemDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'count':
      return (IsarNative.jsObjectGet(jsObj, 'count') ?? double.negativeInfinity)
          as P;
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '') as P;
    case 'discount':
      return (IsarNative.jsObjectGet(jsObj, 'discount')) as P;
    case 'forderId':
      return (IsarNative.jsObjectGet(jsObj, 'forderId') ??
          double.negativeInfinity) as P;
    case 'fvariantId':
      return (IsarNative.jsObjectGet(jsObj, 'fvariantId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'price':
      return (IsarNative.jsObjectGet(jsObj, 'price') ?? double.negativeInfinity)
          as P;
    case 'remainingStock':
      return (IsarNative.jsObjectGet(jsObj, 'remainingStock') ??
          double.negativeInfinity) as P;
    case 'reported':
      return (IsarNative.jsObjectGet(jsObj, 'reported') ?? false) as P;
    case 'type':
      return (IsarNative.jsObjectGet(jsObj, 'type')) as P;
    case 'updatedAt':
      return (IsarNative.jsObjectGet(jsObj, 'updatedAt') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _orderItemAttachLinks(IsarCollection col, int id, OrderItem object) {}

extension OrderItemQueryWhereSort
    on QueryBuilder<OrderItem, OrderItem, QWhere> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension OrderItemQueryWhere
    on QueryBuilder<OrderItem, OrderItem, QWhereClause> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idBetween(
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
}

extension OrderItemQueryFilter
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {
  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> countGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'count',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> countLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'count',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> countBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'count',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'discount',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'discount',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'discount',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> forderIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'forderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> forderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'forderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> forderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'forderId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> forderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'forderId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> fvariantIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fvariantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      fvariantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fvariantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> fvariantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fvariantId',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> fvariantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fvariantId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'price',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'remainingStock',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      remainingStockBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'remainingStock',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> reportedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reported',
      value: value,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'type',
      value: null,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'updatedAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension OrderItemQueryLinks
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {}

extension OrderItemQueryWhereSortBy
    on QueryBuilder<OrderItem, OrderItem, QSortBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCount() {
    return addSortByInternal('count', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCountDesc() {
    return addSortByInternal('count', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByForderId() {
    return addSortByInternal('forderId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByForderIdDesc() {
    return addSortByInternal('forderId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByFvariantId() {
    return addSortByInternal('fvariantId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByFvariantIdDesc() {
    return addSortByInternal('fvariantId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderItemQueryWhereSortThenBy
    on QueryBuilder<OrderItem, OrderItem, QSortThenBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCount() {
    return addSortByInternal('count', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCountDesc() {
    return addSortByInternal('count', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscount() {
    return addSortByInternal('discount', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscountDesc() {
    return addSortByInternal('discount', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByForderId() {
    return addSortByInternal('forderId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByForderIdDesc() {
    return addSortByInternal('forderId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByFvariantId() {
    return addSortByInternal('fvariantId', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByFvariantIdDesc() {
    return addSortByInternal('fvariantId', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStock() {
    return addSortByInternal('remainingStock', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStockDesc() {
    return addSortByInternal('remainingStock', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderItemQueryWhereDistinct
    on QueryBuilder<OrderItem, OrderItem, QDistinct> {
  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByCount() {
    return addDistinctByInternal('count');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDiscount() {
    return addDistinctByInternal('discount');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByForderId() {
    return addDistinctByInternal('forderId');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByFvariantId() {
    return addDistinctByInternal('fvariantId');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPrice() {
    return addDistinctByInternal('price');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRemainingStock() {
    return addDistinctByInternal('remainingStock');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByReported() {
    return addDistinctByInternal('reported');
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }
}

extension OrderItemQueryProperty
    on QueryBuilder<OrderItem, OrderItem, QQueryProperty> {
  QueryBuilder<OrderItem, double, QQueryOperations> countProperty() {
    return addPropertyNameInternal('count');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> discountProperty() {
    return addPropertyNameInternal('discount');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> forderIdProperty() {
    return addPropertyNameInternal('forderId');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> fvariantIdProperty() {
    return addPropertyNameInternal('fvariantId');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<OrderItem, double, QQueryOperations> priceProperty() {
    return addPropertyNameInternal('price');
  }

  QueryBuilder<OrderItem, int, QQueryOperations> remainingStockProperty() {
    return addPropertyNameInternal('remainingStock');
  }

  QueryBuilder<OrderItem, bool, QQueryOperations> reportedProperty() {
    return addPropertyNameInternal('reported');
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<OrderItem, String, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }
}
