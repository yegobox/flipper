import 'dart:convert';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:supabase_models/brick/models/customer_payments.model.dart';

abstract class HttpApiInterface {
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
  Future<Map<String, dynamic>> payNow(
      {required Map<String, dynamic> paymentData,
      required HttpClientInterface flipperHttpClient});
  Future<bool> checkPaymentStatus(
      {required HttpClientInterface flipperHttpClient,
      required String paymentReference});
}

class HttpApi implements HttpApiInterface {
  @override
  Future<Map<String, dynamic>> payNow(
      {required Map<String, dynamic> paymentData,
      required HttpClientInterface flipperHttpClient}) async {
    try {
      // Ensure the URL is properly formatted
      final Uri uri = Uri.parse('${AppSecrets.apihubProd}/v2/api/payNow');

      // Format the request body according to the required structure
      final formattedPaymentData = {
        "amount": paymentData['amount'].toString(),
        "currency": paymentData['currency'] ?? "RWF",
        "payer": {
          "partyIdType": "MSISDN",
          "partyId": paymentData['phoneNumber']
        },
        // this is constant for now.
        "branchId": "2f83b8b1-6d41-4d80-b0e7-de8ab36910af",
        "payerMessage": paymentData['description'] ?? "Flipper Credit Purchase",
        "payeeNote": "Flipper Credit",
        "businessId": ProxyService.box.getBusinessId() ?? 1,
        "paymentType": "Credit Purchase"
      };

      // Convert formatted payment data to JSON string
      final body = json.encode(formattedPaymentData);

      talker.info('PayNow request body: $body');

      // Make the POST request
      final response = await flipperHttpClient.post(
        uri,
        body: body,
      );

      // Parse the response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Log the response
      talker.info('PayNow response: ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 202) {
        // Expected successful response format:
        // {
        //   "status": "success",
        //   "message": "",
        //   "statusCode": 202,
        //   "paymentReference": "eaa09f4d-1a9d-4aa8-bd99-9a9877687a6c",
        //   "externalId": "eaa09f4d-1a9d-4aa8-bd99-9a9877687a6c"
        // }
        await ProxyService.strategy.upsertPayment(CustomerPayments(
          phoneNumber: paymentData['phoneNumber'],
          paymentStatus: "pending",
          amountPayable: paymentData['amount'].toDouble(),
          transactionId: responseData['paymentReference'],
        ));
        return responseData;
      } else {
        // Handle error response
        talker.error('PayNow error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'PayNow request failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // Log and rethrow any exceptions
      talker.error(e);
      talker.error(stackTrace);
      ProxyService.crash.reportError(e, stackTrace);
      throw Exception('Failed to process payment: $e');
    }
  }

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
        headers: {'Content-Type': 'application/json'},
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

  @override
  Future<bool> checkPaymentStatus(
      {required HttpClientInterface flipperHttpClient,
      required String paymentReference}) async {
    try {
      final response = await flipperHttpClient.get(Uri.parse(
          '${AppSecrets.apihubProd}/v2/api/requesttopay/status/$paymentReference/2f83b8b1-6d41-4d80-b0e7-de8ab36910af'));

      talker.info('Payment status response: ${response.body}');

      // Parse the response
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if payment was successful
      if (response.statusCode == 200 &&
          responseData['status'] == 'SUCCESSFUL') {
        // Update payment status in database
        await _updatePaymentStatus(paymentReference, responseData);
        return true;
      } else {
        talker.error('Payment not successful: ${responseData['status']}');
        return false;
      }
    } catch (e, stackTrace) {
      talker.error('Error checking payment status', e, stackTrace);
      return false;
    }
  }

  Future<void> _updatePaymentStatus(
      String paymentReference, Map<String, dynamic> responseData) async {
    try {
      // Find the payment record
      final payments = await ProxyService.strategy
          .getPayment(paymentReference: paymentReference);

      if (payments != null) {
        final payment = payments;

        // Update payment status
        payment.paymentStatus = 'completed';

        // Add credits to user account if payment was successful
        if (responseData['status'] == 'SUCCESSFUL') {
          final amount = double.tryParse(responseData['amount'] ?? '0') ?? 0;
          Credit? credit = await ProxyService.strategy.getCredit(
              branchId: (await ProxyService.strategy
                      .branch(serverId: ProxyService.box.getBranchId()!))!
                  .id);
          if (credit != null) {
            credit.credits += amount;
            await ProxyService.strategy.updateCredit(credit);
          } else {
            Credit credit = Credit(
              branchServerId: ProxyService.box.getBranchId()!,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              businessId: (await ProxyService.strategy.getBusiness(
                      businessId: ProxyService.box.getBusinessId()!))!
                  .id,
              branchId: (await ProxyService.strategy
                      .branch(serverId: ProxyService.box.getBranchId()!))!
                  .id,
              credits: amount,
            );
            await ProxyService.strategy.updateCredit(credit);
          }
        }

        // Save updated payment record
        await ProxyService.strategy.upsertPayment(payment);
        talker.info('Payment status updated for reference: $paymentReference');
      } else {
        talker
            .error('Payment record not found for reference: $paymentReference');
      }
    } catch (e, stackTrace) {
      talker.error('Error updating payment status', e, stackTrace);
    }
  }
}

class RealmViaHttpServiceMock implements HttpApiInterface {
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

  @override
  Future<Map<String, dynamic>> payNow(
      {required Map<String, dynamic> paymentData,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement payNow
    throw UnimplementedError();
  }

  @override
  Future<bool> checkPaymentStatus(
      {required HttpClientInterface flipperHttpClient,
      required String paymentReference}) {
    // TODO: implement checkPaymentStatus
    throw UnimplementedError();
  }
}
