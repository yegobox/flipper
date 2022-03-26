// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetProductSyncCollection on Isar {
  IsarCollection<ProductSync> get productSyncs {
    return getCollection('ProductSync');
  }
}

final ProductSyncSchema = CollectionSchema(
  name: 'ProductSync',
  schema:
      '{"name":"ProductSync","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"barCode","type":"String"},{"name":"branchId","type":"Long"},{"name":"businessId","type":"Long"},{"name":"categoryId","type":"String"},{"name":"color","type":"String"},{"name":"createdAt","type":"String"},{"name":"currentUpdate","type":"Bool"},{"name":"description","type":"String"},{"name":"draft","type":"Bool"},{"name":"expiryDate","type":"String"},{"name":"hasPicture","type":"Bool"},{"name":"imageLocal","type":"Bool"},{"name":"imageUrl","type":"String"},{"name":"name","type":"String"},{"name":"picture","type":"String"},{"name":"supplierId","type":"String"},{"name":"synced","type":"Bool"},{"name":"table","type":"String"},{"name":"taxId","type":"String"},{"name":"unit","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _ProductSyncNativeAdapter(),
  webAdapter: const _ProductSyncWebAdapter(),
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
  indexTypes: {},
  linkIds: {},
  backlinkIds: {'variants': 0},
  linkedCollections: ['VariantSync'],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.variants],
  version: 2,
);

class _ProductSyncWebAdapter extends IsarWebTypeAdapter<ProductSync> {
  const _ProductSyncWebAdapter();

  @override
  Object serialize(IsarCollection<ProductSync> collection, ProductSync object) {
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

  @override
  ProductSync deserialize(
      IsarCollection<ProductSync> collection, dynamic jsObj) {
    final object = ProductSync();
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
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.imageLocal = IsarNative.jsObjectGet(jsObj, 'imageLocal');
    object.imageUrl = IsarNative.jsObjectGet(jsObj, 'imageUrl');
    object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
    object.picture = IsarNative.jsObjectGet(jsObj, 'picture');
    object.supplierId = IsarNative.jsObjectGet(jsObj, 'supplierId');
    object.synced = IsarNative.jsObjectGet(jsObj, 'synced');
    object.table = IsarNative.jsObjectGet(jsObj, 'table');
    object.taxId = IsarNative.jsObjectGet(jsObj, 'taxId');
    object.unit = IsarNative.jsObjectGet(jsObj, 'unit');
    attachLinks(collection.isar,
        IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
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
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
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

  @override
  void attachLinks(Isar isar, int id, ProductSync object) {
    object.variants.attach(
      id,
      isar.productSyncs,
      isar.getCollection<VariantSync>('VariantSync'),
      'variants',
      true,
    );
  }
}

class _ProductSyncNativeAdapter extends IsarNativeTypeAdapter<ProductSync> {
  const _ProductSyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<ProductSync> collection,
      IsarRawObject rawObj,
      ProductSync object,
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

  @override
  ProductSync deserialize(IsarCollection<ProductSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = ProductSync();
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
    attachLinks(collection.isar, id, object);
    return object;
  }

  @override
  P deserializeProperty<P>(
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

  @override
  void attachLinks(Isar isar, int id, ProductSync object) {
    object.variants.attach(
      id,
      isar.productSyncs,
      isar.getCollection<VariantSync>('VariantSync'),
      'variants',
      true,
    );
  }
}

extension ProductSyncQueryWhereSort
    on QueryBuilder<ProductSync, ProductSync, QWhere> {
  QueryBuilder<ProductSync, ProductSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension ProductSyncQueryWhere
    on QueryBuilder<ProductSync, ProductSync, QWhereClause> {
  QueryBuilder<ProductSync, ProductSync, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterWhereClause> idNotEqualTo(
      int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<ProductSync, ProductSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension ProductSyncQueryFilter
    on QueryBuilder<ProductSync, ProductSync, QFilterCondition> {
  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> activeEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      barCodeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'barCode',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      barCodeGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      barCodeStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'barCode',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> barCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'barCode',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      branchIdGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      branchIdLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      businessIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      businessIdGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      businessIdLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      businessIdBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'categoryId',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'categoryId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      categoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'categoryId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      colorGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'color',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'color',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'createdAt',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      currentUpdateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'currentUpdate',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      currentUpdateEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'currentUpdate',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> draftIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'draft',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> draftEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'draft',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'expiryDate',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'expiryDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      expiryDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'expiryDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      hasPictureEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hasPicture',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageLocalIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageLocal',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageLocalEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imageLocal',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageUrl',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> imageUrlEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> imageUrlBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imageUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      pictureIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'picture',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      pictureGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      pictureStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'picture',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'picture',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'supplierId',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'supplierId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      supplierIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'supplierId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> syncedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'synced',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> syncedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'synced',
      value: value,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      tableGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'taxId',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition>
      taxIdGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'taxId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> taxIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'taxId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'unit',
      value: null,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitEqualTo(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitGreaterThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitLessThan(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitBetween(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitStartsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitEndsWith(
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

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'unit',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<ProductSync, ProductSync, QAfterFilterCondition> unitMatches(
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

extension ProductSyncQueryWhereSortBy
    on QueryBuilder<ProductSync, ProductSync, QSortBy> {
  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBarCode() {
    return addSortByInternal('barCode', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBarCodeDesc() {
    return addSortByInternal('barCode', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByCategoryId() {
    return addSortByInternal('categoryId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByCategoryIdDesc() {
    return addSortByInternal('categoryId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByCurrentUpdate() {
    return addSortByInternal('currentUpdate', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy>
      sortByCurrentUpdateDesc() {
    return addSortByInternal('currentUpdate', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByExpiryDate() {
    return addSortByInternal('expiryDate', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByExpiryDateDesc() {
    return addSortByInternal('expiryDate', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByHasPicture() {
    return addSortByInternal('hasPicture', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByHasPictureDesc() {
    return addSortByInternal('hasPicture', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByImageLocal() {
    return addSortByInternal('imageLocal', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByImageLocalDesc() {
    return addSortByInternal('imageLocal', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByPicture() {
    return addSortByInternal('picture', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByPictureDesc() {
    return addSortByInternal('picture', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortBySupplierId() {
    return addSortByInternal('supplierId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortBySupplierIdDesc() {
    return addSortByInternal('supplierId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByTaxId() {
    return addSortByInternal('taxId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByTaxIdDesc() {
    return addSortByInternal('taxId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> sortByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension ProductSyncQueryWhereSortThenBy
    on QueryBuilder<ProductSync, ProductSync, QSortThenBy> {
  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBarCode() {
    return addSortByInternal('barCode', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBarCodeDesc() {
    return addSortByInternal('barCode', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByCategoryId() {
    return addSortByInternal('categoryId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByCategoryIdDesc() {
    return addSortByInternal('categoryId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByColor() {
    return addSortByInternal('color', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByColorDesc() {
    return addSortByInternal('color', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByCurrentUpdate() {
    return addSortByInternal('currentUpdate', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy>
      thenByCurrentUpdateDesc() {
    return addSortByInternal('currentUpdate', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByExpiryDate() {
    return addSortByInternal('expiryDate', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByExpiryDateDesc() {
    return addSortByInternal('expiryDate', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByHasPicture() {
    return addSortByInternal('hasPicture', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByHasPictureDesc() {
    return addSortByInternal('hasPicture', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByImageLocal() {
    return addSortByInternal('imageLocal', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByImageLocalDesc() {
    return addSortByInternal('imageLocal', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByPicture() {
    return addSortByInternal('picture', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByPictureDesc() {
    return addSortByInternal('picture', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenBySupplierId() {
    return addSortByInternal('supplierId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenBySupplierIdDesc() {
    return addSortByInternal('supplierId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenBySynced() {
    return addSortByInternal('synced', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenBySyncedDesc() {
    return addSortByInternal('synced', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByTaxId() {
    return addSortByInternal('taxId', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByTaxIdDesc() {
    return addSortByInternal('taxId', Sort.desc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByUnit() {
    return addSortByInternal('unit', Sort.asc);
  }

  QueryBuilder<ProductSync, ProductSync, QAfterSortBy> thenByUnitDesc() {
    return addSortByInternal('unit', Sort.desc);
  }
}

extension ProductSyncQueryWhereDistinct
    on QueryBuilder<ProductSync, ProductSync, QDistinct> {
  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByBarCode(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('barCode', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByBusinessId() {
    return addDistinctByInternal('businessId');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByCategoryId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('categoryId', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('color', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByCurrentUpdate() {
    return addDistinctByInternal('currentUpdate');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByDraft() {
    return addDistinctByInternal('draft');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByExpiryDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('expiryDate', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByHasPicture() {
    return addDistinctByInternal('hasPicture');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByImageLocal() {
    return addDistinctByInternal('imageLocal');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imageUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('picture', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctBySupplierId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('supplierId', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctBySynced() {
    return addDistinctByInternal('synced');
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByTaxId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('taxId', caseSensitive: caseSensitive);
  }

  QueryBuilder<ProductSync, ProductSync, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('unit', caseSensitive: caseSensitive);
  }
}

extension ProductSyncQueryProperty
    on QueryBuilder<ProductSync, ProductSync, QQueryProperty> {
  QueryBuilder<ProductSync, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> barCodeProperty() {
    return addPropertyNameInternal('barCode');
  }

  QueryBuilder<ProductSync, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<ProductSync, int, QQueryOperations> businessIdProperty() {
    return addPropertyNameInternal('businessId');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> categoryIdProperty() {
    return addPropertyNameInternal('categoryId');
  }

  QueryBuilder<ProductSync, String, QQueryOperations> colorProperty() {
    return addPropertyNameInternal('color');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<ProductSync, bool?, QQueryOperations> currentUpdateProperty() {
    return addPropertyNameInternal('currentUpdate');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> descriptionProperty() {
    return addPropertyNameInternal('description');
  }

  QueryBuilder<ProductSync, bool?, QQueryOperations> draftProperty() {
    return addPropertyNameInternal('draft');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> expiryDateProperty() {
    return addPropertyNameInternal('expiryDate');
  }

  QueryBuilder<ProductSync, bool, QQueryOperations> hasPictureProperty() {
    return addPropertyNameInternal('hasPicture');
  }

  QueryBuilder<ProductSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<ProductSync, bool?, QQueryOperations> imageLocalProperty() {
    return addPropertyNameInternal('imageLocal');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> imageUrlProperty() {
    return addPropertyNameInternal('imageUrl');
  }

  QueryBuilder<ProductSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> pictureProperty() {
    return addPropertyNameInternal('picture');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> supplierIdProperty() {
    return addPropertyNameInternal('supplierId');
  }

  QueryBuilder<ProductSync, bool?, QQueryOperations> syncedProperty() {
    return addPropertyNameInternal('synced');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> taxIdProperty() {
    return addPropertyNameInternal('taxId');
  }

  QueryBuilder<ProductSync, String?, QQueryOperations> unitProperty() {
    return addPropertyNameInternal('unit');
  }
}
