// import 'package:background_fetch/background_fetch.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/branch_repository.dart';
import 'package:flipper/data/respositories/business_repository.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/data/respositories/user_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/helper/constant.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../app_state.dart';
import 'auth_actions.dart';

List<Middleware<AppState>> createAuthenticationMiddleware(
  UserRepository userRepository,
  BusinessRepository businessRepository,
  BranchRepository branchRepository,
  GeneralRepository generalRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, VerifyAuthenticationState>(_verifyAuthState(
        userRepository,
        businessRepository,
        branchRepository,
        generalRepository,
        navigatorKey)),
    TypedMiddleware<AppState, LogIn>(_authLogin(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogOutAction>(
        _authLogout(userRepository, navigatorKey)),
    TypedMiddleware<AppState, AfterLoginAction>(_verifyAuthState(userRepository,
        businessRepository, branchRepository, generalRepository, navigatorKey)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _verifyAuthState(
  UserRepository userRepository,
  BusinessRepository businessRepository,
  BranchRepository branchRepository,
  GeneralRepository generalRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);

    final FlipperNavigationService _navigationService =
        locator<FlipperNavigationService>();

    final bool isLoggedIn = await isUserCurrentlyLoggedIn(store);
    if (!isLoggedIn) {
      _navigationService.navigateTo(Routing.afterSplash);
      return;
    }
    final TabsTableData tab = await generalRepository.getTab(store);
    dispatchFocusedTab(tab, store);

    await getBusinesses(store, generalRepository);
    await generateAppColors(generalRepository, store);
    await createAppActions(store);
    // ignore: always_specify_types

    await DataManager.createTempProduct(store, 'custom-product');
    _getCurrentLocation(store: store);
  };
}

Future<bool> isUserCurrentlyLoggedIn(Store<AppState> store) async {
  final UserTableData user = await store.state.database.userDao.getUser();
  final DatabaseService _databaseService = locator<DatabaseService>();
  if (user != null) {
    //login to couchbase
    // ignore: always_specify_types
    final List<String> channels = [];
    channels.add(user.id.toString());

    await AppDatabase.instance.login(channels: channels);

    // start with business closed.
    await _databaseService.openCloseBusiness(
        isSocial: false,
        name: user.username,
        userId: user.id.toString(),
        isClosed: true);

    final FUser u = FUser(
      (FUserBuilder p) => p
        ..email = user.email
        ..active = true
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String()
        ..token = user.token
        ..name = user.username,
    );
    store.dispatch(WithUser(user: u));
    store.dispatch(UserID(userId: user.userId));
    return true;
  }

  return false;
}

Future<void> _getCurrentLocation({Store<AppState> store}) async {
  final Geolocator geoLocator = Geolocator();
  const LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  if (store.state.currentActiveBusiness == null) {
    return;
  }
  final BusinessTableData businessTableData = await store
      .state.database.businessDao
      .getBusinesById(id: store.state.currentActiveBusiness.id);
  geoLocator
      .getPositionStream(locationOptions)
      .listen((Position location) async {
    //time to update data....
    if (businessTableData != null) {
      await store.state.database.businessDao.updateBusiness(
          businessTableData.copyWith(
              idLocal: businessTableData.idLocal,
              longitude: location.longitude,
              latitude: location.latitude));
    }
  });
}

Future<List<Branch>> getBranches(
    Store<AppState> store, GeneralRepository generalRepository) async {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final List<Map<String, dynamic>> branche = await _databaseService.filter(
    equator: AppTables.branch + store.state.userId.toString(),
    property: 'tableName',
  );
  List<Branch> branches =[];
  if(branche.isNotEmpty){
    // ignore: unnecessary_type_check
    if(branche[0][AppDatabase.instance.dbName] is Object){
      branches.add(Branch.fromMap(branche[0][AppDatabase.instance.dbName]));
    }else{
       branches =
      branche[0][AppDatabase.instance.dbName].map((e) => Branch.fromMap(e)).toList();
    }
  }
 
  for (Branch branch in branches) {
    if (branch.active) {
      //set current active branch
      final bool weHaveCustomCategory = await isCategory(branchId: branch.id);
      if(!weHaveCustomCategory){
        final String id = Uuid().v1();
        _databaseService.insert(id: id,data:{'tableName': AppTables.category+branch.id,'id':id, 'channels':[store.state.userId.toString()], 'name':'custom'});
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
Future<bool> isCategory({String branchId})async{
  final DatabaseService _databaseService = locator<DatabaseService>();
   final List<Map<String, dynamic>> category = await _databaseService.filter(
        equator: 'custom',
        property: 'name',
        and: true,
        andProperty: 'tableName',
        andEquator: AppTables.category + branchId,
      );
    return category.isNotEmpty;
}

void dispatchFocusedTab(TabsTableData tab, Store<AppState> store) {
  final int currentTab = tab == null ? 0 : tab.tab;
  store.dispatch(
    CurrentTab(tab: currentTab),
  );
}

Future<void> generateAppColors(
    GeneralRepository generalRepository, Store<AppState> store) async {
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
  for (int i = 0; i < 8; i++) {
    //create default color items if does not exist
    await generalRepository.insertOrUpdateColor(
        store,
        //ignore: missing_required_param
        ColorTableData(isActive: false, name: colors[i]));
  }
}

Future<void> createSystemStockReasons(Store<AppState> store) async {
  final List<ReasonTableData> reasons =
      await store.state.database.reasonDao.getReasons();
  if (reasons.isEmpty) {
    await store.state.database.reasonDao.insert(
        //ignore:missing_required_param
        ReasonTableData(name: 'Stock Received', action: 'Received'));
    await store.state.database.reasonDao
        //ignore:missing_required_param
        .insert(ReasonTableData(name: 'Lost', action: 'Lost'));
    await store.state.database.reasonDao
        //ignore:missing_required_param
        .insert(ReasonTableData(name: 'Thief', action: 'Thief'));
    await store.state.database.reasonDao
        //ignore:missing_required_param
        .insert(ReasonTableData(name: 'Damaged', action: 'Damaged'));
    await store.state.database.reasonDao.insert(
        //ignore:missing_required_param
        ReasonTableData(name: 'Inventory Re-counted', action: 'Re-counted'));
    await store.state.database.reasonDao.insert(
        //ignore:missing_required_param
        ReasonTableData(name: 'Restocked Return', action: 'Restocked Return'));
    await store.state.database.reasonDao
        //ignore:missing_required_param
        .insert(ReasonTableData(name: 'Sold', action: 'Sold'));
    await store.state.database.reasonDao.insert(
        //ignore:missing_required_param
        ReasonTableData(name: 'Transferred', action: 'Transferred'));

    await store.state.database.reasonDao
        //ignore:missing_required_param
        .insert(ReasonTableData(name: 'Canceled', action: 'Canceled'));
  }
}

Future<void> createAppActions(Store<AppState> store) async {
  final ActionsTableData actionAction =
      await store.state.database.actionsDao.getActionBy('save');

  final ActionsTableData saveItem =
      await store.state.database.actionsDao.getActionBy('saveItem');
  if (saveItem == null) {
    await store.state.database.actionsDao.insert(
        //ignore:missing_required_param
        ActionsTableData(name: 'saveItem', isLocked: true));
  }
  if (actionAction == null) {
    await store.state.database.actionsDao.insert(
        //ignore:missing_required_param
        ActionsTableData(name: 'save', isLocked: true));
  }
}

Future<void> createTemporalOrder(
    GeneralRepository generalRepository, Store<AppState> store) async {
  if (store.state.branch == null) {
    return;
  }
  if (store.state.userId == null) {
    return;
  }
  DataManager.createTemporalOrder(generalRepository, store);
}

Future<void> getBusinesses(
    Store<AppState> store, GeneralRepository generalRepository) async {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final List<Map<String, dynamic>> business = await _databaseService.filter(
    equator: AppTables.business + store.state.userId.toString(),
    property: 'tableName',
  );
  
  // ignore: always_specify_types
  List<Business> businesses =[];
  final Logger log = Logging.getLogger('DDD ....');
  if(business.isNotEmpty){
    log.d(business[0][AppDatabase.instance.dbName]);

    // ignore: unnecessary_type_check
    if( business[0][AppDatabase.instance.dbName] is Object){ //one business
       businesses.add( Business.fromMap(business[0][AppDatabase.instance.dbName]));
    }else{//in case a user have more than one business this use case is not yet supported
      businesses =
      business[0][AppDatabase.instance.dbName].map((e) => Business.fromMap(e)).toList();
    }  
  }
 
  await getBranches(store, generalRepository);
  await createTemporalOrder(generalRepository, store);

  for (Business business in businesses) {
    if (business.active) {
      store.dispatch(
        ActiveBusinessAction(business),
      );
    }
  }

  final FlipperNavigationService _navigationService =
      locator<FlipperNavigationService>();

  if (businesses.isEmpty) {
    if (store.state.user != null) {
      _navigationService.navigateTo(
        Routing.signUpScreen,
        arguments: SignUpScreenArguments(
          name: store.state.user.name,
          avatar: 'avatar',
          email: store.state.user.email,
          token: store.state.user.token,
        ),
      );
    } else {
      _navigationService.navigateTo(Routing.afterSplash);
    }
  } else if (store.state.userId == null) {
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
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.logOut(store);
      store.dispatch(OnLogoutSuccess());
    } catch (e) {
      // Logger.w('Failed logout', e: e);
      store.dispatch(OnLogoutFail(e));
    }
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogin(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    next(action);
  };
}
