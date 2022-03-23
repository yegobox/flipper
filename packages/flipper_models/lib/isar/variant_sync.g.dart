// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetVariantSyncCollection on Isar {
  IsarCollection<VariantSync> get variantSyncs {
    return getCollection('VariantSync');
  }
}

final VariantSyncSchema = CollectionSchema(
  name: 'VariantSync',
  schema:
      '{"name":"VariantSync","idName":"id","properties":[{"name":"branchId","type":"Long"},{"name":"name","type":"String"},{"name":"productId","type":"Long"},{"name":"productName","type":"String"},{"name":"retailPrice","type":"Double"},{"name":"sku","type":"String"},{"name":"supplyPrice","type":"Double"},{"name":"synced","type":"Bool"},{"name":"table","type":"String"},{"name":"taxName","type":"String"},{"name":"taxPercentage","type":"Double"},{"name":"unit","type":"String"}],"indexes":[],"links":[{"name":"stock","target":"StockSync"}]}',
  nativeAdapter: const _VariantSyncNativeAdapter(),
  webAdapter: const _VariantSyncWebAdapter(),
  idName: 'id',
  propertyIds: {
    'branchId': 0,
    'name': 1,
    'productId': 2,
    'productName': 3,
    'retailPrice': 4,
    'sku': 5,
    'supplyPrice': 6,
    'synced': 7,
    'table': 8,
    'taxName': 9,
    'taxPercentage': 10,
    'unit': 11
  },
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {'stock': 0},
  backlinkIds: {},
  linkedCollections: ['StockSync'],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.stock],
  version: 2,
);

class _VariantSyncWebAdapter extends IsarWebTypeAdapter<VariantSync> {
  const _VariantSyncWebAdapter();

  @override
  Object serialize(IsarCollection<VariantSync> collection, VariantSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'productId', object.productId);
    IsarNative.jsObjectSet(jsObj, 'productName', object.productName);
    IsarNative.jsObjectSet(jsObj, 'retailPrice', object.retailPrice);
    IsarNative.jsObjectSet(jsObj, 'sku', object.sku);
    IsarNative.jsObjectSet(jsObj, 'supplyPrice', object.supplyPrice);
    IsarNative.jsObjectSet(jsObj, 'synced', object.synced);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    IsarNative.jsObjectSet(jsObj, 'taxName', object.taxName);
    IsarNative.jsObjectSet(jsObj, 'taxPercentage', object.taxPercentage);
    IsarNative.jsObjectSet(jsObj, 'unit', object.unit);
    return jsObj;
  }

  @override
  VariantSync deserialize(
      IsarCollection<VariantSync> collection, dynamic jsObj) {
    final object = VariantSync();
    object.branchId =
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
    object.productId =
        IsarNative.jsObjectGet(jsObj, 'productId') ?? double.negativeInfinity;
    object.productName = IsarNative.jsObjectGet(jsObj, 'productName') ?? '';
    object.retailPrice =
        IsarNative.jsObjectGet(jsObj, 'retailPrice') ?? double.negativeInfinity;
    object.sku = IsarNative.jsObjectGet(jsObj, 'sku') ?? '';
    object.supplyPrice =
        IsarNative.jsObjectGet(jsObj, 'supplyPrice') ?? double.negativeInfinity;
    object.synced = IsarNative.jsObjectGet(jsObj, 'synced');
    object.table = IsarNative.jsObjectGet(jsObj, 'table') ?? '';
    object.taxName = IsarNative.jsObjectGet(jsObj, 'taxName');
    object.taxPercentage = IsarNative.jsObjectGet(jsObj, 'taxPercentage');
    object.unit = IsarNative.jsObjectGet(jsObj, 'unit') ?? '';
    attachLinks(collection.isar,
        IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'branchId':
        return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
            double.negativeInfinity) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'productId':
        return (IsarNative.jsObjectGet(jsObj, 'productId') ??
            double.negativeInfinity) as P;
      case 'productName':
        return (IsarNative.jsObjectGet(jsObj, 'productName') ?? '') as P;
      case 'retailPrice':
        return (IsarNative.jsObjectGet(jsObj, 'retailPrice') ??
            double.negativeInfinity) as P;
      case 'sku':
        return (IsarNative.jsObjectGet(jsObj, 'sku') ?? '') as P;
      case 'supplyPrice':
        return (IsarNative.jsObjectGet(jsObj, 'supplyPrice') ??
            double.negativeInfinity) as P;
      case 'synced':
        return (IsarNative.jsObjectGet(jsObj, 'synced')) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table') ?? '') as P;
      case 'taxName':
        return (IsarNative.jsObjectGet(jsObj, 'taxName')) as P;
      case 'taxPercentage':
        return (IsarNative.jsObjectGet(jsObj, 'taxPercentage')) as P;
      case 'unit':
        return (IsarNative.jsObjectGet(jsObj, 'unit') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, VariantSync object) {
    object.stock.attach(
      id,
      isar.variantSyncs,
      isar.getCollection<StockSync>('StockSync'),
      'stock',
      false,
    );
  }
}

class _VariantSyncNativeAdapter extends IsarNativeTypeAdapter<VariantSync> {
  const _VariantSyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<VariantSync> collection,
      IsarRawObject rawObj,
      VariantSync object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.branchId;
    final _branchId = value0;
    final value1 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_name.length) as int;
    final value2 = object.productId;
    final _productId = value2;
    final value3 = object.productName;
    final _productName = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_productName.length) as int;
    final value4 = object.retailPrice;
    final _retailPrice = value4;
    final value5 = object.sku;
    final _sku = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_sku.length) as int;
    final value6 = object.supplyPrice;
    final _supplyPrice = value6;
    final value7 = object.synced;
    final _synced = value7;
    final value8 = object.table;
    final _table = IsarBinaryWriter.utf8Encoder.convert(value8);
    dynamicSize += (_table.length) as int;
    final value9 = object.taxName;
    IsarUint8List? _taxName;
    if (value9 != null) {
      _taxName = IsarBinaryWriter.utf8Encoder.convert(value9);
    }
    dynamicSize += (_taxName?.length ?? 0) as int;
    final value10 = object.taxPercentage;
    final _taxPercentage = value10;
    final value11 = object.unit;
    final _unit = IsarBinaryWriter.utf8Encoder.convert(value11);
    dynamicSize += (_unit.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeLong(offsets[0], _branchId);
    writer.writeBytes(offsets[1], _name);
    writer.writeLong(offsets[2], _productId);
    writer.writeBytes(offsets[3], _productName);
    writer.writeDouble(offsets[4], _retailPrice);
    writer.writeBytes(offsets[5], _sku);
    writer.writeDouble(offsets[6], _supplyPrice);
    writer.writeBool(offsets[7], _synced);
    writer.writeBytes(offsets[8], _table);
    writer.writeBytes(offsets[9], _taxName);
    writer.writeDouble(offsets[10], _taxPercentage);
    writer.writeBytes(offsets[11], _unit);
  }

  @override
  VariantSync deserialize(IsarCollection<VariantSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = VariantSync();
    object.branchId = reader.readLong(offsets[0]);
    object.id = id;
    object.name = reader.readString(offsets[1]);
    object.productId = reader.readLong(offsets[2]);
    object.productName = reader.readString(offsets[3]);
    object.retailPrice = reader.readDouble(offsets[4]);
    object.sku = reader.readString(offsets[5]);
    object.supplyPrice = reader.readDouble(offsets[6]);
    object.synced = reader.readBoolOrNull(offsets[7]);
    object.table = reader.readString(offsets[8]);
    object.taxName = reader.readStringOrNull(offsets[9]);
    object.taxPercentage = reader.readDoubleOrNull(offsets[10]);
    object.unit = reader.readString(offsets[11]);
    attachLinks(collection.isar, id, object);
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
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readDouble(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      case 6:
        return (reader.readDouble(offset)) as P;
      case 7:
        return (reader.readBoolOrNull(offset)) as P;
      case 8:
        return (reader.readString(offset)) as P;
      case 9:
        return (reader.readStringOrNull(offset)) as P;
      case 10:
        return (reader.readDoubleOrNull(offset)) as P;
      case 11:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, VariantSync object) {
    object.stock.attach(
      id,
      isar.variantSyncs,
      isar.getCollection<StockSync>('StockSync'),
      'stock',
      false,
    );
  }
}

extension VariantSyncQueryWhereSort
    on QueryBuilder<VariantSync, VariantSync, QWhere> {
  QueryBuilder<VariantSync, VariantSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension VariantSyncQueryWhere
    on QueryBuilder<VariantSync, VariantSync, QWhereClause> {
  QueryBuilder<VariantSync, VariantSync, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VariantSync, VariantSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterWhereClause> idBetween(
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

extension VariantSyncQueryFilter
    on QueryBuilder<VariantSync, VariantSync, QFilterCondition> {
  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productIdLessThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productIdBetween(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'productName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'productName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'productName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      retailPriceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      retailPriceLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      retailPriceBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'retailPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sku',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'sku',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'sku',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      supplyPriceGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      supplyPriceLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      supplyPriceBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplyPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> syncedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'synced',
      value: null,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> syncedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'synced',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableEqualTo(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      tableGreaterThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableLessThan(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableBetween(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableStartsWith(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableEndsWith(
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

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxName',
      value: null,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> taxNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxPercentageIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxPercentage',
      value: null,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxPercentageGreaterThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'taxPercentage',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxPercentageLessThan(double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'taxPercentage',
      value: value,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition>
      taxPercentageBetween(double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxPercentage',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'unit',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VariantSync, VariantSync, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'unit',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension VariantSyncQueryWhereSortBy
    on QueryBuilder<VariantSync, VariantSync, QSortBy> {
  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByProductName() {
    return addSortByInternal('productName', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByProductNameDesc() {
    return addSortByInternal('productName', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySku() {
    return addSortByInternal('sku', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySkuDesc() {
    return addSortByInternal('sku', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByTaxName() {
    return addSortByInternal('taxName', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByTaxNameDesc() {
    return addSortByInternal('taxName', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByTaxPercentage() {
    return addSortByInternal('taxPercentage', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy>
      sortByTaxPercentageDesc() {
    return addSortByInternal('taxPercentage', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> sortByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension VariantSyncQueryWhereSortThenBy
    on QueryBuilder<VariantSync, VariantSync, QSortThenBy> {
  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByProductName() {
    return addSortByInternal('productName', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByProductNameDesc() {
    return addSortByInternal('productName', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySku() {
    return addSortByInternal('sku', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySkuDesc() {
    return addSortByInternal('sku', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByTaxName() {
    return addSortByInternal('taxName', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByTaxNameDesc() {
    return addSortByInternal('taxName', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByTaxPercentage() {
    return addSortByInternal('taxPercentage', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy>
      thenByTaxPercentageDesc() {
    return addSortByInternal('taxPercentage', Sort.desc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<VariantSync, VariantSync, QAfterSortBy> thenByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension VariantSyncQueryWhereDistinct
    on QueryBuilder<VariantSync, VariantSync, QDistinct> {
  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('productName', caseSensitive: caseSensitive);
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByRetailPrice() {
    return addDistinctByInternal('retailPrice');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('sku', caseSensitive: caseSensitive);
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctBySupplyPrice() {
    return addDistinctByInternal('supplyPrice');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctBySynced() {
    return addDistinctByInternal('synced');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByTaxName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxName', caseSensitive: caseSensitive);
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByTaxPercentage() {
    return addDistinctByInternal('taxPercentage');
  }

  QueryBuilder<VariantSync, VariantSync, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('unit', caseSensitive: caseSensitive);
  }
}

extension VariantSyncQueryProperty
    on QueryBuilder<VariantSync, VariantSync, QQueryProperty> {
  QueryBuilder<VariantSync, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<VariantSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<VariantSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<VariantSync, int, QQueryOperations> productIdProperty() {
    return addPropertyNameInternal('productId');
  }

  QueryBuilder<VariantSync, String, QQueryOperations> productNameProperty() {
    return addPropertyNameInternal('productName');
  }

  QueryBuilder<VariantSync, double, QQueryOperations> retailPriceProperty() {
    return addPropertyNameInternal('retailPrice');
  }

  QueryBuilder<VariantSync, String, QQueryOperations> skuProperty() {
    return addPropertyNameInternal('sku');
  }

  QueryBuilder<VariantSync, double, QQueryOperations> supplyPriceProperty() {
    return addPropertyNameInternal('supplyPrice');
  }

  QueryBuilder<VariantSync, bool?, QQueryOperations> syncedProperty() {
    return addPropertyNameInternal('synced');
  }

  QueryBuilder<VariantSync, String, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<VariantSync, String?, QQueryOperations> taxNameProperty() {
    return addPropertyNameInternal('taxName');
  }

  QueryBuilder<VariantSync, double?, QQueryOperations> taxPercentageProperty() {
    return addPropertyNameInternal('taxPercentage');
  }

  QueryBuilder<VariantSync, String, QQueryOperations> unitProperty() {
    return addPropertyNameInternal('unit');
  }
}
