import 'package:flutter/foundation.dart';

class CreditData extends ChangeNotifier {
  int _availableCredits = 0;
  final int _maxCredits = 1000; // Maximum credit limit

  int get availableCredits => _availableCredits;
  int get maxCredits => _maxCredits;

  void buyCredits(int amount) {
    _availableCredits += amount;
    if (_availableCredits > _maxCredits) {
      _availableCredits = _maxCredits;
    }
    notifyListeners();
  }

  void useCredits(int amount) {
    if (_availableCredits >= amount) {
      _availableCredits -= amount;
      notifyListeners();
    }
  }
}
