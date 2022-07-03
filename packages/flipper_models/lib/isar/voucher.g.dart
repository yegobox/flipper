// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetVoucherCollection on Isar {
  IsarCollection<Voucher> get vouchers => getCollection();
}

const VoucherSchema = CollectionSchema(
  name: r'Voucher',
  schema:
      r'{"name":"Voucher","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"used","type":"Bool"},{"name":"usedAt","type":"Long"},{"name":"value","type":"Long"}],"indexes":[],"links":[{"name":"features","target":"Feature"}]}',
  idName: r'id',
  propertyIds: {
    r'createdAt': 0,
    r'descriptor': 1,
    r'interval': 2,
    r'used': 3,
    r'usedAt': 4,
    r'value': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {r'features': 0},
  backlinkLinkNames: {},
  getId: _voucherGetId,
  setId: _voucherSetId,
  getLinks: _voucherGetLinks,
  attachLinks: _voucherAttachLinks,
  serializeNative: _voucherSerializeNative,
  deserializeNative: _voucherDeserializeNative,
  deserializePropNative: _voucherDeserializePropNative,
  serializeWeb: _voucherSerializeWeb,
  deserializeWeb: _voucherDeserializeWeb,
  deserializePropWeb: _voucherDeserializePropWeb,
  version: 4,
);

int? _voucherGetId(Voucher object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _voucherSetId(Voucher object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _voucherGetLinks(Voucher object) {
  return [object.features];
}

void _voucherSerializeNative(
    IsarCollection<Voucher> collection,
    IsarCObject cObj,
    Voucher object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final descriptor$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.descriptor);
  final size = (staticSize + (descriptor$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeLong(offsets[0], object.createdAt);
  writer.writeBytes(offsets[1], descriptor$Bytes);
  writer.writeLong(offsets[2], object.interval);
  writer.writeBool(offsets[3], object.used);
  writer.writeLong(offsets[4], object.usedAt);
  writer.writeLong(offsets[5], object.value);
}

Voucher _voucherDeserializeNative(IsarCollection<Voucher> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Voucher();
  object.createdAt = reader.readLong(offsets[0]);
  object.descriptor = reader.readString(offsets[1]);
  object.id = id;
  object.interval = reader.readLong(offsets[2]);
  object.used = reader.readBool(offsets[3]);
  object.usedAt = reader.readLong(offsets[4]);
  object.value = reader.readLong(offsets[5]);
  _voucherAttachLinks(collection, id, object);
  return object;
}

P _voucherDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _voucherSerializeWeb(
    IsarCollection<Voucher> collection, Voucher object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, r'descriptor', object.descriptor);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'interval', object.interval);
  IsarNative.jsObjectSet(jsObj, r'used', object.used);
  IsarNative.jsObjectSet(jsObj, r'usedAt', object.usedAt);
  IsarNative.jsObjectSet(jsObj, r'value', object.value);
  return jsObj;
}

Voucher _voucherDeserializeWeb(
    IsarCollection<Voucher> collection, Object jsObj) {
  final object = Voucher();
  object.createdAt = IsarNative.jsObjectGet(jsObj, r'createdAt') ??
      (double.negativeInfinity as int);
  object.descriptor = IsarNative.jsObjectGet(jsObj, r'descriptor') ?? '';
  object.id =
      IsarNative.jsObjectGet(jsObj, r'id') ?? (double.negativeInfinity as int);
  object.interval = IsarNative.jsObjectGet(jsObj, r'interval') ??
      (double.negativeInfinity as int);
  object.used = IsarNative.jsObjectGet(jsObj, r'used') ?? false;
  object.usedAt = IsarNative.jsObjectGet(jsObj, r'usedAt') ??
      (double.negativeInfinity as int);
  object.value = IsarNative.jsObjectGet(jsObj, r'value') ??
      (double.negativeInfinity as int);
  _voucherAttachLinks(
      collection,
      IsarNative.jsObjectGet(jsObj, r'id') ?? (double.negativeInfinity as int),
      object);
  return object;
}

P _voucherDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'createdAt':
      return (IsarNative.jsObjectGet(jsObj, r'createdAt') ??
          (double.negativeInfinity as int)) as P;
    case r'descriptor':
      return (IsarNative.jsObjectGet(jsObj, r'descriptor') ?? '') as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id') ??
          (double.negativeInfinity as int)) as P;
    case r'interval':
      return (IsarNative.jsObjectGet(jsObj, r'interval') ??
          (double.negativeInfinity as int)) as P;
    case r'used':
      return (IsarNative.jsObjectGet(jsObj, r'used') ?? false) as P;
    case r'usedAt':
      return (IsarNative.jsObjectGet(jsObj, r'usedAt') ??
          (double.negativeInfinity as int)) as P;
    case r'value':
      return (IsarNative.jsObjectGet(jsObj, r'value') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _voucherAttachLinks(IsarCollection<dynamic> col, int id, Voucher object) {
  object.features.attach(col, col.isar.features, r'features', id);
}

extension VoucherQueryWhereSort on QueryBuilder<Voucher, Voucher, QWhere> {
  QueryBuilder<Voucher, Voucher, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VoucherQueryWhere on QueryBuilder<Voucher, Voucher, QWhereClause> {
  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idBetween(
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idBetween(
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

extension VoucherQueryLinks
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> features(
      FilterQuery<Feature> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(
        query.collection.isar.features,
        q,
        r'features',
      );
    });
  }
}

extension VoucherQueryWhereSortBy on QueryBuilder<Voucher, Voucher, QSortBy> {
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

extension VoucherQueryWhereSortThenBy
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

  QueryBuilder<Voucher, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
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
