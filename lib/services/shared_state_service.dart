import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class SharedStateService with ReactiveServiceMixin {
  SharedStateService() {
    listenToReactiveValues([_colors,_image,_currentColor,_product,_variations]);
  }
  final RxValue<List<PColor>> _colors = RxValue<List<PColor>>(initial: []);

  List<PColor> get colors => _colors.value;

  final RxValue<List<Variation>> _variations = RxValue<List<Variation>>(initial: []);

  List<Variation> get variations => _variations.value;

  final RxValue<ImageP> _image = RxValue<ImageP>(initial: null);

  ImageP get image => _image.value;

  final RxValue<PColor> _currentColor = RxValue<PColor>(initial: PColor((p)=>p..name='#ee5253'));

  PColor get currentColor => _currentColor.value;

  final RxValue<Product> _product = RxValue<Product>(initial: null);

  Product get product => _product.value;

  // setters
  void setCurrentColor({PColor color}) {
    _currentColor.value = color;
  }

  void setProduct({Product product}) {
    _product.value = product;
  }

  void setImage({ImageP image}) {
    _image.value = image;
}

void setColors({List<PColor> colors}) {
  _colors.value = colors;
}
void setVariations({List<Variation> variations}) {
  _variations.value = variations;
}

}
