// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmProduct.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmProduct extends _RealmProduct
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmProduct(
    String id,
    ObjectId realmId,
    String name,
    String color,
    int businessId,
    int branchId,
    String action, {
    String? description,
    String? taxId,
    String? supplierId,
    String? categoryId,
    String? createdAt,
    String? unit,
    String? imageUrl,
    String? expiryDate,
    String? barCode,
    bool? nfcEnabled,
    int? bindedToTenantId,
    bool? isFavorite,
    DateTime? lastTouched,
    DateTime? deletedAt,
    bool? searchMatch,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'taxId', taxId);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'supplierId', supplierId);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'expiryDate', expiryDate);
    RealmObjectBase.set(this, 'barCode', barCode);
    RealmObjectBase.set(this, 'nfcEnabled', nfcEnabled);
    RealmObjectBase.set(this, 'bindedToTenantId', bindedToTenantId);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'searchMatch', searchMatch);
  }

  RealmProduct._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get taxId => RealmObjectBase.get<String>(this, 'taxId') as String?;
  @override
  set taxId(String? value) => RealmObjectBase.set(this, 'taxId', value);

  @override
  String get color => RealmObjectBase.get<String>(this, 'color') as String;
  @override
  set color(String value) => RealmObjectBase.set(this, 'color', value);

  @override
  int get businessId => RealmObjectBase.get<int>(this, 'businessId') as int;
  @override
  set businessId(int value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get supplierId =>
      RealmObjectBase.get<String>(this, 'supplierId') as String?;
  @override
  set supplierId(String? value) =>
      RealmObjectBase.set(this, 'supplierId', value);

  @override
  String? get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String?;
  @override
  set categoryId(String? value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String? get expiryDate =>
      RealmObjectBase.get<String>(this, 'expiryDate') as String?;
  @override
  set expiryDate(String? value) =>
      RealmObjectBase.set(this, 'expiryDate', value);

  @override
  String? get barCode =>
      RealmObjectBase.get<String>(this, 'barCode') as String?;
  @override
  set barCode(String? value) => RealmObjectBase.set(this, 'barCode', value);

  @override
  bool? get nfcEnabled =>
      RealmObjectBase.get<bool>(this, 'nfcEnabled') as bool?;
  @override
  set nfcEnabled(bool? value) => RealmObjectBase.set(this, 'nfcEnabled', value);

  @override
  int? get bindedToTenantId =>
      RealmObjectBase.get<int>(this, 'bindedToTenantId') as int?;
  @override
  set bindedToTenantId(int? value) =>
      RealmObjectBase.set(this, 'bindedToTenantId', value);

  @override
  bool? get isFavorite =>
      RealmObjectBase.get<bool>(this, 'isFavorite') as bool?;
  @override
  set isFavorite(bool? value) => RealmObjectBase.set(this, 'isFavorite', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  bool? get searchMatch =>
      RealmObjectBase.get<bool>(this, 'searchMatch') as bool?;
  @override
  set searchMatch(bool? value) =>
      RealmObjectBase.set(this, 'searchMatch', value);

  @override
  Stream<RealmObjectChanges<RealmProduct>> get changes =>
      RealmObjectBase.getChanges<RealmProduct>(this);

  @override
  RealmProduct freeze() => RealmObjectBase.freezeObject<RealmProduct>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'taxId': taxId.toEJson(),
      'color': color.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
      'supplierId': supplierId.toEJson(),
      'categoryId': categoryId.toEJson(),
      'createdAt': createdAt.toEJson(),
      'unit': unit.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'expiryDate': expiryDate.toEJson(),
      'barCode': barCode.toEJson(),
      'nfcEnabled': nfcEnabled.toEJson(),
      'bindedToTenantId': bindedToTenantId.toEJson(),
      'isFavorite': isFavorite.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'searchMatch': searchMatch.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmProduct value) => value.toEJson();
  static RealmProduct _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'taxId': EJsonValue taxId,
        'color': EJsonValue color,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
        'supplierId': EJsonValue supplierId,
        'categoryId': EJsonValue categoryId,
        'createdAt': EJsonValue createdAt,
        'unit': EJsonValue unit,
        'imageUrl': EJsonValue imageUrl,
        'expiryDate': EJsonValue expiryDate,
        'barCode': EJsonValue barCode,
        'nfcEnabled': EJsonValue nfcEnabled,
        'bindedToTenantId': EJsonValue bindedToTenantId,
        'isFavorite': EJsonValue isFavorite,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'searchMatch': EJsonValue searchMatch,
      } =>
        RealmProduct(
          fromEJson(id),
          fromEJson(realmId),
          fromEJson(name),
          fromEJson(color),
          fromEJson(businessId),
          fromEJson(branchId),
          fromEJson(action),
          description: fromEJson(description),
          taxId: fromEJson(taxId),
          supplierId: fromEJson(supplierId),
          categoryId: fromEJson(categoryId),
          createdAt: fromEJson(createdAt),
          unit: fromEJson(unit),
          imageUrl: fromEJson(imageUrl),
          expiryDate: fromEJson(expiryDate),
          barCode: fromEJson(barCode),
          nfcEnabled: fromEJson(nfcEnabled),
          bindedToTenantId: fromEJson(bindedToTenantId),
          isFavorite: fromEJson(isFavorite),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
          searchMatch: fromEJson(searchMatch),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmProduct._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, RealmProduct, 'RealmProduct', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('taxId', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.string),
      SchemaProperty('businessId', RealmPropertyType.int),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('supplierId', RealmPropertyType.string, optional: true),
      SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('expiryDate', RealmPropertyType.string, optional: true),
      SchemaProperty('barCode', RealmPropertyType.string, optional: true),
      SchemaProperty('nfcEnabled', RealmPropertyType.bool, optional: true),
      SchemaProperty('bindedToTenantId', RealmPropertyType.int, optional: true),
      SchemaProperty('isFavorite', RealmPropertyType.bool, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('searchMatch', RealmPropertyType.bool, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
