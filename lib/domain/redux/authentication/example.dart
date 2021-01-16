// import 'package:flipper/core_db.dart';
// import 'package:flipper/data/main_database.dart';

// import 'package:flipper/data/respositories/general_repository.dart';
// import 'package:flipper/data/respositories/user_repository.dart';
// import 'package:flipper/domain/redux/branch/branch_actions.dart';
// import 'package:flipper/domain/redux/business/business_actions.dart';
// import 'package:flipper/domain/redux/user/user_actions.dart';
// import 'package:flipper_services/locator.dart';
// import 'package:flipper/services/shared_state_service.dart';
// import 'package:flipper/utils/constant.dart';
// import 'package:flipper_services/locator.dart';
// import 'package:flipper_models/branch.dart';
// import 'package:flipper_models/business.dart';
// import 'package:flipper_models/fuser.dart';
// import 'package:flipper_models/hint.dart';
// import 'package:flipper/routes/router.gr.dart';
// import 'package:flipper_services/database_service.dart';
// import 'package:flipper_services/flipperNavigation_service.dart';
// import 'package:flipper/utils/data_manager.dart';
// import 'package:flipper/utils/logger.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:logger/logger.dart';
// import 'package:redux/redux.dart';
// import 'package:uuid/uuid.dart';
// import 'package:couchbase_lite/couchbase_lite.dart';
// import '../app_state.dart';
// import 'auth_actions.dart';

// List<Middleware<AppState>> createAuthenticationMiddleware(
//   UserRepository userRepository,
//   GeneralRepository generalRepository,
//   GlobalKey<NavigatorState> navigatorKey,
// ) {
//   return [
//     TypedMiddleware<AppState, VerifyAuthenticationState>(
//         _verifyAuthState(userRepository, generalRepository, navigatorKey)),
//     TypedMiddleware<AppState, LogIn>(_authLogin(userRepository, navigatorKey)),
//     TypedMiddleware<AppState, LogOutAction>(
//         _authLogout(userRepository, navigatorKey)),
//     TypedMiddleware<AppState, AfterLoginAction>(
//         _verifyAuthState(userRepository, generalRepository, navigatorKey)),
//   ];
// }

// void Function(Store<AppState> store, dynamic action, NextDispatcher next)
//     _verifyAuthState(
//   UserRepository userRepository,
//   GeneralRepository generalRepository,
//   GlobalKey<NavigatorState> navigatorKey,
// ) {
//   // ignore: always_specify_types
//   return (Store<AppState> store, action, next) async {
//     next(action);

//     final FlipperNavigationService _navigationService = ProxyService.nav;

//     final bool isLoggedIn = await isUserCurrentlyLoggedIn(store);
//     if (!isLoggedIn) {
//       _navigationService.navigateTo(Routing.afterSplash);
//       return;
//     }

//     CoreDB.instance.initialAppData();
//     await getBusinesses(store, generalRepository);
//     await generateAppColors(store);

//     await ProxyService.sharedPref.setIsAppConstantsInitialized();
//     // ignore: always_specify_types

//     if (store.state.user.id != null &&
//         store.state.currentActiveBusiness != null) {
//       // await DataManager.createTempProduct(
//       //     store: store, userId: store.state.user.id, productName: 'tmp');
//       _getCurrentLocation(store: store);
//     }
//   };
// }

// Future<void> openCloseBusiness({
//   String userId,
//   String name,
//   bool isSocial = false,
//   String businessId,
//   bool isClosed = true,
// }) async {
//   final Document document = await CoreDB.instance.database.document(userId);

//   final Map<String, dynamic> buildMap = {
//     'table': AppTables.switchi,
//     'name': name,
//     'isClosed': isClosed,
//     'isSocial': isSocial,
//     'businessId': businessId,
//     'channels': [userId]
//   };
//   if (document == null) {
//     try {
//       final MutableDocument newDoc =
//           MutableDocument(id: userId, data: buildMap);
//       await CoreDB.instance.database.saveDocument(newDoc);
//       // ignore: empty_catches
//     } on PlatformException {}
//   } else {
//     final MutableDocument mutableDoc =
//         document.toMutable().setBoolean('isClosed', isClosed);
//     CoreDB.instance.database.saveDocument(mutableDoc);
//   }
// }

// Future<bool> isUserCurrentlyLoggedIn(Store<AppState> store) async {
//   final UserTableData user = await store.state.database.userDao.getUser();
//   if (user != null) {
//     final Logger log = Logging.getLogger('Current User: ....');

//     //login to couchbase
//     // ignore: always_specify_types
//     final List<String> channels = [];
//     channels.add(user.userId.toString());
//      log.d(user.userId.toString());
//     await CoreDB.instance.login(channels: channels);

//     // start with business closed.
//     await openCloseBusiness(
//       isSocial: false,
//       name: user.username,
//       userId: user.userId.toString(),
//       isClosed: true,
//     );

//     final FUser u = FUser(
//       (FUserBuilder p) => p
//         ..email = user.email
//         ..active = true
//         ..id = user.userId.toString()
//         ..createdAt = DateTime.now().toIso8601String()
//         ..updatedAt = DateTime.now().toIso8601String()
//         ..token = user.token
//         ..name = user.username,
//     );
//     store.dispatch(WithUser(user: u));
//     return true;
//   }

//   return false;
// }

// Future<void> _getCurrentLocation({Store<AppState> store}) async {
//   final Geolocator geoLocator = Geolocator();
//   const LocationOptions locationOptions =
//       LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

//   if (store.state.currentActiveBusiness == null) {
//     return;
//   }
//   // FIXME:
//   // final BusinessTableData businessTableData = await store
//   //     .state.database.businessDao
//   //     .getBusinesById(id: store.state.currentActiveBusiness.id);
//   // geoLocator
//   //     .getPositionStream(locationOptions)
//   //     .listen((Position location) async {

//   //   if (businessTableData != null) {
//   //     await store.state.database.businessDao.updateBusiness(
//   //         businessTableData.copyWith(
//   //             idLocal: businessTableData.idLocal,
//   //             longitude: location.longitude,
//   //             latitude: location.latitude));
//   //   }
//   // });
// }

// Future<List<Branch>> getBranches(
//     Store<AppState> store, GeneralRepository generalRepository) async {
//   final DatabaseService _databaseService = ProxyService.database;
//   final List<Map<String, dynamic>> branche = await _databaseService.filter(
//     equator: AppTables.branch,
//     property: 'table',
//   );
//   List<Branch> branches = [];
//   if (branche.isNotEmpty) {
//     // ignore: unnecessary_type_check
//     if (branche[0][CoreDB.instance.dbName] is Object) {
//       final _sharedStateService = locator<SharedStateService>();
//       _sharedStateService.setBranch(branch: Branch.fromMap(branche[0][CoreDB.instance.dbName]));
//       branches.add(Branch.fromMap(branche[0][CoreDB.instance.dbName]));
//     } else {
//       branches = branche[0][CoreDB.instance.dbName]
//           .map((e) => Branch.fromMap(e))
//           .toList();
//     }
//   }

//   for (Branch branch in branches) {
//     if (branch.active) {
//       //set current active branch
//       final bool weHaveCustomCategory = await isCategory(branchId: branch.id);
//       if (!weHaveCustomCategory) {
//         final String id = Uuid().v1();
//         _databaseService.insert(id: id, data: {
//           'table': AppTables.category,
//           'id': id,
//           'channels': [store.state.user.id.toString()],
//           'name': 'custom'
//         });
//       }
//       store.dispatch(
//         OnCurrentBranchAction(branch: branch),
//       );
//       //set branch hint
//       final Hint hint = Hint((HintBuilder b) => b
//         ..type = HintType.Branch
//         ..name = branch.name);
//       store.dispatch(OnHintLoaded(hint: hint));
//     }
//   }
//   store.dispatch(OnBranchLoaded(branches: branches));
//   return branches;
// }

// Future<bool> isCategory({String branchId}) async {
//   final DatabaseService _databaseService = ProxyService.database;
//   final List<Map<String, dynamic>> category = await _databaseService.filter(
//     equator: 'custom',
//     property: 'name',
//     and: true,
//     andProperty: 'table',
//     andEquator: AppTables.category,
//   );
//   return category.isNotEmpty;
// }

// Future<void> generateAppColors(Store<AppState> store) async {
//   final bool isAppConstantsInitialized =
//       await ProxyService.sharedPref.isAppConstantsInitialized();
//   if (!isAppConstantsInitialized) {
//     final List<String> colors = [
//       '#d63031',
//       '#0984e3',
//       '#e84393',
//       '#2d3436',
//       '#6c5ce7',
//       '#74b9ff',
//       '#ff7675',
//       '#a29bfe'
//     ];
//     //insert default colors for the app
//     final DatabaseService _databaseService = ProxyService.database;
//     for (int i = 0; i < colors.length; i++) {
//       _databaseService.insert(data: {
//         'name': colors[i],
//         'isActive': false,
//         'channels': [store.state.user.id.toString()],
//         'table': AppTables.color
//       });
//     }
//   }
// }

// Future<void> createSystemStockReasons(Store<AppState> store) async {
//   // FIXME:
//   // final List<ReasonTableData> reasons =
//   //     await store.state.database.reasonDao.getReasons();
//   // if (reasons.isEmpty) {
//   //   await store.state.database.reasonDao.insert(
//   //       //ignore:missing_required_param
//   //       ReasonTableData(name: 'Stock Received', action: 'Received'));
//   //   await store.state.database.reasonDao
//   //       //ignore:missing_required_param
//   //       .insert(ReasonTableData(name: 'Lost', action: 'Lost'));
//   //   await store.state.database.reasonDao
//   //       //ignore:missing_required_param
//   //       .insert(ReasonTableData(name: 'Thief', action: 'Thief'));
//   //   await store.state.database.reasonDao
//   //       //ignore:missing_required_param
//   //       .insert(ReasonTableData(name: 'Damaged', action: 'Damaged'));
//   //   await store.state.database.reasonDao.insert(
//   //       //ignore:missing_required_param
//   //       ReasonTableData(name: 'Inventory Re-counted', action: 'Re-counted'));
//   //   await store.state.database.reasonDao.insert(
//   //       //ignore:missing_required_param
//   //       ReasonTableData(name: 'Restocked Return', action: 'Restocked Return'));
//   //   await store.state.database.reasonDao
//   //       //ignore:missing_required_param
//   //       .insert(ReasonTableData(name: 'Sold', action: 'Sold'));
//   //   await store.state.database.reasonDao.insert(
//   //       //ignore:missing_required_param
//   //       ReasonTableData(name: 'Transferred', action: 'Transferred'));

//   //   await store.state.database.reasonDao
//   //       //ignore:missing_required_param
//   //       .insert(ReasonTableData(name: 'Canceled', action: 'Canceled'));
//   // }
// }

// Future<void> createTemporalOrder(
//     GeneralRepository generalRepository, Store<AppState> store) async {
//   if (store.state.branch == null) {
//     return;
//   }
//   if (store.state.user.id == null) {
//     return;
//   }
//   DataManager.createTemporalOrder(generalRepository, store);
// }

// Future<void> getBusinesses(
//     Store<AppState> store, GeneralRepository generalRepository) async {
//   final Logger log = Logging.getLogger('Get business: ');
//   // log.d(store.state.user.id);
//   final DatabaseService _databaseService = ProxyService.database;

//   final List<Map<String, dynamic>> doc = await _databaseService.filter(
//     equator: AppTables.business,
//     property: 'table',
//     and: true, //define that this query is and type.
//     andEquator: store.state.user.id,
//     andProperty: 'userId',
//   );

//   // ignore: always_specify_types
//   final List<Business> businesses = [];

//   if (doc.isNotEmpty) {
//     //this asume that one user has one business
//     log.i(doc[0]['main']);
//     final _sharedStateService = locator<SharedStateService>();
//     _sharedStateService.setBusiness(business: Business.fromMap(doc[0]['main']));
//     businesses.add(Business.fromMap(doc[0]['main']));
//   }
//   log.i(businesses);
//   await getBranches(store, generalRepository);
//   await createTemporalOrder(generalRepository, store);

//   for (Business business in businesses) {
//     if (business.active) {
//       store.dispatch(
//         ActiveBusinessAction(business),
//       );
//     }
//   }

//   final FlipperNavigationService _navigationService = ProxyService.nav;

//   if (businesses.isEmpty) {
//     if (store.state.user != null) {
//       _navigationService.navigateTo(
//         Routing.signUpView,
//         arguments: SignUpViewArguments(
//           userId: store.state.user.id,
//           name: store.state.user.name,
//           avatar: 'avatar',
//           email: store.state.user.email,
//           token: store.state.user.token,
//         ),
//       );
//     } else {
//       _navigationService.navigateTo(Routing.afterSplash);
//     }
//   } else if (store.state.user.id == null) {
//     _navigationService.navigateTo(Routing.afterSplash);
//   } else {
//     store.dispatch(OnBusinessLoaded(business: businesses));
//     _navigationService.navigateTo(Routing.dashboard);
//   }
// }

// void Function(
//   Store<AppState> store,
//   dynamic action,
//   NextDispatcher next,
// ) _authLogout(
//   UserRepository userRepository,
//   GlobalKey<NavigatorState> navigatorKey,
// ) {
//   // ignore: always_specify_types
//   return (store, action, next) async {
//     next(action);
//     try {
//       await userRepository.logOut(store);
//       store.dispatch(OnLogoutSuccess());
//     } catch (e) {
//       // Logger.w('Failed logout', e: e);
//       store.dispatch(OnLogoutFail(e));
//     }
//   };
// }

// void Function(
//   Store<AppState> store,
//   dynamic action,
//   NextDispatcher next,
// ) _authLogin(
//   UserRepository userRepository,
//   GlobalKey<NavigatorState> navigatorKey,
// ) {
//   // ignore: always_specify_types
//   return (Store<AppState> store, action, next) async {
//     next(action);
//   };
// }
