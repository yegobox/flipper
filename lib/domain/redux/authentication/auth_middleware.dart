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
import 'package:flipper/locator.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

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

    final FlipperNavigationService _navigationService = locator<FlipperNavigationService>();

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
    await DataManager.createTempProduct(store, 'custom-product');
    _getCurrentLocation(store: store);

    await AppDatabase.instance.syncRemoteToLocal(store: store);

    AppDatabase.instance.dbListner(store: store);
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
    await _databaseService.openCloseBusiness(isSocial: false,name: user.username,userId: user.id.toString(),isClosed:true);
    
  
    
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
  final List<Branch> branches = await AppDatabase.instance.getDocumentByFilter(
      filter: 'branches_' + store.state.userId.toString(),
      store: store,
      T: Branch);

  for (int i = 0; i < branches.length; i++) {
    if (branches[i].active) {
      //set current active branch
      store.dispatch(
        OnCurrentBranchAction(
          branch: Branch((BranchBuilder b) => b
            ..name = branches[i].name
            ..id = branches[i].id
            ..active = branches[i].active
            ..businessId = branches[i].businessId
            ..createdAt = branches[i].createdAt
            ..mapLatitude = branches[i].mapLatitude
            ..mapLongitude = branches[i].mapLongitude
            ..mapLongitude = branches[i].mapLongitude
            ..updatedAt = branches[i].updatedAt),
        ),
      );
      //set branch hint
      final Hint hint = Hint((HintBuilder b) => b
        ..type = HintType.Branch
        ..name = branches[i].name);
      store.dispatch(OnHintLoaded(hint: hint));
    }
  }
  store.dispatch(OnBranchLoaded(branches: branches));
  return branches;
}

List<Category> loadSystemCategories(List<CategoryTableData> categoryList) {
  final List<Category> categories = [];
  // ignore: avoid_function_literals_in_foreach_calls
  categoryList.forEach((CategoryTableData c) => {
        categories.add(
          Category(
            (CategoryBuilder u) => u
              ..name = c.name
              ..focused = c.focused
              ..branchId = u.branchId ?? 0
              ..id = c.id,
          ),
        )
      });
  return categories;
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
  final List<Business> businesses = await AppDatabase.instance
      .getDocumentByFilter(
          filter: 'business_' + store.state.userId.toString(),
          store: store,
          T: Business);

  await getBranches(store, generalRepository);
  await createTemporalOrder(generalRepository, store);

  for (int i = 0; i < businesses.length; i++) {
    if (businesses[i].active) {
     
      store.dispatch(
        ActiveBusinessAction(
          Business(
            (BusinessBuilder b) => b
              ..id = businesses[i].id
              ..currency = businesses[i].currency
              ..typeId = businesses[i].typeId
              ..categoryId = businesses[i].categoryId
              ..active = businesses[i].active
              ..name = businesses[i].name
              ..type = BusinessType.NORMAL
              ..hexColor = FlipperColors.defaultBusinessColor
              ..image = 'image_null',
          ),
        ),
      );
    }
  }

  final FlipperNavigationService _navigationService = locator<FlipperNavigationService>();

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
