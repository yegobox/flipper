import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:geolocator/geolocator.dart';

import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class BusinessViewModel extends BaseViewModel {
  bool get nameisEmpty {
    return _name.text.isEmpty;
  }

  // ignore: always_declare_return_types
  createBusiness({BuildContext context}) {
    // this will trigger business middleware for taking action on the old way!
    StoreProvider.of<AppState>(context).dispatch(AppAction(
        actions:
            AppActions((AppActionsBuilder a) => a..name = 'createBusiness')));
  }

  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  TextEditingController _name;
  TextEditingController get name {
    return _name;
  }

  TextEditingController _email;
  TextEditingController get email {
    return _email;
  }

  Position _position;
  Position get position {
    return _position;
  }

  // ignore: always_declare_return_types
  getCurrentLocation() async {
    final Geolocator geolocator = Geolocator();
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position location) {
      _position = location;
    });
    notifyListeners();
  }

  // ignore: always_declare_return_types
  handleFormSubmit({BuildContext context, String token, String userId}) {
    StoreProvider.of<AppState>(context).dispatch(AppAction(
        actions: AppActions((AppActionsBuilder a) => a..name = 'showLoader')));

    if (_formKey.currentState == null) {
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final Business business = Business(
        (BusinessBuilder b) => b
          ..id = Uuid().v1()
          ..name = _name.text
          ..active = true
          ..country = 'Rwanda'
          ..currency = 'RWF'
          ..categoryId = '1'
          ..typeId = '1'
          ..latitude = _position.latitude.toString() ?? '0'
          ..longitude = _position.longitude.toString() ?? '0'
          ..active = true
          ..type = 'NORMAL',
      );

      final FUser user = FUser(
        (FUserBuilder user) => user
          ..email = _email.text
          ..active = true
          ..id = userId
          ..createdAt = DateTime.now().toIso8601String()
          ..updatedAt = DateTime.now().toIso8601String()
          ..token = token
          ..name = _name.text,
      );
      // TODO(richard): submit business on remote, and branch so we wont have issue on next login
      StoreProvider.of<AppState>(context).dispatch(WithUser(user: user));
      StoreProvider.of<AppState>(context).dispatch(WithBusiness(business));
      StoreProvider.of<AppState>(context).dispatch(CreateUser(user));
    }
  }

  void initFields({TextEditingController name,TextEditingController email,GlobalKey<FormState> formKey}) {
    _name = name;
    _email = email;
    _formKey = formKey;
  }
}
