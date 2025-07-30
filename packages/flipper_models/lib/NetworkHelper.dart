import 'dart:convert';
import 'package:dio/dio.dart';

mixin NetworkHelper {
  Dio? get dioInstance;
  dynamic get talkerInstance;

  Future<Response> sendPostRequest(
    String baseUrl,
    Map<String, dynamic>? data,
  ) async {
    final headers = {'Content-Type': 'application/json'};

    try {
      // Set timeout configurations
      final response = await dioInstance!.post(
        baseUrl,
        data: json.encode(data),
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );
      print('Response received: ${response.statusCode}');
      return response;
    } on DioException catch (e, s) {
      print('DioException caught: ${e.message}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout occurred.');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('Send timeout occurred.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Received timeout occurred.From the server');
      } else if (e.type == DioExceptionType.badResponse) {
        // This handles server response errors
        final errorMessage = e.response?.data;
        throw Exception(
            'Error sending POST request: ${errorMessage ?? 'Bad Request'}');
      } else {
        talkerInstance?.error(s);
        throw Exception('Unexpected error occurred: ${e.message}');
      }
    } catch (e, s) {
      print('General exception caught: $e');
      talkerInstance?.info(e);
      talkerInstance?.error(s);
      rethrow;
    }
  }
}
