import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class FlipperHttpClient extends http.BaseClient {
  final http.Client _inner;

  // ignore: sort_constructors_first
  FlipperHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    /// token,userId can be null when is desktop login with pin
    String? token = ProxyService.box.getBearerToken();
    int? userId = ProxyService.box.getUserId();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
      'userId': userId == null ? "" : userId.toString()
    };
    request.headers.addAll(headers);

    const maxRetries = 10;
    var retries = 0;

    try {
      while (retries < maxRetries) {
        try {
          return await _inner.send(request);
        } on SocketException catch (e) {
          print('Failed to connect: ${e.message}');
          retries++;
          await Future.delayed(Duration(seconds: 1));
          if (retries >= maxRetries) {
            throw Exception('Maximum retries exceeded');
          }
          continue;
        } catch (error, stackTrace) {
          // Handle other types of errors that might occur during the request
          ProxyService.crash.reportError(error, stackTrace);
          print('Unknown error: ${error.toString()}');
          throw Exception('Unknown error: ${error.toString()}');
        }
      }

      print('Failed after $maxRetries retries');
      // Handle the error after maximum retries have been exhausted
      throw Exception('Maximum retries exceeded');
    } catch (error, stackTrace) {
      // Handle other types of errors that might occur during the request
      ProxyService.crash.reportError(error, stackTrace);
      print('Unknown error: ${error.toString()}');
      throw Exception('Unknown error: ${error.toString()}');
    }
  }
}
