import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';

abstract class RealmViaHttp {
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode});
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId});
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId});
  Future<bool> makePayment(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      required String phoneNumber,
      String? externalId,
      required String branchId,
      required String paymentType,
      required String payeemessage,
      required int amount});
  Future<bool> subscribe(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      int? agentCode,
      int? timeInSeconds = 120,
      required int amount});
}

class HttpApi implements RealmViaHttp {
  @override
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode}) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    final response = await flipperHttpClient.post(
        headers: headers,
        Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
        body: json.encode({
          "collection": AppSecrets.flipperCompaignCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"couponCode": couponCode}
        }));
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];

      if (documents.isNotEmpty) {
        // Print the discountRate of the first document
        final discountRate = documents.first['discountRate'];
        print('Discount Rate: $discountRate');
        return true;
      } else {
        return false;
      }
    } else {
      // If the status code is not 200, return false
      return false;
    }
  }

  @override
  Future<bool> isPaymentComplete({
    required HttpClientInterface flipperHttpClient,
    required int businessId,
  }) async {
    var headers = {
      'api-key': AppSecrets.supabaseAnonKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await flipperHttpClient.get(
        headers: headers,
        Uri.parse(
            '${AppSecrets.superbaseurl}/rest/v1/plans?business_id=eq.$businessId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Check if the response list is not empty
        if (responseData.isNotEmpty) {
          // Get the first item from the array
          final Map<String, dynamic> planData = responseData.first;

          // Use the correct field name from the API response
          return planData['payment_completed_by_user'] ?? false;
        }
      }

      // Return false for any other status code or empty response
      return false;
    } catch (e) {
      // Handle any errors that might occur during the API call
      print('Error checking payment completion: $e');
      return false;
    }
  }

  @override
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    final response = await flipperHttpClient.post(
        headers: headers,
        Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
        body: json.encode({
          "collection": AppSecrets.AccessCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"businessId": businessId}
        }));
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];

      if (documents.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      // If the status code is not 200, return false
      return false;
    }
  }

  @override
  Future<bool> makePayment(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      required String branchId,
      required String paymentType,
      String? externalId,
      required String payeemessage,
      required int amount,
      required String phoneNumber}) async {
    final response = await flipperHttpClient.post(
        headers: {
          'api-key': AppSecrets.apikey,
          'Content-Type': 'application/json'
        },
        Uri.parse('${AppSecrets.coreApi}/v2/api/payNow'),
        body: json.encode({
          "amount": amount,
          "currency": "RWF",
          "payer": {
            "partyIdType": "MSISDN",
            "partyId": phoneNumber,
          },
          "payerMessage": "Flipper Subscription",
          "payeeNote": payeemessage,
          "businessId": ProxyService.box.getBusinessId()!,
          "branchId": branchId,
          "paymentType": paymentType,
          "externalId": externalId
        }));
    talker.warning(response.body);
    final status = response.statusCode;
    if (status == 400) {
      throw Exception("Bad request");
    } else if (status == 401) {
      throw Exception("Unauthorized");
    } else if (status == 403) {
      throw Exception("Forbidden");
    } else if (status == 404) {
      throw Exception("Not found");
    } else if (status == 409) {
      throw Exception("Duplicate payment Id");
    } else if (status == 500) {
      throw Exception("Internal server error");
    } else if (status == 502) {
      throw Exception("Payment gateway down");
    } else if (status == 503) {
      throw Exception("Service unavailable");
    } else if (status == 504) {
      throw Exception("Gateway timeout");
    }
    return status == 200;
  }

  @override
  Future<bool> subscribe(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      int? agentCode,
      int? timeInSeconds = 120,
      required int amount}) async {
    final phone =
        ProxyService.box.customPhoneNumberForPayment()?.replaceAll("+", "") ??
            ProxyService.box.getUserPhone()!.replaceAll("+", "");
    final response = await flipperHttpClient.post(
        headers: {
          'api-key': AppSecrets.apikey,
          'Content-Type': 'application/json'
        },
        Uri.parse('${AppSecrets.coreApi}/v2/api/preApprove'),
        body: json.encode({
          "payer": {"partyIdType": "MSISDN", "partyId": phone},
          "payerCurrency": "RWF",
          "payerMessage": "Flipper Subscription",
          "validityTime": timeInSeconds,
          "branchId": "2f83b8b1-6d41-4d80-b0e7-de8ab36910af"
        }));
    return response.statusCode == 200;
  }
}

class RealmViaHttpServiceMock implements RealmViaHttp {
  @override
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode}) async {
    return true;
  }

  @override
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) async {
    return true;
  }

  @override
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) {
    // TODO: implement hasAcessSaved
    throw UnimplementedError();
  }

  @override
  Future<bool> subscribe(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      int? timeInSeconds,
      int? agentCode,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<bool> makePayment(
      {required HttpClientInterface flipperHttpClient,
      required int businessId,
      required String paymentType,
      required String phoneNumber,
      String? externalId,
      required String branchId,
      required String payeemessage,
      required int amount}) {
    // TODO: implement makePayment
    throw UnimplementedError();
  }
}
