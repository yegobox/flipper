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
      id: json['id'] as int,
      integration: json['integration'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalTransactions: json['total_transactions'] as int?,
      totalTransactionValue: json['total_transaction_value'] as List<dynamic>?,
      dedicatedAccount: json['dedicated_account'],
      dedicatedAccounts: json['dedicated_accounts'] as List<dynamic>?,
      identified: json['identified'] as bool,
      identifications: json['identifications'],
    );

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
