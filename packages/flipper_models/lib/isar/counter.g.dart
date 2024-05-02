// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetICounterCollection on Isar {
  IsarCollection<ICounter> get iCounters => this.collection();
}

const ICounterSchema = CollectionSchema(
  name: r'ICounter',
  id: 2262460088481352541,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'branchId': PropertySchema(
      id: 1,
      name: r'branchId',
      type: IsarType.long,
    ),
    r'businessId': PropertySchema(
      id: 2,
      name: r'businessId',
      type: IsarType.long,
    ),
    r'curRcptNo': PropertySchema(
      id: 3,
      name: r'curRcptNo',
      type: IsarType.long,
    ),
    r'deletedAt': PropertySchema(
      id: 4,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'lastTouched': PropertySchema(
      id: 5,
      name: r'lastTouched',
      type: IsarType.dateTime,
    ),
    r'receiptType': PropertySchema(
      id: 6,
      name: r'receiptType',
      type: IsarType.string,
    ),
    r'totRcptNo': PropertySchema(
      id: 7,
      name: r'totRcptNo',
      type: IsarType.long,
    )
  },
  estimateSize: _iCounterEstimateSize,
  serialize: _iCounterSerialize,
  deserialize: _iCounterDeserialize,
  deserializeProp: _iCounterDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _iCounterGetId,
  getLinks: _iCounterGetLinks,
  attach: _iCounterAttach,
  version: '3.1.0+1',
);

int _iCounterEstimateSize(
  ICounter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.length * 3;
  bytesCount += 3 + object.receiptType.length * 3;
  return bytesCount;
}

void _iCounterSerialize(
  ICounter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeLong(offsets[1], object.branchId);
  writer.writeLong(offsets[2], object.businessId);
  writer.writeLong(offsets[3], object.curRcptNo);
  writer.writeDateTime(offsets[4], object.deletedAt);
  writer.writeDateTime(offsets[5], object.lastTouched);
  writer.writeString(offsets[6], object.receiptType);
  writer.writeLong(offsets[7], object.totRcptNo);
}

ICounter _iCounterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ICounter(
    action: reader.readStringOrNull(offsets[0]) ?? "created",
    branchId: reader.readLong(offsets[1]),
    businessId: reader.readLong(offsets[2]),
    curRcptNo: reader.readLong(offsets[3]),
    id: id,
    lastTouched: reader.readDateTimeOrNull(offsets[5]),
    receiptType: reader.readString(offsets[6]),
    totRcptNo: reader.readLong(offsets[7]),
  );
  object.deletedAt = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _iCounterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "created") as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iCounterGetId(ICounter object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _iCounterGetLinks(ICounter object) {
  return [];
}

void _iCounterAttach(IsarCollection<dynamic> col, Id id, ICounter object) {
  object.id = id;
}

extension ICounterQueryWhereSort on QueryBuilder<ICounter, ICounter, QWhere> {
  QueryBuilder<ICounter, ICounter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ICounterQueryWhere on QueryBuilder<ICounter, ICounter, QWhereClause> {
  QueryBuilder<ICounter, ICounter, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ICounter, ICounter, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterWhereClause> idBetween(
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

extension ICounterQueryFilter
    on QueryBuilder<ICounter, ICounter, QFilterCondition> {
  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> businessIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> businessIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> businessIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> businessIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> curRcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> curRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> curRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> curRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'curRcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> lastTouchedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition>
      lastTouchedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> lastTouchedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> lastTouchedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTouched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition>
      receiptTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> receiptTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptType',
        value: '',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition>
      receiptTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiptType',
        value: '',
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> totRcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> totRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> totRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterFilterCondition> totRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totRcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ICounterQueryObject
    on QueryBuilder<ICounter, ICounter, QFilterCondition> {}

extension ICounterQueryLinks
    on QueryBuilder<ICounter, ICounter, QFilterCondition> {}

extension ICounterQuerySortBy on QueryBuilder<ICounter, ICounter, QSortBy> {
  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByCurRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> sortByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }
}

extension ICounterQuerySortThenBy
    on QueryBuilder<ICounter, ICounter, QSortThenBy> {
  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByCurRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<ICounter, ICounter, QAfterSortBy> thenByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }
}

extension ICounterQueryWhereDistinct
    on QueryBuilder<ICounter, ICounter, QDistinct> {
  QueryBuilder<ICounter, ICounter, QDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branchId');
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessId');
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'curRcptNo');
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTouched');
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByReceiptType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ICounter, ICounter, QDistinct> distinctByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totRcptNo');
    });
  }
}

extension ICounterQueryProperty
    on QueryBuilder<ICounter, ICounter, QQueryProperty> {
  QueryBuilder<ICounter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ICounter, String, QQueryOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<ICounter, int, QQueryOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branchId');
    });
  }

  QueryBuilder<ICounter, int, QQueryOperations> businessIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessId');
    });
  }

  QueryBuilder<ICounter, int, QQueryOperations> curRcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'curRcptNo');
    });
  }

  QueryBuilder<ICounter, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<ICounter, DateTime?, QQueryOperations> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTouched');
    });
  }

  QueryBuilder<ICounter, String, QQueryOperations> receiptTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptType');
    });
  }

  QueryBuilder<ICounter, int, QQueryOperations> totRcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totRcptNo');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICounter _$ICounterFromJson(Map<String, dynamic> json) => ICounter(
      id: json['id'] as int?,
      businessId: json['businessId'] as int,
      branchId: json['branchId'] as int,
      receiptType: json['receiptType'] as String,
      totRcptNo: json['totRcptNo'] as int,
      curRcptNo: json['curRcptNo'] as int,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String? ?? "created",
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$ICounterToJson(ICounter instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'receiptType': instance.receiptType,
      'totRcptNo': instance.totRcptNo,
      'curRcptNo': instance.curRcptNo,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
    };
