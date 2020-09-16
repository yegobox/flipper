import 'package:flipper/locator.dart';
import 'package:stacked_services/stacked_services.dart';

final SnackbarService _snackbarService = locator<SnackbarService>();
final NavigationService _navigationService = locator<NavigationService>();


abstract class ProxyService {
  static NavigationService get navigation => _navigationService;

  static SnackbarService get toast => _snackbarService;
}