// mock_http_client.dart
import 'package:flipper_services/constants.dart';

import 'http_client_interface.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_models/secrets.dart';

import 'package:flutter/foundation.dart' as foundation;

class MockHttpClient extends http.BaseClient implements HttpClientInterface {
  // Mock the behavior for testing
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String apihub = '';
    String commApi = '';
    if (foundation.kDebugMode && !isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (foundation.kDebugMode && isAndroid) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else if (!foundation.kDebugMode) {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }

    // Mock implementation for testing
    /// I need to know the endpoint passed to the request so I can provide specific
    /// fake object
    final requestUrl = request.url;
    http.StreamedResponse streamedResponse;

    if (requestUrl == '${apihub}/v2/api/businessUserId/1') {
      final response = http.Response.bytes([], 200);
      streamedResponse = http.StreamedResponse(
        http.ByteStream.fromBytes(response.bodyBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } else if (requestUrl == 'https://example.com/endpoint2') {
      final response = http.Response.bytes([], 200);
      streamedResponse = http.StreamedResponse(
        http.ByteStream.fromBytes(response.bodyBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } else {
      final response = http.Response.bytes([], 200);
      streamedResponse = http.StreamedResponse(
        http.ByteStream.fromBytes(response.bodyBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    }

    return streamedResponse;
  }
}
