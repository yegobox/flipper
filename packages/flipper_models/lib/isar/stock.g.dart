// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetStockCollection on Isar {
  IsarCollection<Stock> get stocks => collection();
}

const StockSchema = CollectionSchema(
  name: r'Stock',
  schema:
      r'{"name":"Stock","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"canTrackingStock","type":"Bool"},{"name":"currentStock","type":"Double"},{"name":"lowStock","type":"Double"},{"name":"productId","type":"Long"},{"name":"retailPrice","type":"Double"},{"name":"rsdQty","type":"Double"},{"name":"showLowStockAlert","type":"Bool"},{"name":"supplyPrice","type":"Double"},{"name":"value","type":"Double"},{"name":"variantId","type":"Long"}],"indexes":[{"name":"branchId","unique":false,"replace":false,"properties":[{"name":"branchId","type":"Value","caseSensitive":false}]},{"name":"productId","unique":false,"replace":false,"properties":[{"name":"productId","type":"Value","caseSensitive":false}]},{"name":"variantId_branchId","unique":false,"replace":false,"properties":[{"name":"variantId","type":"Value","caseSensitive":false},{"name":"branchId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'active': 0,
    r'branchId': 1,
    r'canTrackingStock': 2,
    r'currentStock': 3,
    r'lowStock': 4,
    r'productId': 5,
    r'retailPrice': 6,
    r'rsdQty': 7,
    r'showLowStockAlert': 8,
    r'supplyPrice': 9,
    r'value': 10,
    r'variantId': 11
  },
  listProperties: {},
  indexIds: {r'branchId': 0, r'productId': 1, r'variantId_branchId': 2},
  indexValueTypes: {
    r'branchId': [
      IndexValueType.long,
    ],
    r'productId': [
      IndexValueType.long,
    ],
    r'variantId_branchId': [
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
  version: 4,
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

List<IsarLinkBase<dynamic>> _stockGetLinks(Stock object) {
  return [];
}

void _stockSerializeNative(IsarCollection<Stock> collection, IsarCObject cObj,
    Stock object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  final size = (staticSize) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBool(offsets[0], object.active);
  writer.writeLong(offsets[1], object.branchId);
  writer.writeBool(offsets[2], object.canTrackingStock);
  writer.writeDouble(offsets[3], object.currentStock);
  writer.writeDouble(offsets[4], object.lowStock);
  writer.writeLong(offsets[5], object.productId);
  writer.writeDouble(offsets[6], object.retailPrice);
  writer.writeDouble(offsets[7], object.rsdQty);
  writer.writeBool(offsets[8], object.showLowStockAlert);
  writer.writeDouble(offsets[9], object.supplyPrice);
  writer.writeDouble(offsets[10], object.value);
  writer.writeLong(offsets[11], object.variantId);
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _stockSerializeWeb(IsarCollection<Stock> collection, Stock object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'active', object.active);
  IsarNative.jsObjectSet(jsObj, r'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, r'canTrackingStock', object.canTrackingStock);
  IsarNative.jsObjectSet(jsObj, r'currentStock', object.currentStock);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'lowStock', object.lowStock);
  IsarNative.jsObjectSet(jsObj, r'productId', object.productId);
  IsarNative.jsObjectSet(jsObj, r'retailPrice', object.retailPrice);
  IsarNative.jsObjectSet(jsObj, r'rsdQty', object.rsdQty);
  IsarNative.jsObjectSet(jsObj, r'showLowStockAlert', object.showLowStockAlert);
  IsarNative.jsObjectSet(jsObj, r'supplyPrice', object.supplyPrice);
  IsarNative.jsObjectSet(jsObj, r'value', object.value);
  IsarNative.jsObjectSet(jsObj, r'variantId', object.variantId);
  return jsObj;
}

Stock _stockDeserializeWeb(IsarCollection<Stock> collection, Object jsObj) {
  final object = Stock();
  object.active = IsarNative.jsObjectGet(jsObj, r'active');
  object.branchId = IsarNative.jsObjectGet(jsObj, r'branchId') ??
      (double.negativeInfinity as int);
  object.canTrackingStock = IsarNative.jsObjectGet(jsObj, r'canTrackingStock');
  object.currentStock =
      IsarNative.jsObjectGet(jsObj, r'currentStock') ?? double.negativeInfinity;
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.lowStock = IsarNative.jsObjectGet(jsObj, r'lowStock');
  object.productId = IsarNative.jsObjectGet(jsObj, r'productId') ??
      (double.negativeInfinity as int);
  object.retailPrice = IsarNative.jsObjectGet(jsObj, r'retailPrice');
  object.rsdQty = IsarNative.jsObjectGet(jsObj, r'rsdQty');
  object.showLowStockAlert =
      IsarNative.jsObjectGet(jsObj, r'showLowStockAlert');
  object.supplyPrice = IsarNative.jsObjectGet(jsObj, r'supplyPrice');
  object.value = IsarNative.jsObjectGet(jsObj, r'value');
  object.variantId = IsarNative.jsObjectGet(jsObj, r'variantId') ??
      (double.negativeInfinity as int);
  return object;
}

P _stockDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'active':
      return (IsarNative.jsObjectGet(jsObj, r'active')) as P;
    case r'branchId':
      return (IsarNative.jsObjectGet(jsObj, r'branchId') ??
          (double.negativeInfinity as int)) as P;
    case r'canTrackingStock':
      return (IsarNative.jsObjectGet(jsObj, r'canTrackingStock')) as P;
    case r'currentStock':
      return (IsarNative.jsObjectGet(jsObj, r'currentStock') ??
          double.negativeInfinity) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'lowStock':
      return (IsarNative.jsObjectGet(jsObj, r'lowStock')) as P;
    case r'productId':
      return (IsarNative.jsObjectGet(jsObj, r'productId') ??
          (double.negativeInfinity as int)) as P;
    case r'retailPrice':
      return (IsarNative.jsObjectGet(jsObj, r'retailPrice')) as P;
    case r'rsdQty':
      return (IsarNative.jsObjectGet(jsObj, r'rsdQty')) as P;
    case r'showLowStockAlert':
      return (IsarNative.jsObjectGet(jsObj, r'showLowStockAlert')) as P;
    case r'supplyPrice':
      return (IsarNative.jsObjectGet(jsObj, r'supplyPrice')) as P;
    case r'value':
      return (IsarNative.jsObjectGet(jsObj, r'value')) as P;
    case r'variantId':
      return (IsarNative.jsObjectGet(jsObj, r'variantId') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _stockAttachLinks(IsarCollection<dynamic> col, int id, Stock object) {}

extension StockQueryWhereSort on QueryBuilder<Stock, Stock, QWhere> {
  QueryBuilder<Stock, Stock, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'branchId'),
      );
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'productId'),
      );
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhere> anyVariantIdBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'variantId_branchId'),
      );
    });
  }
}

extension StockQueryWhere on QueryBuilder<Stock, Stock, QWhereClause> {
  QueryBuilder<Stock, Stock, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Stock, Stock, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> idBetween(
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

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdEqualTo(int branchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'branchId',
        value: [branchId],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdNotEqualTo(
      int branchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'branchId',
              lower: [],
              upper: [branchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'branchId',
              lower: [branchId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'branchId',
              lower: [branchId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'branchId',
              lower: [],
              upper: [branchId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdGreaterThan(
    int branchId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'branchId',
        lower: [branchId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdLessThan(
    int branchId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'branchId',
        lower: [],
        upper: [branchId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> branchIdBetween(
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'branchId',
        lower: [lowerBranchId],
        includeLower: includeLower,
        upper: [upperBranchId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdEqualTo(
      int productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdNotEqualTo(
      int productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdGreaterThan(
    int productId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [productId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdLessThan(
    int productId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [],
        upper: [productId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> productIdBetween(
    int lowerProductId,
    int upperProductId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'productId',
        lower: [lowerProductId],
        includeLower: includeLower,
        upper: [upperProductId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdEqualToAnyBranchId(
      int variantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_branchId',
        value: [variantId],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdNotEqualToAnyBranchId(
      int variantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdGreaterThanAnyBranchId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [variantId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdLessThanAnyBranchId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [],
        upper: [variantId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdBetweenAnyBranchId(
    int lowerVariantId,
    int upperVariantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [lowerVariantId],
        includeLower: includeLower,
        upper: [upperVariantId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdBranchIdEqualTo(
      int variantId, int branchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_branchId',
        value: [variantId, branchId],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause>
      variantIdEqualToBranchIdNotEqualTo(int variantId, int branchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId],
              upper: [variantId, branchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId, branchId],
              includeLower: false,
              upper: [variantId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId, branchId],
              includeLower: false,
              upper: [variantId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_branchId',
              lower: [variantId],
              upper: [variantId, branchId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause>
      variantIdEqualToBranchIdGreaterThan(
    int variantId,
    int branchId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [variantId, branchId],
        includeLower: include,
        upper: [variantId],
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause>
      variantIdEqualToBranchIdLessThan(
    int variantId,
    int branchId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [variantId],
        upper: [variantId, branchId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterWhereClause> variantIdEqualToBranchIdBetween(
    int variantId,
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_branchId',
        lower: [variantId, lowerBranchId],
        includeLower: includeLower,
        upper: [variantId, upperBranchId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StockQueryFilter on QueryBuilder<Stock, Stock, QFilterCondition> {
  QueryBuilder<Stock, Stock, QAfterFilterCondition> activeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'active',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> activeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'branchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> canTrackingStockIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'canTrackingStock',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> canTrackingStockEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canTrackingStock',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockGreaterThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentStock',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'currentStock',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> currentStockBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStock',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lowStock',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lowStock',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'lowStock',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> lowStockBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowStock',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> productIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'retailPrice',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> retailPriceBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retailPrice',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rsdQty',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rsdQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'rsdQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> rsdQtyBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rsdQty',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> showLowStockAlertIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showLowStockAlert',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> showLowStockAlertEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showLowStockAlert',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supplyPrice',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supplyPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'supplyPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> supplyPriceBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supplyPrice',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueGreaterThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueLessThan(
      double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> valueBetween(
      double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<Stock, Stock, QAfterFilterCondition> variantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'variantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StockQueryLinks on QueryBuilder<Stock, Stock, QFilterCondition> {}

extension StockQueryWhereSortBy on QueryBuilder<Stock, Stock, QSortBy> {
  QueryBuilder<Stock, Stock, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCanTrackingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByCurrentStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByLowStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByShowLowStockAlert() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLowStockAlert', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByShowLowStockAlertDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLowStockAlert', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> sortByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension StockQueryWhereSortThenBy on QueryBuilder<Stock, Stock, QSortThenBy> {
  QueryBuilder<Stock, Stock, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCanTrackingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByCurrentStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByLowStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rsdQty', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByShowLowStockAlert() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLowStockAlert', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByShowLowStockAlertDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showLowStockAlert', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplyPrice', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<Stock, Stock, QAfterSortBy> thenByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension StockQueryWhereDistinct on QueryBuilder<Stock, Stock, QDistinct> {
  QueryBuilder<Stock, Stock, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branchId');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canTrackingStock');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStock');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowStock');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retailPrice');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rsdQty');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByShowLowStockAlert() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showLowStockAlert');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplyPrice');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }

  QueryBuilder<Stock, Stock, QDistinct> distinctByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variantId');
    });
  }
}

extension StockQueryProperty on QueryBuilder<Stock, Stock, QQueryProperty> {
  QueryBuilder<Stock, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Stock, bool?, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<Stock, int, QQueryOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branchId');
    });
  }

  QueryBuilder<Stock, bool?, QQueryOperations> canTrackingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canTrackingStock');
    });
  }

  QueryBuilder<Stock, double, QQueryOperations> currentStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStock');
    });
  }

  QueryBuilder<Stock, double?, QQueryOperations> lowStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowStock');
    });
  }

  QueryBuilder<Stock, int, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<Stock, double?, QQueryOperations> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retailPrice');
    });
  }

  QueryBuilder<Stock, double?, QQueryOperations> rsdQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rsdQty');
    });
  }

  QueryBuilder<Stock, bool?, QQueryOperations> showLowStockAlertProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showLowStockAlert');
    });
  }

  QueryBuilder<Stock, double?, QQueryOperations> supplyPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplyPrice');
    });
  }

  QueryBuilder<Stock, double?, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }

  QueryBuilder<Stock, int, QQueryOperations> variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variantId');
    });
  }
}
