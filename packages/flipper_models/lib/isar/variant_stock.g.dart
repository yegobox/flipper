// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_stock.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVariantStockCollection on Isar {
  IsarCollection<VariantStock> get variantStocks => this.collection();
}

final VariantStockSchema = CollectionSchema(
  name: r'VariantStock',
  id: BigInt.parse("1510484417733258098").toInt(),
  properties: {
    r'canTrackingStock': PropertySchema(
      id: BigInt.parse("0").toInt(),
      name: r'canTrackingStock',
      type: IsarType.bool,
    ),
    r'currentStock': PropertySchema(
      id: BigInt.parse("1").toInt(),
      name: r'currentStock',
      type: IsarType.double,
    ),
    r'fbranchId': PropertySchema(
      id: BigInt.parse("2").toInt(),
      name: r'fbranchId',
      type: IsarType.string,
    ),
    r'fvariantId': PropertySchema(
      id: BigInt.parse("3").toInt(),
      name: r'fvariantId',
      type: IsarType.string,
    ),
    r'lowStock': PropertySchema(
      id: BigInt.parse("4").toInt(),
      name: r'lowStock',
      type: IsarType.double,
    ),
    r'productName': PropertySchema(
      id: BigInt.parse("5").toInt(),
      name: r'productName',
      type: IsarType.string,
    ),
    r'retailPrice': PropertySchema(
      id: BigInt.parse("6").toInt(),
      name: r'retailPrice',
      type: IsarType.double,
    ),
    r'sku': PropertySchema(
      id: BigInt.parse("7").toInt(),
      name: r'sku',
      type: IsarType.string,
    ),
    r'taxName': PropertySchema(
      id: BigInt.parse("8").toInt(),
      name: r'taxName',
      type: IsarType.string,
    ),
    r'taxPercentage': PropertySchema(
      id: BigInt.parse("9").toInt(),
      name: r'taxPercentage',
      type: IsarType.double,
    ),
    r'unit': PropertySchema(
      id: BigInt.parse("10").toInt(),
      name: r'unit',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: BigInt.parse("11").toInt(),
      name: r'value',
      type: IsarType.double,
    ),
    r'variantName': PropertySchema(
      id: BigInt.parse("12").toInt(),
      name: r'variantName',
      type: IsarType.string,
    )
  },
  estimateSize: _variantStockEstimateSize,
  serialize: _variantStockSerialize,
  deserialize: _variantStockDeserialize,
  deserializeProp: _variantStockDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _variantStockGetId,
  getLinks: _variantStockGetLinks,
  attach: _variantStockAttach,
  version: '3.1.0',
);

int _variantStockEstimateSize(
  VariantStock object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fbranchId.length * 3;
  bytesCount += 3 + object.fvariantId.length * 3;
  bytesCount += 3 + object.productName.length * 3;
  bytesCount += 3 + object.sku.length * 3;
  {
    final value = object.taxName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.unit.length * 3;
  bytesCount += 3 + object.variantName.length * 3;
  return bytesCount;
}

void _variantStockSerialize(
  VariantStock object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.canTrackingStock);
  writer.writeDouble(offsets[1], object.currentStock);
  writer.writeString(offsets[2], object.fbranchId);
  writer.writeString(offsets[3], object.fvariantId);
  writer.writeDouble(offsets[4], object.lowStock);
  writer.writeString(offsets[5], object.productName);
  writer.writeDouble(offsets[6], object.retailPrice);
  writer.writeString(offsets[7], object.sku);
  writer.writeString(offsets[8], object.taxName);
  writer.writeDouble(offsets[9], object.taxPercentage);
  writer.writeString(offsets[10], object.unit);
  writer.writeDouble(offsets[11], object.value);
  writer.writeString(offsets[12], object.variantName);
}

VariantStock _variantStockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
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

P _variantStockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
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
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _variantStockGetId(VariantStock object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _variantStockGetLinks(VariantStock object) {
  return [];
}

void _variantStockAttach(
    IsarCollection<dynamic> col, Id id, VariantStock object) {
  object.id = id;
}

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
  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idNotEqualTo(
      Id id) {
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
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
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
      currentStockEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      currentStockBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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
      fbranchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fbranchId',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fbranchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fbranchId',
        value: '',
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fvariantId',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      fvariantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fvariantId',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> idGreaterThan(
    Id value, {
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
    Id value, {
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
    Id lower,
    Id upper, {
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
      lowStockIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lowStock',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      lowStockBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowStock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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
      productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retailPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retailPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retailPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      retailPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retailPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sku',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sku',
        value: '',
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
      taxNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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
      taxNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxName',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxName',
        value: '',
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
      taxPercentageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxPercentage',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      taxPercentageBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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
      unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool include = false,
    bool caseSensitive = true,
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
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
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

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variantName',
        value: '',
      ));
    });
  }

  QueryBuilder<VariantStock, VariantStock, QAfterFilterCondition>
      variantNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'variantName',
        value: '',
      ));
    });
  }
}

extension VariantStockQueryObject
    on QueryBuilder<VariantStock, VariantStock, QFilterCondition> {}

extension VariantStockQueryLinks
    on QueryBuilder<VariantStock, VariantStock, QFilterCondition> {}

extension VariantStockQuerySortBy
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

extension VariantStockQuerySortThenBy
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
  QueryBuilder<VariantStock, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

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
