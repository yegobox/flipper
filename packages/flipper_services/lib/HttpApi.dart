import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:supabase_models/brick/models/customer_payments.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Response from [HttpApiInterface.makePaymentWithReference] (`/v2/api/payNow` with `planId`).
///
/// [paymentReference] is the id for `GET .../requesttopay/status/{paymentReference}/{branchId}` (payNow JSON field).
/// [HttpApi] only returns this on HTTP 200/202 when that value is non-empty; otherwise it throws.
class MakePaymentWithReferenceResult {
  final String? paymentReference;

  const MakePaymentWithReferenceResult({this.paymentReference});
}

/// One GET `.../requesttopay/status/{ref}/{branch}` result (for polling / commission fields).
class RequestToPayHttpSnapshot {
  RequestToPayHttpSnapshot({
    required this.httpStatus,
    required this.json,
    required this.sanitizedReference,
  });

  final int httpStatus;
  final Map<String, dynamic> json;
  final String sanitizedReference;

  static String? _normStatus(Map<String, dynamic> j) =>
      j['status']?.toString().trim().toUpperCase();

  /// MTN success: 2xx HTTP and body status SUCCESSFUL (case-insensitive).
  bool get isMtnSuccessful =>
      httpStatus >= 200 &&
      httpStatus < 300 &&
      _normStatus(json) == 'SUCCESSFUL';

  String? get financialTransactionId =>
      json['financialTransactionId']?.toString();

  String? get externalId => json['externalId']?.toString();

  /// RWF from MTN body [amount] (string or number).
  int? get settledAmountRwf {
    final a = json['amount'];
    if (a is num) return a.round();
    return int.tryParse(a?.toString().trim() ?? '');
  }
}

abstract class HttpApiInterface {
  Future<bool> isCouponValid({
    required HttpClientInterface flipperHttpClient,
    required String couponCode,
  });
  Future<bool> isPaymentComplete({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
  });
  Future<bool> hasAcessSaved({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
  });
  Future<bool> makePayment({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String phoneNumber,
    String? externalId,
    required String branchId,
    required String paymentType,
    required String payeemessage,
    required String payerMessage,
    required int amount,
  });

  /// POST `/v2/api/payNow`; parses `paymentReference` from JSON on HTTP 200 or 202.
  Future<MakePaymentWithReferenceResult> initiatePayNowWithReference({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String branchId,
    required String paymentType,
    String? externalId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
    required String phoneNumber,
  });

  Future<bool> subscribe({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
    required String phoneNumber,
    int? agentCode,
    int? timeInSeconds = 120,
    required int amount,
  });
  Future<Map<String, dynamic>> payNow({
    required Map<String, dynamic> paymentData,
    required HttpClientInterface flipperHttpClient,
  });
  /// Polls MTN via `GET .../requesttopay/status/{paymentReference}/{branchId}`.
  /// [paymentReference] must be the payNow response `paymentReference` (same value as MTN's X-Reference-Id).
  /// [branchId] must match payNow `branchId`; when null, the default collection branch id is used.
  Future<bool> checkPaymentStatus({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  });

  /// GET request-to-pay status (parsed JSON). Use [RequestToPayHttpSnapshot.isMtnSuccessful] when polling.
  Future<RequestToPayHttpSnapshot?> fetchRequestToPayHttpSnapshot({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  });

  /// Uploads a PDF document and extracts company information from it
  /// Returns a Map containing the extracted company information
  Future<Map<String, dynamic>> extractCompanyInfoFromPdf({
    required HttpClientInterface flipperHttpClient,
    required String filePath,
    String? fileName,
  });
  Future<bool> fetchRemoteStockQuantity({
    required Variant variant,
    required HttpClientInterface client,
  });
  Future<int?> getBusinessId({
    required HttpClientInterface client,
    required String businessId,
  });

  /// Accumulated subscription amount due (RWF) from flipper-turbo
  /// `GET /v2/api/plans/{planId}/amount-due`.
  Future<Map<String, dynamic>?> getPlanAmountDue({
    required HttpClientInterface flipperHttpClient,
    required String planId,
  });

  /// Client confirmed MTN SUCCESSFUL; backend verifies MTN, updates plan, creates invoice.
  /// POST `/v2/api/payment/finalize-on-success` (flipper-turbo `MTNPaymentController`).
  Future<void> finalizePaymentOnSuccess({
    required HttpClientInterface flipperHttpClient,
    required String planId,
    required String paymentReference,
  });

  /// MTN request-to-pay after pre-approval; includes [planId] for backend tracking (`MTNModel`).
  /// POST `/v2/api/payNow`.
  Future<MakePaymentWithReferenceResult> makePaymentWithReference({
    required HttpClientInterface flipperHttpClient,
    required Object businessId,
    required String phoneNumber,
    required String paymentType,
    required String payeemessage,
    required String payerMessage,
    required String branchId,
    String? planId,
    required int amount,
  });
}

class HttpApi implements HttpApiInterface {
  /// MTN collection branch id — must match payNow JSON `branchId` when calling requesttopay status.
  static const String defaultMtnRequestToPayBranchId =
      '2f83b8b1-6d41-4d80-b0e7-de8ab36910af';

  static final RegExp _ansiSgr = RegExp('\u001B\\[[0-9;]*m');
  static final RegExp _uuidPattern = RegExp(
    r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
  );

  /// MTN request-to-pay id: payNow `paymentReference` / `externalId` (same as [X-Reference-Id] on the wire).
  static String? sanitizeMtnRequestToPayReferenceId(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    s = s.replaceAll(_ansiSgr, '');
    final m = _uuidPattern.firstMatch(s);
    if (m != null) return m.group(0);
    return s.isEmpty ? null : s;
  }

  /// [json.decode] often yields [Map] without [Map<String,dynamic>] at runtime; always normalize.
  static Map<String, dynamic>? jsonObjectFromDecoded(dynamic decoded) {
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    return null;
  }

  /// Value for the status URL path: payNow JSON `paymentReference`, else `externalId` (server sends both; same MTN id).
  static String? paymentReferenceForStatusPolling(Map<String, dynamic> decoded) {
    final fromPr =
        sanitizeMtnRequestToPayReferenceId(decoded['paymentReference']?.toString());
    if (fromPr != null && fromPr.isNotEmpty) return fromPr;
    return sanitizeMtnRequestToPayReferenceId(decoded['externalId']?.toString());
  }

  @override
  Future<bool> fetchRemoteStockQuantity({
    required Variant variant,
    required HttpClientInterface client,
  }) async {
    try {
      // Construct the Supabase REST endpoint for variants
      final String baseUrl = AppSecrets.superbaseurl;
      final String anonKey = AppSecrets.supabaseAnonKey;
      final Uri uri = Uri.parse(
        '$baseUrl/rest/v1/variants?id=eq.${variant.id}&select=stock_id',
      );

      // Fetch the variant to get the stock_id
      final variantResp = await client.get(
        uri,
        headers: {
          'apikey': anonKey,
          'Authorization': 'Bearer $anonKey',
          'Accept': 'application/json',
        },
      );
      if (variantResp.statusCode != 200) {
        talker.error('Failed to fetch variant: \\${variantResp.body}');
        return false;
      }
      final variantList = json.decode(variantResp.body);
      if (variantList is! List ||
          variantList.isEmpty ||
          variantList[0]['stock_id'] == null) {
        talker.error('No stock_id found for variant ${variant.id}');
        return false;
      }
      final String stockId = variantList[0]['stock_id'];

      // Now fetch the stock
      final Uri stockUri = Uri.parse(
        '$baseUrl/rest/v1/stocks?id=eq.$stockId&select=current_stock',
      );
      final stockResp = await client.get(
        stockUri,
        headers: {
          'apikey': anonKey,
          'Authorization': 'Bearer $anonKey',
          'Accept': 'application/json',
        },
      );
      if (stockResp.statusCode != 200) {
        talker.error('Failed to fetch stock: \\${stockResp.body}');
        return false;
      }
      final stockList = json.decode(stockResp.body);
      if (stockList is! List ||
          stockList.isEmpty ||
          stockList[0]['current_stock'] == null) {
        talker.error('No currentStock found for stock $stockId');
        return false;
      }
      return variant.stock?.currentStock == stockList[0]['current_stock'];
    } catch (e, stack) {
      talker.error('Error in fetchRemoteStockQuantity', e, stack);
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> payNow({
    required Map<String, dynamic> paymentData,
    required HttpClientInterface flipperHttpClient,
  }) async {
    try {
      // Ensure the URL is properly formatted
      final Uri uri = Uri.parse('${AppSecrets.apihubProd}/v2/api/payNow');

      // Format the request body according to the required structure
      final formattedPaymentData = {
        "amount": paymentData['amount'].toString(),
        "currency": paymentData['currency'] ?? "RWF",
        "payer": {
          "partyIdType": "MSISDN",
          "partyId": paymentData['phoneNumber'],
        },
        // this is constant for now.
        "branchId": "2f83b8b1-6d41-4d80-b0e7-de8ab36910af",
        "payerMessage": paymentData['description'] ?? "Flipper Credit Purchase",
        "payeeNote": "Flipper Credit",
        "businessId": ProxyService.box.getBusinessId() ?? 1,
        "paymentType": "Credit Purchase",
      };

      // Convert formatted payment data to JSON string
      final body = json.encode(formattedPaymentData);

      talker.info('PayNow request body: $body');

      // Make the POST request
      final response = await flipperHttpClient.post(uri, body: body);

      final decoded = json.decode(response.body);
      final responseData = HttpApi.jsonObjectFromDecoded(decoded);
      if (responseData == null) {
        throw Exception('PayNow response is not a JSON object');
      }

      // Log the response
      talker.info('PayNow response: ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 202) {
        await ProxyService.strategy.upsertPayment(
          CustomerPayments(
            phoneNumber: paymentData['phoneNumber'],
            paymentStatus: "pending",
            amountPayable: paymentData['amount'].toDouble(),
            transactionId: responseData['paymentReference'],
          ),
        );
        return responseData;
      } else {
        // Handle error response
        talker.error('PayNow error: ${response.statusCode} - ${response.body}');
        throw Exception(
          'PayNow request failed with status: ${response.statusCode}',
        );
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
  Future<bool> isCouponValid({
    required HttpClientInterface flipperHttpClient,
    required String couponCode,
  }) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json',
    };
    final response = await flipperHttpClient.post(
      headers: headers,
      Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
      body: json.encode({
        "collection": AppSecrets.flipperCompaignCollection,
        "database": AppSecrets.database,
        "dataSource": AppSecrets.dataSource,
        "filter": {"couponCode": couponCode},
      }),
    );
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
    required String businessId,
  }) async {
    var headers = {
      'api-key': AppSecrets.supabaseAnonKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await flipperHttpClient.get(
        headers: headers,
        Uri.parse(
          '${AppSecrets.superbaseurl}/rest/v1/plans?business_id=eq.$businessId',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // Check if the response list is not empty
        if (responseData.isNotEmpty) {
          // Get the first item from the array
          final Map<String, dynamic> planData = responseData.first;

          final bool isCompletedByUser =
              planData['payment_completed_by_user'] ?? false;
          final bool isStatusCompleted =
              planData['payment_status'] == 'COMPLETED';

          return isCompletedByUser || isStatusCompleted;
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
  Future<bool> hasAcessSaved({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
  }) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json',
    };
    final response = await flipperHttpClient.post(
      headers: headers,
      Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
      body: json.encode({
        "collection": AppSecrets.AccessCollection,
        "database": AppSecrets.database,
        "dataSource": AppSecrets.dataSource,
        "filter": {"businessId": businessId},
      }),
    );
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

  /// Strips `+`, spaces, and non-digits so `partyId` matches gateway MSISDN rules.
  static String _normalizePayNowMsisdn(String phoneNumber) {
    var s = phoneNumber.trim();
    s = s.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    s = s.replaceAll('+', '');
    s = s.replaceAll('\uFF0B', '');
    return s.replaceAll(RegExp(r'\D'), '');
  }

  Future<http.Response> _payNowPost({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String branchId,
    required String paymentType,
    String? externalId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
    required String phoneNumber,
  }) async {
    final partyId = _normalizePayNowMsisdn(phoneNumber);
    final payload = <String, dynamic>{
      "amount": amount,
      "currency": "RWF",
      "payer": {"partyIdType": "MSISDN", "partyId": partyId},
      "payerMessage": payerMessage,
      "payeeNote": payeemessage,
      "branchId": branchId,
      "paymentType": paymentType,
      "externalId": externalId,
    };
    if (businessId != null) {
      payload["businessId"] = businessId;
    } else {
      payload.remove("businessId");
    }
    final body = json.encode(payload);
    talker.debug(body);
    final response = await flipperHttpClient.post(
      headers: {'Content-Type': 'application/json'},
      Uri.parse('${AppSecrets.coreApi}/v2/api/payNow'),
      body: body,
    );
    talker.debug(response.body);
    return response;
  }

  void _throwIfPayNowHttpError(int status) {
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
  }

  @override
  Future<bool> makePayment({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String branchId,
    required String paymentType,
    String? externalId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
    required String phoneNumber,
  }) async {
    final response = await _payNowPost(
      flipperHttpClient: flipperHttpClient,
      businessId: businessId,
      branchId: branchId,
      paymentType: paymentType,
      externalId: externalId,
      payeemessage: payeemessage,
      payerMessage: payerMessage,
      amount: amount,
      phoneNumber: phoneNumber,
    );
    final status = response.statusCode;
    _throwIfPayNowHttpError(status);
    return status == 200 || status == 202;
  }

  @override
  Future<MakePaymentWithReferenceResult> initiatePayNowWithReference({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String branchId,
    required String paymentType,
    String? externalId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
    required String phoneNumber,
  }) async {
    final response = await _payNowPost(
      flipperHttpClient: flipperHttpClient,
      businessId: businessId,
      branchId: branchId,
      paymentType: paymentType,
      externalId: externalId,
      payeemessage: payeemessage,
      payerMessage: payerMessage,
      amount: amount,
      phoneNumber: phoneNumber,
    );
    final status = response.statusCode;
    _throwIfPayNowHttpError(status);
    if (status != 200 && status != 202) {
      throw Exception('PayNow failed: HTTP $status');
    }
    dynamic decoded;
    try {
      decoded = json.decode(response.body);
    } catch (e, st) {
      talker.error(
        'initiatePayNowWithReference: invalid JSON (HTTP $status): ${response.body}',
        e,
        st,
      );
      throw Exception('PayNow returned invalid JSON (HTTP $status)');
    }
    final decodedMap = HttpApi.jsonObjectFromDecoded(decoded);
    if (decodedMap == null) {
      throw Exception('PayNow response is not a JSON object (HTTP $status)');
    }
    final paymentReference =
        HttpApi.paymentReferenceForStatusPolling(decodedMap);
    if (paymentReference == null || paymentReference.isEmpty) {
      throw Exception(
        'PayNow response missing paymentReference/externalId (HTTP $status)',
      );
    }
    return MakePaymentWithReferenceResult(
      paymentReference: paymentReference,
    );
  }

  @override
  Future<bool> subscribe({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
    required String phoneNumber,
    int? agentCode,
    int? timeInSeconds = 120,
    required int amount,
  }) async {
    final phone = phoneNumber.replaceAll('+', '').replaceAll(' ', '').trim();
    final response = await flipperHttpClient.post(
      Uri.parse('${AppSecrets.coreApi}/v2/api/preApprove'),
      body: json.encode({
        "payer": {"partyIdType": "MSISDN", "partyId": phone},
        "payerCurrency": "RWF",
        "payerMessage": "Flipper Subscription",
        "validityTime": timeInSeconds,
        "branchId": "2f83b8b1-6d41-4d80-b0e7-de8ab36910af",
      }),
    );
    return response.statusCode == 200;
  }

  @override
  Future<RequestToPayHttpSnapshot?> fetchRequestToPayHttpSnapshot({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  }) async {
    final idForStatusPath =
        HttpApi.sanitizeMtnRequestToPayReferenceId(paymentReference);
    if (idForStatusPath == null || idForStatusPath.isEmpty) {
      talker.error(
        'fetchRequestToPayHttpSnapshot: invalid paymentReference (input: $paymentReference)',
      );
      return null;
    }
    final branch = (branchId != null && branchId.trim().isNotEmpty)
        ? branchId.trim()
        : defaultMtnRequestToPayBranchId;
    final response = await flipperHttpClient.get(
      Uri.parse(
        '${AppSecrets.apihubProd}/v2/api/requesttopay/status/$idForStatusPath/$branch',
      ),
    );

    talker.info('Payment status response: ${response.body}');

    Map<String, dynamic>? map;
    try {
      map = HttpApi.jsonObjectFromDecoded(json.decode(response.body));
    } catch (e, st) {
      talker.error(
        'fetchRequestToPayHttpSnapshot: invalid JSON (HTTP ${response.statusCode})',
        e,
        st,
      );
      return null;
    }
    if (map == null) {
      talker.warning(
        'fetchRequestToPayHttpSnapshot: body is not a JSON object (HTTP ${response.statusCode})',
      );
      return null;
    }
    final snap = RequestToPayHttpSnapshot(
      httpStatus: response.statusCode,
      json: map,
      sanitizedReference: idForStatusPath,
    );
    talker.info(
      'Request-to-pay snapshot HTTP ${response.statusCode} mtnStatus=${snap.json['status']} isMtnSuccessful=${snap.isMtnSuccessful}',
    );
    return snap;
  }

  @override
  Future<bool> checkPaymentStatus({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  }) async {
    try {
      final snap = await fetchRequestToPayHttpSnapshot(
        flipperHttpClient: flipperHttpClient,
        paymentReference: paymentReference,
        branchId: branchId,
      );
      if (snap == null) return false;
      if (!snap.isMtnSuccessful) {
        talker.error('Payment not successful: ${snap.json['status']}');
        return false;
      }
      await _updatePaymentStatus(snap.sanitizedReference, snap.json);
      return true;
    } catch (e, stackTrace) {
      talker.error('Error checking payment status', e, stackTrace);
      return false;
    }
  }

  Future<void> _updatePaymentStatus(
    String paymentReference,
    Map<String, dynamic> responseData,
  ) async {
    try {
      // Find the payment record
      final payments = await ProxyService.strategy.getPayment(
        paymentReference: paymentReference,
      );

      if (payments != null) {
        final payment = payments;

        // Update payment status
        payment.paymentStatus = 'completed';

        // Add credits to user account if payment was successful
        if (responseData['status']?.toString().trim().toUpperCase() ==
            'SUCCESSFUL') {
          final amount = double.tryParse(responseData['amount']?.toString() ?? '0') ?? 0;
          Credit? credit = await ProxyService.strategy.getCredit(
            branchId: (await ProxyService.strategy.branch(
              serverId: ProxyService.box.getBranchId()!,
            ))!.id,
          );
          if (credit != null) {
            credit.credits += amount;
            await ProxyService.strategy.updateCredit(credit);
          } else {
            Credit credit = Credit(
              branchServerId: ProxyService.box.getBranchId()!,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              businessId: (await ProxyService.strategy.getBusiness(
                businessId: ProxyService.box.getBusinessId()!,
              ))!.id,
              branchId: (await ProxyService.strategy.branch(
                serverId: ProxyService.box.getBranchId()!,
              ))!.id,
              credits: amount,
            );
            await ProxyService.strategy.updateCredit(credit);
          }
        }

        // Save updated payment record
        await ProxyService.strategy.upsertPayment(payment);
        talker.info('Payment status updated for reference: $paymentReference');
      } else {
        // MTN success does not imply a local Brick [CustomerPayments] row: subscription
        // flows usually sync one (transactionId == reference); gig / ad-hoc payNow often does not.
        talker.info(
          'No local payment row for reference $paymentReference — skipping credit/upsert (normal for some payNow flows)',
        );
      }
    } catch (e, stackTrace) {
      talker.error('Error updating payment status', e, stackTrace);
    }
  }

  @override
  Future<Map<String, dynamic>> extractCompanyInfoFromPdf({
    required HttpClientInterface flipperHttpClient,
    required String filePath,
    String? fileName,
  }) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      final request = http.Request(
        'POST',
        Uri.parse('${AppSecrets.apihubProd}/document-intelligence/analyze'),
      );

      // Set headers
      request.headers['Content-Type'] = 'application/octet-stream';
      final credentials = base64Encode(
        utf8.encode('${AppSecrets.username}:${AppSecrets.password}'),
      );
      request.headers['Authorization'] = 'Basic $credentials';

      // Set the file bytes as the request body
      request.bodyBytes = bytes;

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse and return the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        talker.error(
          'PDF extraction failed: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to extract company info from PDF: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      talker.error('Error in extractCompanyInfoFromPdf', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<int?> getBusinessId({
    required HttpClientInterface client,
    required String businessId,
  }) {
    // TODO: implement getBusinessId
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getPlanAmountDue({
    required HttpClientInterface flipperHttpClient,
    required String planId,
  }) async {
    try {
      final response = await flipperHttpClient.get(
        Uri.parse('${AppSecrets.apihubProd}/v2/api/plans/$planId/amount-due'),
      );
      if (response.statusCode == 200) {
        final map = HttpApi.jsonObjectFromDecoded(json.decode(response.body));
        if (map != null) {
          return map;
        }
      } else {
        talker.warning(
          'getPlanAmountDue failed: ${response.statusCode} ${response.body}',
        );
      }
      return null;
    } catch (e, stackTrace) {
      talker.error('getPlanAmountDue error', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> finalizePaymentOnSuccess({
    required HttpClientInterface flipperHttpClient,
    required String planId,
    required String paymentReference,
  }) async {
    final uri = Uri.parse(
      '${AppSecrets.apihubProd}/v2/api/payment/finalize-on-success',
    );
    final body = json.encode({
      'planId': planId,
      'paymentReference': paymentReference,
    });
    final response = await flipperHttpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 200) {
      talker.warning(
        'finalizePaymentOnSuccess failed: ${response.statusCode} ${response.body}',
      );
      throw Exception(
        'finalizePaymentOnSuccess failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  @override
  Future<MakePaymentWithReferenceResult> makePaymentWithReference({
    required HttpClientInterface flipperHttpClient,
    required Object businessId,
    required String phoneNumber,
    required String paymentType,
    required String payeemessage,
    required String payerMessage,
    required String branchId,
    String? planId,
    required int amount,
  }) async {
    final payload = <String, dynamic>{
      'amount': amount,
      'currency': 'RWF',
      'payer': {'partyIdType': 'MSISDN', 'partyId': phoneNumber},
      'payerMessage': payerMessage,
      'payeeNote': payeemessage,
      'businessId': '$businessId',
      'branchId': branchId,
      'paymentType': paymentType,
      if (planId != null) 'planId': planId,
    };

    final response = await flipperHttpClient.post(
      headers: {'Content-Type': 'application/json'},
      Uri.parse('${AppSecrets.coreApi}/v2/api/payNow'),
      body: json.encode(payload),
    );
    talker.debug(response.body);

    final status = response.statusCode;
    if (status == 200 || status == 202) {
      dynamic decoded;
      try {
        decoded = json.decode(response.body);
      } catch (e, st) {
        talker.error(
          'makePaymentWithReference: invalid JSON on HTTP $status (body: ${response.body})',
          e,
          st,
        );
        throw Exception(
          'makePaymentWithReference: invalid JSON response (HTTP $status)',
        );
      }
      final decodedMap = HttpApi.jsonObjectFromDecoded(decoded);
      if (decodedMap == null) {
        talker.error(
          'makePaymentWithReference: HTTP $status but body is not a JSON object '
          '(got ${decoded.runtimeType}). body=${response.body}',
        );
        throw Exception(
          'makePaymentWithReference: unexpected response shape (HTTP $status)',
        );
      }
      final paymentReference =
          HttpApi.paymentReferenceForStatusPolling(decodedMap);
      if (paymentReference == null || paymentReference.isEmpty) {
        talker.error(
          'makePaymentWithReference: HTTP $status but paymentReference/externalId missing. '
          'body=${response.body}',
        );
        throw Exception(
          'makePaymentWithReference: missing payment reference (HTTP $status)',
        );
      }
      return MakePaymentWithReferenceResult(
        paymentReference: paymentReference,
      );
    }
    if (status == 400) {
      throw Exception('Bad request');
    } else if (status == 401) {
      throw Exception('Unauthorized');
    } else if (status == 403) {
      throw Exception('Forbidden');
    } else if (status == 404) {
      throw Exception('Not found');
    } else if (status == 409) {
      throw Exception('Duplicate payment Id');
    } else if (status == 500) {
      throw Exception('Internal server error');
    } else if (status == 502) {
      throw Exception('Payment gateway down');
    } else if (status == 503) {
      throw Exception('Service unavailable');
    } else if (status == 504) {
      throw Exception('Gateway timeout');
    }
    throw Exception('payNow failed: $status ${response.body}');
  }
}

class RealmViaHttpServiceMock implements HttpApiInterface {
  @override
  Future<bool> fetchRemoteStockQuantity({
    required Variant variant,
    required HttpClientInterface client,
  }) async {
    // Mock: always return 42.0 for testing
    return true;
  }

  @override
  Future<bool> isCouponValid({
    required HttpClientInterface flipperHttpClient,
    required String couponCode,
  }) async {
    return true;
  }

  @override
  Future<bool> isPaymentComplete({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
  }) async {
    return true;
  }

  @override
  Future<bool> hasAcessSaved({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
  }) {
    // TODO: implement hasAcessSaved
    throw UnimplementedError();
  }

  @override
  Future<bool> subscribe({
    required HttpClientInterface flipperHttpClient,
    required String businessId,
    required String phoneNumber,
    int? timeInSeconds,
    int? agentCode,
    required int amount,
  }) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<bool> makePayment({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String paymentType,
    required String phoneNumber,
    String? externalId,
    required String branchId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
  }) {
    // TODO: implement makePayment
    throw UnimplementedError();
  }

  @override
  Future<MakePaymentWithReferenceResult> initiatePayNowWithReference({
    required HttpClientInterface flipperHttpClient,
    String? businessId,
    required String branchId,
    required String paymentType,
    String? externalId,
    required String payeemessage,
    required String payerMessage,
    required int amount,
    required String phoneNumber,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> payNow({
    required Map<String, dynamic> paymentData,
    required HttpClientInterface flipperHttpClient,
  }) {
    // TODO: implement payNow
    throw UnimplementedError();
  }

  @override
  Future<bool> checkPaymentStatus({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  }) {
    // TODO: implement checkPaymentStatus
    throw UnimplementedError();
  }

  @override
  Future<RequestToPayHttpSnapshot?> fetchRequestToPayHttpSnapshot({
    required HttpClientInterface flipperHttpClient,
    required String paymentReference,
    String? branchId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> extractCompanyInfoFromPdf({
    required HttpClientInterface flipperHttpClient,
    required String filePath,
    String? fileName,
  }) async {
    // Mock implementation for testing
    return {
      "Producer":
          "Microsoft Reporting Services PDF Rendering Extension 11.0.0.0",
      "Content": {
        "CompanyName": "YEGOBOX Ltd",
        "ShareCapital": "5000000",
        "Type": "Limited by shares",
        "Category": "Type: Limited by shares",
        "Email": "info@yegobox.com",
        "RegistrationDate": "05/04/2019",
        "Address": "Management details:",
        "MainBusinessActivityDescription": "Computer programming activities",
        "PhoneNumber": "+250788360058",
        "CompanyCode": "108754813",
      },
      "Title": "DomesticDetail",
      "Creator": "Microsoft Reporting Services 11.0.0.0",
    };
  }

  @override
  Future<int?> getBusinessId({
    required HttpClientInterface client,
    required String businessId,
  }) {
    // TODO: implement getBusinessId
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> getPlanAmountDue({
    required HttpClientInterface flipperHttpClient,
    required String planId,
  }) async {
    return {
      'amountDue': 5000,
      'periodsBucket': 0,
      'partialDays': 0,
      'basePeriodPrice': 5000,
    };
  }

  @override
  Future<void> finalizePaymentOnSuccess({
    required HttpClientInterface flipperHttpClient,
    required String planId,
    required String paymentReference,
  }) async {}

  @override
  Future<MakePaymentWithReferenceResult> makePaymentWithReference({
    required HttpClientInterface flipperHttpClient,
    required Object businessId,
    required String phoneNumber,
    required String paymentType,
    required String payeemessage,
    required String payerMessage,
    required String branchId,
    String? planId,
    required int amount,
  }) async {
    return const MakePaymentWithReferenceResult(
      paymentReference: 'mock-payment-reference',
    );
  }
}
