// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVoucherCollection on Isar {
  IsarCollection<Voucher> get vouchers => this.collection();
}

final VoucherSchema = CollectionSchema(
  name: r'Voucher',
  id: BigInt.parse("6548118931563840322").toInt(),
  properties: {
    r'createdAt': PropertySchema(
      id: BigInt.parse("0").toInt(),
      name: r'createdAt',
      type: IsarType.long,
    ),
    r'descriptor': PropertySchema(
      id: BigInt.parse("1").toInt(),
      name: r'descriptor',
      type: IsarType.string,
    ),
    r'interval': PropertySchema(
      id: BigInt.parse("2").toInt(),
      name: r'interval',
      type: IsarType.long,
    ),
    r'used': PropertySchema(
      id: BigInt.parse("3").toInt(),
      name: r'used',
      type: IsarType.bool,
    ),
    r'usedAt': PropertySchema(
      id: BigInt.parse("4").toInt(),
      name: r'usedAt',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: BigInt.parse("5").toInt(),
      name: r'value',
      type: IsarType.long,
    )
  },
  estimateSize: _voucherEstimateSize,
  serialize: _voucherSerialize,
  deserialize: _voucherDeserialize,
  deserializeProp: _voucherDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _voucherGetId,
  getLinks: _voucherGetLinks,
  attach: _voucherAttach,
  version: '3.1.0',
);

int _voucherEstimateSize(
  Voucher object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.descriptor.length * 3;
  return bytesCount;
}

void _voucherSerialize(
  Voucher object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.descriptor);
  writer.writeLong(offsets[2], object.interval);
  writer.writeBool(offsets[3], object.used);
  writer.writeLong(offsets[4], object.usedAt);
  writer.writeLong(offsets[5], object.value);
}

Voucher _voucherDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Voucher();
  object.createdAt = reader.readLong(offsets[0]);
  object.descriptor = reader.readString(offsets[1]);
  object.id = id;
  object.interval = reader.readLong(offsets[2]);
  object.used = reader.readBool(offsets[3]);
  object.usedAt = reader.readLong(offsets[4]);
  object.value = reader.readLong(offsets[5]);
  return object;
}

P _voucherDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _voucherGetId(Voucher object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _voucherGetLinks(Voucher object) {
  return [];
}

void _voucherAttach(IsarCollection<dynamic> col, Id id, Voucher object) {
  object.id = id;
}

extension VoucherQueryWhereSort on QueryBuilder<Voucher, Voucher, QWhere> {
  QueryBuilder<Voucher, Voucher, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VoucherQueryWhere on QueryBuilder<Voucher, Voucher, QWhereClause> {
  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idBetween(
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

extension VoucherQueryFilter
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descriptor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descriptor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptor',
        value: '',
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descriptor',
        value: '',
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'used',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'usedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'usedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'usedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VoucherQueryObject
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {}

extension VoucherQueryLinks
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {}

extension VoucherQuerySortBy on QueryBuilder<Voucher, Voucher, QSortBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedAt', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedAt', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension VoucherQuerySortThenBy
    on QueryBuilder<Voucher, Voucher, QSortThenBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedAt', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usedAt', Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension VoucherQueryWhereDistinct
    on QueryBuilder<Voucher, Voucher, QDistinct> {
  QueryBuilder<Voucher, Voucher, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descriptor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'used');
    });
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usedAt');
    });
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension VoucherQueryProperty
    on QueryBuilder<Voucher, Voucher, QQueryProperty> {
  QueryBuilder<Voucher, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Voucher, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Voucher, String, QQueryOperations> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptor');
    });
  }

  QueryBuilder<Voucher, int, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<Voucher, bool, QQueryOperations> usedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'used');
    });
  }

  QueryBuilder<Voucher, int, QQueryOperations> usedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usedAt');
    });
  }

  QueryBuilder<Voucher, int, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
