// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:flipper_web/core/secrets.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flipper_models/helperModels/business_type.dart';

final signupRepositoryProvider = Provider<SignupRepository>((ref) {
  return SignupRepository();
});

class SignupRepository {
  late final http.Client _httpClient;

  SignupRepository() {
    _httpClient = http.Client();
  }

  Future<bool> checkUsernameAvailability(String username) async {
    if (username.length < 3) {
      return false;
    }

    try {
      final response = await _httpClient.get(
        Uri.parse(
          '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/search?name=$username',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      // A 404 response means the username is not found in the system,
      // which means it's available to be used
      if (response.statusCode == 404) {
        return true; // Username is available
      } else if (response.statusCode == 200) {
        // Username exists in the system (found)
        return false; // Username is not available
      }
      return false; // Default to unavailable for other status codes
    } catch (e) {
      if (kDebugMode) {
        print('Username availability check error: $e');
      }

      // Network errors should be propagated to show error state
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HttpException') ||
          e.toString().contains('timeout')) {
        throw Exception(
          'Network error while checking username. Please try again.',
        );
      }

      // For demo purposes or when network is unavailable, simulate username availability check with a simple rule
      // In production, you would use the actual API response
      return username.length >= 4 &&
          !['admin', 'system', 'user', 'test'].contains(username.toLowerCase());
    }
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
        Uri.parse(
          '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/business',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
      return (response as List).map((e) => BusinessType.fromJson(e)).toList();
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
