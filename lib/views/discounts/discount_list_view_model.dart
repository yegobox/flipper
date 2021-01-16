import 'package:stacked/stacked.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';

class ListDiscountViewModel extends BaseViewModel {
  final FlipperNavigationService _navigationService = ProxyService.nav;
  void navigateTo({@required String path}) {
    _navigationService.navigateTo(path);
  }
}
