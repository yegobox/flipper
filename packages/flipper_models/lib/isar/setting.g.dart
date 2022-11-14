// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetSettingCollection on Isar {
  IsarCollection<Setting> get settings => this.collection();
}

const SettingSchema = CollectionSchema(
  name: r'Setting',
  id: 2542600759502230801,
  properties: {
    r'attendnaceDocCreated': PropertySchema(
      id: 0,
      name: r'attendnaceDocCreated',
      type: IsarType.bool,
    ),
    r'autoPrint': PropertySchema(
      id: 1,
      name: r'autoPrint',
      type: IsarType.bool,
    ),
    r'defaultLanguage': PropertySchema(
      id: 2,
      name: r'defaultLanguage',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 3,
      name: r'email',
      type: IsarType.string,
    ),
    r'googleSheetDocCreated': PropertySchema(
      id: 4,
      name: r'googleSheetDocCreated',
      type: IsarType.bool,
    ),
    r'hasPin': PropertySchema(
      id: 5,
      name: r'hasPin',
      type: IsarType.string,
    ),
    r'isAttendanceEnabled': PropertySchema(
      id: 6,
      name: r'isAttendanceEnabled',
      type: IsarType.bool,
    ),
    r'openReceiptFileOSaleComplete': PropertySchema(
      id: 7,
      name: r'openReceiptFileOSaleComplete',
      type: IsarType.bool,
    ),
    r'sendDailyReport': PropertySchema(
      id: 8,
      name: r'sendDailyReport',
      type: IsarType.bool,
    ),
    r'userId': PropertySchema(
      id: 9,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _settingEstimateSize,
  serialize: _settingSerialize,
  deserialize: _settingDeserialize,
  deserializeProp: _settingDeserializeProp,
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
  links: {},
  embeddedSchemas: {},
  getId: _settingGetId,
  getLinks: _settingGetLinks,
  attach: _settingAttach,
  version: '3.0.4',
);

int _settingEstimateSize(
  Setting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.defaultLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.hasPin.length * 3;
  return bytesCount;
}

void _settingSerialize(
  Setting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.attendnaceDocCreated);
  writer.writeBool(offsets[1], object.autoPrint);
  writer.writeString(offsets[2], object.defaultLanguage);
  writer.writeString(offsets[3], object.email);
  writer.writeBool(offsets[4], object.googleSheetDocCreated);
  writer.writeString(offsets[5], object.hasPin);
  writer.writeBool(offsets[6], object.isAttendanceEnabled);
  writer.writeBool(offsets[7], object.openReceiptFileOSaleComplete);
  writer.writeBool(offsets[8], object.sendDailyReport);
  writer.writeLong(offsets[9], object.userId);
}

Setting _settingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Setting(
    attendnaceDocCreated: reader.readBoolOrNull(offsets[0]),
    autoPrint: reader.readBoolOrNull(offsets[1]),
    defaultLanguage: reader.readStringOrNull(offsets[2]),
    email: reader.readString(offsets[3]),
    googleSheetDocCreated: reader.readBoolOrNull(offsets[4]),
    hasPin: reader.readString(offsets[5]),
    id: id,
    isAttendanceEnabled: reader.readBoolOrNull(offsets[6]),
    openReceiptFileOSaleComplete: reader.readBoolOrNull(offsets[7]),
    sendDailyReport: reader.readBoolOrNull(offsets[8]),
    userId: reader.readLong(offsets[9]),
  );
  return object;
}

P _settingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingGetId(Setting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingGetLinks(Setting object) {
  return [];
}

void _settingAttach(IsarCollection<dynamic> col, Id id, Setting object) {
  object.id = id;
}

extension SettingQueryWhereSort on QueryBuilder<Setting, Setting, QWhere> {
  QueryBuilder<Setting, Setting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension SettingQueryWhere on QueryBuilder<Setting, Setting, QWhereClause> {
  QueryBuilder<Setting, Setting, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idBetween(
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdNotEqualTo(
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdLessThan(
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdBetween(
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

extension SettingQueryFilter
    on QueryBuilder<Setting, Setting, QFilterCondition> {
  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      attendnaceDocCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attendnaceDocCreated',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      attendnaceDocCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attendnaceDocCreated',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      attendnaceDocCreatedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendnaceDocCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> autoPrintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'autoPrint',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> autoPrintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'autoPrint',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> autoPrintEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoPrint',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultLanguage',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultLanguage',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'googleSheetDocCreated',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'googleSheetDocCreated',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleSheetDocCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hasPin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hasPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hasPin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasPin',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hasPin',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isAttendanceEnabled',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isAttendanceEnabled',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAttendanceEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      openReceiptFileOSaleCompleteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openReceiptFileOSaleComplete',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      openReceiptFileOSaleCompleteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'openReceiptFileOSaleComplete',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      openReceiptFileOSaleCompleteEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openReceiptFileOSaleComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      sendDailyReportIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sendDailyReport',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      sendDailyReportIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sendDailyReport',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> sendDailyReportEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sendDailyReport',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdBetween(
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

extension SettingQueryObject
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQueryLinks
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQuerySortBy on QueryBuilder<Setting, Setting, QSortBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAttendnaceDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendnaceDocCreated', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByAttendnaceDocCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendnaceDocCreated', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAutoPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByDefaultLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLanguage', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByDefaultLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLanguage', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByGoogleSheetDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSheetDocCreated', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByGoogleSheetDocCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSheetDocCreated', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByHasPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPin', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByHasPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPin', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByIsAttendanceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAttendanceEnabled', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByIsAttendanceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAttendanceEnabled', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByOpenReceiptFileOSaleComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openReceiptFileOSaleComplete', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByOpenReceiptFileOSaleCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openReceiptFileOSaleComplete', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySendDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendDailyReport', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySendDailyReportDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendDailyReport', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SettingQuerySortThenBy
    on QueryBuilder<Setting, Setting, QSortThenBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAttendnaceDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendnaceDocCreated', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByAttendnaceDocCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendnaceDocCreated', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAutoPrintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoPrint', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByDefaultLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLanguage', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByDefaultLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLanguage', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByGoogleSheetDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSheetDocCreated', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByGoogleSheetDocCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSheetDocCreated', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByHasPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPin', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByHasPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPin', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIsAttendanceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAttendanceEnabled', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIsAttendanceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAttendanceEnabled', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByOpenReceiptFileOSaleComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openReceiptFileOSaleComplete', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByOpenReceiptFileOSaleCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openReceiptFileOSaleComplete', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySendDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendDailyReport', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySendDailyReportDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sendDailyReport', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SettingQueryWhereDistinct
    on QueryBuilder<Setting, Setting, QDistinct> {
  QueryBuilder<Setting, Setting, QDistinct> distinctByAttendnaceDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendnaceDocCreated');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByAutoPrint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoPrint');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByDefaultLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByGoogleSheetDocCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googleSheetDocCreated');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByHasPin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasPin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByIsAttendanceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAttendanceEnabled');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct>
      distinctByOpenReceiptFileOSaleComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openReceiptFileOSaleComplete');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctBySendDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sendDailyReport');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension SettingQueryProperty
    on QueryBuilder<Setting, Setting, QQueryProperty> {
  QueryBuilder<Setting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations>
      attendnaceDocCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendnaceDocCreated');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations> autoPrintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoPrint');
    });
  }

  QueryBuilder<Setting, String?, QQueryOperations> defaultLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultLanguage');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations>
      googleSheetDocCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleSheetDocCreated');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> hasPinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasPin');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations> isAttendanceEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAttendanceEnabled');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations>
      openReceiptFileOSaleCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openReceiptFileOSaleComplete');
    });
  }

  QueryBuilder<Setting, bool?, QQueryOperations> sendDailyReportProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sendDailyReport');
    });
  }

  QueryBuilder<Setting, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
