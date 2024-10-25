// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentPlanImpl _$$PaymentPlanImplFromJson(Map<String, dynamic> json) =>
    _$PaymentPlanImpl(
      id: (json['id'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      selectedPlan: json['selectedPlan'] as String?,
      additionalDevices: (json['additionalDevices'] as num?)?.toInt(),
      isYearlyPlan: json['isYearlyPlan'] as bool?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      paymentCompletedByUser: json['paymentCompletedByUser'] as bool? ?? false,
      payStackCustomerId: (json['payStackCustomerId'] as num?)?.toInt(),
      rule: json['rule'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      customerCode: json['customerCode'] as String?,
      payStackPlanId: json['payStackPlanId'] as String?,
    );

const _$$PaymentPlanImplFieldMap = <String, String>{
  'id': 'id',
  'businessId': 'businessId',
  'selectedPlan': 'selectedPlan',
  'additionalDevices': 'additionalDevices',
  'isYearlyPlan': 'isYearlyPlan',
  'totalPrice': 'totalPrice',
  'createdAt': 'createdAt',
  'paymentCompletedByUser': 'paymentCompletedByUser',
  'payStackCustomerId': 'payStackCustomerId',
  'rule': 'rule',
  'paymentMethod': 'paymentMethod',
  'customerCode': 'customerCode',
  'payStackPlanId': 'payStackPlanId',
};

// ignore: unused_element
abstract class _$$PaymentPlanImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? selectedPlan(String? instance) => instance;
  // ignore: unused_element
  static Object? additionalDevices(int? instance) => instance;
  // ignore: unused_element
  static Object? isYearlyPlan(bool? instance) => instance;
  // ignore: unused_element
  static Object? totalPrice(double? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? paymentCompletedByUser(bool? instance) => instance;
  // ignore: unused_element
  static Object? payStackCustomerId(int? instance) => instance;
  // ignore: unused_element
  static Object? rule(String? instance) => instance;
  // ignore: unused_element
  static Object? paymentMethod(String? instance) => instance;
  // ignore: unused_element
  static Object? customerCode(String? instance) => instance;
  // ignore: unused_element
  static Object? payStackPlanId(String? instance) => instance;
}

Map<String, dynamic> _$$PaymentPlanImplToJson(_$PaymentPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'selectedPlan': instance.selectedPlan,
      'additionalDevices': instance.additionalDevices,
      'isYearlyPlan': instance.isYearlyPlan,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt?.toIso8601String(),
      'paymentCompletedByUser': instance.paymentCompletedByUser,
      'payStackCustomerId': instance.payStackCustomerId,
      'rule': instance.rule,
      'paymentMethod': instance.paymentMethod,
      'customerCode': instance.customerCode,
      'payStackPlanId': instance.payStackPlanId,
    };
