import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/secrets.dart';

abstract class RealmViaHttp {
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode});
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId});
}

class RealmViaHttpService implements RealmViaHttp {
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
          "collection": AppSecrets.collection,
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
  Future<bool> isPaymentComplete(
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
          "collection": AppSecrets.paymentPlanCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"businessId": businessId}
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];
      if (documents.isNotEmpty) {
        // Print the discountRate of the first document
        return documents.first['paymentCompletedByUser'];
      } else {
        return false;
      }
    }
    return false;
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
}
