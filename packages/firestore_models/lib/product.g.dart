// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      taxId: json['taxId'] as String?,
      color: json['color'] as String? ?? "#e74c3c",
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      supplierId: json['supplierId'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
      expiryDate: json['expiryDate'] as String?,
      barCode: json['barCode'] as String?,
      nfcEnabled: json['nfcEnabled'] as bool? ?? false,
      bindedToTenantId: (json['bindedToTenantId'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      searchMatch: json['searchMatch'] as bool? ?? false,
      spplrNm: json['spplrNm'] as String?,
      isComposite: json['isComposite'] as bool? ?? false,
      composites: (json['composites'] as List<dynamic>?)
              ?.map((e) => Composite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Composite>[],
    );

const _$$ProductImplFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'description': 'description',
  'taxId': 'taxId',
  'color': 'color',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'supplierId': 'supplierId',
  'categoryId': 'categoryId',
  'createdAt': 'createdAt',
  'unit': 'unit',
  'imageUrl': 'imageUrl',
  'expiryDate': 'expiryDate',
  'barCode': 'barCode',
  'nfcEnabled': 'nfcEnabled',
  'bindedToTenantId': 'bindedToTenantId',
  'isFavorite': 'isFavorite',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'spplrNm': 'spplrNm',
  'isComposite': 'isComposite',
  'composites': 'composites',
};

// ignore: unused_element
abstract class _$$ProductImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? description(String? instance) => instance;
  // ignore: unused_element
  static Object? taxId(String? instance) => instance;
  // ignore: unused_element
  static Object? color(String instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? supplierId(String? instance) => instance;
  // ignore: unused_element
  static Object? categoryId(int? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? unit(String? instance) => instance;
  // ignore: unused_element
  static Object? imageUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? expiryDate(String? instance) => instance;
  // ignore: unused_element
  static Object? barCode(String? instance) => instance;
  // ignore: unused_element
  static Object? nfcEnabled(bool instance) => instance;
  // ignore: unused_element
  static Object? bindedToTenantId(int? instance) => instance;
  // ignore: unused_element
  static Object? isFavorite(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? spplrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isComposite(bool? instance) => instance;
  // ignore: unused_element
  static Object? composites(List<Composite> instance) => instance;
}

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'taxId': instance.taxId,
      'color': instance.color,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'supplierId': instance.supplierId,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt,
      'unit': instance.unit,
      'imageUrl': instance.imageUrl,
      'expiryDate': instance.expiryDate,
      'barCode': instance.barCode,
      'nfcEnabled': instance.nfcEnabled,
      'bindedToTenantId': instance.bindedToTenantId,
      'isFavorite': instance.isFavorite,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'spplrNm': instance.spplrNm,
      'isComposite': instance.isComposite,
      'composites': instance.composites,
    };
