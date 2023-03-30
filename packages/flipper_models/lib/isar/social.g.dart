// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSocialCollection on Isar {
  IsarCollection<Social> get socials => this.collection();
}

const SocialSchema = CollectionSchema(
  name: r'Social',
  id: -7903313734955614803,
  properties: {
    r'businessId': PropertySchema(
      id: 0,
      name: r'businessId',
      type: IsarType.long,
    ),
    r'isAccountSet': PropertySchema(
      id: 1,
      name: r'isAccountSet',
      type: IsarType.bool,
    ),
    r'socialType': PropertySchema(
      id: 2,
      name: r'socialType',
      type: IsarType.string,
    ),
    r'socialUrl': PropertySchema(
      id: 3,
      name: r'socialUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _socialEstimateSize,
  serialize: _socialSerialize,
  deserialize: _socialDeserialize,
  deserializeProp: _socialDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _socialGetId,
  getLinks: _socialGetLinks,
  attach: _socialAttach,
  version: '3.0.6-dev.0',
);

int _socialEstimateSize(
  Social object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.socialType.length * 3;
  bytesCount += 3 + object.socialUrl.length * 3;
  return bytesCount;
}

void _socialSerialize(
  Social object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.businessId);
  writer.writeBool(offsets[1], object.isAccountSet);
  writer.writeString(offsets[2], object.socialType);
  writer.writeString(offsets[3], object.socialUrl);
}

Social _socialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Social(
    businessId: reader.readLong(offsets[0]),
    id: id,
    isAccountSet: reader.readBool(offsets[1]),
    socialType: reader.readString(offsets[2]),
    socialUrl: reader.readString(offsets[3]),
  );
  return object;
}

P _socialDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _socialGetId(Social object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _socialGetLinks(Social object) {
  return [];
}

void _socialAttach(IsarCollection<dynamic> col, Id id, Social object) {
  object.id = id;
}

extension SocialQueryWhereSort on QueryBuilder<Social, Social, QWhere> {
  QueryBuilder<Social, Social, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SocialQueryWhere on QueryBuilder<Social, Social, QWhereClause> {
  QueryBuilder<Social, Social, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Social, Social, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Social, Social, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Social, Social, QAfterWhereClause> idBetween(
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

extension SocialQueryFilter on QueryBuilder<Social, Social, QFilterCondition> {
  QueryBuilder<Social, Social, QAfterFilterCondition> businessIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> businessIdGreaterThan(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> businessIdLessThan(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> businessIdBetween(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Social, Social, QAfterFilterCondition> isAccountSetEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAccountSet',
        value: value,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'socialType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'socialType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'socialType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'socialType',
        value: '',
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'socialType',
        value: '',
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'socialUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'socialUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'socialUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'socialUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Social, Social, QAfterFilterCondition> socialUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'socialUrl',
        value: '',
      ));
    });
  }
}

extension SocialQueryObject on QueryBuilder<Social, Social, QFilterCondition> {}

extension SocialQueryLinks on QueryBuilder<Social, Social, QFilterCondition> {}

extension SocialQuerySortBy on QueryBuilder<Social, Social, QSortBy> {
  QueryBuilder<Social, Social, QAfterSortBy> sortByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortByIsAccountSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccountSet', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortByIsAccountSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccountSet', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortBySocialType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialType', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortBySocialTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialType', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortBySocialUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialUrl', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> sortBySocialUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialUrl', Sort.desc);
    });
  }
}

extension SocialQuerySortThenBy on QueryBuilder<Social, Social, QSortThenBy> {
  QueryBuilder<Social, Social, QAfterSortBy> thenByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenByIsAccountSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccountSet', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenByIsAccountSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAccountSet', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenBySocialType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialType', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenBySocialTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialType', Sort.desc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenBySocialUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialUrl', Sort.asc);
    });
  }

  QueryBuilder<Social, Social, QAfterSortBy> thenBySocialUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'socialUrl', Sort.desc);
    });
  }
}

extension SocialQueryWhereDistinct on QueryBuilder<Social, Social, QDistinct> {
  QueryBuilder<Social, Social, QDistinct> distinctByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessId');
    });
  }

  QueryBuilder<Social, Social, QDistinct> distinctByIsAccountSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAccountSet');
    });
  }

  QueryBuilder<Social, Social, QDistinct> distinctBySocialType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'socialType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Social, Social, QDistinct> distinctBySocialUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'socialUrl', caseSensitive: caseSensitive);
    });
  }
}

extension SocialQueryProperty on QueryBuilder<Social, Social, QQueryProperty> {
  QueryBuilder<Social, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Social, int, QQueryOperations> businessIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessId');
    });
  }

  QueryBuilder<Social, bool, QQueryOperations> isAccountSetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAccountSet');
    });
  }

  QueryBuilder<Social, String, QQueryOperations> socialTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'socialType');
    });
  }

  QueryBuilder<Social, String, QQueryOperations> socialUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'socialUrl');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
      id: json['id'] as int?,
      isAccountSet: json['isAccountSet'] as bool,
      socialType: json['socialType'] as String,
      businessId: json['businessId'] as int,
      socialUrl: json['socialUrl'] as String,
    );

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'id': instance.id,
      'isAccountSet': instance.isAccountSet,
      'socialType': instance.socialType,
      'socialUrl': instance.socialUrl,
      'businessId': instance.businessId,
    };
