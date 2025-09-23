import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _detectAndSetLocale();
  }

  Future<void> _detectAndSetLocale() async {
    try {
      final detectedLocale = await _detectUserLocale();
      state = detectedLocale;
    } catch (e) {
      // Fallback to English if detection fails
      state = const Locale('en');
    }
  }

  Future<Locale> _detectUserLocale() async {
    if (!kIsWeb) {
      return const Locale('en');
    }

    try {
      // Use ipapi.co for free IP geolocation
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
            // Swahili-speaking countries: Kenya, Tanzania, Uganda, Rwanda, Burundi, DRC
            return const Locale('sw');
          }
        }
      }
    } catch (e) {
      // If IP detection fails, fallback to English
    }

    // Default fallback
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
  }
}
