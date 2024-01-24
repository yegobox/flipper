// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetVoucherCollection on Isar {
  IsarCollection<String, Voucher> get vouchers => this.collection();
}

const VoucherSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Voucher',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'value',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'interval',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'used',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'usedAt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'descriptor',
        type: IsarType.string,
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<String, Voucher>(
    serialize: serializeVoucher,
    deserialize: deserializeVoucher,
    deserializeProperty: deserializeVoucherProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeVoucher(IsarWriter writer, Voucher object) {
  IsarCore.writeString(writer, 1, object.id);
  IsarCore.writeLong(writer, 2, object.value ?? -9223372036854775808);
  IsarCore.writeLong(writer, 3, object.interval ?? -9223372036854775808);
  {
    final value = object.used;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeBool(writer, 4, value);
    }
  }
  IsarCore.writeLong(writer, 5, object.createdAt ?? -9223372036854775808);
  IsarCore.writeLong(writer, 6, object.usedAt ?? -9223372036854775808);
  {
    final value = object.descriptor;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  return Isar.fastHash(object.id);
}

@isarProtected
Voucher deserializeVoucher(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 1) ?? '';
  final int? _value;
  {
    final value = IsarCore.readLong(reader, 2);
    if (value == -9223372036854775808) {
      _value = null;
    } else {
      _value = value;
    }
  }
  final int? _interval;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _interval = null;
    } else {
      _interval = value;
    }
  }
  final bool? _used;
  {
    if (IsarCore.readNull(reader, 4)) {
      _used = null;
    } else {
      _used = IsarCore.readBool(reader, 4);
    }
  }
  final int? _createdAt;
  {
    final value = IsarCore.readLong(reader, 5);
    if (value == -9223372036854775808) {
      _createdAt = null;
    } else {
      _createdAt = value;
    }
  }
  final int? _usedAt;
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      _usedAt = null;
    } else {
      _usedAt = value;
    }
  }
  final String? _descriptor;
  _descriptor = IsarCore.readString(reader, 7);
  final object = Voucher(
    id: _id,
    value: _value,
    interval: _interval,
    used: _used,
    createdAt: _createdAt,
    usedAt: _usedAt,
    descriptor: _descriptor,
  );
  return object;
}

@isarProtected
dynamic deserializeVoucherProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        final value = IsarCore.readLong(reader, 2);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 4:
      {
        if (IsarCore.readNull(reader, 4)) {
          return null;
        } else {
          return IsarCore.readBool(reader, 4);
        }
      }
    case 5:
      {
        final value = IsarCore.readLong(reader, 5);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 7:
      return IsarCore.readString(reader, 7);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _VoucherUpdate {
  bool call({
    required String id,
    int? value,
    int? interval,
    bool? used,
    int? createdAt,
    int? usedAt,
    String? descriptor,
  });
}

class _VoucherUpdateImpl implements _VoucherUpdate {
  const _VoucherUpdateImpl(this.collection);

  final IsarCollection<String, Voucher> collection;

  @override
  bool call({
    required String id,
    Object? value = ignore,
    Object? interval = ignore,
    Object? used = ignore,
    Object? createdAt = ignore,
    Object? usedAt = ignore,
    Object? descriptor = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (value != ignore) 2: value as int?,
          if (interval != ignore) 3: interval as int?,
          if (used != ignore) 4: used as bool?,
          if (createdAt != ignore) 5: createdAt as int?,
          if (usedAt != ignore) 6: usedAt as int?,
          if (descriptor != ignore) 7: descriptor as String?,
        }) >
        0;
  }
}

sealed class _VoucherUpdateAll {
  int call({
    required List<String> id,
    int? value,
    int? interval,
    bool? used,
    int? createdAt,
    int? usedAt,
    String? descriptor,
  });
}

class _VoucherUpdateAllImpl implements _VoucherUpdateAll {
  const _VoucherUpdateAllImpl(this.collection);

  final IsarCollection<String, Voucher> collection;

  @override
  int call({
    required List<String> id,
    Object? value = ignore,
    Object? interval = ignore,
    Object? used = ignore,
    Object? createdAt = ignore,
    Object? usedAt = ignore,
    Object? descriptor = ignore,
  }) {
    return collection.updateProperties(id, {
      if (value != ignore) 2: value as int?,
      if (interval != ignore) 3: interval as int?,
      if (used != ignore) 4: used as bool?,
      if (createdAt != ignore) 5: createdAt as int?,
      if (usedAt != ignore) 6: usedAt as int?,
      if (descriptor != ignore) 7: descriptor as String?,
    });
  }
}

extension VoucherUpdate on IsarCollection<String, Voucher> {
  _VoucherUpdate get update => _VoucherUpdateImpl(this);

  _VoucherUpdateAll get updateAll => _VoucherUpdateAllImpl(this);
}

sealed class _VoucherQueryUpdate {
  int call({
    int? value,
    int? interval,
    bool? used,
    int? createdAt,
    int? usedAt,
    String? descriptor,
  });
}

class _VoucherQueryUpdateImpl implements _VoucherQueryUpdate {
  const _VoucherQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Voucher> query;
  final int? limit;

  @override
  int call({
    Object? value = ignore,
    Object? interval = ignore,
    Object? used = ignore,
    Object? createdAt = ignore,
    Object? usedAt = ignore,
    Object? descriptor = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (value != ignore) 2: value as int?,
      if (interval != ignore) 3: interval as int?,
      if (used != ignore) 4: used as bool?,
      if (createdAt != ignore) 5: createdAt as int?,
      if (usedAt != ignore) 6: usedAt as int?,
      if (descriptor != ignore) 7: descriptor as String?,
    });
  }
}

extension VoucherQueryUpdate on IsarQuery<Voucher> {
  _VoucherQueryUpdate get updateFirst =>
      _VoucherQueryUpdateImpl(this, limit: 1);

  _VoucherQueryUpdate get updateAll => _VoucherQueryUpdateImpl(this);
}

class _VoucherQueryBuilderUpdateImpl implements _VoucherQueryUpdate {
  const _VoucherQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Voucher, Voucher, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? value = ignore,
    Object? interval = ignore,
    Object? used = ignore,
    Object? createdAt = ignore,
    Object? usedAt = ignore,
    Object? descriptor = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (value != ignore) 2: value as int?,
        if (interval != ignore) 3: interval as int?,
        if (used != ignore) 4: used as bool?,
        if (createdAt != ignore) 5: createdAt as int?,
        if (usedAt != ignore) 6: usedAt as int?,
        if (descriptor != ignore) 7: descriptor as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension VoucherQueryBuilderUpdate
    on QueryBuilder<Voucher, Voucher, QOperations> {
  _VoucherQueryUpdate get updateFirst =>
      _VoucherQueryBuilderUpdateImpl(this, limit: 1);

  _VoucherQueryUpdate get updateAll => _VoucherQueryBuilderUpdateImpl(this);
}

extension VoucherQueryFilter
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThanOrEqualTo(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThanOrEqualTo(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idContains(String value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idMatches(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueGreaterThan(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      valueGreaterThanOrEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueLessThan(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueLessThanOrEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueBetween(
    int? lower,
    int? upper,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalGreaterThan(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      intervalGreaterThanOrEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalLessThan(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      intervalLessThanOrEqualTo(
    int? value,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalBetween(
    int? lower,
    int? upper,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      usedAtGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      descriptorGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition>
      descriptorLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }
}

extension VoucherQueryObject
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {}

extension VoucherQuerySortBy on QueryBuilder<Voucher, Voucher, QSortBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptorDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension VoucherQuerySortThenBy
    on QueryBuilder<Voucher, Voucher, QSortThenBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptorDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension VoucherQueryWhereDistinct
    on QueryBuilder<Voucher, Voucher, QDistinct> {
  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }
}

extension VoucherQueryProperty1 on QueryBuilder<Voucher, Voucher, QProperty> {
  QueryBuilder<Voucher, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Voucher, int?, QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Voucher, int?, QAfterProperty> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Voucher, bool?, QAfterProperty> usedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Voucher, int?, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Voucher, int?, QAfterProperty> usedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Voucher, String?, QAfterProperty> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension VoucherQueryProperty2<R> on QueryBuilder<Voucher, R, QAfterProperty> {
  QueryBuilder<Voucher, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Voucher, (R, int?), QAfterProperty> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Voucher, (R, int?), QAfterProperty> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Voucher, (R, bool?), QAfterProperty> usedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Voucher, (R, int?), QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Voucher, (R, int?), QAfterProperty> usedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Voucher, (R, String?), QAfterProperty> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}

extension VoucherQueryProperty3<R1, R2>
    on QueryBuilder<Voucher, (R1, R2), QAfterProperty> {
  QueryBuilder<Voucher, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Voucher, (R1, R2, int?), QOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Voucher, (R1, R2, int?), QOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Voucher, (R1, R2, bool?), QOperations> usedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Voucher, (R1, R2, int?), QOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Voucher, (R1, R2, int?), QOperations> usedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Voucher, (R1, R2, String?), QOperations> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }
}
