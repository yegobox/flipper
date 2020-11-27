import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flipper/domain/app_actions.dart'; //the entire app action no more actions! since we may reject redux fully!
import 'package:flipper/model/fuser.dart';

class SharedStateService with ReactiveServiceMixin {
  SharedStateService() {
    listenToReactiveValues(
        [_colors, _image, _currentColor, _product, _variations]);
  }

  final RxValue<Branch> _branch = RxValue<Branch>(initial: null);
  final RxValue<Business> _businesses = RxValue<Business>(initial: null);
  final RxValue<List<PColor>> _colors = RxValue<List<PColor>>(initial: []);
  final RxValue<PColor> _currentColor = RxValue<PColor>(
      initial: PColor((p) => p
        ..name = '#ee5253'
        ..id = '1'
        ..table = 'table'
        ..isActive = false));

  final RxValue<ImageP> _image = RxValue<ImageP>(initial: null);
  final RxValue<Product> _product = RxValue<Product>(initial: null);

  final RxValue<FUser> _user = RxValue<FUser>(initial: null);

  final RxValue<List<Variation>> _variations =
      RxValue<List<Variation>>(initial: []);

  List<PColor> get colors => _colors.value;

  List<Variation> get variations => _variations.value;

  ImageP get image => _image.value;

  PColor get currentColor => _currentColor.value;

  Product get product => _product.value;

  FUser get user => _user.value;

  Business get business => _businesses.value;

  Branch get branch => _branch.value;

  // setters
  void setCurrentColor({PColor color,@required BuildContext context}) {
    _currentColor.value = color;
    
    StoreProvider.of<AppState>(context).dispatch(CurrentColor(color:color));
  }

  void setProduct({Product product}) {
    _product.value = product;
  }

  void setUser({FUser user}) {
    _user.value = user;
  }

  void setBranch({Branch branch}) {
    _branch.value = branch;
  }

  void setBusiness({Business business}) {
    _businesses.value = business;
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
