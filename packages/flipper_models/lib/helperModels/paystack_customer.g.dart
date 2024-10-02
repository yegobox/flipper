// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayStackCustomer _$PayStackCustomerFromJson(Map<String, dynamic> json) =>
    PayStackCustomer(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: CustomerData.fromJson(json['data'] as Map<String, dynamic>),
    );

const _$PayStackCustomerFieldMap = <String, String>{
  'status': 'status',
  'message': 'message',
  'data': 'data',
};

// ignore: unused_element
abstract class _$PayStackCustomerPerFieldToJson {
  // ignore: unused_element
  static Object? status(bool instance) => instance;
  // ignore: unused_element
  static Object? message(String instance) => instance;
  // ignore: unused_element
  static Object? data(CustomerData instance) => instance.toJson();
}

Map<String, dynamic> _$PayStackCustomerToJson(PayStackCustomer instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
      transactions: json['transactions'] as List<dynamic>?,
      subscriptions: json['subscriptions'] as List<dynamic>?,
      authorizations: json['authorizations'] as List<dynamic>?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      metadata: CustomerData._convertMetadata(json['metadata']),
      domain: json['domain'] as String,
      customerCode: json['customer_code'] as String,
      riskAction: json['risk_action'] as String,
      id: (json['id'] as num).toInt(),
      integration: (json['integration'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalTransactions: (json['total_transactions'] as num?)?.toInt(),
      totalTransactionValue: json['total_transaction_value'] as List<dynamic>?,
      dedicatedAccount: json['dedicated_account'],
      dedicatedAccounts: json['dedicated_accounts'] as List<dynamic>?,
      identified: json['identified'] as bool,
      identifications: json['identifications'],
    );

const _$CustomerDataFieldMap = <String, String>{
  'transactions': 'transactions',
  'subscriptions': 'subscriptions',
  'authorizations': 'authorizations',
  'firstName': 'first_name',
  'lastName': 'last_name',
  'email': 'email',
  'phone': 'phone',
  'metadata': 'metadata',
  'domain': 'domain',
  'customerCode': 'customer_code',
  'riskAction': 'risk_action',
  'id': 'id',
  'integration': 'integration',
  'createdAt': 'createdAt',
  'updatedAt': 'updatedAt',
  'totalTransactions': 'total_transactions',
  'totalTransactionValue': 'total_transaction_value',
  'dedicatedAccount': 'dedicated_account',
  'dedicatedAccounts': 'dedicated_accounts',
  'identified': 'identified',
  'identifications': 'identifications',
};

// ignore: unused_element
abstract class _$CustomerDataPerFieldToJson {
  // ignore: unused_element
  static Object? transactions(List<dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? subscriptions(List<dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? authorizations(List<dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? firstName(String instance) => instance;
  // ignore: unused_element
  static Object? lastName(String instance) => instance;
  // ignore: unused_element
  static Object? email(String instance) => instance;
  // ignore: unused_element
  static Object? phone(String instance) => instance;
  // ignore: unused_element
  static Object? metadata(Map<String, dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? domain(String instance) => instance;
  // ignore: unused_element
  static Object? customerCode(String instance) => instance;
  // ignore: unused_element
  static Object? riskAction(String instance) => instance;
  // ignore: unused_element
  static Object? id(int instance) => instance;
  // ignore: unused_element
  static Object? integration(int instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime instance) => instance.toIso8601String();
  // ignore: unused_element
  static Object? updatedAt(DateTime instance) => instance.toIso8601String();
  // ignore: unused_element
  static Object? totalTransactions(int? instance) => instance;
  // ignore: unused_element
  static Object? totalTransactionValue(List<dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? dedicatedAccount(dynamic instance) => instance;
  // ignore: unused_element
  static Object? dedicatedAccounts(List<dynamic>? instance) => instance;
  // ignore: unused_element
  static Object? identified(bool instance) => instance;
  // ignore: unused_element
  static Object? identifications(dynamic instance) => instance;
}

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'subscriptions': instance.subscriptions,
      'authorizations': instance.authorizations,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'metadata': instance.metadata,
      'domain': instance.domain,
      'customer_code': instance.customerCode,
      'risk_action': instance.riskAction,
      'id': instance.id,
      'integration': instance.integration,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'total_transactions': instance.totalTransactions,
      'total_transaction_value': instance.totalTransactionValue,
      'dedicated_account': instance.dedicatedAccount,
      'dedicated_accounts': instance.dedicatedAccounts,
      'identified': instance.identified,
      'identifications': instance.identifications,
    };
