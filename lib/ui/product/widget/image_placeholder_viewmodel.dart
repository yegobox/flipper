import 'package:flipper/locator.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:stacked/stacked.dart';

class ImagePlaceholderViewModel extends BaseViewModel {
  final _sharedStateService = locator<SharedStateService>();
  List<PColor> get colors => _sharedStateService.colors;
  ImageP get image => _sharedStateService.image;

  PColor get currentColor => _sharedStateService.currentColor;

  Product get product => _sharedStateService.product;
}
