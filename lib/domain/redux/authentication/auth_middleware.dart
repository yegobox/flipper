import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';

import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/model/pcolor.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/utils/data_manager.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
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

    final FlipperNavigationService _navigationService = ProxyService.nav;

    final String userId = await isUserCurrentlyLoggedIn(store);
    if (userId == null) {
      _navigationService.navigateTo(Routing.afterSplash);
      return;
    }

    await getBusinesses(store: store, userId: userId);
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
  String userId,
  String name,
  bool isSocial = false,
  String businessId,
  bool isClosed = true,
}) async {
  final DatabaseService _databaseService = ProxyService.database;
  final openDrawer = _databaseService.getById(id: null);

  final Map<String, dynamic> buildMap = {
    'table': AppTables.switchi,
    'name': name,
    'isClosed': isClosed,
    'isSocial': isSocial,
    'businessId': businessId,
    'channels': [userId]
  };
  if (openDrawer == null) {
    try {
      // final MutableDocument newDoc =
      //     MutableDocument(id: userId, data: buildMap);
      // await CoreDB.instance.database.saveDocument(newDoc);
      // ignore: empty_catches
    } on PlatformException {}
  } else {
    // final MutableDocument mutableDoc =
    //     document.toMutable().setBoolean('isClosed', isClosed);
    // CoreDB.instance.database.saveDocument(mutableDoc);
  }
}

Future<String> isUserCurrentlyLoggedIn(Store<AppState> store) async {
  final DatabaseService _databaseService = ProxyService.database;
  final Logger log = Logging.getLogger('Get User: ');
  final String userExist = await ProxyService.sharedPref.getUserId();
  if (userExist == null) {
    await _databaseService.login();
    return null;
  } else {
    final List<String> channels = [];

    channels.add(userExist);

    await _databaseService.login(channels: channels);

    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {
      'VALUE': AppTables.user,
    };

    final results = q.execute();

    if (results.isNotEmpty) {
      for (Map map in results) {
        map.forEach((key, value) {
          // FIXME(richard): fix bellow code.
          // openCloseBusiness(
          //   isSocial: false,
          //   name: FUser.fromMap(value).name,
          //   userId: FUser.fromMap(value).id.toString(),
          //   isClosed: true,
          // );
          ProxyService.sharedState.setUser(user: FUser.fromMap(value));
          log.d(FUser.fromMap(value));
          store.dispatch(WithUser(user: FUser.fromMap(value)));
        });
      }
    }

    return userExist;
  }
}

Future<List<Branch>> getBranches(Store<AppState> store, String userId) async {
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
          'channels': [userId],
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

Future<void> getBusinesses({Store<AppState> store, String userId}) async {
  final Logger log = Logging.getLogger('Get business: ');
  // log.d(userId);
  final DatabaseService _databaseService = ProxyService.database;

  final List<Business> businesses = [];

  final q = Query(
      _databaseService.db, 'SELECT * WHERE table=\$VALUE AND userId=\$USERID');

  q.parameters = {'VALUE': AppTables.business, 'USERID': userId};

  final results = q.execute();
  if (results.isNotEmpty) {
    for (Map map in results) {
      map.forEach((key, value) {
        businesses.add(Business.fromMap(value));
      });
    }
  }

  await getBranches(store, userId);
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
    if (userId != null) {
      _navigationService.navigateTo(
        Routing.signUpView,
        arguments: SignUpViewArguments(
          userId: userId,
          name: store.state.user.name,
          avatar: 'avatar',
          email: store.state.user.email,
          token: store.state.user.token,
        ),
      );
    } else {
      _navigationService.navigateTo(Routing.afterSplash);
    }
  } else if (userId == null) {
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

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogin(
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);
  };
}
