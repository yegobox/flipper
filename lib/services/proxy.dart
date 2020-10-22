
import 'package:flipper/locator.dart';
import 'package:flipper/services/analytics_service.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/mail_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'abstractions/api.dart';
import 'bluethooth_service.dart';
import 'connectivity_service.dart';
import 'flipperNavigation_service.dart';

final DialogService _dialogService = locator<DialogService>();
final NavigationService _navigationService = locator<NavigationService>();
final SnackbarService _snackbarService = locator<SnackbarService>();

final AnalyticsService _analyticsService = locator<AnalyticsService>();
final ConnectivityService _connectivityService = locator<ConnectivityService>();
final Api _apiService = locator<Api>();
final DatabaseService _databaseService = locator<DatabaseService>();
final BlueToothService _blue = locator<BlueToothService>();
final FlipperNavigationService _nav = locator<FlipperNavigationService>();
final MailService _mail = locator<MailService>();

// ignore: avoid_classes_with_only_static_members
abstract class ProxyService {
  static NavigationService get navigation => _navigationService;
  static DialogService get modal => _dialogService;
  static SnackbarService get toast => _snackbarService;
  static Api get api => _apiService;
  static ConnectivityService get connectivity => _connectivityService;
  static AnalyticsService get analytics => _analyticsService;
  static DatabaseService get database => _databaseService;
  static BlueToothService get blue => _blue;
  static FlipperNavigationService get nav => _nav;
  static MailService get mail =>_mail;
}
