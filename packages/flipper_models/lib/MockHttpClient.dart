// mock_http_client.dart
import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/constants.dart';

import 'package:http/http.dart' as http;
import 'package:flipper_models/secrets.dart';

import 'package:flutter/foundation.dart' as foundation;

class MockHttpClient implements HttpClientInterface {
  // Mock the behavior for testing
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String apihub = '';
    if (foundation.kDebugMode && !isAndroid) {
      apihub = AppSecrets.coreApi;
    } else if (foundation.kDebugMode && isAndroid) {
      apihub = AppSecrets.coreApi;
    } else if (!foundation.kDebugMode) {
      apihub = AppSecrets.apihubProd;
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

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement put
    throw UnimplementedError();
  }
  
  @override
  Future<http.Response> getUniversalProducts(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement getUniversalProducts
    throw UnimplementedError();
  }
}
