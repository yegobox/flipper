import 'package:flutter/foundation.dart';

class LoginInfo extends ChangeNotifier {
  var _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool isDrawerOpen = false;
  void setDrawerOpen(bool drawerOpen) {
    isDrawerOpen = drawerOpen;
    notifyListeners();
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  var _loginChoices = false;
  bool get loginChoices => _loginChoices;
  set loginChoices(bool value) {
    _loginChoices = value;
    notifyListeners();
  }

  var _needSignUp = false;
  bool get needSignUp => _needSignUp;
  set needSignUp(bool value) {
    _needSignUp = value;
    notifyListeners();
  }

  var _switchBranch = false;
  bool get switchBranch => _switchBranch;
  set switchBranch(bool value) {
    _switchBranch = value;
    notifyListeners();
  }

  var _country = "";
  String get country => _country;
  set country(String value) {
    _country = value;
    notifyListeners();
  }

  var _noNet = false;
  bool get noNet => _noNet;
  set noNet(bool value) {
    _noNet = value;
    notifyListeners();
  }

  var _redirecting = false;
  bool get redirecting => _redirecting;
  set redirecting(bool value) {
    _redirecting = value;
    notifyListeners();
  }
}
