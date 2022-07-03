// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetVariantStockCollection on Isar {
  IsarCollection<VariantStock> get variantStocks => getCollection();
}

const VariantStockSchema = CollectionSchema(
  name: r'VariantStock',
  schema:
      r'{"name":"VariantStock","idName":"id","properties":[{"name":"canTrackingStock","type":"Bool"},{"name":"currentStock","type":"Double"},{"name":"fbranchId","type":"String"},{"name":"fvariantId","type":"String"},{"name":"lowStock","type":"Double"},{"name":"productName","type":"String"},{"name":"retailPrice","type":"Double"},{"name":"sku","type":"String"},{"name":"taxName","type":"String"},{"name":"taxPercentage","type":"Double"},{"name":"unit","type":"String"},{"name":"value","type":"Double"},{"name":"variantName","type":"String"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'canTrackingStock': 0,
    r'currentStock': 1,
    r'fbranchId': 2,
    r'fvariantId': 3,
    r'lowStock': 4,
    r'productName': 5,
    r'retailPrice': 6,
    r'sku': 7,
    r'taxName': 8,
    r'taxPercentage': 9,
    r'unit': 10,
    r'value': 11,
    r'variantName': 12
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _variantStockGetId,
  setId: _variantStockSetId,
  getLinks: _variantStockGetLinks,
  attachLinks: _variantStockAttachLinks,
  serializeNative: _variantStockSerializeNative,
  deserializeNative: _variantStockDeserializeNative,
  deserializePropNative: _variantStockDeserializePropNative,
  serializeWeb: _variantStockSerializeWeb,
  deserializeWeb: _variantStockDeserializeWeb,
  deserializePropWeb: _variantStockDeserializePropWeb,
  version: 4,
);

int? _variantStockGetId(VariantStock object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _variantStockSetId(VariantStock object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _variantStockGetLinks(VariantStock object) {
  return [];
}

void _variantStockSerializeNative(
    IsarCollection<VariantStock> collection,
    IsarCObject cObj,
    VariantStock object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final fbranchId$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.fbranchId);
  final fvariantId$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.fvariantId);
  final productName$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.productName);
  final sku$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.sku);
  IsarUint8List? taxName$Bytes;
  final taxName$Value = object.taxName;
  if (taxName$Value != null) {
    taxName$Bytes = IsarBinaryWriter.utf8Encoder.convert(taxName$Value);
  }
  final unit$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.unit);
  final variantName$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.variantName);
  final size = (staticSize +
      (fbranchId$Bytes.length) +
      (fvariantId$Bytes.length) +
      (productName$Bytes.length) +
      (sku$Bytes.length) +
      (taxName$Bytes?.length ?? 0) +
      (unit$Bytes.length) +
      (variantName$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBool(offsets[0], object.canTrackingStock);
  writer.writeDouble(offsets[1], object.currentStock);
  writer.writeBytes(offsets[2], fbranchId$Bytes);
  writer.writeBytes(offsets[3], fvariantId$Bytes);
  writer.writeDouble(offsets[4], object.lowStock);
  writer.writeBytes(offsets[5], productName$Bytes);
  writer.writeDouble(offsets[6], object.retailPrice);
  writer.writeBytes(offsets[7], sku$Bytes);
  writer.writeBytes(offsets[8], taxName$Bytes);
  writer.writeDouble(offsets[9], object.taxPercentage);
  writer.writeBytes(offsets[10], unit$Bytes);
  writer.writeDouble(offsets[11], object.value);
  writer.writeBytes(offsets[12], variantName$Bytes);
}

VariantStock _variantStockDeserializeNative(
    IsarCollection<VariantStock> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = VariantStock(
    canTrackingStock: reader.readBool(offsets[0]),
    currentStock: reader.readDouble(offsets[1]),
    fbranchId: reader.readString(offsets[2]),
    fvariantId: reader.readString(offsets[3]),
    id: id,
    lowStock: reader.readDoubleOrNull(offsets[4]),
    productName: reader.readString(offsets[5]),
    retailPrice: reader.readDouble(offsets[6]),
    sku: reader.readString(offsets[7]),
    taxName: reader.readStringOrNull(offsets[8]),
    taxPercentage: reader.readDoubleOrNull(offsets[9]),
    unit: reader.readString(offsets[10]),
    value: reader.readDouble(offsets[11]),
    variantName: reader.readString(offsets[12]),
  );
  return object;
}

P _variantStockDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _variantStockSerializeWeb(
    IsarCollection<VariantStock> collection, VariantStock object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'canTrackingStock', object.canTrackingStock);
  IsarNative.jsObjectSet(jsObj, r'currentStock', object.currentStock);
  IsarNative.jsObjectSet(jsObj, r'fbranchId', object.fbranchId);
  IsarNative.jsObjectSet(jsObj, r'fvariantId', object.fvariantId);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'lowStock', object.lowStock);
  IsarNative.jsObjectSet(jsObj, r'productName', object.productName);
  IsarNative.jsObjectSet(jsObj, r'retailPrice', object.retailPrice);
  IsarNative.jsObjectSet(jsObj, r'sku', object.sku);
  IsarNative.jsObjectSet(jsObj, r'taxName', object.taxName);
  IsarNative.jsObjectSet(jsObj, r'taxPercentage', object.taxPercentage);
  IsarNative.jsObjectSet(jsObj, r'unit', object.unit);
  IsarNative.jsObjectSet(jsObj, r'value', object.value);
  IsarNative.jsObjectSet(jsObj, r'variantName', object.variantName);
  return jsObj;
}

VariantStock _variantStockDeserializeWeb(
    IsarCollection<VariantStock> collection, Object jsObj) {
  final object = VariantStock(
    canTrackingStock:
        IsarNative.jsObjectGet(jsObj, r'canTrackingStock') ?? false,
    currentStock: IsarNative.jsObjectGet(jsObj, r'currentStock') ??
        double.negativeInfinity,
    fbranchId: IsarNative.jsObjectGet(jsObj, r'fbranchId') ?? '',
    fvariantId: IsarNative.jsObjectGet(jsObj, r'fvariantId') ?? '',
    id: IsarNative.jsObjectGet(jsObj, r'id') ??
        (double.negativeInfinity as int),
    lowStock: IsarNative.jsObjectGet(jsObj, r'lowStock'),
    productName: IsarNative.jsObjectGet(jsObj, r'productName') ?? '',
    retailPrice: IsarNative.jsObjectGet(jsObj, r'retailPrice') ??
        double.negativeInfinity,
    sku: IsarNative.jsObjectGet(jsObj, r'sku') ?? '',
    taxName: IsarNative.jsObjectGet(jsObj, r'taxName'),
    taxPercentage: IsarNative.jsObjectGet(jsObj, r'taxPercentage'),
    unit: IsarNative.jsObjectGet(jsObj, r'unit') ?? '',
    value: IsarNative.jsObjectGet(jsObj, r'value') ?? double.negativeInfinity,
    variantName: IsarNative.jsObjectGet(jsObj, r'variantName') ?? '',
  );
  return object;
}

P _variantStockDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'canTrackingStock':
      return (IsarNative.jsObjectGet(jsObj, r'canTrackingStock') ?? false) as P;
    case r'currentStock':
      return (IsarNative.jsObjectGet(jsObj, r'currentStock') ??
          double.negativeInfinity) as P;
    case r'fbranchId':
      return (IsarNative.jsObjectGet(jsObj, r'fbranchId') ?? '') as P;
    case r'fvariantId':
      return (IsarNative.jsObjectGet(jsObj, r'fvariantId') ?? '') as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id') ??
          (double.negativeInfinity as int)) as P;
    case r'lowStock':
      return (IsarNative.jsObjectGet(jsObj, r'lowStock')) as P;
    case r'productName':
      return (IsarNative.jsObjectGet(jsObj, r'productName') ?? '') as P;
    case r'retailPrice':
      return (IsarNative.jsObjectGet(jsObj, r'retailPrice') ??
          double.negativeInfinity) as P;
    case r'sku':
      return (IsarNative.jsObjectGet(jsObj, r'sku') ?? '') as P;
    case r'taxName':
      return (IsarNative.jsObjectGet(jsObj, r'taxName')) as P;
    case r'taxPercentage':
      return (IsarNative.jsObjectGet(jsObj, r'taxPercentage')) as P;
    case r'unit':
      return (IsarNative.jsObjectGet(jsObj, r'unit') ?? '') as P;
    case r'value':
      return (IsarNative.jsObjectGet(jsObj, r'value') ??
          double.negativeInfinity) as P;
    case r'variantName':
      return (IsarNative.jsObjectGet(jsObj, r'variantName') ?? '') as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _variantStockAttachLinks(
    IsarCollection<dynamic> col, int id, VariantStock object) {}

extension VariantStockQueryWhereSort
    on QueryBuilder<VariantStock, VariantStock, QWhere> {
  QueryBuilder<VariantStock, VariantStock, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VariantStockQueryWhere
    on QueryBuilder<VariantStock, VariantStock, QWhereClause> {
  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idBetween(
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
}

extension VariantStockQueryFilter
    on QueryBuilder<VariantStock, VariantStock, QFilterCondition> {
  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      canTrackingStockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canTrackingStock',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentStock',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'currentStock',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockBetween(double lower, double upper) {
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fbranchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fbranchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fbranchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fvariantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fvariantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fvariantId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lowStock',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockGreaterThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lowStock',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockLessThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'lowStock',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockBetween(double? lower, double? upper) {
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'retailPrice',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceBetween(double lower, double upper) {
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      skuGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sku',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sku',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sku',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxName',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxPercentage',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageGreaterThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageLessThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'taxPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageBetween(double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxPercentage',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      unitGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      valueGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> valueLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> valueBetween(
      double lower, double upper) {
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'variantName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'variantName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'variantName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension VariantStockQueryLinks
    on QueryBuilder<VariantStock, VariantStock, QFilterCondition> {}

extension VariantStockQueryWhereSortBy
    on QueryBuilder<VariantStock, VariantStock, QSortBy> {
  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByCanTrackingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByCurrentStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByFbranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbranchId', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByFbranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbranchId', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByFvariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fvariantId', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByFvariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fvariantId', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByLowStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByTaxName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByTaxNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> sortByVariantName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      sortByVariantNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantName', Sort.desc);
    });
  }
}

extension VariantStockQueryWhereSortThenBy
    on QueryBuilder<VariantStock, VariantStock, QSortThenBy> {
  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByCanTrackingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canTrackingStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByCurrentStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByFbranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbranchId', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByFbranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fbranchId', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByFvariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fvariantId', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByFvariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fvariantId', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByLowStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStock', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retailPrice', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByTaxName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByTaxNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxName', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy> thenByVariantName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantName', Sort.asc);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterSortBy>
      thenByVariantNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantName', Sort.desc);
    });
  }
}

extension VariantStockQueryWhereDistinct
    on QueryBuilder<VariantStock, VariantStock, QDistinct> {
  QueryBuilder<VariantStock, VariantStock, QDistinct>
      distinctByCanTrackingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canTrackingStock');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByCurrentStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStock');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByFbranchId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fbranchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByFvariantId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fvariantId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByLowStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowStock');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retailPrice');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByTaxName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct>
      distinctByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxPercentage');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }

  QueryBuilder<VariantStock, VariantStock, QDistinct> distinctByVariantName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variantName', caseSensitive: caseSensitive);
    });
  }
}

extension VariantStockQueryProperty
    on QueryBuilder<VariantStock, VariantStock, QQueryProperty> {
  QueryBuilder<VariantStock, bool, QQueryOperations>
      canTrackingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canTrackingStock');
    });
  }

  QueryBuilder<VariantStock, double, QQueryOperations> currentStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStock');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> fbranchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fbranchId');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> fvariantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fvariantId');
    });
  }

  QueryBuilder<VariantStock, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VariantStock, double?, QQueryOperations> lowStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowStock');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<VariantStock, double, QQueryOperations> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retailPrice');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sku');
    });
  }

  QueryBuilder<VariantStock, String?, QQueryOperations> taxNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxName');
    });
  }

  QueryBuilder<VariantStock, double?, QQueryOperations>
      taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxPercentage');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }

  QueryBuilder<VariantStock, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }

  QueryBuilder<VariantStock, String, QQueryOperations> variantNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variantName');
    });
  }
}
