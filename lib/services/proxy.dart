import 'package:flipper/locator.dart';
import 'package:flipper/services/analytics_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'abstractions/api.dart';

final DialogService _dialogService = locator<DialogService>();
final NavigationService _navigationService = locator<NavigationService>();
final SnackbarService _snackbarService = locator<SnackbarService>();

final AnalyticsService _analyticsService = locator<AnalyticsService>();

final Api _apiService = locator<Api>();



// ignore: avoid_classes_with_only_static_members
abstract class ProxyService {
  static NavigationService get navigation => _navigationService;
  static DialogService get modal => _dialogService;
  static SnackbarService get toast => _snackbarService;
  static Api get api => _apiService;
  
  static AnalyticsService get analytics => _analyticsService;
}
