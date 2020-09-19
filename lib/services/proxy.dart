import 'package:flipper/locator.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:stacked_services/stacked_services.dart';

final SnackbarService _snackbarService = locator<SnackbarService>();
final _navigationService = locator<FlipperNavigationService>();

abstract class ProxyService {
  // ignore: avoid_classes_with_only_static_members
  static FlipperNavigationService get navigation => _navigationService;
}
