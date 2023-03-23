// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetIChangeCollection on Isar {
  IsarCollection<IChange> get iChanges => this.collection();
}

const IChangeSchema = CollectionSchema(
  name: r'IChange',
  id: -7171164164434596357,
  properties: {
    r'branchId': PropertySchema(
      id: 0,
      name: r'branchId',
      type: IsarType.long,
    ),
    r'businessId': PropertySchema(
      id: 1,
      name: r'businessId',
      type: IsarType.long,
    ),
    r'lastTouched': PropertySchema(
      id: 2,
      name: r'lastTouched',
      type: IsarType.string,
    ),
    r'model': PropertySchema(
      id: 3,
      name: r'model',
      type: IsarType.string,
    ),
    r'remoteChange': PropertySchema(
      id: 4,
      name: r'remoteChange',
      type: IsarType.bool,
    )
  },
  estimateSize: _iChangeEstimateSize,
  serialize: _iChangeSerialize,
  deserialize: _iChangeDeserialize,
  deserializeProp: _iChangeDeserializeProp,
  idName: r'id',
  indexes: {
    r'branchId': IndexSchema(
      id: 2037049677925728410,
      name: r'branchId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'branchId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'businessId': IndexSchema(
      id: 2228048290814354584,
      name: r'businessId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'businessId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lastTouched': IndexSchema(
      id: -1197289422054722944,
      name: r'lastTouched',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastTouched',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'model': IndexSchema(
      id: 8229337662361542422,
      name: r'model',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'model',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _iChangeGetId,
  getLinks: _iChangeGetLinks,
  attach: _iChangeAttach,
  version: '3.0.6-dev.0',
);

int _iChangeEstimateSize(
  IChange object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastTouched;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.model.length * 3;
  return bytesCount;
}

void _iChangeSerialize(
  IChange object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.branchId);
  writer.writeLong(offsets[1], object.businessId);
  writer.writeString(offsets[2], object.lastTouched);
  writer.writeString(offsets[3], object.model);
  writer.writeBool(offsets[4], object.remoteChange);
}

IChange _iChangeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IChange(
    branchId: reader.readLong(offsets[0]),
    businessId: reader.readLong(offsets[1]),
    id: id,
    lastTouched: reader.readStringOrNull(offsets[2]),
    model: reader.readString(offsets[3]),
    remoteChange: reader.readBoolOrNull(offsets[4]),
  );
  return object;
}

P _iChangeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iChangeGetId(IChange object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _iChangeGetLinks(IChange object) {
  return [];
}

void _iChangeAttach(IsarCollection<dynamic> col, Id id, IChange object) {
  object.id = id;
}

extension IChangeQueryWhereSort on QueryBuilder<IChange, IChange, QWhere> {
  QueryBuilder<IChange, IChange, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhere> anyBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'branchId'),
      );
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhere> anyBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'businessId'),
      );
    });
  }
}

extension IChangeQueryWhere on QueryBuilder<IChange, IChange, QWhereClause> {
  QueryBuilder<IChange, IChange, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> idBetween(
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> branchIdEqualTo(
      int branchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'branchId',
        value: [branchId],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> branchIdNotEqualTo(
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> branchIdGreaterThan(
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> branchIdLessThan(
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> branchIdBetween(
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

  QueryBuilder<IChange, IChange, QAfterWhereClause> businessIdEqualTo(
      int businessId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'businessId',
        value: [businessId],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> businessIdNotEqualTo(
      int businessId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'businessId',
              lower: [],
              upper: [businessId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'businessId',
              lower: [businessId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'businessId',
              lower: [businessId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'businessId',
              lower: [],
              upper: [businessId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> businessIdGreaterThan(
    int businessId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'businessId',
        lower: [businessId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> businessIdLessThan(
    int businessId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'businessId',
        lower: [],
        upper: [businessId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> businessIdBetween(
    int lowerBusinessId,
    int upperBusinessId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'businessId',
        lower: [lowerBusinessId],
        includeLower: includeLower,
        upper: [upperBusinessId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTouched',
        value: [null],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTouched',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> lastTouchedEqualTo(
      String? lastTouched) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTouched',
        value: [lastTouched],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> lastTouchedNotEqualTo(
      String? lastTouched) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [],
              upper: [lastTouched],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [lastTouched],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [lastTouched],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [],
              upper: [lastTouched],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> modelEqualTo(String model) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'model',
        value: [model],
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterWhereClause> modelNotEqualTo(
      String model) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [],
              upper: [model],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [model],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [model],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'model',
              lower: [],
              upper: [model],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IChangeQueryFilter
    on QueryBuilder<IChange, IChange, QFilterCondition> {
  QueryBuilder<IChange, IChange, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> businessIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> businessIdGreaterThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> businessIdLessThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> businessIdBetween(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTouched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastTouched',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> lastTouchedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: '',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition>
      lastTouchedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastTouched',
        value: '',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> remoteChangeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteChange',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition>
      remoteChangeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteChange',
      ));
    });
  }

  QueryBuilder<IChange, IChange, QAfterFilterCondition> remoteChangeEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteChange',
        value: value,
      ));
    });
  }
}

extension IChangeQueryObject
    on QueryBuilder<IChange, IChange, QFilterCondition> {}

extension IChangeQueryLinks
    on QueryBuilder<IChange, IChange, QFilterCondition> {}

extension IChangeQuerySortBy on QueryBuilder<IChange, IChange, QSortBy> {
  QueryBuilder<IChange, IChange, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByRemoteChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteChange', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> sortByRemoteChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteChange', Sort.desc);
    });
  }
}

extension IChangeQuerySortThenBy
    on QueryBuilder<IChange, IChange, QSortThenBy> {
  QueryBuilder<IChange, IChange, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByRemoteChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteChange', Sort.asc);
    });
  }

  QueryBuilder<IChange, IChange, QAfterSortBy> thenByRemoteChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteChange', Sort.desc);
    });
  }
}

extension IChangeQueryWhereDistinct
    on QueryBuilder<IChange, IChange, QDistinct> {
  QueryBuilder<IChange, IChange, QDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branchId');
    });
  }

  QueryBuilder<IChange, IChange, QDistinct> distinctByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessId');
    });
  }

  QueryBuilder<IChange, IChange, QDistinct> distinctByLastTouched(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTouched', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IChange, IChange, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IChange, IChange, QDistinct> distinctByRemoteChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteChange');
    });
  }
}

extension IChangeQueryProperty
    on QueryBuilder<IChange, IChange, QQueryProperty> {
  QueryBuilder<IChange, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IChange, int, QQueryOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branchId');
    });
  }

  QueryBuilder<IChange, int, QQueryOperations> businessIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessId');
    });
  }

  QueryBuilder<IChange, String?, QQueryOperations> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTouched');
    });
  }

  QueryBuilder<IChange, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<IChange, bool?, QQueryOperations> remoteChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteChange');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IChange _$IChangeFromJson(Map<String, dynamic> json) => IChange(
      branchId: json['branchId'] as int,
      model: json['model'] as String,
      businessId: json['businessId'] as int,
      id: json['id'] as int?,
      remoteChange: json['remoteChange'] as bool?,
      lastTouched: json['lastTouched'] as String?,
    );

Map<String, dynamic> _$IChangeToJson(IChange instance) => <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'lastTouched': instance.lastTouched,
      'model': instance.model,
      'remoteChange': instance.remoteChange,
    };
