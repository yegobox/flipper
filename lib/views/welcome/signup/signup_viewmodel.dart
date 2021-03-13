import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper_models/app_action.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class SignUpViewModel extends BaseViewModel {
  bool get nameisEmpty {
    return _name.text.isEmpty;
  }

  final List<Business> _business = <Business>[];
  List<Business> get business {
    return _business;
  }

  Branch _branch;
  Branch get branch {
    return _branch;
  }

  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  TextEditingController _name;
  TextEditingController get name {
    return _name;
  }

   TextEditingController _referralCOde;
  TextEditingController get referralCode {
    return _referralCOde;
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
  singUp({BuildContext context, String token, String userId}) async {
    if (nameisEmpty) {
      return;
    }
    
    StoreProvider.of<AppState>(context).dispatch(AppAction(
        actions:
            AppActions((AppActionsBuilder a) => a..name = 'createBusiness')));

    StoreProvider.of<AppState>(context).dispatch(AppAction(
        actions: AppActions((AppActionsBuilder a) => a..name = 'showLoader')));

    if (_formKey.currentState == null) {
      return;
    }
    // _formKey.currentState.validate();
   
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // create a business
      final businessId = await createBusiness(
          userId: userId, businessName: _name.text, context: context);

      // create a it's branches
      final branchId = await createBranch(
          businessId: businessId, businessName: _name.text, userId: userId);

      await generateAppColors(userId: userId);
      await generateAppDefaultCategory(branchId: branchId, userId: userId);

      await ProxyService.database
          .initialAppData(branchId: branchId, userId: userId);
      await ProxyService.sharedPref.setIsAppConstantsInitialized();
      // then navigate to a right page ditch auth middleware
      StoreProvider.of<AppState>(context).dispatch(VerifyAuthenticationState());
    }
  }

  Future<void> generateAppColors({String userId}) async {
    final List<String> colors = [
      '#d63031',
      '#0984e3',
      '#e84393',
      '#2d3436',
      '#6c5ce7',
      '#74b9ff',
      '#ff7675',
      '#a29bfe'
    ];
    //insert default colors for the app
    final _databaseService = ProxyService.database;

    for (int i = 0; i < colors.length; i++) {
      final id = Uuid().v1();
      _databaseService.insert(id: id, data: {
        'name': colors[i],
        'id': id,
        'isActive': false,
        'channels': [userId],
        'table': AppTables.color
      });
    }
  }

  void initFields(
      {TextEditingController name,
      TextEditingController email,
      GlobalKey<FormState> formKey}) {
    _name = name;
    _email = email;
    _formKey = formKey;
  }

  Future<String> createBranch(
      {@required String userId, String businessName, String businessId}) async {
    assert(userId != null);
    final String branchId = Uuid().v1();
    final Map<String, dynamic> _mapBranch = {
      'active': true,
      'name': businessName,
      'channels': [userId],
      'businessId': businessId,
      'id': branchId,
      'syncedOnline': true, //we don't need  really
      'channel': userId, //we don't need  really
      'table': AppTables.branch,
      'mapLatitude': '0.0',
      'mapLongitude': ' 0.0',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final Document branch =
        ProxyService.database.insert(id: branchId, data: _mapBranch);
    return branch.ID;
  }

  Future<String> createBusiness(
      {@required String userId,
      String businessName,
      BuildContext context}) async {
    assert(userId != null);

    final businessId = Uuid().v1();
    final Map<String, dynamic> _mapBusiness = {
      'active': true,
      'id': businessId,
      'categoryId': '10', //pet store a default id when signup on mobile
      'channels': [userId],
      'typeId': '1', //pet store a default id when signup on mobile
      'table': AppTables.business,
      'country': 'Rwanda',
      'currency': 'RWF',
      'name': businessName,
      'userId': userId,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final Document business =
        ProxyService.database.insert(id: businessId, data: _mapBusiness);

    _business.add(Business.fromMap(business.jsonProperties));
    StoreProvider.of<AppState>(context)
        .dispatch(OnBusinessLoaded(business: _business));
    // ignore: always_specify_types
    final taxId = Uuid().v1();
    final Map<String, dynamic> _notTax = {
      'active': true,
      'channels': [userId],
      'businessId': business.ID,
      'table': AppTables.tax,
      'createdAt': DateTime.now().toIso8601String(),
      'id': taxId,
      'updatedAt': DateTime.now().toIso8601String(),
      'isDefault': false,
      'name': 'No Tax',
      'percentage': 0,
    };

    ProxyService.database.insert(id: taxId, data: _notTax);

    final tax2Id = Uuid().v1();

    final Map<String, dynamic> vat = {
      'active': true,
      'channels': [userId],
      'businessId': business.ID,
      'table': AppTables.tax,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'id': tax2Id,
      'isDefault': true,
      'name': 'Vat',
      'percentage': 18,
    };

    ProxyService.database.insert(id: tax2Id, data: vat);

    return business.ID;
  }

  Future generateAppDefaultCategory({String branchId, String userId}) async {
    final id = Uuid().v1();
    final Map<String, dynamic> category = {
      'active': true,
      'table': AppTables.category,
      'branchId': branchId,
      'focused': true,
      'id': id,
      'channels': [userId],
      'name': 'NONE'
    };
    ProxyService.database.insert(id: id, data: category);
  }
}
