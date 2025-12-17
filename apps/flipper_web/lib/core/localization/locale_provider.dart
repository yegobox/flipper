import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

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

  void setLocale(Locale locale) {
    state = locale;
  }
}
