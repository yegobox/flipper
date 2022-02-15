// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetStockSyncCollection on Isar {
  IsarCollection<StockSync> get stockSyncs {
    return getCollection('StockSync');
  }
}

final StockSyncSchema = CollectionSchema(
  name: 'StockSync',
  schema:
      '{"name":"StockSync","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"canTrackingStock","type":"Bool"},{"name":"channels","type":"StringList"},{"name":"currentStock","type":"Double"},{"name":"fbranchId","type":"Long"},{"name":"fproductId","type":"Long"},{"name":"fvariantId","type":"Long"},{"name":"lowStock","type":"Double"},{"name":"retailPrice","type":"Double"},{"name":"showLowStockAlert","type":"Bool"},{"name":"supplyPrice","type":"Double"},{"name":"table","type":"String"},{"name":"value","type":"Double"}],"indexes":[],"links":[]}',
  nativeAdapter: const _StockSyncNativeAdapter(),
  webAdapter: const _StockSyncWebAdapter(),
  idName: 'id',
  propertyIds: {
    'active': 0,
    'canTrackingStock': 1,
    'channels': 2,
    'currentStock': 3,
    'fbranchId': 4,
    'fproductId': 5,
    'fvariantId': 6,
    'lowStock': 7,
    'retailPrice': 8,
    'showLowStockAlert': 9,
    'supplyPrice': 10,
    'table': 11,
    'value': 12
  },
  listProperties: {'channels'},
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

class _StockSyncWebAdapter extends IsarWebTypeAdapter<StockSync> {
  const _StockSyncWebAdapter();

  @override
  Object serialize(IsarCollection<StockSync> collection, StockSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'canTrackingStock', object.canTrackingStock);
    IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
    IsarNative.jsObjectSet(jsObj, 'currentStock', object.currentStock);
    IsarNative.jsObjectSet(jsObj, 'fbranchId', object.fbranchId);
    IsarNative.jsObjectSet(jsObj, 'fproductId', object.fproductId);
    IsarNative.jsObjectSet(jsObj, 'fvariantId', object.fvariantId);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'lowStock', object.lowStock);
    IsarNative.jsObjectSet(jsObj, 'retailPrice', object.retailPrice);
    IsarNative.jsObjectSet(
        jsObj, 'showLowStockAlert', object.showLowStockAlert);
    IsarNative.jsObjectSet(jsObj, 'supplyPrice', object.supplyPrice);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    IsarNative.jsObjectSet(jsObj, 'value', object.value);
    return jsObj;
  }

  @override
  StockSync deserialize(IsarCollection<StockSync> collection, dynamic jsObj) {
    final object = StockSync(
      active: IsarNative.jsObjectGet(jsObj, 'active'),
      canTrackingStock:
          IsarNative.jsObjectGet(jsObj, 'canTrackingStock') ?? false,
      channels: (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
          ?.map((e) => e ?? '')
          .toList()
          .cast<String>(),
      currentStock: IsarNative.jsObjectGet(jsObj, 'currentStock') ??
          double.negativeInfinity,
      fbranchId: IsarNative.jsObjectGet(jsObj, 'fbranchId'),
      fproductId: IsarNative.jsObjectGet(jsObj, 'fproductId') ??
          double.negativeInfinity,
      fvariantId: IsarNative.jsObjectGet(jsObj, 'fvariantId') ??
          double.negativeInfinity,
      id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      lowStock:
          IsarNative.jsObjectGet(jsObj, 'lowStock') ?? double.negativeInfinity,
      retailPrice: IsarNative.jsObjectGet(jsObj, 'retailPrice') ??
          double.negativeInfinity,
      showLowStockAlert:
          IsarNative.jsObjectGet(jsObj, 'showLowStockAlert') ?? false,
      supplyPrice: IsarNative.jsObjectGet(jsObj, 'supplyPrice') ??
          double.negativeInfinity,
      table: IsarNative.jsObjectGet(jsObj, 'table') ?? '',
      value: IsarNative.jsObjectGet(jsObj, 'value') ?? double.negativeInfinity,
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'active':
        return (IsarNative.jsObjectGet(jsObj, 'active')) as P;
      case 'canTrackingStock':
        return (IsarNative.jsObjectGet(jsObj, 'canTrackingStock') ?? false)
            as P;
      case 'channels':
        return ((IsarNative.jsObjectGet(jsObj, 'channels') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>()) as P;
      case 'currentStock':
        return (IsarNative.jsObjectGet(jsObj, 'currentStock') ??
            double.negativeInfinity) as P;
      case 'fbranchId':
        return (IsarNative.jsObjectGet(jsObj, 'fbranchId')) as P;
      case 'fproductId':
        return (IsarNative.jsObjectGet(jsObj, 'fproductId') ??
            double.negativeInfinity) as P;
      case 'fvariantId':
        return (IsarNative.jsObjectGet(jsObj, 'fvariantId') ??
            double.negativeInfinity) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'lowStock':
        return (IsarNative.jsObjectGet(jsObj, 'lowStock') ??
            double.negativeInfinity) as P;
      case 'retailPrice':
        return (IsarNative.jsObjectGet(jsObj, 'retailPrice') ??
            double.negativeInfinity) as P;
      case 'showLowStockAlert':
        return (IsarNative.jsObjectGet(jsObj, 'showLowStockAlert') ?? false)
            as P;
      case 'supplyPrice':
        return (IsarNative.jsObjectGet(jsObj, 'supplyPrice') ??
            double.negativeInfinity) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table') ?? '') as P;
      case 'value':
        return (IsarNative.jsObjectGet(jsObj, 'value') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, StockSync object) {}
}

class _StockSyncNativeAdapter extends IsarNativeTypeAdapter<StockSync> {
  const _StockSyncNativeAdapter();

  @override
  void serialize(IsarCollection<StockSync> collection, IsarRawObject rawObj,
      StockSync object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.active;
    final _active = value0;
    final value1 = object.canTrackingStock;
    final _canTrackingStock = value1;
    final value2 = object.channels;
    dynamicSize += (value2?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList2;
    if (value2 != null) {
      bytesList2 = [];
      for (var str in value2) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList2.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _channels = bytesList2;
    final value3 = object.currentStock;
    final _currentStock = value3;
    final value4 = object.fbranchId;
    final _fbranchId = value4;
    final value5 = object.fproductId;
    final _fproductId = value5;
    final value6 = object.fvariantId;
    final _fvariantId = value6;
    final value7 = object.lowStock;
    final _lowStock = value7;
    final value8 = object.retailPrice;
    final _retailPrice = value8;
    final value9 = object.showLowStockAlert;
    final _showLowStockAlert = value9;
    final value10 = object.supplyPrice;
    final _supplyPrice = value10;
    final value11 = object.table;
    final _table = IsarBinaryWriter.utf8Encoder.convert(value11);
    dynamicSize += (_table.length) as int;
    final value12 = object.value;
    final _value = value12;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBool(offsets[0], _active);
    writer.writeBool(offsets[1], _canTrackingStock);
    writer.writeStringList(offsets[2], _channels);
    writer.writeDouble(offsets[3], _currentStock);
    writer.writeLong(offsets[4], _fbranchId);
    writer.writeLong(offsets[5], _fproductId);
    writer.writeLong(offsets[6], _fvariantId);
    writer.writeDouble(offsets[7], _lowStock);
    writer.writeDouble(offsets[8], _retailPrice);
    writer.writeBool(offsets[9], _showLowStockAlert);
    writer.writeDouble(offsets[10], _supplyPrice);
    writer.writeBytes(offsets[11], _table);
    writer.writeDouble(offsets[12], _value);
  }

  @override
  StockSync deserialize(IsarCollection<StockSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = StockSync(
      active: reader.readBoolOrNull(offsets[0]),
      canTrackingStock: reader.readBool(offsets[1]),
      channels: reader.readStringList(offsets[2]),
      currentStock: reader.readDouble(offsets[3]),
      fbranchId: reader.readLongOrNull(offsets[4]),
      fproductId: reader.readLong(offsets[5]),
      fvariantId: reader.readLong(offsets[6]),
      id: id,
      lowStock: reader.readDouble(offsets[7]),
      retailPrice: reader.readDouble(offsets[8]),
      showLowStockAlert: reader.readBool(offsets[9]),
      supplyPrice: reader.readDouble(offsets[10]),
      table: reader.readString(offsets[11]),
      value: reader.readDouble(offsets[12]),
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
        return (reader.readBoolOrNull(offset)) as P;
      case 1:
        return (reader.readBool(offset)) as P;
      case 2:
        return (reader.readStringList(offset)) as P;
      case 3:
        return (reader.readDouble(offset)) as P;
      case 4:
        return (reader.readLongOrNull(offset)) as P;
      case 5:
        return (reader.readLong(offset)) as P;
      case 6:
        return (reader.readLong(offset)) as P;
      case 7:
        return (reader.readDouble(offset)) as P;
      case 8:
        return (reader.readDouble(offset)) as P;
      case 9:
        return (reader.readBool(offset)) as P;
      case 10:
        return (reader.readDouble(offset)) as P;
      case 11:
        return (reader.readString(offset)) as P;
      case 12:
        return (reader.readDouble(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, StockSync object) {}
}

extension StockSyncQueryWhereSort
    on QueryBuilder<StockSync, StockSync, QWhere> {
  QueryBuilder<StockSync, StockSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension StockSyncQueryWhere
    on QueryBuilder<StockSync, StockSync, QWhereClause> {
  QueryBuilder<StockSync, StockSync, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<StockSync, StockSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterWhereClause> idBetween(
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

extension StockSyncQueryFilter
    on QueryBuilder<StockSync, StockSync, QFilterCondition> {
  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> activeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'active',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> activeEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      canTrackingStockEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'canTrackingStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      channelsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'channels',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      channelsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> channelsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      currentStockGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'currentStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      currentStockLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'currentStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> currentStockBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'currentStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fbranchIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fbranchId',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fbranchIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      fbranchIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fbranchIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fbranchIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fbranchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fproductIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fproductId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      fproductIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fproductId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fproductIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fproductId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fproductIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fproductId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fvariantIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fvariantId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fvariantIdLessThan(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> fvariantIdBetween(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lowStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      retailPriceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> retailPriceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> retailPriceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'retailPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      showLowStockAlertEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'showLowStockAlert',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      supplyPriceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> supplyPriceLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> supplyPriceBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplyPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'table',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }
}

extension StockSyncQueryWhereSortBy
    on QueryBuilder<StockSync, StockSync, QSortBy> {
  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByCanTrackingStock() {
    return addSortByInternal('canTrackingStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy>
      sortByCanTrackingStockDesc() {
    return addSortByInternal('canTrackingStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByCurrentStock() {
    return addSortByInternal('currentStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByCurrentStockDesc() {
    return addSortByInternal('currentStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFbranchId() {
    return addSortByInternal('fbranchId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFbranchIdDesc() {
    return addSortByInternal('fbranchId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFproductId() {
    return addSortByInternal('fproductId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFproductIdDesc() {
    return addSortByInternal('fproductId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFvariantId() {
    return addSortByInternal('fvariantId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByFvariantIdDesc() {
    return addSortByInternal('fvariantId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByLowStock() {
    return addSortByInternal('lowStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByLowStockDesc() {
    return addSortByInternal('lowStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByShowLowStockAlert() {
    return addSortByInternal('showLowStockAlert', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy>
      sortByShowLowStockAlertDesc() {
    return addSortByInternal('showLowStockAlert', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension StockSyncQueryWhereSortThenBy
    on QueryBuilder<StockSync, StockSync, QSortThenBy> {
  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByCanTrackingStock() {
    return addSortByInternal('canTrackingStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy>
      thenByCanTrackingStockDesc() {
    return addSortByInternal('canTrackingStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByCurrentStock() {
    return addSortByInternal('currentStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByCurrentStockDesc() {
    return addSortByInternal('currentStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFbranchId() {
    return addSortByInternal('fbranchId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFbranchIdDesc() {
    return addSortByInternal('fbranchId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFproductId() {
    return addSortByInternal('fproductId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFproductIdDesc() {
    return addSortByInternal('fproductId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFvariantId() {
    return addSortByInternal('fvariantId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByFvariantIdDesc() {
    return addSortByInternal('fvariantId', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByLowStock() {
    return addSortByInternal('lowStock', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByLowStockDesc() {
    return addSortByInternal('lowStock', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByShowLowStockAlert() {
    return addSortByInternal('showLowStockAlert', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy>
      thenByShowLowStockAlertDesc() {
    return addSortByInternal('showLowStockAlert', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension StockSyncQueryWhereDistinct
    on QueryBuilder<StockSync, StockSync, QDistinct> {
  QueryBuilder<StockSync, StockSync, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByCanTrackingStock() {
    return addDistinctByInternal('canTrackingStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByCurrentStock() {
    return addDistinctByInternal('currentStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByFbranchId() {
    return addDistinctByInternal('fbranchId');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByFproductId() {
    return addDistinctByInternal('fproductId');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByFvariantId() {
    return addDistinctByInternal('fvariantId');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByLowStock() {
    return addDistinctByInternal('lowStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByRetailPrice() {
    return addDistinctByInternal('retailPrice');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByShowLowStockAlert() {
    return addDistinctByInternal('showLowStockAlert');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctBySupplyPrice() {
    return addDistinctByInternal('supplyPrice');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension StockSyncQueryProperty
    on QueryBuilder<StockSync, StockSync, QQueryProperty> {
  QueryBuilder<StockSync, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<StockSync, bool, QQueryOperations> canTrackingStockProperty() {
    return addPropertyNameInternal('canTrackingStock');
  }

  QueryBuilder<StockSync, List<String>?, QQueryOperations> channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<StockSync, double, QQueryOperations> currentStockProperty() {
    return addPropertyNameInternal('currentStock');
  }

  QueryBuilder<StockSync, int?, QQueryOperations> fbranchIdProperty() {
    return addPropertyNameInternal('fbranchId');
  }

  QueryBuilder<StockSync, int, QQueryOperations> fproductIdProperty() {
    return addPropertyNameInternal('fproductId');
  }

  QueryBuilder<StockSync, int, QQueryOperations> fvariantIdProperty() {
    return addPropertyNameInternal('fvariantId');
  }

  QueryBuilder<StockSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<StockSync, double, QQueryOperations> lowStockProperty() {
    return addPropertyNameInternal('lowStock');
  }

  QueryBuilder<StockSync, double, QQueryOperations> retailPriceProperty() {
    return addPropertyNameInternal('retailPrice');
  }

  QueryBuilder<StockSync, bool, QQueryOperations> showLowStockAlertProperty() {
    return addPropertyNameInternal('showLowStockAlert');
  }

  QueryBuilder<StockSync, double, QQueryOperations> supplyPriceProperty() {
    return addPropertyNameInternal('supplyPrice');
  }

  QueryBuilder<StockSync, String, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<StockSync, double, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
