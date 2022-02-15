library flipper_models;

import 'package:flipper_services/locator.dart';
import 'package:stacked/stacked.dart';
// import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/analytic_service.dart';

class AnalyticViewModel extends ReactiveViewModel {
  final AnalyticService analytic = locator<AnalyticService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];
}
