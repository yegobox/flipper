import 'dart:convert';

import 'package:flipper_models/bulk_rra_client.dart';
import 'package:flipper_models/data_connector_http_log.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:http/http.dart' as http;

/// HTTP client for data-connector `POST /api/products`.
class ProductCreateClient {
  ProductCreateClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.logHttp = true,
  })  : _http = httpClient ?? http.Client(),
        _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final String baseUrl;
  final http.Client _http;
  final String _base;
  final bool logHttp;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  /// Syncs regulated fuel variants from RRA via data-connector.
  Future<ProductCreateResult> syncFuelReference({
    required String productName,
    required String categoryId,
    required String businessId,
    required String branchId,
    String? lastReqDt,
  }) async {
    final uri = Uri.parse('${_base}api/products');
    final body = <String, dynamic>{
      'product_name': productName,
      'category_id': categoryId,
      'business_id': businessId,
      'branch_id': branchId,
      'catalog_source': 'fuel_reference',
    };
    if (lastReqDt != null && lastReqDt.isNotEmpty) {
      body['last_req_dt'] = lastReqDt;
    }

    if (logHttp) {
      DataConnectorHttpLog.request(
        method: 'POST',
        uri: uri,
        body: jsonEncode(body),
        headers: _jsonHeaders,
        operation: 'fuel_reference sync',
      );
    }

    final started = Stopwatch()..start();
    final response = await _http
        .post(
          uri,
          headers: _jsonHeaders,
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(minutes: 5),
          onTimeout: () {
            throw Exception(
              'Fuel sync timed out after 5 minutes. '
              'Check data-connector is reachable.',
            );
          },
        );
    started.stop();

    if (logHttp) {
      DataConnectorHttpLog.response(
        method: 'POST',
        uri: uri,
        statusCode: response.statusCode,
        body: response.body,
        elapsed: started.elapsed,
        operation: 'fuel_reference sync',
      );
    }

    if (response.statusCode != 200) {
      talker.error(
        'fuel_reference sync failed ${response.statusCode}: ${response.body}',
      );
      throw Exception(
        'Fuel sync failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final resultCd = (decoded['resultCd'] ?? decoded['result_cd'] ?? '')
        .toString();
    final resultMsg = (decoded['resultMsg'] ?? decoded['result_msg'] ?? '')
        .toString();
    if (resultCd != '000') {
      throw Exception(
        resultMsg.isNotEmpty ? resultMsg : 'Fuel sync failed ($resultCd)',
      );
    }

    final data = decoded['data'] as Map<String, dynamic>?;
    final variantIds = (data?['variant_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return ProductCreateResult(
      productId: data?['product_id']?.toString(),
      variantIds: variantIds,
      message: resultMsg.isNotEmpty ? resultMsg : 'Fuel synced successfully',
    );
  }
}

class ProductCreateResult {
  const ProductCreateResult({
    this.productId,
    this.variantIds = const [],
    required this.message,
  });

  final String? productId;
  final List<String> variantIds;
  final String message;
}

/// Resolves connector base URL and returns a [ProductCreateClient].
Future<ProductCreateClient> productCreateClientForBranch({
  String? dataConnectorUrl,
}) async {
  final base = await resolveDataConnectorBaseUrl(
    dataConnectorUrl: dataConnectorUrl,
  );
  return ProductCreateClient(baseUrl: base);
}
