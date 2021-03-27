library flipper_models;
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flipper_services/proxy.dart';

class ReportViewModel extends BaseViewModel {
  final controller = PageController();
  final FlipperNavigationService _navigationService = ProxyService.nav;
  void navigateTo({@required String path}) {
    _navigationService.navigateTo(path);
  }

  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  var date = Jiffy().yMMMMd;
}
