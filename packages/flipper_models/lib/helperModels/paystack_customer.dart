import 'package:json_annotation/json_annotation.dart';

part 'paystack_customer.g.dart';

@JsonSerializable(explicitToJson: true)
class PayStackCustomer {
  final bool status;
  final String message;
  final CustomerData data;

  PayStackCustomer({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PayStackCustomer.fromJson(Map<String, dynamic> json) =>
      _$PayStackCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$PayStackCustomerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CustomerData {
  final List<dynamic>? transactions;
  final List<dynamic>? subscriptions;
  final List<dynamic>? authorizations;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  final String phone;
  @JsonKey(fromJson: _convertMetadata)
  final Map<String, dynamic>? metadata;
  final String domain;
  @JsonKey(name: 'customer_code')
  final String customerCode;
  @JsonKey(name: 'risk_action')
  final String riskAction;
  final int id;
  final int integration;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @JsonKey(name: 'total_transactions')
  final int? totalTransactions;
  @JsonKey(name: 'total_transaction_value')
  final List<dynamic>? totalTransactionValue;
  @JsonKey(name: 'dedicated_account')
  final dynamic dedicatedAccount;
  @JsonKey(name: 'dedicated_accounts')
  final List<dynamic>? dedicatedAccounts;
  final bool identified;
  final dynamic identifications;

  CustomerData({
    this.transactions,
    this.subscriptions,
    this.authorizations,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.metadata,
    required this.domain,
    required this.customerCode,
    required this.riskAction,
    required this.id,
    required this.integration,
    required this.createdAt,
    required this.updatedAt,
    this.totalTransactions,
    this.totalTransactionValue,
    this.dedicatedAccount,
    this.dedicatedAccounts,
    required this.identified,
    this.identifications,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);

  static Map<String, dynamic>? _convertMetadata(dynamic metadata) {
    if (metadata == null) return null;
    if (metadata is Map<String, dynamic>) return metadata;
    if (metadata is Map) {
      return metadata.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }
}
