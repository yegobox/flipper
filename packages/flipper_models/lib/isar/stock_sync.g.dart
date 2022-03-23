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
      '{"name":"StockSync","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"canTrackingStock","type":"Bool"},{"name":"currentStock","type":"Double"},{"name":"lowStock","type":"Double"},{"name":"productId","type":"Long"},{"name":"retailPrice","type":"Double"},{"name":"showLowStockAlert","type":"Bool"},{"name":"supplyPrice","type":"Double"},{"name":"table","type":"String"},{"name":"value","type":"Double"},{"name":"variantId","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _StockSyncNativeAdapter(),
  webAdapter: const _StockSyncWebAdapter(),
  idName: 'id',
  propertyIds: {
    'active': 0,
    'branchId': 1,
    'canTrackingStock': 2,
    'currentStock': 3,
    'lowStock': 4,
    'productId': 5,
    'retailPrice': 6,
    'showLowStockAlert': 7,
    'supplyPrice': 8,
    'table': 9,
    'value': 10,
    'variantId': 11
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

class _StockSyncWebAdapter extends IsarWebTypeAdapter<StockSync> {
  const _StockSyncWebAdapter();

  @override
  Object serialize(IsarCollection<StockSync> collection, StockSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
    IsarNative.jsObjectSet(jsObj, 'canTrackingStock', object.canTrackingStock);
    IsarNative.jsObjectSet(jsObj, 'currentStock', object.currentStock);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'lowStock', object.lowStock);
    IsarNative.jsObjectSet(jsObj, 'productId', object.productId);
    IsarNative.jsObjectSet(jsObj, 'retailPrice', object.retailPrice);
    IsarNative.jsObjectSet(
        jsObj, 'showLowStockAlert', object.showLowStockAlert);
    IsarNative.jsObjectSet(jsObj, 'supplyPrice', object.supplyPrice);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    IsarNative.jsObjectSet(jsObj, 'value', object.value);
    IsarNative.jsObjectSet(jsObj, 'variantId', object.variantId);
    return jsObj;
  }

  @override
  StockSync deserialize(IsarCollection<StockSync> collection, dynamic jsObj) {
    final object = StockSync();
    object.active = IsarNative.jsObjectGet(jsObj, 'active');
    object.branchId = IsarNative.jsObjectGet(jsObj, 'branchId');
    object.canTrackingStock = IsarNative.jsObjectGet(jsObj, 'canTrackingStock');
    object.currentStock = IsarNative.jsObjectGet(jsObj, 'currentStock') ??
        double.negativeInfinity;
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.lowStock = IsarNative.jsObjectGet(jsObj, 'lowStock');
    object.productId =
        IsarNative.jsObjectGet(jsObj, 'productId') ?? double.negativeInfinity;
    object.retailPrice = IsarNative.jsObjectGet(jsObj, 'retailPrice');
    object.showLowStockAlert =
        IsarNative.jsObjectGet(jsObj, 'showLowStockAlert');
    object.supplyPrice = IsarNative.jsObjectGet(jsObj, 'supplyPrice');
    object.table = IsarNative.jsObjectGet(jsObj, 'table');
    object.value = IsarNative.jsObjectGet(jsObj, 'value');
    object.variantId =
        IsarNative.jsObjectGet(jsObj, 'variantId') ?? double.negativeInfinity;
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'active':
        return (IsarNative.jsObjectGet(jsObj, 'active')) as P;
      case 'branchId':
        return (IsarNative.jsObjectGet(jsObj, 'branchId')) as P;
      case 'canTrackingStock':
        return (IsarNative.jsObjectGet(jsObj, 'canTrackingStock')) as P;
      case 'currentStock':
        return (IsarNative.jsObjectGet(jsObj, 'currentStock') ??
            double.negativeInfinity) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'lowStock':
        return (IsarNative.jsObjectGet(jsObj, 'lowStock')) as P;
      case 'productId':
        return (IsarNative.jsObjectGet(jsObj, 'productId') ??
            double.negativeInfinity) as P;
      case 'retailPrice':
        return (IsarNative.jsObjectGet(jsObj, 'retailPrice')) as P;
      case 'showLowStockAlert':
        return (IsarNative.jsObjectGet(jsObj, 'showLowStockAlert')) as P;
      case 'supplyPrice':
        return (IsarNative.jsObjectGet(jsObj, 'supplyPrice')) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table')) as P;
      case 'value':
        return (IsarNative.jsObjectGet(jsObj, 'value')) as P;
      case 'variantId':
        return (IsarNative.jsObjectGet(jsObj, 'variantId') ??
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
    final value1 = object.branchId;
    final _branchId = value1;
    final value2 = object.canTrackingStock;
    final _canTrackingStock = value2;
    final value3 = object.currentStock;
    final _currentStock = value3;
    final value4 = object.lowStock;
    final _lowStock = value4;
    final value5 = object.productId;
    final _productId = value5;
    final value6 = object.retailPrice;
    final _retailPrice = value6;
    final value7 = object.showLowStockAlert;
    final _showLowStockAlert = value7;
    final value8 = object.supplyPrice;
    final _supplyPrice = value8;
    final value9 = object.table;
    IsarUint8List? _table;
    if (value9 != null) {
      _table = IsarBinaryWriter.utf8Encoder.convert(value9);
    }
    dynamicSize += (_table?.length ?? 0) as int;
    final value10 = object.value;
    final _value = value10;
    final value11 = object.variantId;
    final _variantId = value11;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBool(offsets[0], _active);
    writer.writeLong(offsets[1], _branchId);
    writer.writeBool(offsets[2], _canTrackingStock);
    writer.writeDouble(offsets[3], _currentStock);
    writer.writeDouble(offsets[4], _lowStock);
    writer.writeLong(offsets[5], _productId);
    writer.writeDouble(offsets[6], _retailPrice);
    writer.writeBool(offsets[7], _showLowStockAlert);
    writer.writeDouble(offsets[8], _supplyPrice);
    writer.writeBytes(offsets[9], _table);
    writer.writeDouble(offsets[10], _value);
    writer.writeLong(offsets[11], _variantId);
  }

  @override
  StockSync deserialize(IsarCollection<StockSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = StockSync();
    object.active = reader.readBoolOrNull(offsets[0]);
    object.branchId = reader.readLongOrNull(offsets[1]);
    object.canTrackingStock = reader.readBoolOrNull(offsets[2]);
    object.currentStock = reader.readDouble(offsets[3]);
    object.id = id;
    object.lowStock = reader.readDoubleOrNull(offsets[4]);
    object.productId = reader.readLong(offsets[5]);
    object.retailPrice = reader.readDoubleOrNull(offsets[6]);
    object.showLowStockAlert = reader.readBoolOrNull(offsets[7]);
    object.supplyPrice = reader.readDoubleOrNull(offsets[8]);
    object.table = reader.readStringOrNull(offsets[9]);
    object.value = reader.readDoubleOrNull(offsets[10]);
    object.variantId = reader.readLong(offsets[11]);
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
        return (reader.readLongOrNull(offset)) as P;
      case 2:
        return (reader.readBoolOrNull(offset)) as P;
      case 3:
        return (reader.readDouble(offset)) as P;
      case 4:
        return (reader.readDoubleOrNull(offset)) as P;
      case 5:
        return (reader.readLong(offset)) as P;
      case 6:
        return (reader.readDoubleOrNull(offset)) as P;
      case 7:
        return (reader.readBoolOrNull(offset)) as P;
      case 8:
        return (reader.readDoubleOrNull(offset)) as P;
      case 9:
        return (reader.readStringOrNull(offset)) as P;
      case 10:
        return (reader.readDoubleOrNull(offset)) as P;
      case 11:
        return (reader.readLong(offset)) as P;
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> branchIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'branchId',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> branchIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> branchIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> branchIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> branchIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'branchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      canTrackingStockIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'canTrackingStock',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      canTrackingStockEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'canTrackingStock',
      value: value,
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lowStock',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> lowStockBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lowStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'productId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      retailPriceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'retailPrice',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      retailPriceGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> retailPriceLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> retailPriceBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'retailPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      showLowStockAlertIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'showLowStockAlert',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      showLowStockAlertEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'showLowStockAlert',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      supplyPriceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'supplyPrice',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
      supplyPriceGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> supplyPriceLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> supplyPriceBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplyPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> tableEqualTo(
    String? value, {
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
    String? value, {
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
    String? value, {
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
    String? lower,
    String? upper, {
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'value',
      value: null,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> valueBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> variantIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition>
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> variantIdLessThan(
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

  QueryBuilder<StockSync, StockSync, QAfterFilterCondition> variantIdBetween(
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

extension StockSyncQueryWhereSortBy
    on QueryBuilder<StockSync, StockSync, QSortBy> {
  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
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

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
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

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> sortByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
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

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
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

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
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

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<StockSync, StockSync, QAfterSortBy> thenByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension StockSyncQueryWhereDistinct
    on QueryBuilder<StockSync, StockSync, QDistinct> {
  QueryBuilder<StockSync, StockSync, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByCanTrackingStock() {
    return addDistinctByInternal('canTrackingStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByCurrentStock() {
    return addDistinctByInternal('currentStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByLowStock() {
    return addDistinctByInternal('lowStock');
  }

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
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

  QueryBuilder<StockSync, StockSync, QDistinct> distinctByVariantId() {
    return addDistinctByInternal('variantId');
  }
}

extension StockSyncQueryProperty
    on QueryBuilder<StockSync, StockSync, QQueryProperty> {
  QueryBuilder<StockSync, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<StockSync, int?, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<StockSync, bool?, QQueryOperations> canTrackingStockProperty() {
    return addPropertyNameInternal('canTrackingStock');
  }

  QueryBuilder<StockSync, double, QQueryOperations> currentStockProperty() {
    return addPropertyNameInternal('currentStock');
  }

  QueryBuilder<StockSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<StockSync, double?, QQueryOperations> lowStockProperty() {
    return addPropertyNameInternal('lowStock');
  }

  QueryBuilder<StockSync, int, QQueryOperations> productIdProperty() {
    return addPropertyNameInternal('productId');
  }

  QueryBuilder<StockSync, double?, QQueryOperations> retailPriceProperty() {
    return addPropertyNameInternal('retailPrice');
  }

  QueryBuilder<StockSync, bool?, QQueryOperations> showLowStockAlertProperty() {
    return addPropertyNameInternal('showLowStockAlert');
  }

  QueryBuilder<StockSync, double?, QQueryOperations> supplyPriceProperty() {
    return addPropertyNameInternal('supplyPrice');
  }

  QueryBuilder<StockSync, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<StockSync, double?, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }

  QueryBuilder<StockSync, int, QQueryOperations> variantIdProperty() {
    return addPropertyNameInternal('variantId');
  }
}
