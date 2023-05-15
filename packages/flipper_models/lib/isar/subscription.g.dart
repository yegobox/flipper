// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubscriptionCollection on Isar {
  IsarCollection<Subscription> get subscriptions => this.collection();
}

const SubscriptionSchema = CollectionSchema(
  name: r'Subscription',
  id: -3426239935225026138,
  properties: {
    r'descriptor': PropertySchema(
      id: 0,
      name: r'descriptor',
      type: IsarType.string,
    ),
    r'interval': PropertySchema(
      id: 1,
      name: r'interval',
      type: IsarType.long,
    ),
    r'lastBillingDate': PropertySchema(
      id: 2,
      name: r'lastBillingDate',
      type: IsarType.string,
    ),
    r'nextBillingDate': PropertySchema(
      id: 3,
      name: r'nextBillingDate',
      type: IsarType.string,
    ),
    r'recurring': PropertySchema(
      id: 4,
      name: r'recurring',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(
      id: 5,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _subscriptionEstimateSize,
  serialize: _subscriptionSerialize,
  deserialize: _subscriptionDeserialize,
  deserializeProp: _subscriptionDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'features': LinkSchema(
      id: -3702405399721331688,
      name: r'features',
      target: r'Feature',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _subscriptionGetId,
  getLinks: _subscriptionGetLinks,
  attach: _subscriptionAttach,
  version: '3.1.0+1',
);

int _subscriptionEstimateSize(
  Subscription object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.descriptor.length * 3;
  bytesCount += 3 + object.lastBillingDate.length * 3;
  bytesCount += 3 + object.nextBillingDate.length * 3;
  return bytesCount;
}

void _subscriptionSerialize(
  Subscription object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.descriptor);
  writer.writeLong(offsets[1], object.interval);
  writer.writeString(offsets[2], object.lastBillingDate);
  writer.writeString(offsets[3], object.nextBillingDate);
  writer.writeDouble(offsets[4], object.recurring);
  writer.writeLong(offsets[5], object.userId);
}

Subscription _subscriptionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Subscription(
    descriptor: reader.readString(offsets[0]),
    id: id,
    interval: reader.readLong(offsets[1]),
    lastBillingDate: reader.readString(offsets[2]),
    nextBillingDate: reader.readString(offsets[3]),
    recurring: reader.readDouble(offsets[4]),
    userId: reader.readLong(offsets[5]),
  );
  return object;
}

P _subscriptionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _subscriptionGetId(Subscription object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _subscriptionGetLinks(Subscription object) {
  return [object.features];
}

void _subscriptionAttach(
    IsarCollection<dynamic> col, Id id, Subscription object) {
  object.id = id;
  object.features.attach(col, col.isar.collection<Feature>(), r'features', id);
}

extension SubscriptionQueryWhereSort
    on QueryBuilder<Subscription, Subscription, QWhere> {
  QueryBuilder<Subscription, Subscription, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension SubscriptionQueryWhere
    on QueryBuilder<Subscription, Subscription, QWhereClause> {
  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdEqualTo(
      int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdNotEqualTo(
      int userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubscriptionQueryFilter
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {
  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEqualTo(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorGreaterThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorLessThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorStartsWith(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEndsWith(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descriptor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptor',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descriptor',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalGreaterThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalLessThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBillingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBillingDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastBillingDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextBillingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextBillingDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextBillingDate',
        value: '',
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurring',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurring',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurring',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurring',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubscriptionQueryObject
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {}

extension SubscriptionQueryLinks
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {
  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> features(
      FilterQuery<Feature> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'features');
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      featuresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'features', 0, true, 0, true);
    });
  }
}

extension SubscriptionQuerySortBy
    on QueryBuilder<Subscription, Subscription, QSortBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SubscriptionQuerySortThenBy
    on QueryBuilder<Subscription, Subscription, QSortThenBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SubscriptionQueryWhereDistinct
    on QueryBuilder<Subscription, Subscription, QDistinct> {
  QueryBuilder<Subscription, Subscription, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descriptor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByLastBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurring');
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension SubscriptionQueryProperty
    on QueryBuilder<Subscription, Subscription, QQueryProperty> {
  QueryBuilder<Subscription, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Subscription, String, QQueryOperations> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptor');
    });
  }

  QueryBuilder<Subscription, int, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      lastBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBillingDate');
    });
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      nextBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextBillingDate');
    });
  }

  QueryBuilder<Subscription, double, QQueryOperations> recurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurring');
    });
  }

  QueryBuilder<Subscription, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
