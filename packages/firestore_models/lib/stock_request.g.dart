// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockRequestImpl _$$StockRequestImplFromJson(Map<String, dynamic> json) =>
    _$StockRequestImpl(
      id: (json['id'] as num?)?.toInt(),
      mainBranchId: (json['mainBranchId'] as num?)?.toInt(),
      subBranchId: (json['subBranchId'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      deliveryNote: json['deliveryNote'] as String?,
      orderNote: json['orderNote'] as String?,
      customerReceivedOrder: json['customerReceivedOrder'] as bool? ?? false,
      driverRequestDeliveryConfirmation:
          json['driverRequestDeliveryConfirmation'] as bool? ?? false,
      driverId: (json['driverId'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

const _$$StockRequestImplFieldMap = <String, String>{
  'id': 'id',
  'mainBranchId': 'mainBranchId',
  'subBranchId': 'subBranchId',
  'createdAt': 'createdAt',
  'status': 'status',
  'deliveryDate': 'deliveryDate',
  'deliveryNote': 'deliveryNote',
  'orderNote': 'orderNote',
  'customerReceivedOrder': 'customerReceivedOrder',
  'driverRequestDeliveryConfirmation': 'driverRequestDeliveryConfirmation',
  'driverId': 'driverId',
  'items': 'items',
  'updatedAt': 'updatedAt',
};

// ignore: unused_element
abstract class _$$StockRequestImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? mainBranchId(int? instance) => instance;
  // ignore: unused_element
  static Object? subBranchId(int? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? status(String? instance) => instance;
  // ignore: unused_element
  static Object? deliveryDate(DateTime? instance) =>
      instance?.toIso8601String();
  // ignore: unused_element
  static Object? deliveryNote(String? instance) => instance;
  // ignore: unused_element
  static Object? orderNote(String? instance) => instance;
  // ignore: unused_element
  static Object? customerReceivedOrder(bool? instance) => instance;
  // ignore: unused_element
  static Object? driverRequestDeliveryConfirmation(bool? instance) => instance;
  // ignore: unused_element
  static Object? driverId(int? instance) => instance;
  // ignore: unused_element
  static Object? items(List<TransactionItem> instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$StockRequestImplToJson(_$StockRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mainBranchId': instance.mainBranchId,
      'subBranchId': instance.subBranchId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'status': instance.status,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliveryNote': instance.deliveryNote,
      'orderNote': instance.orderNote,
      'customerReceivedOrder': instance.customerReceivedOrder,
      'driverRequestDeliveryConfirmation':
          instance.driverRequestDeliveryConfirmation,
      'driverId': instance.driverId,
      'items': instance.items,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
