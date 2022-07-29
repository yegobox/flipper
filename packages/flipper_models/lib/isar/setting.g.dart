// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetSettingCollection on Isar {
  IsarCollection<Setting> get settings => collection();
}

const SettingSchema = CollectionSchema(
  name: r'Setting',
  schema:
      r'{"name":"Setting","idName":"id","properties":[{"name":"attendnaceDocCreated","type":"Bool"},{"name":"autoPrint","type":"Bool"},{"name":"defaultLanguage","type":"String"},{"name":"email","type":"String"},{"name":"googleSheetDocCreated","type":"Bool"},{"name":"hasPin","type":"String"},{"name":"isAttendanceEnabled","type":"Bool"},{"name":"openReceiptFileOSaleComplete","type":"Bool"},{"name":"sendDailyReport","type":"Bool"},{"name":"userId","type":"Long"}],"indexes":[{"name":"userId","unique":false,"replace":false,"properties":[{"name":"userId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'attendnaceDocCreated': 0,
    r'autoPrint': 1,
    r'defaultLanguage': 2,
    r'email': 3,
    r'googleSheetDocCreated': 4,
    r'hasPin': 5,
    r'isAttendanceEnabled': 6,
    r'openReceiptFileOSaleComplete': 7,
    r'sendDailyReport': 8,
    r'userId': 9
  },
  listProperties: {},
  indexIds: {r'userId': 0},
  indexValueTypes: {
    r'userId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _settingGetId,
  setId: _settingSetId,
  getLinks: _settingGetLinks,
  attachLinks: _settingAttachLinks,
  serializeNative: _settingSerializeNative,
  deserializeNative: _settingDeserializeNative,
  deserializePropNative: _settingDeserializePropNative,
  serializeWeb: _settingSerializeWeb,
  deserializeWeb: _settingDeserializeWeb,
  deserializePropWeb: _settingDeserializePropWeb,
  version: 4,
);

int? _settingGetId(Setting object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _settingSetId(Setting object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _settingGetLinks(Setting object) {
  return [];
}

void _settingSerializeNative(
    IsarCollection<Setting> collection,
    IsarCObject cObj,
    Setting object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? defaultLanguage$Bytes;
  final defaultLanguage$Value = object.defaultLanguage;
  if (defaultLanguage$Value != null) {
    defaultLanguage$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(defaultLanguage$Value);
  }
  final email$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.email);
  final hasPin$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.hasPin);
  final size = (staticSize +
      3 +
      (defaultLanguage$Bytes?.length ?? 0) +
      3 +
      (email$Bytes.length) +
      3 +
      (hasPin$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBool(offsets[0], object.attendnaceDocCreated);
  writer.writeBool(offsets[1], object.autoPrint);
  writer.writeByteList(offsets[2], defaultLanguage$Bytes);
  writer.writeByteList(offsets[3], email$Bytes);
  writer.writeBool(offsets[4], object.googleSheetDocCreated);
  writer.writeByteList(offsets[5], hasPin$Bytes);
  writer.writeBool(offsets[6], object.isAttendanceEnabled);
  writer.writeBool(offsets[7], object.openReceiptFileOSaleComplete);
  writer.writeBool(offsets[8], object.sendDailyReport);
  writer.writeLong(offsets[9], object.userId);
}

Setting _settingDeserializeNative(IsarCollection<Setting> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
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

P _settingDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _settingSerializeWeb(
    IsarCollection<Setting> collection, Setting object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, r'attendnaceDocCreated', object.attendnaceDocCreated);
  IsarNative.jsObjectSet(jsObj, r'autoPrint', object.autoPrint);
  IsarNative.jsObjectSet(jsObj, r'defaultLanguage', object.defaultLanguage);
  IsarNative.jsObjectSet(jsObj, r'email', object.email);
  IsarNative.jsObjectSet(
      jsObj, r'googleSheetDocCreated', object.googleSheetDocCreated);
  IsarNative.jsObjectSet(jsObj, r'hasPin', object.hasPin);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(
      jsObj, r'isAttendanceEnabled', object.isAttendanceEnabled);
  IsarNative.jsObjectSet(jsObj, r'openReceiptFileOSaleComplete',
      object.openReceiptFileOSaleComplete);
  IsarNative.jsObjectSet(jsObj, r'sendDailyReport', object.sendDailyReport);
  IsarNative.jsObjectSet(jsObj, r'userId', object.userId);
  return jsObj;
}

Setting _settingDeserializeWeb(
    IsarCollection<Setting> collection, Object jsObj) {
  final object = Setting(
    attendnaceDocCreated:
        IsarNative.jsObjectGet(jsObj, r'attendnaceDocCreated'),
    autoPrint: IsarNative.jsObjectGet(jsObj, r'autoPrint'),
    defaultLanguage: IsarNative.jsObjectGet(jsObj, r'defaultLanguage'),
    email: IsarNative.jsObjectGet(jsObj, r'email') ?? '',
    googleSheetDocCreated:
        IsarNative.jsObjectGet(jsObj, r'googleSheetDocCreated'),
    hasPin: IsarNative.jsObjectGet(jsObj, r'hasPin') ?? '',
    id: IsarNative.jsObjectGet(jsObj, r'id'),
    isAttendanceEnabled: IsarNative.jsObjectGet(jsObj, r'isAttendanceEnabled'),
    openReceiptFileOSaleComplete:
        IsarNative.jsObjectGet(jsObj, r'openReceiptFileOSaleComplete'),
    sendDailyReport: IsarNative.jsObjectGet(jsObj, r'sendDailyReport'),
    userId: IsarNative.jsObjectGet(jsObj, r'userId') ??
        (double.negativeInfinity as int),
  );
  return object;
}

P _settingDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'attendnaceDocCreated':
      return (IsarNative.jsObjectGet(jsObj, r'attendnaceDocCreated')) as P;
    case r'autoPrint':
      return (IsarNative.jsObjectGet(jsObj, r'autoPrint')) as P;
    case r'defaultLanguage':
      return (IsarNative.jsObjectGet(jsObj, r'defaultLanguage')) as P;
    case r'email':
      return (IsarNative.jsObjectGet(jsObj, r'email') ?? '') as P;
    case r'googleSheetDocCreated':
      return (IsarNative.jsObjectGet(jsObj, r'googleSheetDocCreated')) as P;
    case r'hasPin':
      return (IsarNative.jsObjectGet(jsObj, r'hasPin') ?? '') as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'isAttendanceEnabled':
      return (IsarNative.jsObjectGet(jsObj, r'isAttendanceEnabled')) as P;
    case r'openReceiptFileOSaleComplete':
      return (IsarNative.jsObjectGet(jsObj, r'openReceiptFileOSaleComplete'))
          as P;
    case r'sendDailyReport':
      return (IsarNative.jsObjectGet(jsObj, r'sendDailyReport')) as P;
    case r'userId':
      return (IsarNative.jsObjectGet(jsObj, r'userId') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _settingAttachLinks(IsarCollection<dynamic> col, int id, Setting object) {}

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
  QueryBuilder<Setting, Setting, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idBetween(
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool include = false,
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
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
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

extension SettingQueryLinks
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQueryWhereSortBy on QueryBuilder<Setting, Setting, QSortBy> {
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

extension SettingQueryWhereSortThenBy
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
