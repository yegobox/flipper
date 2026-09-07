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

import '../core/api_login_key.dart';

/// apihub sits behind HTTP basic auth; without these headers every call comes
/// back as 401 "Authentication required". The mobile client
/// (`FlipperHttpClient._getHeaders`) attaches the same credentials to every
/// apihub request, so anything talking to apihub from web must too.
Map<String, String> apiHubHeaders() {
  final credentials =
      '${AppSecrets.publicUsername}:${AppSecrets.publicPassword}';
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
  };
}

/// The body POST `/v2/api/business` expects, byte-for-byte the one the mobile
/// app sends — see `SignupViewModel.registerTenant`
/// (packages/flipper_models/lib/view_models/signup_viewmodel.dart) and
/// `CoreSync.signup`, which strips `businessTypeId` before sending.
///
/// `businessTypeId` is deliberately absent: the server defaults it to 1, and
/// mobile has always let it. Sending the picked id (2 for Individual) made
/// web-created businesses skip the subscription check `AuthMixin` waives for
/// `businessTypeId == 2`, and changed which app `Booting.setDefaultApp` lands
/// the user in.
///
/// `type` is the literal `'Business'` mobile sends, not the business-type enum
/// name — web was writing 'INDIVIDUAL' / 'BUSINESS' / 'ENTERPRISE' into that
/// column.
Map<String, dynamic> buildBusinessRegistrationPayload({
  required String username,
  required String fullName,
  required String businessTypeId,
  required String tinNumber,
  required String country,
  String? phoneNumber,
  Object? userId,
  DateTime? createdAt,
}) {
  final isIndividual = businessTypeId == BusinessTypeEnum.INDIVIDUAL.id;
  // Mobile's fallback TIN for individuals and for a blank field.
  const placeholderTin = 999909695;
  final tin = (isIndividual || tinNumber.trim().isEmpty)
      ? placeholderTin
      : (int.tryParse(tinNumber.trim()) ?? placeholderTin);

  return {
    'name': username,
    'fullName': fullName,
    'latitude': '1',
    'longitude': '1',
    'phoneNumber': phoneNumber,
    'currency': 'RWF',
    'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    // Ensure userId is sent as a string regardless of incoming type
    'userId': userId?.toString(),
    'tinNumber': tin,
    'type': 'Business',
    'bhfid': '00',
    'referredBy': 'Organic',
    'country': country,
  };
}

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

  Map<String, String> _apiHubHeaders() => apiHubHeaders();

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
      final Map<String, dynamic> payload = buildBusinessRegistrationPayload(
        username: username,
        fullName: fullName,
        businessTypeId: businessTypeId,
        tinNumber: tinNumber,
        country: country,
        phoneNumber: phoneNumber,
        userId: userId,
      );

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

  Map<String, dynamic> _decodeOrEmpty(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  /// POST `/v2/api/user` — returns the id of the user behind [contact],
  /// creating it when apihub has not seen the contact before.
  ///
  /// apihub wants the user to exist before it will send a signup OTP, which is
  /// why the mobile bloc calls `sendLoginRequest(..., refreshUserAccessOnly:
  /// true)` before `sendOtpForSignup`.
  Future<String?> lookupOrCreateUserId(String contact) async {
    final http.Response response;
    try {
      response = await _httpClient.post(
        Uri.parse('$_apiHubDomain/v2/api/user'),
        headers: _apiHubHeaders(),
        body: jsonEncode({'phoneNumber': normalizeApiUserLoginKey(contact)}),
      );
    } catch (e) {
      if (kDebugMode) print('User lookup error: $e');
      throw Exception(
        'Network error while starting registration. Please try again.',
      );
    }

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('User lookup failed: ${response.statusCode} - ${response.body}');
      }
      throw Exception(
        'Could not start registration (${response.statusCode}). '
        'Please try again.',
      );
    }

    return _decodeOrEmpty(response.body)['id']?.toString();
  }

  /// POST `/v2/api/login/send-otp-signup` — mirrors
  /// `AuthMixin.sendOtpForSignup`, including its 409 "contact already exists"
  /// conflict, which is what stops a second account being opened on a phone
  /// number that already has one.
  Future<Map<String, dynamic>> sendSignupOtp(String contact) async {
    final http.Response response;
    try {
      response = await _httpClient.post(
        Uri.parse('$_apiHubDomain/v2/api/login/send-otp-signup'),
        headers: _apiHubHeaders(),
        body: jsonEncode({'contact': contact}),
      );
    } catch (e) {
      if (kDebugMode) print('Send OTP error: $e');
      throw Exception('Network error while sending the code. Please try again.');
    }

    if (response.statusCode == 200) {
      return _decodeOrEmpty(response.body);
    }
    if (response.statusCode == 409) {
      throw Exception(
        _decodeOrEmpty(response.body)['error'] ?? 'Contact already exists',
      );
    }
    throw Exception(
      _decodeOrEmpty(response.body)['error'] ?? 'Failed to send OTP for signup',
    );
  }

  /// POST `/v2/api/login/verify-otp-signup` — mirrors
  /// `AuthMixin.verifyOtpForSignup`. The caller reads `verified`.
  Future<Map<String, dynamic>> verifySignupOtp(
    String contact,
    String otp,
  ) async {
    final http.Response response;
    try {
      response = await _httpClient.post(
        Uri.parse('$_apiHubDomain/v2/api/login/verify-otp-signup'),
        headers: _apiHubHeaders(),
        body: jsonEncode({'contact': contact, 'otp': otp}),
      );
    } catch (e) {
      if (kDebugMode) print('Verify OTP error: $e');
      throw Exception('Network error while checking the code. Please try again.');
    }

    if (response.statusCode == 200) {
      return _decodeOrEmpty(response.body);
    }
    throw Exception(
      _decodeOrEmpty(response.body)['error'] ??
          'Failed to verify OTP for signup',
    );
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
