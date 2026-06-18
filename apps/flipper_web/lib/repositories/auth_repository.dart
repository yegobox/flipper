import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flipper_web/core/api_login_key.dart';
import 'package:flipper_web/core/session_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/core/utils/http_overrides.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/supabase_provider.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/core/ditto/ditto_bootstrap.dart';
import 'package:flipper_web/repositories/user_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthRepository(supabase, userRepository, ref);
});

class AuthRepository {
  final SupabaseClient _supabase;
  final UserRepository _userRepository;
  final Ref _ref;
  late final http.Client _httpClient;

  AuthRepository(this._supabase, this._userRepository, this._ref) {
    // Ensure HTTP overrides (e.g. badCertificateCallback) are installed
    // before creating the `http.Client` so its underlying HttpClient
    // picks up the overrides on non-web platforms.
    initializeCriticalDependencies();
    _httpClient = http.Client();
  }

  Future<bool> verifyPin(String pin) async {
    final url = Uri.parse(
      '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/pin',
    );

    try {
      final response = await _httpClient
          .post(
            url,
            body: jsonEncode({'pin': pin}),
            headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Pin not found');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied - check authentication');
      } else {
        throw Exception('Invalid PIN (${response.statusCode})');
      }
    } on SocketException catch (e) {
      debugPrint('Socket error: $e');
      throw Exception(
        'Network connection failed. Check your internet connection.',
      );
    } on TimeoutException catch (e) {
      debugPrint('Timeout error: $e');
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }

  Future<void> sendOtp() async {
    // This seems to be handled by verifyPin in the existing implementation.
    // If a separate call is needed, it can be added here.
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> verifyOtp(String pin, String otp) async {
    final response = await _httpClient.post(
      Uri.parse(
        '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/verify-otp',
      ),
      body: jsonEncode({'pin': pin, 'otp': otp}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return _completeOtpLogin(responseData);
    } else if (response.statusCode == 404) {
      throw Exception('OTP not found');
    } else {
      throw Exception('Invalid OTP');
    }
  }

  Future<bool> verifyTotp(String pin, String totp) async {
    final response = await _httpClient.post(
      Uri.parse(
        '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/login/verify-totp',
      ),
      body: jsonEncode({'pin': pin, 'totp': totp}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${AppSecrets.publicUsername}:${AppSecrets.publicPassword}'))}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return _completeOtpLogin(responseData);
    } else if (response.statusCode == 404) {
      throw Exception('TOTP not found');
    } else {
      throw Exception('Invalid TOTP');
    }
  }

  Future<bool> _completeOtpLogin(Map<String, dynamic> responseData) async {
    final refreshToken = responseData['refreshToken'] as String?;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Login succeeded but no Supabase refresh token was returned');
    }

    final pinUserId = responseData['userId']?.toString().trim();
    if (pinUserId != null && pinUserId.isNotEmpty) {
      _ref.read(sessionApiUserIdProvider.notifier).state = pinUserId;
      await SessionPersistence.save(apiUserId: pinUserId);
    }

    final rawLoginKey = responseData['phoneNumber']?.toString().trim();
    final loginKey = rawLoginKey == null || rawLoginKey.isEmpty
        ? null
        : normalizeApiUserLoginKey(rawLoginKey);
    if (loginKey != null &&
        loginKey.isNotEmpty &&
        !isFlipperDittoLoginKey(loginKey)) {
      _ref.read(sessionLoginKeyProvider.notifier).state = loginKey;
      await SessionPersistence.save(loginKey: loginKey);
    }

    await _supabase.auth.setSession(refreshToken);
    await _fetchAndSaveUserProfile(
      loginKey: loginKey,
      pinUserId: pinUserId,
    );
    return true;
  }

  /// Fetches the user profile from the API, saves it to Ditto, and caches
  /// it in memory so the business-selection screen can use it immediately.
  Future<void> _fetchAndSaveUserProfile({
    String? loginKey,
    String? pinUserId,
  }) async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No active session found');
      }

      final resolvedLoginKey =
          loginKey ?? _ref.read(sessionLoginKeyProvider);
      final resolvedPinUserId =
          pinUserId ?? _ref.read(sessionApiUserIdProvider);
      final profile = await _userRepository.fetchAndSaveUserProfile(
        session,
        loginKey: resolvedLoginKey,
        pinUserId: resolvedPinUserId,
      );

      await SessionPersistence.save(
        apiUserId: resolvedPinUserId ?? profile.id,
        loginKey: _ref.read(sessionLoginKeyProvider),
      );

      final profilePhone = profile.phoneNumber.trim();
      if (profilePhone.isNotEmpty) {
        final normalizedPhone = normalizeApiUserLoginKey(profilePhone);
        _ref.read(sessionLoginKeyProvider.notifier).state = normalizedPhone;
        await SessionPersistence.save(loginKey: normalizedPhone);
      }

      // Cache only complete profiles so business selection is not blocked.
      if (profile.hasBusinesses) {
        _ref.read(userProfileCacheProvider.notifier).state = profile;
      } else {
        _ref.read(userProfileCacheProvider.notifier).state = null;
      }

      _ref.invalidate(currentUserProfileProvider);

      final dittoUserId = (resolvedPinUserId ?? profile.id).trim();
      if (dittoUserId.isNotEmpty) {
        // Non-blocking — accounting providers refresh when Ditto becomes ready.
        unawaited(DittoBootstrap.ensureInitialized(_ref, userId: dittoUserId));
      }

      debugPrint('User profile fetched and cached successfully');
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      rethrow;
    }
  }
}
