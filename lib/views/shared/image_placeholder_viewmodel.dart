import 'package:flipper_services/locator.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';

class ImagePlaceholderViewModel extends ReactiveViewModel {
  final _sharedStateService = locator<SharedStateService>();
  List<PColor> get colors => _sharedStateService.colors;
  ImageP get image => _sharedStateService.image;

  PColor get currentColor => _sharedStateService.currentColor;

  Product get product => _sharedStateService.product;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_sharedStateService];
}
