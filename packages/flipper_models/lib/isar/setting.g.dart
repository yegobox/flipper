// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetSettingCollection on Isar {
  IsarCollection<Setting> get settings => getCollection();
}

const SettingSchema = CollectionSchema(
  name: 'Setting',
  schema:
      '{"name":"Setting","idName":"id","properties":[{"name":"attendnaceDocCreated","type":"Bool"},{"name":"autoPrint","type":"Bool"},{"name":"defaultLanguage","type":"String"},{"name":"email","type":"String"},{"name":"googleSheetDocCreated","type":"Bool"},{"name":"hasPin","type":"String"},{"name":"isAttendanceEnabled","type":"Bool"},{"name":"openReceiptFileOSaleComplete","type":"Bool"},{"name":"sendDailyReport","type":"Bool"},{"name":"userId","type":"Long"}],"indexes":[{"name":"userId","unique":false,"properties":[{"name":"userId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {
    'attendnaceDocCreated': 0,
    'autoPrint': 1,
    'defaultLanguage': 2,
    'email': 3,
    'googleSheetDocCreated': 4,
    'hasPin': 5,
    'isAttendanceEnabled': 6,
    'openReceiptFileOSaleComplete': 7,
    'sendDailyReport': 8,
    'userId': 9
  },
  listProperties: {},
  indexIds: {'userId': 0},
  indexValueTypes: {
    'userId': [
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
  version: 3,
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

List<IsarLinkBase> _settingGetLinks(Setting object) {
  return [];
}

void _settingSerializeNative(
    IsarCollection<Setting> collection,
    IsarRawObject rawObj,
    Setting object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.attendnaceDocCreated;
  final _attendnaceDocCreated = value0;
  final value1 = object.autoPrint;
  final _autoPrint = value1;
  final value2 = object.defaultLanguage;
  IsarUint8List? _defaultLanguage;
  if (value2 != null) {
    _defaultLanguage = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_defaultLanguage?.length ?? 0) as int;
  final value3 = object.email;
  final _email = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_email.length) as int;
  final value4 = object.googleSheetDocCreated;
  final _googleSheetDocCreated = value4;
  final value5 = object.hasPin;
  final _hasPin = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_hasPin.length) as int;
  final value6 = object.isAttendanceEnabled;
  final _isAttendanceEnabled = value6;
  final value7 = object.openReceiptFileOSaleComplete;
  final _openReceiptFileOSaleComplete = value7;
  final value8 = object.sendDailyReport;
  final _sendDailyReport = value8;
  final value9 = object.userId;
  final _userId = value9;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _attendnaceDocCreated);
  writer.writeBool(offsets[1], _autoPrint);
  writer.writeBytes(offsets[2], _defaultLanguage);
  writer.writeBytes(offsets[3], _email);
  writer.writeBool(offsets[4], _googleSheetDocCreated);
  writer.writeBytes(offsets[5], _hasPin);
  writer.writeBool(offsets[6], _isAttendanceEnabled);
  writer.writeBool(offsets[7], _openReceiptFileOSaleComplete);
  writer.writeBool(offsets[8], _sendDailyReport);
  writer.writeLong(offsets[9], _userId);
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
      throw 'Illegal propertyIndex';
  }
}

dynamic _settingSerializeWeb(
    IsarCollection<Setting> collection, Setting object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, 'attendnaceDocCreated', object.attendnaceDocCreated);
  IsarNative.jsObjectSet(jsObj, 'autoPrint', object.autoPrint);
  IsarNative.jsObjectSet(jsObj, 'defaultLanguage', object.defaultLanguage);
  IsarNative.jsObjectSet(jsObj, 'email', object.email);
  IsarNative.jsObjectSet(
      jsObj, 'googleSheetDocCreated', object.googleSheetDocCreated);
  IsarNative.jsObjectSet(jsObj, 'hasPin', object.hasPin);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(
      jsObj, 'isAttendanceEnabled', object.isAttendanceEnabled);
  IsarNative.jsObjectSet(jsObj, 'openReceiptFileOSaleComplete',
      object.openReceiptFileOSaleComplete);
  IsarNative.jsObjectSet(jsObj, 'sendDailyReport', object.sendDailyReport);
  IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
  return jsObj;
}

Setting _settingDeserializeWeb(
    IsarCollection<Setting> collection, dynamic jsObj) {
  final object = Setting(
    attendnaceDocCreated: IsarNative.jsObjectGet(jsObj, 'attendnaceDocCreated'),
    autoPrint: IsarNative.jsObjectGet(jsObj, 'autoPrint'),
    defaultLanguage: IsarNative.jsObjectGet(jsObj, 'defaultLanguage'),
    email: IsarNative.jsObjectGet(jsObj, 'email') ?? '',
    googleSheetDocCreated:
        IsarNative.jsObjectGet(jsObj, 'googleSheetDocCreated'),
    hasPin: IsarNative.jsObjectGet(jsObj, 'hasPin') ?? '',
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    isAttendanceEnabled: IsarNative.jsObjectGet(jsObj, 'isAttendanceEnabled'),
    openReceiptFileOSaleComplete:
        IsarNative.jsObjectGet(jsObj, 'openReceiptFileOSaleComplete'),
    sendDailyReport: IsarNative.jsObjectGet(jsObj, 'sendDailyReport'),
    userId: IsarNative.jsObjectGet(jsObj, 'userId') ?? double.negativeInfinity,
  );
  return object;
}

P _settingDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'attendnaceDocCreated':
      return (IsarNative.jsObjectGet(jsObj, 'attendnaceDocCreated')) as P;
    case 'autoPrint':
      return (IsarNative.jsObjectGet(jsObj, 'autoPrint')) as P;
    case 'defaultLanguage':
      return (IsarNative.jsObjectGet(jsObj, 'defaultLanguage')) as P;
    case 'email':
      return (IsarNative.jsObjectGet(jsObj, 'email') ?? '') as P;
    case 'googleSheetDocCreated':
      return (IsarNative.jsObjectGet(jsObj, 'googleSheetDocCreated')) as P;
    case 'hasPin':
      return (IsarNative.jsObjectGet(jsObj, 'hasPin') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'isAttendanceEnabled':
      return (IsarNative.jsObjectGet(jsObj, 'isAttendanceEnabled')) as P;
    case 'openReceiptFileOSaleComplete':
      return (IsarNative.jsObjectGet(jsObj, 'openReceiptFileOSaleComplete'))
          as P;
    case 'sendDailyReport':
      return (IsarNative.jsObjectGet(jsObj, 'sendDailyReport')) as P;
    case 'userId':
      return (IsarNative.jsObjectGet(jsObj, 'userId') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _settingAttachLinks(IsarCollection col, int id, Setting object) {}

extension SettingQueryWhereSort on QueryBuilder<Setting, Setting, QWhere> {
  QueryBuilder<Setting, Setting, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Setting, Setting, QAfterWhere> anyUserId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'userId'));
  }
}

extension SettingQueryWhere on QueryBuilder<Setting, Setting, QWhereClause> {
  QueryBuilder<Setting, Setting, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdEqualTo(int userId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'userId',
      value: [userId],
    ));
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdNotEqualTo(
      int userId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'userId',
        upper: [userId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'userId',
        lower: [userId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'userId',
        lower: [userId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'userId',
        upper: [userId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'userId',
      lower: [userId],
      includeLower: include,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'userId',
      upper: [userId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'userId',
      lower: [lowerUserId],
      includeLower: includeLower,
      upper: [upperUserId],
      includeUpper: includeUpper,
    ));
  }
}

extension SettingQueryFilter
    on QueryBuilder<Setting, Setting, QFilterCondition> {
  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      attendnaceDocCreatedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'attendnaceDocCreated',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      attendnaceDocCreatedEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'attendnaceDocCreated',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> autoPrintIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'autoPrint',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> autoPrintEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'autoPrint',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'defaultLanguage',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'defaultLanguage',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      defaultLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'defaultLanguage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> defaultLanguageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'defaultLanguage',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'email',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'email',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'googleSheetDocCreated',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      googleSheetDocCreatedEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'googleSheetDocCreated',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'hasPin',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'hasPin',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> hasPinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'hasPin',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isAttendanceEnabled',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      isAttendanceEnabledEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isAttendanceEnabled',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      openReceiptFileOSaleCompleteIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'openReceiptFileOSaleComplete',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      openReceiptFileOSaleCompleteEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'openReceiptFileOSaleComplete',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      sendDailyReportIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'sendDailyReport',
      value: null,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> sendDailyReportEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sendDailyReport',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension SettingQueryLinks
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQueryWhereSortBy on QueryBuilder<Setting, Setting, QSortBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAttendnaceDocCreated() {
    return addSortByInternal('attendnaceDocCreated', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByAttendnaceDocCreatedDesc() {
    return addSortByInternal('attendnaceDocCreated', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAutoPrint() {
    return addSortByInternal('autoPrint', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByAutoPrintDesc() {
    return addSortByInternal('autoPrint', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByDefaultLanguage() {
    return addSortByInternal('defaultLanguage', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByDefaultLanguageDesc() {
    return addSortByInternal('defaultLanguage', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByGoogleSheetDocCreated() {
    return addSortByInternal('googleSheetDocCreated', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByGoogleSheetDocCreatedDesc() {
    return addSortByInternal('googleSheetDocCreated', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByHasPin() {
    return addSortByInternal('hasPin', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByHasPinDesc() {
    return addSortByInternal('hasPin', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByIsAttendanceEnabled() {
    return addSortByInternal('isAttendanceEnabled', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByIsAttendanceEnabledDesc() {
    return addSortByInternal('isAttendanceEnabled', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByOpenReceiptFileOSaleComplete() {
    return addSortByInternal('openReceiptFileOSaleComplete', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      sortByOpenReceiptFileOSaleCompleteDesc() {
    return addSortByInternal('openReceiptFileOSaleComplete', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySendDailyReport() {
    return addSortByInternal('sendDailyReport', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySendDailyReportDesc() {
    return addSortByInternal('sendDailyReport', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension SettingQueryWhereSortThenBy
    on QueryBuilder<Setting, Setting, QSortThenBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAttendnaceDocCreated() {
    return addSortByInternal('attendnaceDocCreated', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByAttendnaceDocCreatedDesc() {
    return addSortByInternal('attendnaceDocCreated', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAutoPrint() {
    return addSortByInternal('autoPrint', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByAutoPrintDesc() {
    return addSortByInternal('autoPrint', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByDefaultLanguage() {
    return addSortByInternal('defaultLanguage', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByDefaultLanguageDesc() {
    return addSortByInternal('defaultLanguage', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByGoogleSheetDocCreated() {
    return addSortByInternal('googleSheetDocCreated', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByGoogleSheetDocCreatedDesc() {
    return addSortByInternal('googleSheetDocCreated', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByHasPin() {
    return addSortByInternal('hasPin', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByHasPinDesc() {
    return addSortByInternal('hasPin', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIsAttendanceEnabled() {
    return addSortByInternal('isAttendanceEnabled', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIsAttendanceEnabledDesc() {
    return addSortByInternal('isAttendanceEnabled', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByOpenReceiptFileOSaleComplete() {
    return addSortByInternal('openReceiptFileOSaleComplete', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy>
      thenByOpenReceiptFileOSaleCompleteDesc() {
    return addSortByInternal('openReceiptFileOSaleComplete', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySendDailyReport() {
    return addSortByInternal('sendDailyReport', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySendDailyReportDesc() {
    return addSortByInternal('sendDailyReport', Sort.desc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension SettingQueryWhereDistinct
    on QueryBuilder<Setting, Setting, QDistinct> {
  QueryBuilder<Setting, Setting, QDistinct> distinctByAttendnaceDocCreated() {
    return addDistinctByInternal('attendnaceDocCreated');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByAutoPrint() {
    return addDistinctByInternal('autoPrint');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByDefaultLanguage(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('defaultLanguage',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('email', caseSensitive: caseSensitive);
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByGoogleSheetDocCreated() {
    return addDistinctByInternal('googleSheetDocCreated');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByHasPin(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('hasPin', caseSensitive: caseSensitive);
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByIsAttendanceEnabled() {
    return addDistinctByInternal('isAttendanceEnabled');
  }

  QueryBuilder<Setting, Setting, QDistinct>
      distinctByOpenReceiptFileOSaleComplete() {
    return addDistinctByInternal('openReceiptFileOSaleComplete');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctBySendDailyReport() {
    return addDistinctByInternal('sendDailyReport');
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByUserId() {
    return addDistinctByInternal('userId');
  }
}

extension SettingQueryProperty
    on QueryBuilder<Setting, Setting, QQueryProperty> {
  QueryBuilder<Setting, bool?, QQueryOperations>
      attendnaceDocCreatedProperty() {
    return addPropertyNameInternal('attendnaceDocCreated');
  }

  QueryBuilder<Setting, bool?, QQueryOperations> autoPrintProperty() {
    return addPropertyNameInternal('autoPrint');
  }

  QueryBuilder<Setting, String?, QQueryOperations> defaultLanguageProperty() {
    return addPropertyNameInternal('defaultLanguage');
  }

  QueryBuilder<Setting, String, QQueryOperations> emailProperty() {
    return addPropertyNameInternal('email');
  }

  QueryBuilder<Setting, bool?, QQueryOperations>
      googleSheetDocCreatedProperty() {
    return addPropertyNameInternal('googleSheetDocCreated');
  }

  QueryBuilder<Setting, String, QQueryOperations> hasPinProperty() {
    return addPropertyNameInternal('hasPin');
  }

  QueryBuilder<Setting, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Setting, bool?, QQueryOperations> isAttendanceEnabledProperty() {
    return addPropertyNameInternal('isAttendanceEnabled');
  }

  QueryBuilder<Setting, bool?, QQueryOperations>
      openReceiptFileOSaleCompleteProperty() {
    return addPropertyNameInternal('openReceiptFileOSaleComplete');
  }

  QueryBuilder<Setting, bool?, QQueryOperations> sendDailyReportProperty() {
    return addPropertyNameInternal('sendDailyReport');
  }

  QueryBuilder<Setting, int, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
