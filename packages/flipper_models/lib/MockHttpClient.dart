// mock_http_client.dart
import 'http_client_interface.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends http.BaseClient implements HttpClientInterface {
  // Mock the behavior for testing
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Mock implementation for testing
    final response = http.Response.bytes([], 200);
    final streamedResponse = http.StreamedResponse(
      http.ByteStream.fromBytes(response.bodyBytes),
      response.statusCode,
      contentLength: response.contentLength,
      request: request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
    return streamedResponse;
  }
}
