import 'dart:convert';

import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http/retry.dart';

abstract class HttpClientInterface {
  Future<http.StreamedResponse> send(http.BaseRequest request);
  Future<http.Response> get(Uri url, {Map<String, String>? headers});
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
}

class FlipperHttpClient implements HttpClientInterface {
  final http.Client _inner;

  FlipperHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Handle retries and errors
    const retries = 3;
    var retryClient = RetryClient(_inner, retries: retries);

    try {
      return await retryClient.send(request);
    } on SocketException catch (e) {
      throw Exception('Failed to connect: ${e.message}');
    } on HandshakeException catch (e) {
      throw Exception('Failed to connect: ${e.message}');
    } catch (error, stackTrace) {
      ProxyService.crash.reportError(error, stackTrace);
      throw Exception('Unknown error: $error');
    }
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _sendUnstreamed('GET', url, headers);
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _sendUnstreamed('POST', url, headers, body, encoding);
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _sendUnstreamed('PATCH', url, headers, body, encoding);
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _sendUnstreamed('PUT', url, headers, body, encoding);
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _sendUnstreamed('DELETE', url, headers, body, encoding);
  }

  Future<http.Response> _sendUnstreamed(
      String method, Uri url, Map<String, String>? headers,
      [Object? body, Encoding? encoding]) async {
    var request = http.Request(method, url);

    // Get default headers
    Map<String, String> defaultHeaders = await _getHeaders();

    // If 'api-key' is present in the provided headers, remove 'Authorization' from default headers
    if (headers != null && headers.containsKey('api-key')) {
      defaultHeaders.remove('Authorization');
    }

    request.headers.addAll({
      ...defaultHeaders,
      ...?headers, // Ensure headers are not null
    });

    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.body = json.encode(body);
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return http.Response.fromStream(await send(request));
  }

  Future<Map<String, String>> _getHeaders() async {
    String? token;
    if (ProxyService.box.getDefaultApp() == 2) {
      token = ProxyService.box.whatsAppToken();
    } else {
      token = ProxyService.box.getBearerToken();
    }

    int? userId = ProxyService.box.getUserId();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'userId': userId?.toString() ?? "",
    };

    if (token != null) {
      headers['Authorization'] = token;
    }

    return headers;
  }
}
