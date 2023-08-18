import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

abstract class Language {
  void setLocale({required String lang});
}

class UnImplementedLanguage with ReactiveServiceMixin implements Language {
  final _locale = ReactiveValue<Locale>(Locale('en'));

  Locale get locale => _locale.value;

  @override
  void setLocale({required String lang}) {
    _locale.value = Locale(lang);
  }

  LanguageService() {
    listenToReactiveValues([
      _locale,
    ]);
  }
}

class LanguageService with ReactiveServiceMixin implements Language {
  final _locale = ReactiveValue<Locale>(Locale('en'));

  Locale get locale => _locale.value;
  void setLocale({required String lang}) {
    _locale.value = Locale(lang);
  }

  LanguageService() {
    listenToReactiveValues([
      _locale,
    ]);
  }
}
