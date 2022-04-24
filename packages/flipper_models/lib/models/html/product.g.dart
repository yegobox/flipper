// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetProductCollection on Isar {
  IsarCollection<Product> get products => getCollection();
}

const ProductSchema = CollectionSchema(
  name: 'Product',
  schema:
      '{"name":"Product","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"barCode","type":"String"},{"name":"channels","type":"StringList"},{"name":"color","type":"String"},{"name":"createdAt","type":"String"},{"name":"currentUpdate","type":"Bool"},{"name":"description","type":"String"},{"name":"draft","type":"Bool"},{"name":"expiryDate","type":"String"},{"name":"fbranchId","type":"Long"},{"name":"fbusinessId","type":"Long"},{"name":"fcategoryId","type":"String"},{"name":"fsupplierId","type":"String"},{"name":"ftaxId","type":"String"},{"name":"hasPicture","type":"Bool"},{"name":"imageLocal","type":"Bool"},{"name":"imageUrl","type":"String"},{"name":"migrated","type":"Bool"},{"name":"name","type":"String"},{"name":"synced","type":"Bool"},{"name":"table","type":"String"},{"name":"unit","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'active': 0,
    'barCode': 1,
    'channels': 2,
    'color': 3,
    'createdAt': 4,
    'currentUpdate': 5,
    'description': 6,
    'draft': 7,
    'expiryDate': 8,
    'fbranchId': 9,
    'fbusinessId': 10,
    'fcategoryId': 11,
    'fsupplierId': 12,
    'ftaxId': 13,
    'hasPicture': 14,
    'imageLocal': 15,
    'imageUrl': 16,
    'migrated': 17,
    'name': 18,
    'synced': 19,
    'table': 20,
    'unit': 21
  },
  listProperties: {'channels'},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _productGetId,
  setId: _productSetId,
  getLinks: _productGetLinks,
  attachLinks: _productAttachLinks,
  serializeNative: _productSerializeNative,
  deserializeNative: _productDeserializeNative,
  deserializePropNative: _productDeserializePropNative,
  serializeWeb: _productSerializeWeb,
  deserializeWeb: _productDeserializeWeb,
  deserializePropWeb: _productDeserializePropWeb,
  version: 3,
);

int? _productGetId(Product object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _productSetId(Product object, int id) {
  object.id = id;
}

List<IsarLinkBase> _productGetLinks(Product object) {
  return [];
}

void _productSerializeNative(
    IsarCollection<Product> collection,
    IsarRawObject rawObj,
    Product object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.active;
  final _active = value0;
  final value1 = object.barCode;
  IsarUint8List? _barCode;
  if (value1 != null) {
    _barCode = IsarBinaryWriter.utf8Encoder.convert(value1);
  }
  dynamicSize += (_barCode?.length ?? 0) as int;
  final value2 = object.channels;
  dynamicSize += (value2?.length ?? 0) * 8;
  List<IsarUint8List?>? bytesList2;
  if (value2 != null) {
    bytesList2 = [];
    for (var str in value2) {
      final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
      bytesList2.add(bytes);
      dynamicSize += bytes.length as int;
    }
  }
  final _channels = bytesList2;
  final value3 = object.color;
  final _color = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_color.length) as int;
  final value4 = object.createdAt;
  IsarUint8List? _createdAt;
  if (value4 != null) {
    _createdAt = IsarBinaryWriter.utf8Encoder.convert(value4);
  }
  dynamicSize += (_createdAt?.length ?? 0) as int;
  final value5 = object.currentUpdate;
  final _currentUpdate = value5;
  final value6 = object.description;
  IsarUint8List? _description;
  if (value6 != null) {
    _description = IsarBinaryWriter.utf8Encoder.convert(value6);
  }
  dynamicSize += (_description?.length ?? 0) as int;
  final value7 = object.draft;
  final _draft = value7;
  final value8 = object.expiryDate;
  IsarUint8List? _expiryDate;
  if (value8 != null) {
    _expiryDate = IsarBinaryWriter.utf8Encoder.convert(value8);
  }
  dynamicSize += (_expiryDate?.length ?? 0) as int;
  final value9 = object.fbranchId;
  final _fbranchId = value9;
  final value10 = object.fbusinessId;
  final _fbusinessId = value10;
  final value11 = object.fcategoryId;
  IsarUint8List? _fcategoryId;
  if (value11 != null) {
    _fcategoryId = IsarBinaryWriter.utf8Encoder.convert(value11);
  }
  dynamicSize += (_fcategoryId?.length ?? 0) as int;
  final value12 = object.fsupplierId;
  IsarUint8List? _fsupplierId;
  if (value12 != null) {
    _fsupplierId = IsarBinaryWriter.utf8Encoder.convert(value12);
  }
  dynamicSize += (_fsupplierId?.length ?? 0) as int;
  final value13 = object.ftaxId;
  IsarUint8List? _ftaxId;
  if (value13 != null) {
    _ftaxId = IsarBinaryWriter.utf8Encoder.convert(value13);
  }
  dynamicSize += (_ftaxId?.length ?? 0) as int;
  final value14 = object.hasPicture;
  final _hasPicture = value14;
  final value15 = object.imageLocal;
  final _imageLocal = value15;
  final value16 = object.imageUrl;
  IsarUint8List? _imageUrl;
  if (value16 != null) {
    _imageUrl = IsarBinaryWriter.utf8Encoder.convert(value16);
  }
  dynamicSize += (_imageUrl?.length ?? 0) as int;
  final value17 = object.migrated;
  final _migrated = value17;
  final value18 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value18);
  dynamicSize += (_name.length) as int;
  final value19 = object.synced;
  final _synced = value19;
  final value20 = object.table;
  final _table = IsarBinaryWriter.utf8Encoder.convert(value20);
  dynamicSize += (_table.length) as int;
  final value21 = object.unit;
  final _unit = IsarBinaryWriter.utf8Encoder.convert(value21);
  dynamicSize += (_unit.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _active);
  writer.writeBytes(offsets[1], _barCode);
  writer.writeStringList(offsets[2], _channels);
  writer.writeBytes(offsets[3], _color);
  writer.writeBytes(offsets[4], _createdAt);
  writer.writeBool(offsets[5], _currentUpdate);
  writer.writeBytes(offsets[6], _description);
  writer.writeBool(offsets[7], _draft);
  writer.writeBytes(offsets[8], _expiryDate);
  writer.writeLong(offsets[9], _fbranchId);
  writer.writeLong(offsets[10], _fbusinessId);
  writer.writeBytes(offsets[11], _fcategoryId);
  writer.writeBytes(offsets[12], _fsupplierId);
  writer.writeBytes(offsets[13], _ftaxId);
  writer.writeBool(offsets[14], _hasPicture);
  writer.writeBool(offsets[15], _imageLocal);
  writer.writeBytes(offsets[16], _imageUrl);
  writer.writeBool(offsets[17], _migrated);
  writer.writeBytes(offsets[18], _name);
  writer.writeBool(offsets[19], _synced);
  writer.writeBytes(offsets[20], _table);
  writer.writeBytes(offsets[21], _unit);
}

Product _productDeserializeNative(IsarCollection<Product> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Product(
    active: reader.readBool(offsets[0]),
    barCode: reader.readStringOrNull(offsets[1]),
    channels: reader.readStringList(offsets[2]),
    color: reader.readString(offsets[3]),
    createdAt: reader.readStringOrNull(offsets[4]),
    currentUpdate: reader.readBoolOrNull(offsets[5]),
    description: reader.readStringOrNull(offsets[6]),
    draft: reader.readBoolOrNull(offsets[7]),
    expiryDate: reader.readStringOrNull(offsets[8]),
    fbranchId: reader.readLong(offsets[9]),
    fbusinessId: reader.readLong(offsets[10]),
    fcategoryId: reader.readStringOrNull(offsets[11]),
    fsupplierId: reader.readStringOrNull(offsets[12]),
    ftaxId: reader.readStringOrNull(offsets[13]),
    hasPicture: reader.readBool(offsets[14]),
    id: id,
    imageLocal: reader.readBoolOrNull(offsets[15]),
    imageUrl: reader.readStringOrNull(offsets[16]),
    migrated: reader.readBoolOrNull(offsets[17]),
    name: reader.readString(offsets[18]),
    synced: reader.readBoolOrNull(offsets[19]),
    table: reader.readString(offsets[20]),
    unit: reader.readString(offsets[21]),
  );
  return object;
}

P _productDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readBoolOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _productSerializeWeb(
    IsarCollection<Product> collection, Product object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'barCode', object.barCode);
  IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
  IsarNative.jsObjectSet(jsObj, 'color', object.color);
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'currentUpdate', object.currentUpdate);
  IsarNative.jsObjectSet(jsObj, 'description', object.description);
  IsarNative.jsObjectSet(jsObj, 'draft', object.draft);
  IsarNative.jsObjectSet(jsObj, 'expiryDate', object.expiryDate);
  IsarNative.jsObjectSet(jsObj, 'fbranchId', object.fbranchId);
  IsarNative.jsObjectSet(jsObj, 'fbusinessId', object.fbusinessId);
  IsarNative.jsObjectSet(jsObj, 'fcategoryId', object.fcategoryId);
  IsarNative.jsObjectSet(jsObj, 'fsupplierId', object.fsupplierId);
  IsarNative.jsObjectSet(jsObj, 'ftaxId', object.ftaxId);
  IsarNative.jsObjectSet(jsObj, 'hasPicture', object.hasPicture);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'imageLocal', object.imageLocal);
  IsarNative.jsObjectSet(jsObj, 'imageUrl', object.imageUrl);
  IsarNative.jsObjectSet(jsObj, 'migrated', object.migrated);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'synced', object.synced);
  IsarNative.jsObjectSet(jsObj, 'table', object.table);
  IsarNative.jsObjectSet(jsObj, 'unit', object.unit);
  return jsObj;
}

Product _productDeserializeWeb(
    IsarCollection<Product> collection, dynamic jsObj) {
  final object = Product(
    active: IsarNative.jsObjectGet(jsObj, 'active') ?? false,
    barCode: IsarNative.jsObjectGet(jsObj, 'barCode'),
    channels: (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>(),
    color: IsarNative.jsObjectGet(jsObj, 'color') ?? '',
    createdAt: IsarNative.jsObjectGet(jsObj, 'createdAt'),
    currentUpdate: IsarNative.jsObjectGet(jsObj, 'currentUpdate'),
    description: IsarNative.jsObjectGet(jsObj, 'description'),
    draft: IsarNative.jsObjectGet(jsObj, 'draft'),
    expiryDate: IsarNative.jsObjectGet(jsObj, 'expiryDate'),
    fbranchId:
        IsarNative.jsObjectGet(jsObj, 'fbranchId') ?? double.negativeInfinity,
    fbusinessId:
        IsarNative.jsObjectGet(jsObj, 'fbusinessId') ?? double.negativeInfinity,
    fcategoryId: IsarNative.jsObjectGet(jsObj, 'fcategoryId'),
    fsupplierId: IsarNative.jsObjectGet(jsObj, 'fsupplierId'),
    ftaxId: IsarNative.jsObjectGet(jsObj, 'ftaxId'),
    hasPicture: IsarNative.jsObjectGet(jsObj, 'hasPicture') ?? false,
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    imageLocal: IsarNative.jsObjectGet(jsObj, 'imageLocal'),
    imageUrl: IsarNative.jsObjectGet(jsObj, 'imageUrl'),
    migrated: IsarNative.jsObjectGet(jsObj, 'migrated'),
    name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
    synced: IsarNative.jsObjectGet(jsObj, 'synced'),
    table: IsarNative.jsObjectGet(jsObj, 'table') ?? '',
    unit: IsarNative.jsObjectGet(jsObj, 'unit') ?? '',
  );
  return object;
}

P _productDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active') ?? false) as P;
    case 'barCode':
      return (IsarNative.jsObjectGet(jsObj, 'barCode')) as P;
    case 'channels':
      return ((IsarNative.jsObjectGet(jsObj, 'channels') as List?)
          ?.map((e) => e ?? '')
          .toList()
          .cast<String>()) as P;
    case 'color':
      return (IsarNative.jsObjectGet(jsObj, 'color') ?? '') as P;
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt')) as P;
    case 'currentUpdate':
      return (IsarNative.jsObjectGet(jsObj, 'currentUpdate')) as P;
    case 'description':
      return (IsarNative.jsObjectGet(jsObj, 'description')) as P;
    case 'draft':
      return (IsarNative.jsObjectGet(jsObj, 'draft')) as P;
    case 'expiryDate':
      return (IsarNative.jsObjectGet(jsObj, 'expiryDate')) as P;
    case 'fbranchId':
      return (IsarNative.jsObjectGet(jsObj, 'fbranchId') ??
          double.negativeInfinity) as P;
    case 'fbusinessId':
      return (IsarNative.jsObjectGet(jsObj, 'fbusinessId') ??
          double.negativeInfinity) as P;
    case 'fcategoryId':
      return (IsarNative.jsObjectGet(jsObj, 'fcategoryId')) as P;
    case 'fsupplierId':
      return (IsarNative.jsObjectGet(jsObj, 'fsupplierId')) as P;
    case 'ftaxId':
      return (IsarNative.jsObjectGet(jsObj, 'ftaxId')) as P;
    case 'hasPicture':
      return (IsarNative.jsObjectGet(jsObj, 'hasPicture') ?? false) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'imageLocal':
      return (IsarNative.jsObjectGet(jsObj, 'imageLocal')) as P;
    case 'imageUrl':
      return (IsarNative.jsObjectGet(jsObj, 'imageUrl')) as P;
    case 'migrated':
      return (IsarNative.jsObjectGet(jsObj, 'migrated')) as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'synced':
      return (IsarNative.jsObjectGet(jsObj, 'synced')) as P;
    case 'table':
      return (IsarNative.jsObjectGet(jsObj, 'table') ?? '') as P;
    case 'unit':
      return (IsarNative.jsObjectGet(jsObj, 'unit') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _productAttachLinks(IsarCollection col, int id, Product object) {}

extension ProductQueryWhereSort on QueryBuilder<Product, Product, QWhere> {
  QueryBuilder<Product, Product, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension ProductQueryWhere on QueryBuilder<Product, Product, QWhereClause> {
  QueryBuilder<Product, Product, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Product, Product, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Product, Product, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Product, Product, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Product, Product, QAfterWhereClause> idBetween(
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
}

extension ProductQueryFilter
    on QueryBuilder<Product, Product, QFilterCondition> {
  QueryBuilder<Product, Product, QAfterFilterCondition> activeEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'barCode',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'barCode',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> barCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'barCode',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'channels',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> channelsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'color',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'color',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'createdAt',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> currentUpdateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'currentUpdate',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> currentUpdateEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'currentUpdate',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'description',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> draftIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'draft',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> draftEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'draft',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'expiryDate',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'expiryDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> expiryDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'expiryDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbranchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbranchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbranchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fbranchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbranchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fbranchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbusinessIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbusinessIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbusinessIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fbusinessIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fbusinessId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fcategoryId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fcategoryId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fcategoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fcategoryIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fcategoryId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fsupplierId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fsupplierId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fsupplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> fsupplierIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fsupplierId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'ftaxId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'ftaxId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'ftaxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> ftaxIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'ftaxId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> hasPictureEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hasPicture',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Product, Product, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Product, Product, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Product, Product, QAfterFilterCondition> imageLocalIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageLocal',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageLocalEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imageLocal',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageUrl',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'imageUrl',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imageUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> migratedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'migrated',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> migratedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'migrated',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> syncedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'synced',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> syncedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'synced',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'table',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'unit',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'unit',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension ProductQueryLinks
    on QueryBuilder<Product, Product, QFilterCondition> {}

extension ProductQueryWhereSortBy on QueryBuilder<Product, Product, QSortBy> {
  QueryBuilder<Product, Product, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByBarCode() {
    return addSortByInternal('barCode', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByBarCodeDesc() {
    return addSortByInternal('barCode', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCurrentUpdate() {
    return addSortByInternal('currentUpdate', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCurrentUpdateDesc() {
    return addSortByInternal('currentUpdate', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByExpiryDate() {
    return addSortByInternal('expiryDate', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByExpiryDateDesc() {
    return addSortByInternal('expiryDate', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFbranchId() {
    return addSortByInternal('fbranchId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFbranchIdDesc() {
    return addSortByInternal('fbranchId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFbusinessId() {
    return addSortByInternal('fbusinessId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFbusinessIdDesc() {
    return addSortByInternal('fbusinessId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFsupplierId() {
    return addSortByInternal('fsupplierId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFsupplierIdDesc() {
    return addSortByInternal('fsupplierId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFtaxId() {
    return addSortByInternal('ftaxId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByFtaxIdDesc() {
    return addSortByInternal('ftaxId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByHasPicture() {
    return addSortByInternal('hasPicture', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByHasPictureDesc() {
    return addSortByInternal('hasPicture', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByImageLocal() {
    return addSortByInternal('imageLocal', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByImageLocalDesc() {
    return addSortByInternal('imageLocal', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByMigrated() {
    return addSortByInternal('migrated', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByMigratedDesc() {
    return addSortByInternal('migrated', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension ProductQueryWhereSortThenBy
    on QueryBuilder<Product, Product, QSortThenBy> {
  QueryBuilder<Product, Product, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByBarCode() {
    return addSortByInternal('barCode', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByBarCodeDesc() {
    return addSortByInternal('barCode', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCurrentUpdate() {
    return addSortByInternal('currentUpdate', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCurrentUpdateDesc() {
    return addSortByInternal('currentUpdate', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByExpiryDate() {
    return addSortByInternal('expiryDate', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByExpiryDateDesc() {
    return addSortByInternal('expiryDate', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFbranchId() {
    return addSortByInternal('fbranchId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFbranchIdDesc() {
    return addSortByInternal('fbranchId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFbusinessId() {
    return addSortByInternal('fbusinessId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFbusinessIdDesc() {
    return addSortByInternal('fbusinessId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFsupplierId() {
    return addSortByInternal('fsupplierId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFsupplierIdDesc() {
    return addSortByInternal('fsupplierId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFtaxId() {
    return addSortByInternal('ftaxId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByFtaxIdDesc() {
    return addSortByInternal('ftaxId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByHasPicture() {
    return addSortByInternal('hasPicture', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByHasPictureDesc() {
    return addSortByInternal('hasPicture', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByImageLocal() {
    return addSortByInternal('imageLocal', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByImageLocalDesc() {
    return addSortByInternal('imageLocal', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByMigrated() {
    return addSortByInternal('migrated', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByMigratedDesc() {
    return addSortByInternal('migrated', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension ProductQueryWhereDistinct
    on QueryBuilder<Product, Product, QDistinct> {
  QueryBuilder<Product, Product, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByBarCode(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('barCode', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('color', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByCurrentUpdate() {
    return addDistinctByInternal('currentUpdate');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByDraft() {
    return addDistinctByInternal('draft');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByExpiryDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('expiryDate', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByFbranchId() {
    return addDistinctByInternal('fbranchId');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByFbusinessId() {
    return addDistinctByInternal('fbusinessId');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByFcategoryId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fcategoryId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByFsupplierId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fsupplierId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByFtaxId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('ftaxId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByHasPicture() {
    return addDistinctByInternal('hasPicture');
  }

  QueryBuilder<Product, Product, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByImageLocal() {
    return addDistinctByInternal('imageLocal');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imageUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByMigrated() {
    return addDistinctByInternal('migrated');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctBySynced() {
    return addDistinctByInternal('synced');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('unit', caseSensitive: caseSensitive);
  }
}

extension ProductQueryProperty
    on QueryBuilder<Product, Product, QQueryProperty> {
  QueryBuilder<Product, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Product, String?, QQueryOperations> barCodeProperty() {
    return addPropertyNameInternal('barCode');
  }

  QueryBuilder<Product, List<String>?, QQueryOperations> channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<Product, String, QQueryOperations> colorProperty() {
    return addPropertyNameInternal('color');
  }

  QueryBuilder<Product, String?, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Product, bool?, QQueryOperations> currentUpdateProperty() {
    return addPropertyNameInternal('currentUpdate');
  }

  QueryBuilder<Product, String?, QQueryOperations> descriptionProperty() {
    return addPropertyNameInternal('description');
  }

  QueryBuilder<Product, bool?, QQueryOperations> draftProperty() {
    return addPropertyNameInternal('draft');
  }

  QueryBuilder<Product, String?, QQueryOperations> expiryDateProperty() {
    return addPropertyNameInternal('expiryDate');
  }

  QueryBuilder<Product, int, QQueryOperations> fbranchIdProperty() {
    return addPropertyNameInternal('fbranchId');
  }

  QueryBuilder<Product, int, QQueryOperations> fbusinessIdProperty() {
    return addPropertyNameInternal('fbusinessId');
  }

  QueryBuilder<Product, String?, QQueryOperations> fcategoryIdProperty() {
    return addPropertyNameInternal('fcategoryId');
  }

  QueryBuilder<Product, String?, QQueryOperations> fsupplierIdProperty() {
    return addPropertyNameInternal('fsupplierId');
  }

  QueryBuilder<Product, String?, QQueryOperations> ftaxIdProperty() {
    return addPropertyNameInternal('ftaxId');
  }

  QueryBuilder<Product, bool, QQueryOperations> hasPictureProperty() {
    return addPropertyNameInternal('hasPicture');
  }

  QueryBuilder<Product, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Product, bool?, QQueryOperations> imageLocalProperty() {
    return addPropertyNameInternal('imageLocal');
  }

  QueryBuilder<Product, String?, QQueryOperations> imageUrlProperty() {
    return addPropertyNameInternal('imageUrl');
  }

  QueryBuilder<Product, bool?, QQueryOperations> migratedProperty() {
    return addPropertyNameInternal('migrated');
  }

  QueryBuilder<Product, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Product, bool?, QQueryOperations> syncedProperty() {
    return addPropertyNameInternal('synced');
  }

  QueryBuilder<Product, String, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<Product, String, QQueryOperations> unitProperty() {
    return addPropertyNameInternal('unit');
  }
}
