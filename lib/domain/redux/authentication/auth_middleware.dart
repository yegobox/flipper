import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/respositories/branch_repository.dart';
import 'package:flipper/data/respositories/business_repository.dart';
import 'package:flipper/data/respositories/general_repository.dart';
import 'package:flipper/data/respositories/user_repository.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/branch/branch_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flipper/util/logger.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:redux/redux.dart";

import '../app_state.dart';
import 'auth_actions.dart';

/// Authentication Middleware
/// LogIn: Logging user in
/// LogOut: Logging user out
/// VerifyAuthenticationState: Verify if user is logged in

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
  return (store, action, next) async {
    next(action);

    loadClientDb(store);
    TabsTableData tab = await generalRepository.getTab(store);
    dispatchFocusedTab(tab, store);
    //todo: implement token based auth if  user is logging via token
    await store.state.couch.initSqlDb(store);
    await getBusinesses(store, generalRepository);
    await generateAppColors(generalRepository, store);
    await createAppActions(store);
  };
}

Future<List<Branch>> getBranches(
    Store<AppState> store, GeneralRepository generalRepository) async {
  List<Branch> branches = await CouchBase(shouldInitDb: false)
      .getDocumentByDocId(
          docId: 'branches_' + store.state.userId.toString(),
          store: store,
          T: Branch);

  for (var i = 0; i < branches.length; i++) {
    if (branches[i].active) {
      //set current active branch
      store.dispatch(
        OnCurrentBranchAction(
          branch: Branch((b) => b
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
      Hint hint = Hint((b) => b
        ..type = HintType.Branch
        ..name = branches[i].name);
      store.dispatch(OnHintLoaded(hint: hint));
    }
  }
  store.dispatch(OnBranchLoaded(branches: branches));
  return branches;
}

List<Unit> buildUnitList(List<UnitTableData> unitsList) {
  List<Unit> units = [];
  unitsList.forEach((b) => {
        units.add(Unit((u) => u
          ..name = b.name
          ..branchId =
              1 //todo: put default now, discuss more if we still need referencing as we are now in noSQL
          ..businessId = 1
          ..focused = b.focused
          ..id = b.id))
      });
  return units;
}

List<Category> loadSystemCategories(List<CategoryTableData> categoryList) {
  List<Category> categories = [];
  categoryList.forEach((c) => {
        categories.add(
          Category(
            (u) => u
              ..name = c.name
              ..focused = c.focused
              ..branchId = u.branchId ?? 0
              ..id = c.id,
          ),
        )
      });
  return categories;
}

Future createSystemCustomCategory(
    GeneralRepository generalRepository, Store<AppState> store) async {
//  if (store.state.branch == null) return;
//  await generalRepository.insertCustomCategory(
//    store,
//    //ignore: missing_required_param
//    CategoryTableData(
//        branchId: store.state.branch.id, focused: false, name: 'custom'),
//  );
}

void dispatchFocusedTab(TabsTableData tab, Store<AppState> store) {
  final currentTab = tab == null ? 0 : tab.tab;
  store.dispatch(
    CurrentTab(tab: currentTab),
  );
}

Future generateAppColors(
    GeneralRepository generalRepository, Store<AppState> store) async {
  List<String> colors = [
    "#d63031",
    "#0984e3",
    "#e84393",
    "#2d3436",
    "#6c5ce7",
    "#74b9ff",
    "#ff7675",
    "#a29bfe"
  ];
  //insert default colors for the app
  for (var i = 0; i < 8; i++) {
    //create default color items if does not exist
    await generalRepository.insertOrUpdateColor(
        store,
        //ignore: missing_required_param
        ColorTableData(isActive: false, name: colors[i]));
  }
}

Future createSystemStockReasons(Store<AppState> store) async {
  List<ReasonTableData> reasons =
      await store.state.database.reasonDao.getReasons();
  if (reasons.length == 0) {
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

Future createAppActions(Store<AppState> store) async {
  ActionsTableData actionAction =
      await store.state.database.actionsDao.getActionBy('save');

  ActionsTableData saveItem =
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

Future createTemporalOrder(
    GeneralRepository generalRepository, Store<AppState> store) async {
  if (store.state.branch == null) return;
  if (store.state.userId == null) return;
  OrderTableData order =
      await generalRepository.createDraftOrderOrReturnExistingOne(store);
  //broadcast order to be used later when creating a sale
  if (order != null) {
    store.dispatch(
      OrderCreated(
        order: Order(
          (o) => o
            ..status = order.status
            ..id = order.id
            ..userId = store.state.userId
            ..branchId = order.branchId
            ..orderNote = order.orderNote
            ..orderNUmber = order.orderNUmber
            ..supplierId = order.supplierId
            ..subTotal = order.subTotal
            ..discountAmount = order.discountAmount
            ..supplierInvoiceNumber = order.supplierInvoiceNumber
            ..deliverDate = order.deliverDate
            ..discountRate = order.discountRate
            ..taxRate = order.taxRate
            ..taxAmount = order.taxAmount
            ..cashReceived = order.cashReceived
            ..saleTotal = order.saleTotal
            ..userId = order.userId
            ..customerSaving = order.customerSaving
            ..paymentId = order.paymentId
            ..orderNote = order.orderNote
            ..status = order.status
            ..customerChangeDue = order.customerChangeDue,
        ),
      ),
    );
  }
}

Future getBusinesses(
    Store<AppState> store, GeneralRepository generalRepository) async {
  List<Business> businesses = await CouchBase(shouldInitDb: false)
      .getDocumentByDocId(
          docId: 'business_' + store.state.userId.toString(),
          store: store,
          T: Business);

  await getBranches(store, generalRepository);
  await createTemporalOrder(generalRepository, store);

  for (var i = 0; i < businesses.length; i++) {
    if (businesses[i].active) {
      store.dispatch(
        ActiveBusinessAction(
          Business(
            (b) => b
              ..id = businesses[i].id
              ..currency = businesses[i].currency
              ..typeId = businesses[i].typeId
              ..categoryId = businesses[i].categoryId
              ..active = businesses[i].active
              ..name = businesses[i].name
              ..type = BusinessType.NORMAL
              ..hexColor = FlipperColors.defaultBusinessColor
              ..image = "image_null",
          ),
        ),
      );
    }
  }

  if (businesses.length == 0) {
    Router.navigator.pushNamed(Router.afterSplash);
  } else if (store.state.userId == null) {
    Router.navigator.pushNamed(Router.afterSplash);
  } else {
    store.dispatch(OnBusinessLoaded(business: businesses));
    Router.navigator.pushNamed(Router.dashboard);
  }
}

void loadClientDb(Store<AppState> store) {
  //todo: load db from sqlite.
  store.dispatch(OnDbLoaded(name: 'lagrace'));
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogout(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.logOut();
      store.dispatch(OnLogoutSuccess());
    } catch (e) {
      Logger.w("Failed logout", e: e);
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
  return (store, action, next) async {
    next(action);
  };
}
