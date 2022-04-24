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
      '{"name":"Product","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"barCode","type":"String"},{"name":"branchId","type":"Long"},{"name":"businessId","type":"Long"},{"name":"categoryId","type":"String"},{"name":"color","type":"String"},{"name":"createdAt","type":"String"},{"name":"currentUpdate","type":"Bool"},{"name":"description","type":"String"},{"name":"draft","type":"Bool"},{"name":"expiryDate","type":"String"},{"name":"hasPicture","type":"Bool"},{"name":"imageLocal","type":"Bool"},{"name":"imageUrl","type":"String"},{"name":"name","type":"String"},{"name":"picture","type":"String"},{"name":"supplierId","type":"String"},{"name":"synced","type":"Bool"},{"name":"table","type":"String"},{"name":"taxId","type":"String"},{"name":"unit","type":"String"}],"indexes":[],"links":[{"name":"variants","target":"Variant"}]}',
  idName: 'id',
  propertyIds: {
    'active': 0,
    'barCode': 1,
    'branchId': 2,
    'businessId': 3,
    'categoryId': 4,
    'color': 5,
    'createdAt': 6,
    'currentUpdate': 7,
    'description': 8,
    'draft': 9,
    'expiryDate': 10,
    'hasPicture': 11,
    'imageLocal': 12,
    'imageUrl': 13,
    'name': 14,
    'picture': 15,
    'supplierId': 16,
    'synced': 17,
    'table': 18,
    'taxId': 19,
    'unit': 20
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {'variants': 0},
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
  return [object.variants];
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
  final value2 = object.branchId;
  final _branchId = value2;
  final value3 = object.businessId;
  final _businessId = value3;
  final value4 = object.categoryId;
  IsarUint8List? _categoryId;
  if (value4 != null) {
    _categoryId = IsarBinaryWriter.utf8Encoder.convert(value4);
  }
  dynamicSize += (_categoryId?.length ?? 0) as int;
  final value5 = object.color;
  final _color = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_color.length) as int;
  final value6 = object.createdAt;
  IsarUint8List? _createdAt;
  if (value6 != null) {
    _createdAt = IsarBinaryWriter.utf8Encoder.convert(value6);
  }
  dynamicSize += (_createdAt?.length ?? 0) as int;
  final value7 = object.currentUpdate;
  final _currentUpdate = value7;
  final value8 = object.description;
  IsarUint8List? _description;
  if (value8 != null) {
    _description = IsarBinaryWriter.utf8Encoder.convert(value8);
  }
  dynamicSize += (_description?.length ?? 0) as int;
  final value9 = object.draft;
  final _draft = value9;
  final value10 = object.expiryDate;
  IsarUint8List? _expiryDate;
  if (value10 != null) {
    _expiryDate = IsarBinaryWriter.utf8Encoder.convert(value10);
  }
  dynamicSize += (_expiryDate?.length ?? 0) as int;
  final value11 = object.hasPicture;
  final _hasPicture = value11;
  final value12 = object.imageLocal;
  final _imageLocal = value12;
  final value13 = object.imageUrl;
  IsarUint8List? _imageUrl;
  if (value13 != null) {
    _imageUrl = IsarBinaryWriter.utf8Encoder.convert(value13);
  }
  dynamicSize += (_imageUrl?.length ?? 0) as int;
  final value14 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value14);
  dynamicSize += (_name.length) as int;
  final value15 = object.picture;
  IsarUint8List? _picture;
  if (value15 != null) {
    _picture = IsarBinaryWriter.utf8Encoder.convert(value15);
  }
  dynamicSize += (_picture?.length ?? 0) as int;
  final value16 = object.supplierId;
  IsarUint8List? _supplierId;
  if (value16 != null) {
    _supplierId = IsarBinaryWriter.utf8Encoder.convert(value16);
  }
  dynamicSize += (_supplierId?.length ?? 0) as int;
  final value17 = object.synced;
  final _synced = value17;
  final value18 = object.table;
  IsarUint8List? _table;
  if (value18 != null) {
    _table = IsarBinaryWriter.utf8Encoder.convert(value18);
  }
  dynamicSize += (_table?.length ?? 0) as int;
  final value19 = object.taxId;
  IsarUint8List? _taxId;
  if (value19 != null) {
    _taxId = IsarBinaryWriter.utf8Encoder.convert(value19);
  }
  dynamicSize += (_taxId?.length ?? 0) as int;
  final value20 = object.unit;
  IsarUint8List? _unit;
  if (value20 != null) {
    _unit = IsarBinaryWriter.utf8Encoder.convert(value20);
  }
  dynamicSize += (_unit?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _active);
  writer.writeBytes(offsets[1], _barCode);
  writer.writeLong(offsets[2], _branchId);
  writer.writeLong(offsets[3], _businessId);
  writer.writeBytes(offsets[4], _categoryId);
  writer.writeBytes(offsets[5], _color);
  writer.writeBytes(offsets[6], _createdAt);
  writer.writeBool(offsets[7], _currentUpdate);
  writer.writeBytes(offsets[8], _description);
  writer.writeBool(offsets[9], _draft);
  writer.writeBytes(offsets[10], _expiryDate);
  writer.writeBool(offsets[11], _hasPicture);
  writer.writeBool(offsets[12], _imageLocal);
  writer.writeBytes(offsets[13], _imageUrl);
  writer.writeBytes(offsets[14], _name);
  writer.writeBytes(offsets[15], _picture);
  writer.writeBytes(offsets[16], _supplierId);
  writer.writeBool(offsets[17], _synced);
  writer.writeBytes(offsets[18], _table);
  writer.writeBytes(offsets[19], _taxId);
  writer.writeBytes(offsets[20], _unit);
}

Product _productDeserializeNative(IsarCollection<Product> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Product();
  object.active = reader.readBool(offsets[0]);
  object.barCode = reader.readStringOrNull(offsets[1]);
  object.branchId = reader.readLong(offsets[2]);
  object.businessId = reader.readLong(offsets[3]);
  object.categoryId = reader.readStringOrNull(offsets[4]);
  object.color = reader.readString(offsets[5]);
  object.createdAt = reader.readStringOrNull(offsets[6]);
  object.currentUpdate = reader.readBoolOrNull(offsets[7]);
  object.description = reader.readStringOrNull(offsets[8]);
  object.draft = reader.readBoolOrNull(offsets[9]);
  object.expiryDate = reader.readStringOrNull(offsets[10]);
  object.hasPicture = reader.readBool(offsets[11]);
  object.id = id;
  object.imageLocal = reader.readBoolOrNull(offsets[12]);
  object.imageUrl = reader.readStringOrNull(offsets[13]);
  object.name = reader.readString(offsets[14]);
  object.picture = reader.readStringOrNull(offsets[15]);
  object.supplierId = reader.readStringOrNull(offsets[16]);
  object.synced = reader.readBoolOrNull(offsets[17]);
  object.table = reader.readStringOrNull(offsets[18]);
  object.taxId = reader.readStringOrNull(offsets[19]);
  object.unit = reader.readStringOrNull(offsets[20]);
  _productAttachLinks(collection, id, object);
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _productSerializeWeb(
    IsarCollection<Product> collection, Product object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'barCode', object.barCode);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'businessId', object.businessId);
  IsarNative.jsObjectSet(jsObj, 'categoryId', object.categoryId);
  IsarNative.jsObjectSet(jsObj, 'color', object.color);
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'currentUpdate', object.currentUpdate);
  IsarNative.jsObjectSet(jsObj, 'description', object.description);
  IsarNative.jsObjectSet(jsObj, 'draft', object.draft);
  IsarNative.jsObjectSet(jsObj, 'expiryDate', object.expiryDate);
  IsarNative.jsObjectSet(jsObj, 'hasPicture', object.hasPicture);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'imageLocal', object.imageLocal);
  IsarNative.jsObjectSet(jsObj, 'imageUrl', object.imageUrl);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'picture', object.picture);
  IsarNative.jsObjectSet(jsObj, 'supplierId', object.supplierId);
  IsarNative.jsObjectSet(jsObj, 'synced', object.synced);
  IsarNative.jsObjectSet(jsObj, 'table', object.table);
  IsarNative.jsObjectSet(jsObj, 'taxId', object.taxId);
  IsarNative.jsObjectSet(jsObj, 'unit', object.unit);
  return jsObj;
}

Product _productDeserializeWeb(
    IsarCollection<Product> collection, dynamic jsObj) {
  final object = Product();
  object.active = IsarNative.jsObjectGet(jsObj, 'active') ?? false;
  object.barCode = IsarNative.jsObjectGet(jsObj, 'barCode');
  object.branchId =
      IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
  object.businessId =
      IsarNative.jsObjectGet(jsObj, 'businessId') ?? double.negativeInfinity;
  object.categoryId = IsarNative.jsObjectGet(jsObj, 'categoryId');
  object.color = IsarNative.jsObjectGet(jsObj, 'color') ?? '';
  object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt');
  object.currentUpdate = IsarNative.jsObjectGet(jsObj, 'currentUpdate');
  object.description = IsarNative.jsObjectGet(jsObj, 'description');
  object.draft = IsarNative.jsObjectGet(jsObj, 'draft');
  object.expiryDate = IsarNative.jsObjectGet(jsObj, 'expiryDate');
  object.hasPicture = IsarNative.jsObjectGet(jsObj, 'hasPicture') ?? false;
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.imageLocal = IsarNative.jsObjectGet(jsObj, 'imageLocal');
  object.imageUrl = IsarNative.jsObjectGet(jsObj, 'imageUrl');
  object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
  object.picture = IsarNative.jsObjectGet(jsObj, 'picture');
  object.supplierId = IsarNative.jsObjectGet(jsObj, 'supplierId');
  object.synced = IsarNative.jsObjectGet(jsObj, 'synced');
  object.table = IsarNative.jsObjectGet(jsObj, 'table');
  object.taxId = IsarNative.jsObjectGet(jsObj, 'taxId');
  object.unit = IsarNative.jsObjectGet(jsObj, 'unit');
  _productAttachLinks(collection, IsarNative.jsObjectGet(jsObj, 'id'), object);
  return object;
}

P _productDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active') ?? false) as P;
    case 'barCode':
      return (IsarNative.jsObjectGet(jsObj, 'barCode')) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'businessId':
      return (IsarNative.jsObjectGet(jsObj, 'businessId') ??
          double.negativeInfinity) as P;
    case 'categoryId':
      return (IsarNative.jsObjectGet(jsObj, 'categoryId')) as P;
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
    case 'hasPicture':
      return (IsarNative.jsObjectGet(jsObj, 'hasPicture') ?? false) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'imageLocal':
      return (IsarNative.jsObjectGet(jsObj, 'imageLocal')) as P;
    case 'imageUrl':
      return (IsarNative.jsObjectGet(jsObj, 'imageUrl')) as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'picture':
      return (IsarNative.jsObjectGet(jsObj, 'picture')) as P;
    case 'supplierId':
      return (IsarNative.jsObjectGet(jsObj, 'supplierId')) as P;
    case 'synced':
      return (IsarNative.jsObjectGet(jsObj, 'synced')) as P;
    case 'table':
      return (IsarNative.jsObjectGet(jsObj, 'table')) as P;
    case 'taxId':
      return (IsarNative.jsObjectGet(jsObj, 'taxId')) as P;
    case 'unit':
      return (IsarNative.jsObjectGet(jsObj, 'unit')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _productAttachLinks(IsarCollection col, int id, Product object) {
  object.variants.attach(col, col.isar.variants, 'variants', id);
}

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

  QueryBuilder<Product, Product, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'branchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> businessIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> businessIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> businessIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> businessIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'businessId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'categoryId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'categoryId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> categoryIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'categoryId',
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

  QueryBuilder<Product, Product, QAfterFilterCondition> hasPictureEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hasPicture',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> idGreaterThan(
    int? value, {
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
    int? value, {
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
    int? lower,
    int? upper, {
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

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'picture',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'picture',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'picture',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'supplierId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'supplierId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> supplierIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'supplierId',
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

  QueryBuilder<Product, Product, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> tableEqualTo(
    String? value, {
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
    String? value, {
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
    String? value, {
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
    String? lower,
    String? upper, {
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

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxId',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'taxId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> taxIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'unit',
      value: null,
    ));
  }

  QueryBuilder<Product, Product, QAfterFilterCondition> unitEqualTo(
    String? value, {
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
    String? value, {
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
    String? value, {
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
    String? lower,
    String? upper, {
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
    on QueryBuilder<Product, Product, QFilterCondition> {
  QueryBuilder<Product, Product, QAfterFilterCondition> variants(
      FilterQuery<Variant> q) {
    return linkInternal(
      isar.variants,
      q,
      'variants',
    );
  }
}

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

  QueryBuilder<Product, Product, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCategoryId() {
    return addSortByInternal('categoryId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByCategoryIdDesc() {
    return addSortByInternal('categoryId', Sort.desc);
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

  QueryBuilder<Product, Product, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByPicture() {
    return addSortByInternal('picture', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByPictureDesc() {
    return addSortByInternal('picture', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortBySupplierId() {
    return addSortByInternal('supplierId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortBySupplierIdDesc() {
    return addSortByInternal('supplierId', Sort.desc);
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

  QueryBuilder<Product, Product, QAfterSortBy> sortByTaxId() {
    return addSortByInternal('taxId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> sortByTaxIdDesc() {
    return addSortByInternal('taxId', Sort.desc);
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

  QueryBuilder<Product, Product, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCategoryId() {
    return addSortByInternal('categoryId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByCategoryIdDesc() {
    return addSortByInternal('categoryId', Sort.desc);
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

  QueryBuilder<Product, Product, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByPicture() {
    return addSortByInternal('picture', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByPictureDesc() {
    return addSortByInternal('picture', Sort.desc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenBySupplierId() {
    return addSortByInternal('supplierId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenBySupplierIdDesc() {
    return addSortByInternal('supplierId', Sort.desc);
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

  QueryBuilder<Product, Product, QAfterSortBy> thenByTaxId() {
    return addSortByInternal('taxId', Sort.asc);
  }

  QueryBuilder<Product, Product, QAfterSortBy> thenByTaxIdDesc() {
    return addSortByInternal('taxId', Sort.desc);
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

  QueryBuilder<Product, Product, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByBusinessId() {
    return addDistinctByInternal('businessId');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByCategoryId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('categoryId', caseSensitive: caseSensitive);
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

  QueryBuilder<Product, Product, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('picture', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctBySupplierId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('supplierId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctBySynced() {
    return addDistinctByInternal('synced');
  }

  QueryBuilder<Product, Product, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<Product, Product, QDistinct> distinctByTaxId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxId', caseSensitive: caseSensitive);
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

  QueryBuilder<Product, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Product, int, QQueryOperations> businessIdProperty() {
    return addPropertyNameInternal('businessId');
  }

  QueryBuilder<Product, String?, QQueryOperations> categoryIdProperty() {
    return addPropertyNameInternal('categoryId');
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

  QueryBuilder<Product, bool, QQueryOperations> hasPictureProperty() {
    return addPropertyNameInternal('hasPicture');
  }

  QueryBuilder<Product, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Product, bool?, QQueryOperations> imageLocalProperty() {
    return addPropertyNameInternal('imageLocal');
  }

  QueryBuilder<Product, String?, QQueryOperations> imageUrlProperty() {
    return addPropertyNameInternal('imageUrl');
  }

  QueryBuilder<Product, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Product, String?, QQueryOperations> pictureProperty() {
    return addPropertyNameInternal('picture');
  }

  QueryBuilder<Product, String?, QQueryOperations> supplierIdProperty() {
    return addPropertyNameInternal('supplierId');
  }

  QueryBuilder<Product, bool?, QQueryOperations> syncedProperty() {
    return addPropertyNameInternal('synced');
  }

  QueryBuilder<Product, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<Product, String?, QQueryOperations> taxIdProperty() {
    return addPropertyNameInternal('taxId');
  }

  QueryBuilder<Product, String?, QQueryOperations> unitProperty() {
    return addPropertyNameInternal('unit');
  }
}
