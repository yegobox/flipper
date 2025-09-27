import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// List of supported locales in the app
const List<Locale> supportedLocales = [
  Locale('en'), // English
  Locale('fr'), // French
  Locale('sw'), // Swahili
];

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _detectAndSetLocale();
  }

  Future<void> _detectAndSetLocale() async {
    try {
      // First try platform locale detection
      final detectedLocale = _detectUserLocale();
      state = detectedLocale;

      // Optionally fall back to IP-based detection if enabled and platform detection
      // returned default English (meaning no match was found)
      if (_enableIpGeolocation && detectedLocale.languageCode == 'en') {
        // Only use IP fallback if platform detection didn't give a specific result
        final ipBasedLocale = await _fallbackToIpBasedLocale();
        if (ipBasedLocale.languageCode != 'en') {
          state = ipBasedLocale;
        }
      }
    } catch (e) {
      debugPrint('Locale detection failed: $e');
      // Fallback to English if all detection fails
      state = const Locale('en');
    }
  }

  Locale _detectUserLocale() {
    // Get platform locale(s)
    final platformLocales = WidgetsBinding.instance.platformDispatcher.locales;

    if (platformLocales.isEmpty) {
      return const Locale('en'); // Default fallback
    }

    // First try to find an exact match for language and country
    for (final platformLocale in platformLocales) {
      for (final supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == platformLocale.languageCode &&
            supportedLocale.countryCode == platformLocale.countryCode) {
          return supportedLocale;
        }
      }
    }

    // Then try to match just the language code
    for (final platformLocale in platformLocales) {
      for (final supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == platformLocale.languageCode) {
          return supportedLocale;
        }
      }
    }

    // Additional mapping for specific countries
    for (final platformLocale in platformLocales) {
      if (platformLocale.countryCode == 'FR') {
        return const Locale('fr');
      } else if ([
        'KE', // Kenya
        'TZ', // Tanzania
        'UG', // Uganda
        'RW', // Rwanda
        'BI', // Burundi
        'CD', // Democratic Republic of Congo
      ].contains(platformLocale.countryCode)) {
        return const Locale('sw'); // Swahili
      }
    }

    // Default fallback
    return const Locale('en');
  }

  // Optional feature flag to control IP-based geolocation
  static const bool _enableIpGeolocation = false;

  void setLocale(Locale locale) {
    state = locale;
  }

  /// Fallback method that uses IP-based geolocation with proper safeguards
  /// This should only be used if explicitly enabled and with user consent
  ///
  /// Note: This method is kept for reference but not actively used
  /// unless the feature flag is enabled
  @Deprecated('Use platform locale detection instead')
  Future<Locale> _fallbackToIpBasedLocale() async {
    // Early return if feature is disabled
    if (!_enableIpGeolocation) {
      return const Locale('en');
    }

    try {
      // Set a short timeout to avoid hanging
      final client = http.Client();
      final request = http.Request('GET', Uri.parse('https://ipapi.co/json/'));
      request.headers['User-Agent'] = 'Flutter Locale Detection/1.0';

      // Set a short timeout (3 seconds)
      final response = await client
          .send(request)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw TimeoutException('IP geolocation request timed out');
            },
          );

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        final countryCode = data['country_code'] as String?;

        if (countryCode != null) {
          // Map countries to locales
          if (countryCode == 'FR') {
            return const Locale('fr');
          } else if ([
            'KE',
            'TZ',
            'UG',
            'RW',
            'BI',
            'CD',
          ].contains(countryCode)) {
            // Swahili-speaking countries
            return const Locale('sw');
          }
        }
      }
    } catch (e) {
      debugPrint('IP geolocation failed: $e');
    }

    // Default fallback
    return const Locale('en');
  }
}
