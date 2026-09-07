// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_web/core/analytics/analytics_provider.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flipper_models/helperModels/business_type.dart';

final signupRepositoryProvider = Provider<SignupRepository>((ref) {
  final analytics = ref.watch(productAnalyticsProvider);
  return SignupRepository(analytics: analytics);
});

class SignupRepository {
  SignupRepository({required ProductAnalytics analytics})
      : _analytics = analytics {
    _httpClient = http.Client();
  }

  final ProductAnalytics _analytics;
  late final http.Client _httpClient;

  static String get _apiHubDomain =>
      kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain;

  /// apihub sits behind HTTP basic auth; without these headers every call
  /// comes back as 401 "Authentication required".
  Map<String, String> _apiHubHeaders() {
    final credentials =
        '${AppSecrets.publicUsername}:${AppSecrets.publicPassword}';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
    };
  }

  Future<bool> checkUsernameAvailability(String username) async {
    if (username.length < 3) {
      return false;
    }

    final http.Response response;
    try {
      response = await _httpClient.get(
        Uri.parse(
          '$_apiHubDomain/v2/api/search?name=${Uri.encodeQueryComponent(username)}',
        ),
        headers: _apiHubHeaders(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Username availability check error: $e');
      }
      throw Exception(
        'Network error while checking username. Please try again.',
      );
    }

    // A 404 response means the username is not found in the system,
    // which means it's available to be used
    if (response.statusCode == 404) {
      return true; // Username is available
    }
    if (response.statusCode == 200) {
      // Username exists in the system (found)
      return false; // Username is not available
    }

    // Anything else (401, 5xx, ...) tells us nothing about the username, so
    // surface it as an error instead of falsely reporting "not available".
    if (kDebugMode) {
      print(
        'Username availability check failed: '
        '${response.statusCode} - ${response.body}',
      );
    }
    throw Exception(
      'Could not verify username availability (${response.statusCode}). '
      'Please try again.',
    );
  }

  Future<Map<String, dynamic>> registerBusiness({
    required String username,
    required String fullName,
    required String businessTypeId,
    required String tinNumber,
    required String country,
    String? phoneNumber,
    Object? userId, // Accept flexible userId (int or String)
  }) async {
    try {
      // Construct the registration payload based on CoreSync's signup method
      final Map<String, dynamic> payload = {
        'name': username,
        'fullName': fullName,
        'businessTypeId': businessTypeId,
        'tinNumber': tinNumber,
        'country': country,
        'currency': 'RWF', // Default currency
        'longitude': 1.0,
        'latitude': 1.0,
        'bhfid': '00',
        // Ensure userId is sent as a string regardless of incoming type
        'userId': userId?.toString(),
        'type': BusinessTypeEnum.fromId(businessTypeId).name,
      };

      // Add phone number if available
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        payload['phoneNumber'] = phoneNumber;
      }

      // Log the registration attempt (can be removed in production)
      if (kDebugMode) {
        print('Registering user with payload: $payload');
      }

      // Make the actual API call to register the user
      final response = await _httpClient.post(
        Uri.parse('$_apiHubDomain/v2/api/business'),
        headers: _apiHubHeaders(),
        body: jsonEncode(payload),
      );

      // Parse the response
      if (kDebugMode) {
        print(
          'Registration response: ${response.statusCode} - ${response.body}',
        );
      }

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _analytics.track(
          AnalyticsEvents.signupCompleted,
          properties: {
            'source': 'signup_repository',
            'business_type_id': businessTypeId,
            'country': country,
          },
        );
        // Parse and return the response data to caller
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (kDebugMode) {
            print('Registration successful: $responseData');
          }
          return responseData;
        } catch (e) {
          // If parsing fails, still return a minimal map containing status code and raw body
          if (kDebugMode) {
            print('Registration successful but response parsing failed: $e');
          }
          return {'statusCode': response.statusCode, 'body': response.body};
        }
      } else {
        // Extract error message if available
        Map<String, dynamic>? errorData;
        try {
          errorData = jsonDecode(response.body);
        } catch (_) {
          // If JSON parsing fails, use the raw response
        }

        final errorMessage =
            errorData?['message'] ??
            errorData?['error'] ??
            'Registration failed with status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Registration error: $e');
      }

      // Provide more specific error messages based on exception type
      if (e.toString().contains('SocketException')) {
        throw Exception(
          'Network error: Unable to connect to server. Please check your internet connection.',
        );
      } else if (e.toString().contains('timeout')) {
        throw Exception(
          'Request timed out. The server is taking too long to respond. Please try again later.',
        );
      } else if (e.toString().contains('HttpException')) {
        throw Exception(
          'Network error: Unable to complete the request. Please try again later.',
        );
      } else if (e.toString().contains('Exception:')) {
        // If it's already a formatted exception, pass it through
        throw e;
      } else {
        throw Exception('Registration failed: ${e.toString()}');
      }
    }
  }

  Future<List<BusinessType>> getBusinessTypes() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('business_types').select();
      return (response as List)
          .map((e) => BusinessType.fromSupabaseRow(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching business types: $e');
      }
      // Fallback to enum if fetch fails
      return BusinessTypeEnum.values
          .map((e) => BusinessType(id: e.id, typeName: e.typeName))
          .toList();
    }
  }
}
