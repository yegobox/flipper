import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';

class ItemViewModel extends BaseViewModel {
  final FlipperNavigationService _navigationService = ProxyService.nav;
  void navigateTo({@required String path}) {
    _navigationService.navigateTo(path);
  }
}
