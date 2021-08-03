import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class LanguageService with ReactiveServiceMixin {
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
