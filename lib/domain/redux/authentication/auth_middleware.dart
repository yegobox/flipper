import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper_models/pcolor.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/fuser.dart';
import 'package:flipper_models/hint.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../app_state.dart';
import 'auth_actions.dart';

List<Middleware<AppState>> createAuthenticationMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, VerifyAuthenticationState>(
        _verifyAuthState(navigatorKey)),
    TypedMiddleware<AppState, LogOutAction>(_authLogout(navigatorKey)),
    TypedMiddleware<AppState, AfterLoginAction>(_verifyAuthState(navigatorKey)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _verifyAuthState(
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);
    //start by opening DB if not open
    // ProxyService.database.openDB();
    final FlipperNavigationService _navigationService = ProxyService.nav;

    final String loggedInuserId = await isUserCurrentlyLoggedIn(store);
    if (loggedInuserId == null) {
      _navigationService.navigateTo(Routing.afterSplash);
      return;
    }

    await getBusinesses(store: store, loggedInuserId: loggedInuserId);
    await getAppColors();
  };
}

Future getAppColors() async {
  final Logger log = Logging.getLogger('Get business: ');
  final DatabaseService _databaseService = ProxyService.database;

  final List<PColor> colors = [];

  final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

  q.parameters = {'VALUE': AppTables.color};

  final results = q.execute();
  if (results.isNotEmpty) {
    for (Map map in results) {
      map.forEach((key, value) {
        colors.add(PColor.fromMap(value));
        log.d(colors);
      });
    }
    // five feet apart.
  }
}

Future<void> openCloseBusiness({
  String loggedInuserId,
  String name,
  bool isSocial = false,
  String businessId,
  bool isClosed = false,
}) async {
  final DatabaseService _databaseService = ProxyService.database;

  final q = Query(_databaseService.db,
      'SELECT  id,cashierName,openingHour,isSocial,table,openingFloat,closingFloat,displayText,businessId,userId,createdAt WHERE table=\$T AND openingHour=\$OPEN');

  q.parameters = {'T': AppTables.drawerHistories, 'OPEN': true};
  final isBusinessOpen = q.execute();

  if (isBusinessOpen.isEmpty) {
    //it is not open open it now for later to be closed
    final String id = Uuid().v1();
    // print(loggedInuserId.runtimeType);
    // print(isBusinessOpen);
    final Map<String, dynamic> buildMap = {
      'id': id, //to know the id of this user
      'table': AppTables.drawerHistories,
      'name': name,
      'openingHour': false, //we start in closing mode.
      'cashierName': ProxyService.sharedState.user.name,
      'openingFloat': 0.0,
      'closingFloat': 0.0,
      'displayText': 'null',
      'isSocial': false,
      'businessId': businessId,
      'channels': [loggedInuserId],
      'createdAt': DateTime.now().toIso8601String(),
    };
    _databaseService.insert(id: id, data: buildMap);
  }
}

Future<String> isUserCurrentlyLoggedIn(Store<AppState> store) async {
  final DatabaseService _databaseService = ProxyService.database;

  final String loggedInuserId = ProxyService.sharedPref.getUserId();

  if (loggedInuserId == null) {
    await _databaseService.login();
    return null;
  } else {
    final List<String> channels = [];
    //save user in firebase contacts if he does not exist

    channels.add(loggedInuserId);

    await _databaseService.login(channels: channels);

    //save a device token

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {
      'VALUE': AppTables.user,
    };

    final results = q.execute();

    if (results.isNotEmpty) {
      for (Map map in results) {
        map.forEach((key, value) async {
          if (value.containsKey('userId') &&
              loggedInuserId == FUser.fromMap(value).userId) {
            ProxyService.sharedState.setUser(user: FUser.fromMap(value));
            if (ProxyService.sharedState.user != null) {
              await ProxyService.firestore.addContacts({
                'phoneNumber': ProxyService.sharedState.user.name,
                'name': ProxyService.sharedState.user.name,
                'channels': [ProxyService.sharedState.user.id]
              });
            }
            store.dispatch(WithUser(user: FUser.fromMap(value)));
            try {
              saveDeviceToken(value);
              // ignore: empty_catches
            } catch (e) {}
          }
        });
      }
    }
    return loggedInuserId;
  }
}

Future saveDeviceToken(value) async {
  // final String token = await ProxyService.sharedPref.getToken();
  // await http.post('https://flipper.yegobox.com/save-token', body: {
  //   'phone': FUser.fromMap(value).name, // a name is a phone number in flipper!
  //   'token': token
  // }, headers: {
  //   'Content-Type': 'application/x-www-form-urlencoded',
  //   'Accept': 'application/json'
  // });
}

Future<List<Branch>> getBranches(
    Store<AppState> store, String loggedInuserId) async {
  final DatabaseService _databaseService = ProxyService.database;

  final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

  final List<Branch> branches = [];
  q.parameters = {
    'VALUE': AppTables.branch,
  };

  final results = q.execute();
  if (results.isNotEmpty) {
    for (Map map in results) {
      map.forEach((key, value) {
        branches.add(Branch.fromMap(value));
      });
    }
  }

  for (Branch branch in branches) {
    if (branch.active) {
      //set current active branch
      ProxyService.sharedState.setBranch(branch: branch);

      final bool weHaveCustomCategory = await isCategory(branchId: branch.id);

      if (!weHaveCustomCategory) {
        final String id = Uuid().v1();
        _databaseService.insert(id: id, data: {
          'active': true,
          'table': AppTables.category,
          'branchId': branch.id,
          'focused': true,
          'id': id,
          'channels': [loggedInuserId],
          'name': 'custom'
        });
      }
      store.dispatch(
        OnCurrentBranchAction(branch: branch),
      );
      //set branch hint
      final Hint hint = Hint((HintBuilder b) => b
        ..type = HintType.Branch
        ..name = branch.name);
      store.dispatch(OnHintLoaded(hint: hint));
    }
  }
  store.dispatch(OnBranchLoaded(branches: branches));
  return branches;
}

Future<bool> isCategory({String branchId}) async {
  final DatabaseService _databaseService = ProxyService.database;

  final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

  q.parameters = {
    'VALUE': AppTables.category,
  };

  return q.execute().isNotEmpty;
}

Future<void> createSystemStockReasons(Store<AppState> store) async {
  // FIXME:
  // final List<ReasonTableData> reasons =
  //     await store.state.database.reasonDao.getReasons();
  // if (reasons.isEmpty) {
  //   await store.state.database.reasonDao.insert(
  //       //ignore:missing_required_param
  //       ReasonTableData(name: 'Stock Received', action: 'Received'));
  //   await store.state.database.reasonDao
  //       //ignore:missing_required_param
  //       .insert(ReasonTableData(name: 'Lost', action: 'Lost'));
  //   await store.state.database.reasonDao
  //       //ignore:missing_required_param
  //       .insert(ReasonTableData(name: 'Thief', action: 'Thief'));
  //   await store.state.database.reasonDao
  //       //ignore:missing_required_param
  //       .insert(ReasonTableData(name: 'Damaged', action: 'Damaged'));
  //   await store.state.database.reasonDao.insert(
  //       //ignore:missing_required_param
  //       ReasonTableData(name: 'Inventory Re-counted', action: 'Re-counted'));
  //   await store.state.database.reasonDao.insert(
  //       //ignore:missing_required_param
  //       ReasonTableData(name: 'Restocked Return', action: 'Restocked Return'));
  //   await store.state.database.reasonDao
  //       //ignore:missing_required_param
  //       .insert(ReasonTableData(name: 'Sold', action: 'Sold'));
  //   await store.state.database.reasonDao.insert(
  //       //ignore:missing_required_param
  //       ReasonTableData(name: 'Transferred', action: 'Transferred'));

  //   await store.state.database.reasonDao
  //       //ignore:missing_required_param
  //       .insert(ReasonTableData(name: 'Canceled', action: 'Canceled'));
  // }
}

Future<void> createTemporalOrder(Store<AppState> store) async {
  if (store.state.branch == null) {
    return;
  }
  if (store.state.user.id == null) {
    return;
  }
  DataManager.createTemporalOrder(store);
}

Future<void> getBusinesses(
    {Store<AppState> store, String loggedInuserId}) async {
  // log.d(loggedInuserId);
  final DatabaseService _databaseService = ProxyService.database;

  final List<Business> businesses = [];

  final q = Query(
      _databaseService.db, 'SELECT * WHERE table=\$VALUE AND userId=\$USERID');

  q.parameters = {'VALUE': AppTables.business, 'USERID': loggedInuserId};

  final results = q.execute();
  if (results.isNotEmpty) {
    for (Map map in results) {
      map.forEach((key, value) {
        if (!businesses.contains(Business.fromMap(value))) {
          ProxyService.sharedState
              .setBusiness(business: Business.fromMap(value));
          openCloseBusiness(
            isSocial: false,
            name: ProxyService.sharedState.user.name,
            loggedInuserId: ProxyService.sharedState.user.id,
            isClosed: false,
            businessId: Business.fromMap(value).id,
          );
          businesses.add(Business.fromMap(value));
        }
      });
    }
  }

  await getBranches(store, loggedInuserId);
  await createTemporalOrder(store);

  for (Business business in businesses) {
    if (business.active) {
      ProxyService.sharedState.setBusiness(business: business);
      store.dispatch(
        ActiveBusinessAction(business),
      );
    }
  }

  final FlipperNavigationService _navigationService = ProxyService.nav;

  if (businesses.isEmpty) {
    if (loggedInuserId != null) {
      _navigationService.navigateTo(
        Routing.signUpView,
        arguments: SignUpViewArguments(
          userId: loggedInuserId,
          name: store.state.user.name,
          avatar: 'avatar',
          email: store.state.user.email,
          token: store.state.user.token,
        ),
      );
    } else {
      _navigationService.navigateTo(Routing.afterSplash);
    }
  } else if (loggedInuserId == null) {
    _navigationService.navigateTo(Routing.afterSplash);
  } else {
    store.dispatch(OnBusinessLoaded(business: businesses));
    _navigationService.navigateTo(Routing.dashboard);
  }
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogout(
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (store, action, next) async {
    next(action);
    try {
      // await userRepository.logOut(store);
      store.dispatch(OnLogoutSuccess());
    } catch (e) {
      // Logger.w('Failed logout', e: e);
      // store.dispatch(OnLogoutFail(e));
    }
  };
}
