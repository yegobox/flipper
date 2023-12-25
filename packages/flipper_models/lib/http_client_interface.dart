import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

abstract class HttpClientInterface extends http.BaseClient {
  Future<http.StreamedResponse> send(http.BaseRequest request);

  void close();

  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<http.Response> get(Uri url, {Map<String, String>? headers});

  Future<http.Response> head(Uri url, {Map<String, String>? headers});

  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});

  Future<String> read(Uri url, {Map<String, String>? headers});

  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers});
}
