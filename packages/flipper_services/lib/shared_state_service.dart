library flipper_services;

import 'package:flipper_models/business_history.dart';
import 'package:flutter/foundation.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/fuser.dart';
import 'package:flipper_models/unit.dart';
//the entire app action no more actions! since we may reject redux fully!
// import 'package:flipper/model/fuser.dart';

class SharedStateService with ReactiveServiceMixin {
  SharedStateService() {
    listenToReactiveValues([
      _colors,
      _image,
      _currentColor,
      _product,
      _variations,
      _businesses,
      _blueConnected,
      _bluethoothDevices,
      _variation
    ]);
  }

  final RxValue<Branch> _branch = RxValue<Branch>(initial: null);
  final RxValue<Business> _businesses = RxValue<Business>(initial: null);
  final RxValue<Variation> _variation = RxValue<Variation>(initial: null);
  final RxValue<List<PColor>> _colors = RxValue<List<PColor>>(initial: []);
  final RxValue<PColor> _currentColor = RxValue<PColor>(
    initial: PColor(
      (p) => p
        ..name = '#ee5253'
        ..id = '1'
        ..table = 'table'
        ..isActive = false,
    ),
  );

  final RxValue<ImageP> _image = RxValue<ImageP>(initial: null);
  final RxValue<Product> _product = RxValue<Product>(initial: null);
  final RxValue<bool> didLogout = RxValue<bool>(initial: false);

  final RxValue<FUser> _user = RxValue<FUser>(initial: null);
  FUser get user => _user.value;

  final RxValue<BusinessHistory> _businessHistory =
      RxValue<BusinessHistory>(initial: null);
  BusinessHistory get businessHistory => _businessHistory.value;
  void setBusinessHistory({BusinessHistory history}) {
    _businessHistory.value = history;
  }

  final RxValue<List<Variation>> _variations =
      RxValue<List<Variation>>(initial: []);

  final RxValue<List<Unit>> _units = RxValue<List<Unit>>(initial: []);

  List<Unit> get units => _units.value;

  List<PColor> get colors => _colors.value;

  List<Variation> get variations => _variations.value;

  ImageP get image => _image.value;

  PColor get currentColor => _currentColor.value;

  Product get product => _product.value;

  Business get business => _businesses.value;
  Variation get variation => _variation.value;

  Branch get branch => _branch.value;

  // setters
  void setCurrentColor({PColor color}) {
    _currentColor.value = color;
  }

  void setDidLogout({bool logout}) {
    didLogout.value = logout;
  }

  void setProduct({Product product}) {
    _product.value = product;
  }

  void setUser({FUser user}) {
    _user.value = user;
  }

  void setVariation({Variation variation}) {
    _variation.value = variation;
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

  void setUnits({List<Unit> units}) {
    _units.value = units;
  }

  final RxValue<bool> _blueConnected = RxValue<bool>(initial: false);

  final RxValue<List<dynamic>> _bluethoothDevices =
      RxValue<List<dynamic>>(initial: null);

  bool get blueConnected => _blueConnected.value;

  List<dynamic> get bluethioothDevices => _bluethoothDevices.value;

  // setters
  void setBluethoothConnected({bool connected}) {
    _blueConnected.value = connected;
  }

  void setBluethoothDevices({List<dynamic> devices}) {
    _bluethoothDevices.value = devices;
  }

  final RxValue<bool> clear = RxValue<bool>(initial: false);
  void setClear({bool c}) {
    clear.value = c;
  }

  final RxValue<Map> resumeOrders = RxValue<Map>(initial: {});
  void setResumeOrders({@required String orderId, @required String ticketId}) {
    resumeOrders.value = {'orderId': orderId, 'ticketId': ticketId};
  }
}
