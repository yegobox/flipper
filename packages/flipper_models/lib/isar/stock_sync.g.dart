// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetStockCollection on Isar {
  IsarCollection<Stock> get stocks => getCollection();
}

const StockSchema = CollectionSchema(
  name: 'Stock',
  schema:
      '{"name":"Stock","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"canTrackingStock","type":"Bool"},{"name":"currentStock","type":"Double"},{"name":"lowStock","type":"Double"},{"name":"productId","type":"Long"},{"name":"retailPrice","type":"Double"},{"name":"rsdQty","type":"Double"},{"name":"showLowStockAlert","type":"Bool"},{"name":"supplyPrice","type":"Double"},{"name":"value","type":"Double"},{"name":"variantId","type":"Long"}],"indexes":[{"name":"branchId","unique":false,"properties":[{"name":"branchId","type":"Value","caseSensitive":false}]},{"name":"productId","unique":false,"properties":[{"name":"productId","type":"Value","caseSensitive":false}]},{"name":"variantId_branchId","unique":false,"properties":[{"name":"variantId","type":"Value","caseSensitive":false},{"name":"branchId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'active': 0,
    'branchId': 1,
    'canTrackingStock': 2,
    'currentStock': 3,
    'lowStock': 4,
    'productId': 5,
    'retailPrice': 6,
    'rsdQty': 7,
    'showLowStockAlert': 8,
    'supplyPrice': 9,
    'value': 10,
    'variantId': 11
  },
  listProperties: {},
  indexIds: {'branchId': 0, 'productId': 1, 'variantId_branchId': 2},
  indexValueTypes: {
    'branchId': [
      IndexValueType.long,
    ],
    'productId': [
      IndexValueType.long,
    ],
    'variantId_branchId': [
      IndexValueType.long,
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _stockGetId,
  setId: _stockSetId,
  getLinks: _stockGetLinks,
  attachLinks: _stockAttachLinks,
  serializeNative: _stockSerializeNative,
  deserializeNative: _stockDeserializeNative,
  deserializePropNative: _stockDeserializePropNative,
  serializeWeb: _stockSerializeWeb,
  deserializeWeb: _stockDeserializeWeb,
  deserializePropWeb: _stockDeserializePropWeb,
  version: 3,
);

int? _stockGetId(Stock object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _stockSetId(Stock object, int id) {
  object.id = id;
}

List<IsarLinkBase> _stockGetLinks(Stock object) {
  return [];
}

void _stockSerializeNative(
    IsarCollection<Stock> collection,
    IsarRawObject rawObj,
    Stock object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
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
  final value7 = object.rsdQty;
  final _rsdQty = value7;
  final value8 = object.showLowStockAlert;
  final _showLowStockAlert = value8;
  final value9 = object.supplyPrice;
  final _supplyPrice = value9;
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
  writer.writeDouble(offsets[7], _rsdQty);
  writer.writeBool(offsets[8], _showLowStockAlert);
  writer.writeDouble(offsets[9], _supplyPrice);
  writer.writeDouble(offsets[10], _value);
  writer.writeLong(offsets[11], _variantId);
}

Stock _stockDeserializeNative(IsarCollection<Stock> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Stock();
  object.active = reader.readBoolOrNull(offsets[0]);
  object.branchId = reader.readLong(offsets[1]);
  object.canTrackingStock = reader.readBoolOrNull(offsets[2]);
  object.currentStock = reader.readDouble(offsets[3]);
  object.id = id;
  object.lowStock = reader.readDoubleOrNull(offsets[4]);
  object.productId = reader.readLong(offsets[5]);
  object.retailPrice = reader.readDoubleOrNull(offsets[6]);
  object.rsdQty = reader.readDoubleOrNull(offsets[7]);
  object.showLowStockAlert = reader.readBoolOrNull(offsets[8]);
  object.supplyPrice = reader.readDoubleOrNull(offsets[9]);
  object.value = reader.readDoubleOrNull(offsets[10]);
  object.variantId = reader.readLong(offsets[11]);
  return object;
}

P _stockDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
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
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _stockSerializeWeb(IsarCollection<Stock> collection, Stock object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'canTrackingStock', object.canTrackingStock);
  IsarNative.jsObjectSet(jsObj, 'currentStock', object.currentStock);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'lowStock', object.lowStock);
  IsarNative.jsObjectSet(jsObj, 'productId', object.productId);
  IsarNative.jsObjectSet(jsObj, 'retailPrice', object.retailPrice);
  IsarNative.jsObjectSet(jsObj, 'rsdQty', object.rsdQty);
  IsarNative.jsObjectSet(jsObj, 'showLowStockAlert', object.showLowStockAlert);
  IsarNative.jsObjectSet(jsObj, 'supplyPrice', object.supplyPrice);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  IsarNative.jsObjectSet(jsObj, 'variantId', object.variantId);
  return jsObj;
}

Stock _stockDeserializeWeb(IsarCollection<Stock> collection, dynamic jsObj) {
  final object = Stock();
  object.active = IsarNative.jsObjectGet(jsObj, 'active');
  object.branchId =
      IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
  object.canTrackingStock = IsarNative.jsObjectGet(jsObj, 'canTrackingStock');
  object.currentStock =
      IsarNative.jsObjectGet(jsObj, 'currentStock') ?? double.negativeInfinity;
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.lowStock = IsarNative.jsObjectGet(jsObj, 'lowStock');
  object.productId =
      IsarNative.jsObjectGet(jsObj, 'productId') ?? double.negativeInfinity;
  object.retailPrice = IsarNative.jsObjectGet(jsObj, 'retailPrice');
  object.rsdQty = IsarNative.jsObjectGet(jsObj, 'rsdQty');
  object.showLowStockAlert = IsarNative.jsObjectGet(jsObj, 'showLowStockAlert');
  object.supplyPrice = IsarNative.jsObjectGet(jsObj, 'supplyPrice');
  object.value = IsarNative.jsObjectGet(jsObj, 'value');
  object.variantId =
      IsarNative.jsObjectGet(jsObj, 'variantId') ?? double.negativeInfinity;
  return object;
}

P _stockDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active')) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
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
    case 'rsdQty':
      return (IsarNative.jsObjectGet(jsObj, 'rsdQty')) as P;
    case 'showLowStockAlert':
      return (IsarNative.jsObjectGet(jsObj, 'showLowStockAlert')) as P;
    case 'supplyPrice':
      return (IsarNative.jsObjectGet(jsObj, 'supplyPrice')) as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value')) as P;
    case 'variantId':
      return (IsarNative.jsObjectGet(jsObj, 'variantId') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _stockAttachLinks(IsarCollection col, int id, Stock object) {}

extension StockQueryWhereSort on QueryBuilder<Stock, Stock, QWhere> {
  QueryBuilder<Stock, Stock, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'branchId'));
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyProductId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'productId'));
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyVariantIdBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'variantId_branchId'));
  }
}

extension StockQueryWhere on QueryBuilder<Stock, Stock, QWhereClause> {
  QueryBuilder<Stock, Stock, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Stock, Stock, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idBetween(
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

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdEqualTo(int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'branchId',
      value: [branchId],
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdNotEqualTo(
      int branchId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'branchId',
        upper: [branchId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'branchId',
        lower: [branchId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'branchId',
        lower: [branchId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'branchId',
        upper: [branchId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdGreaterThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'branchId',
      lower: [branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdLessThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'branchId',
      upper: [branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdBetween(
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'branchId',
      lower: [lowerBranchId],
      includeLower: includeLower,
      upper: [upperBranchId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdEqualTo(
      int productId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'productId',
      value: [productId],
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdNotEqualTo(
      int productId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'productId',
        upper: [productId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'productId',
        lower: [productId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'productId',
        lower: [productId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'productId',
        upper: [productId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdGreaterThan(
    int productId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'productId',
      lower: [productId],
      includeLower: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdLessThan(
    int productId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'productId',
      upper: [productId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdBetween(
    int lowerProductId,
    int upperProductId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'productId',
      lower: [lowerProductId],
      includeLower: includeLower,
      upper: [upperProductId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdEqualTo(
      int variantId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'variantId_branchId',
      value: [variantId],
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdNotEqualTo(
      int variantId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_branchId',
        upper: [variantId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_branchId',
        lower: [variantId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_branchId',
        lower: [variantId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_branchId',
        upper: [variantId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdGreaterThan(
    int variantId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'variantId_branchId',
      lower: [variantId],
      includeLower: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdLessThan(
    int variantId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'variantId_branchId',
      upper: [variantId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdBetween(
    int lowerVariantId,
    int upperVariantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'variantId_branchId',
      lower: [lowerVariantId],
      includeLower: includeLower,
      upper: [upperVariantId],
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdBranchIdEqualTo(
      int variantId, int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'variantId_branchId',
      value: [variantId, branchId],
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdBranchIdNotEqualTo(
      int variantId, int branchId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_branchId',
        upper: [variantId, branchId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_branchId',
        lower: [variantId, branchId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'variantId_branchId',
        lower: [variantId, branchId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'variantId_branchId',
        upper: [variantId, branchId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause>
      variantIdEqualToBranchIdGreaterThan(
    int variantId,
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'variantId_branchId',
      lower: [variantId, branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause>
      variantIdEqualToBranchIdLessThan(
    int variantId,
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'variantId_branchId',
      upper: [variantId, branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdEqualToBranchIdBetween(
    int variantId,
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'variantId_branchId',
      lower: [variantId, lowerBranchId],
      includeLower: includeLower,
      upper: [variantId, upperBranchId],
      includeUpper: includeUpper,
    ));
  }
}

extension StockQueryFilter on QueryBuilder<Stock, Stock, QFilterCondition> {
  QueryBuilder<Stock, Stock, QAfterFilterCondition> activeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'active',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> activeEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> canTrackingStockIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'canTrackingStock',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> canTrackingStockEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'canTrackingStock',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'currentStock',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'currentStock',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'currentStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lowStock',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'lowStock',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lowStock',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'productId',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdGreaterThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdLessThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdBetween(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'retailPrice',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'retailPrice',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'retailPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'rsdQty',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'rsdQty',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'rsdQty',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'rsdQty',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> showLowStockAlertIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'showLowStockAlert',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> showLowStockAlertEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'showLowStockAlert',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'supplyPrice',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'supplyPrice',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplyPrice',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'value',
      value: null,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'variantId',
      value: value,
    ));
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdGreaterThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdLessThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdBetween(
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

extension StockQueryLinks on QueryBuilder<Stock, Stock, QFilterCondition> {}

extension StockQueryWhereSortBy on QueryBuilder<Stock, Stock, QSortBy> {
  QueryBuilder<Stock, Stock, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCanTrackingStock() {
    return addSortByInternal('canTrackingStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCanTrackingStockDesc() {
    return addSortByInternal('canTrackingStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCurrentStock() {
    return addSortByInternal('currentStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCurrentStockDesc() {
    return addSortByInternal('currentStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByLowStock() {
    return addSortByInternal('lowStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByLowStockDesc() {
    return addSortByInternal('lowStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRsdQty() {
    return addSortByInternal('rsdQty', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRsdQtyDesc() {
    return addSortByInternal('rsdQty', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByShowLowStockAlert() {
    return addSortByInternal('showLowStockAlert', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByShowLowStockAlertDesc() {
    return addSortByInternal('showLowStockAlert', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension StockQueryWhereSortThenBy on QueryBuilder<Stock, Stock, QSortThenBy> {
  QueryBuilder<Stock, Stock, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCanTrackingStock() {
    return addSortByInternal('canTrackingStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCanTrackingStockDesc() {
    return addSortByInternal('canTrackingStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCurrentStock() {
    return addSortByInternal('currentStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCurrentStockDesc() {
    return addSortByInternal('currentStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByLowStock() {
    return addSortByInternal('lowStock', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByLowStockDesc() {
    return addSortByInternal('lowStock', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByProductId() {
    return addSortByInternal('productId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByProductIdDesc() {
    return addSortByInternal('productId', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRetailPrice() {
    return addSortByInternal('retailPrice', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRetailPriceDesc() {
    return addSortByInternal('retailPrice', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRsdQty() {
    return addSortByInternal('rsdQty', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRsdQtyDesc() {
    return addSortByInternal('rsdQty', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByShowLowStockAlert() {
    return addSortByInternal('showLowStockAlert', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByShowLowStockAlertDesc() {
    return addSortByInternal('showLowStockAlert', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenBySupplyPrice() {
    return addSortByInternal('supplyPrice', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenBySupplyPriceDesc() {
    return addSortByInternal('supplyPrice', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByVariantId() {
    return addSortByInternal('variantId', Sort.asc);
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByVariantIdDesc() {
    return addSortByInternal('variantId', Sort.desc);
  }
}

extension StockQueryWhereDistinct on QueryBuilder<Stock, Stock, QDistinct> {
  QueryBuilder<Stock, Stock, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByCanTrackingStock() {
    return addDistinctByInternal('canTrackingStock');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByCurrentStock() {
    return addDistinctByInternal('currentStock');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByLowStock() {
    return addDistinctByInternal('lowStock');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByProductId() {
    return addDistinctByInternal('productId');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByRetailPrice() {
    return addDistinctByInternal('retailPrice');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByRsdQty() {
    return addDistinctByInternal('rsdQty');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByShowLowStockAlert() {
    return addDistinctByInternal('showLowStockAlert');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctBySupplyPrice() {
    return addDistinctByInternal('supplyPrice');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByVariantId() {
    return addDistinctByInternal('variantId');
  }
}

extension StockQueryProperty on QueryBuilder<Stock, Stock, QQueryProperty> {
  QueryBuilder<Stock, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Stock, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Stock, bool?, QQueryOperations> canTrackingStockProperty() {
    return addPropertyNameInternal('canTrackingStock');
  }

  QueryBuilder<Stock, double, QQueryOperations> currentStockProperty() {
    return addPropertyNameInternal('currentStock');
  }

  QueryBuilder<Stock, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Stock, double?, QQueryOperations> lowStockProperty() {
    return addPropertyNameInternal('lowStock');
  }

  QueryBuilder<Stock, int, QQueryOperations> productIdProperty() {
    return addPropertyNameInternal('productId');
  }

  QueryBuilder<Stock, double?, QQueryOperations> retailPriceProperty() {
    return addPropertyNameInternal('retailPrice');
  }

  QueryBuilder<Stock, double?, QQueryOperations> rsdQtyProperty() {
    return addPropertyNameInternal('rsdQty');
  }

  QueryBuilder<Stock, bool?, QQueryOperations> showLowStockAlertProperty() {
    return addPropertyNameInternal('showLowStockAlert');
  }

  QueryBuilder<Stock, double?, QQueryOperations> supplyPriceProperty() {
    return addPropertyNameInternal('supplyPrice');
  }

  QueryBuilder<Stock, double?, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }

  QueryBuilder<Stock, int, QQueryOperations> variantIdProperty() {
    return addPropertyNameInternal('variantId');
  }
}
