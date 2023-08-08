// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetPointssCollection on Isar {
  IsarCollection<String, Pointss> get pointss => this.collection();
}

const PointssSchema = IsarCollectionSchema(
  schema:
      '{"name":"Pointss","idName":"id","properties":[{"name":"id","type":"String"},{"name":"value","type":"Long"},{"name":"userId","type":"Int"}]}',
  converter: IsarObjectConverter<String, Pointss>(
    serialize: serializePointss,
    deserialize: deserializePointss,
    deserializeProperty: deserializePointssProp,
  ),
  embeddedSchemas: [],
  //hash: 5965548525944701425,
);

@isarProtected
int serializePointss(IsarWriter writer, Pointss object) {
  IsarCore.writeString(writer, 1, object.id);
  IsarCore.writeLong(writer, 2, object.value);
  IsarCore.writeInt(writer, 3, object.userId);
  return Isar.fastHash(object.id);
}

@isarProtected
Pointss deserializePointss(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 1) ?? '';
  final int _value;
  _value = IsarCore.readLong(reader, 2);
  final int _userId;
  _userId = IsarCore.readInt(reader, 3);
  final object = Pointss(
    id: _id,
    value: _value,
    userId: _userId,
  );
  return object;
}

@isarProtected
dynamic deserializePointssProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readLong(reader, 2);
    case 3:
      return IsarCore.readInt(reader, 3);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _PointssUpdate {
  bool call({
    required String id,
    int? value,
    int? userId,
  });
}

class _PointssUpdateImpl implements _PointssUpdate {
  const _PointssUpdateImpl(this.collection);

  final IsarCollection<String, Pointss> collection;

  @override
  bool call({
    required String id,
    Object? value = ignore,
    Object? userId = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (value != ignore) 2: value as int?,
          if (userId != ignore) 3: userId as int?,
        }) >
        0;
  }
}

sealed class _PointssUpdateAll {
  int call({
    required List<String> id,
    int? value,
    int? userId,
  });
}

class _PointssUpdateAllImpl implements _PointssUpdateAll {
  const _PointssUpdateAllImpl(this.collection);

  final IsarCollection<String, Pointss> collection;

  @override
  int call({
    required List<String> id,
    Object? value = ignore,
    Object? userId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (value != ignore) 2: value as int?,
      if (userId != ignore) 3: userId as int?,
    });
  }
}

extension PointssUpdate on IsarCollection<String, Pointss> {
  _PointssUpdate get update => _PointssUpdateImpl(this);

  _PointssUpdateAll get updateAll => _PointssUpdateAllImpl(this);
}

sealed class _PointssQueryUpdate {
  int call({
    int? value,
    int? userId,
  });
}

class _PointssQueryUpdateImpl implements _PointssQueryUpdate {
  const _PointssQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Pointss> query;
  final int? limit;

  @override
  int call({
    Object? value = ignore,
    Object? userId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (value != ignore) 2: value as int?,
      if (userId != ignore) 3: userId as int?,
    });
  }
}

extension PointssQueryUpdate on IsarQuery<Pointss> {
  _PointssQueryUpdate get updateFirst =>
      _PointssQueryUpdateImpl(this, limit: 1);

  _PointssQueryUpdate get updateAll => _PointssQueryUpdateImpl(this);
}

extension PointssQueryFilter
    on QueryBuilder<Pointss, Pointss, QFilterCondition> {
  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> valueEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> valueGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition>
      valueGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> valueLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> valueLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> valueBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> userIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> userIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition>
      userIdGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> userIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> userIdLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension PointssQueryObject
    on QueryBuilder<Pointss, Pointss, QFilterCondition> {}

extension PointssQuerySortBy on QueryBuilder<Pointss, Pointss, QSortBy> {
  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension PointssQuerySortThenBy
    on QueryBuilder<Pointss, Pointss, QSortThenBy> {
  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }
}

extension PointssQueryWhereDistinct
    on QueryBuilder<Pointss, Pointss, QDistinct> {
  QueryBuilder<Pointss, Pointss, QAfterDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<Pointss, Pointss, QAfterDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }
}

extension PointssQueryProperty1 on QueryBuilder<Pointss, Pointss, QProperty> {
  QueryBuilder<Pointss, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Pointss, int, QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Pointss, int, QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension PointssQueryProperty2<R> on QueryBuilder<Pointss, R, QAfterProperty> {
  QueryBuilder<Pointss, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Pointss, (R, int), QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Pointss, (R, int), QAfterProperty> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}

extension PointssQueryProperty3<R1, R2>
    on QueryBuilder<Pointss, (R1, R2), QAfterProperty> {
  QueryBuilder<Pointss, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Pointss, (R1, R2, int), QOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Pointss, (R1, R2, int), QOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }
}
