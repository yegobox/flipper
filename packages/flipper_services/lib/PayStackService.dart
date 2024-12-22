import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/paystack_customer.dart';
import 'package:flipper_mocks/mocks.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';

abstract class PayStackServiceInterface {
  Future<PayStackCustomer> getPayStackCustomer(
      String customerCodeOrEmail, HttpClientInterface flipperHttpClient,
      {required Business business});
  Future<String> sendPaymentRequest(
      {required String customerCode,
      required int amount,
      required String dueDate,
      required HttpClientInterface flipperHttpClient});
  Future<PayStackCustomer> createCustomer(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone,
      required HttpClientInterface flipperHttpClient});
}

class PayStackService implements PayStackServiceInterface {
  @override
  Future<PayStackCustomer> getPayStackCustomer(
      String customerCodeOrEmail, HttpClientInterface flipperHttpClient,
      {required Business business}) async {
    try {
      final response = await flipperHttpClient.get(
          Uri.parse('https://api.paystack.co/customer/$customerCodeOrEmail'),
          headers: {'Authorization': 'Bearer ${AppSecrets.payStackApiKey}'});

      if (response.statusCode == 200) {
        final customerData = json.decode(response.body);
        return PayStackCustomer.fromJson(customerData);
      } else {
        // final errorData = json.decode(response.body);
        // throw CustomerNotFoundException(errorData['message']);
        PayStackCustomer customer = await createCustomer(
          flipperHttpClient: flipperHttpClient,
          email: customerCodeOrEmail,
          phone: ProxyService.box.getUserPhone()!.replaceAll("+", ""),
          firstName: business.firstName ?? "",
          lastName: business.lastName ?? "",
        );
        return customer;
      }
    } catch (e, s) {
      talker.error(s);
      if (e is CustomerNotFoundException) {
        rethrow;
      }
      throw Exception('Error fetching customer: $e');
    }
  }

  @override
  Future<String> sendPaymentRequest(
      {required String customerCode,
      required int amount,
      required String dueDate,
      required HttpClientInterface flipperHttpClient}) async {
    final url = Uri.parse('https://api.paystack.co/paymentrequest');
    final headers = {
      'Authorization': 'Bearer ${AppSecrets.payStackApiKey}',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      "description": "Flipper Subscription",
      "line_items": [
        {"name": "Flipper Subscription", "amount": amount}
      ],
      "customer": customerCode
    });

    try {
      final response =
          await flipperHttpClient.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final requestCode = responseData['data']['request_code'] as String;
        return requestCode;
      } else {
        throw Exception(
            'Failed to send payment request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending payment request: $e');
    }
  }

  @override
  Future<PayStackCustomer> createCustomer(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone,
      required HttpClientInterface flipperHttpClient}) async {
    final url = Uri.parse('https://api.paystack.co/customer');
    final headers = {
      'Authorization': 'Bearer ${AppSecrets.payStackApiKey}',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone.replaceAll("+", ""),
    });

    try {
      final response =
          await flipperHttpClient.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final customerData = json.decode(response.body);
        return PayStackCustomer.fromJson(customerData);
      } else {
        throw Exception('Failed to create customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating customer: $e');
    }
  }
}

class PayStackServiceMock implements PayStackServiceInterface {
  @override
  Future<PayStackCustomer> createCustomer(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone,
      required HttpClientInterface flipperHttpClient}) async {
    return PayStackCustomer.fromJson(payStackCustomer);
  }

  @override
  Future<PayStackCustomer> getPayStackCustomer(
      String customerCodeOrEmail, HttpClientInterface flipperHttpClient,
      {required Business business}) async {
    return PayStackCustomer.fromJson(payStackCustomer);
  }

  @override
  Future<String> sendPaymentRequest(
      {required String customerCode,
      required int amount,
      required String dueDate,
      required HttpClientInterface flipperHttpClient}) async {
    return "code";
  }
}
