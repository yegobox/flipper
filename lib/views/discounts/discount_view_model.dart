import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';

class DiscountViewModel extends BaseViewModel {
  final FlipperNavigationService _navigationService = ProxyService.nav;
  void navigateTo({@required String path}) {
    _navigationService.navigateTo(path);
  }

  String _content = 'New';
  String get content {
    return _content;
  }

  String _toggle = '%';
  String get toggle {
    return _toggle;
  }

  String _discountAmount = '0.0';
  String get discountAmount {
    return _discountAmount;
  }

  TextEditingController _discount;
  TextEditingController get discount {
    return _discount;
  }

  TextEditingController _discountname;
  TextEditingController get discountname {
    return _discountname;
  }

  void discountMethod({@required String value}) {
    _content = value;
    print(_content);
    notifyListeners();
  }

  void discountName({@required String discount}) {
    _discountAmount = discount;
    notifyListeners();
  }

  void checkToggle({@required String value}) {
    _toggle = value;
    notifyListeners();
  }
}
