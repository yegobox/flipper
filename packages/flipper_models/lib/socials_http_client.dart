import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class SocialsHttpClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  SocialsHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    /// token,userId can be null when is desktop login with pin
    String? token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IjI1MDc4ODM2MDA1OCIsImlkIjoiMjUwNzg4MzYwMDU4Iiwicm9sZXMiOlsiVVNFUiJdLCJpYXQiOjE2ODE1Mzc5NjAsImV4cCI6MTY4MTYyNDM2MH0.vcngMYauJpMNBjfq_M0U2sEzfNeH35e-atlfYYRb1is";

    request.headers['Authorization'] = token;
    request.headers['Content-Type'] = 'application/json';

    try {
      return await _inner.send(request);
    } catch (error, stackTrace) {
      if (error is http.ClientException) {
        // Handle network errors
        ProxyService.crash.reportError(error, stackTrace);
        throw Exception('Network error: ${error.message}');
      } else if (error is http.Response) {
        // Handle server errors
        ProxyService.crash.reportError(error, stackTrace);
        throw Exception('Server error: ${error.statusCode}');
      } else {
        // Handle any other errors
        ProxyService.crash.reportError(error, stackTrace);
        throw Exception('Unknown error: ${error.toString()}');
      }
    }
  }
}
