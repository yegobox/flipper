import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:http/retry.dart';

class SocialsHttpClient extends http.BaseClient {
  final http.Client _inner;

  // ignore: sort_constructors_first
  SocialsHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    /// token,userId can be null when is desktop login with pin
    String? token = ProxyService.box.whatsAppToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token ?? ""
    };
    request.headers.addAll(headers);

    const retries = 10;

    var retryClient = RetryClient(_inner, retries: retries);

    try {
      http.StreamedResponse response = await retryClient.send(request);
      return response;
    } on SocketException catch (e) {
      print('Failed to connect: ${e.message}');
      throw Exception('Failed to connect: ${e.message}');
    } catch (error, stackTrace) {
      // Handle other types of errors that might occur during the request
      ProxyService.crash.reportError(error, stackTrace);
      print('Unknown error: ${error.toString()}');
      throw Exception('Unknown error: ${error.toString()}');
    }
  }
}
