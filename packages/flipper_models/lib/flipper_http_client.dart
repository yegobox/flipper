import 'dart:convert';

import 'package:flipper_models/helperModels/UniversalProduct.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/secrets.dart' as secrets;

import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http/retry.dart';

import 'package:supabase_models/brick/models/universalProduct.model.dart';
import 'package:supabase_models/brick/repository.dart';

class DefaultFlipperHttpClient with FlipperHttpClient {
  final http.Client _client;

  @override
  final Repository repository;

  DefaultFlipperHttpClient(this._client, this.repository);

  @override
  http.Client get _inner => _client;
}

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
  Future<http.Response> getUniversalProducts(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
 
}

/// Mixin for HTTP client logic. Requires the implementing class to provide an http.Client via the `_inner` getter.
mixin FlipperHttpClient implements HttpClientInterface {
  Repository get repository;

  /// The underlying http.Client instance must be provided by the implementing class.
  http.Client get _inner;

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
    int? userId = ProxyService.box.getUserId();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'userId': userId?.toString() ?? "",
    };

    // Add basic authentication using credentials from AppSecrets
    final credentials =
        '${secrets.AppSecrets.username}:${secrets.AppSecrets.password}';
    final encodedCredentials = base64Encode(utf8.encode(credentials));
    headers['Authorization'] = 'Basic $encodedCredentials';

    return headers;
  }

  @override
  Future<http.Response> getUniversalProducts(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await http.post(url, headers: headers, body: body);
    final jsonResponse = json.decode(response.body);

    if (jsonResponse is Map<String, dynamic> &&
        jsonResponse['data'] is Map<String, dynamic> &&
        jsonResponse['data']['itemClsList'] is List) {
      final List<dynamic> itemClsList = jsonResponse['data']['itemClsList'];
      UniversalProduct product = UniversalProduct.fromJson(itemClsList[0]);
      final result = await repository.get<UnversalProduct>(
          query:
              Query(where: [Where('itemClsCd').isExactly(product.itemClsCd)]));
      if (result.isEmpty) {
        repository.upsert<UnversalProduct>(UnversalProduct(
          itemClsCd: product.itemClsCd,
          itemClsNm: product.itemClsNm,
          itemClsLvl: product.itemClsLvl,
          taxTyCd: product.taxTyCd,
          mjrTgYn: product.mjrTgYn,
          useYn: product.useYn,
          businessId: product.businessId,
          branchId: product.branchId,
        ));
        talker.info("UniversalProduct added: ${product.itemClsCd}");
      }
    }
    return response;
  }

}
