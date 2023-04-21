import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

class SocialsHttpClient extends http.BaseClient {
  final http.Client _inner;
  // ignore: sort_constructors_first
  SocialsHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    /// token,userId can be null when is desktop login with pin
    String? token = ProxyService.box.getSocialBearerToken();
    print(token);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token ?? ""
    };
    request.headers.addAll(headers);
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
