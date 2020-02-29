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
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/item.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/user.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flipper/util/logger.dart';
import 'package:flipper/util/util.dart';
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
    if (userRepository.checkAuth(store) == null) {
      Router.navigator.pushNamed(Router.afterSplash);
      store.dispatch(Unauthenticated);
      return;
    }
    loadClientDb(store);

    TabsTableData tab = await generalRepository.getTab(store);

    List<ItemTableData> items = await generalRepository.getItems(store);

    List<UnitTableData> unitsList = await generalRepository.getUnits(store);

    List<CategoryTableData> categoryList =
        await generalRepository.getCategories(store);

    List<Unit> units = buildUnitList(unitsList);

    loadProducts(items, store, unitsList);

    List<Category> categories = loadSystemCategories(categoryList);

    //set focused Unit
    store.dispatch(UnitR(units));
    store.dispatch(CategoryAction(categories));
    await buildBranchList(store);
    User _user = await getActiveUser(store);
    store.dispatch(OnAuthenticated(user: _user));
    //create app actions for saving state,or create.
    await createAppActions(store);
    //start by creating a draft order it it does not exist
    await createTemporalOrder(generalRepository, store, _user);
    //set current active business to be used throughout the entire app transaction
    getBusinesses(store, _user);
    //end of setting current active business.
    // Logger.d("Successfully loaded the app");
    dispatchFocusedTab(tab, store);
    //end setting active branch.
    //create custom category if does not exist
    await createSystemCustomCategory(generalRepository, store);
    //if no reason found then create app defaults reasons
    await createSystemStockReasons(store);
    //create custom item if does not exist
    await createDefaultTaxes(store);
    await Util.createCustomItem(store, "custom");
    await generateAppColors(generalRepository, store);

    _createCustomCategory(store);
    _cleanApp(store);
  };
}

Future createDefaultTaxes(Store<AppState> store) {
  if (store.state.branch == null) return null;
  return store.state.database.taxDao
      //ignore:missing_required_param
      .insert(TaxTableData(
          name: 'vat', value: 18, branchId: store.state.branch.id));
}

Future<User> getActiveUser(Store<AppState> store) async {
  List<User> users = await CouchBase(shouldInitDb: false)
      .getDocumentByDocId(docId: 'users', T: User);
  User user;
  for (var i = 0; i < users.length; i++) {
    if (users[i].active) {
      user = users[i];
    }
  }

  store.dispatch(WithUsers(users: users));
  return user;
}

Future<List<Branch>> buildBranchList(store) async {
  List<Branch> branches = await CouchBase(shouldInitDb: false)
      .getDocumentByDocId(docId: 'branches', T: Branch);

  for (var i = 0; i < branches.length; i++) {
    if (branches[i].active) {
      //set current active branch
      store.dispatch(
        OnCurrentBranchAction(
          branch: Branch((b) => b
            ..name = branches[i].name
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
  if (store.state.branch == null) return;
  await generalRepository.insertCustomCategory(
    store,
    //ignore: missing_required_param
    CategoryTableData(
        branchId: store.state.branch.id, focused: false, name: 'custom'),
  );
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

void loadProducts(List<ItemTableData> items, Store<AppState> store,
    List<UnitTableData> unitsList) {
  List<Item> itemList = [];

  items.forEach(
    (i) => itemList.add(
      Item(
        (v) => v
          ..name = i.name
          ..branchId = i.branchId
          ..unitId = i.unitId
          ..id = i.id
          ..color = i.color
          ..price = 0
          ..categoryId = i.categoryId,
      ),
    ),
  );

  store.dispatch(ItemLoaded(items: itemList));
  unitsList.forEach((c) => {
        if (c.focused)
          {
            store.dispatch(
              CurrentUnit(
                unit: Unit(
                  (u) => u
                    ..id = c.id
                    ..name = c.name
                    ..focused = c.focused
                    ..businessId = c.businessId ?? 0
                    ..branchId = c.branchId ?? 0,
                ),
              ),
            )
          }
      });
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

Future createTemporalOrder(GeneralRepository generalRepository,
    Store<AppState> store, User user) async {
  if (store.state.branch == null) return;
  if (store.state.user == null) return;
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
            ..userId = user.id
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

void getBusinesses(Store<AppState> store, user) async {
  List<Business> businesses = await CouchBase(shouldInitDb: false)
      .getDocumentByDocId(docId: 'businesses', T: Business);

  for (var i = 0; i < businesses.length; i++) {
    if (businesses[i].active) {
      store.dispatch(
        ActiveBusinessAction(
          Business(
            (b) => b
              ..id = businesses[i].id
              ..active = businesses[i].active
              ..name = businesses[i].name
              ..type = BusinessType.NORMAL
              ..hexColor = FlipperColors.defaultBusinessColor
              ..abbreviation = businesses[i].abbreviation
              ..image = "image_null",
          ),
        ),
      );
    }
  }
  store.dispatch(OnBusinessLoaded(business: businesses));
  if (businesses.length == 0 || user == null) {
    Router.navigator.pushNamed(Router.afterSplash);
    return;
  } else {
    Router.navigator.pushNamed(Router.dashboard);
  }
}

void loadClientDb(Store<AppState> store) {
  //todo: load db from sqlite.
  store.dispatch(OnDbLoaded(name: 'lagrace'));
}

void _createCustomCategory(Store<AppState> store) async {
  if (store.state.branch == null) return null;
  CategoryTableData category = await store.state.database.categoryDao
      .getCategoryNameAndBranch("custom", store.state.branch.id);
  if (category == null) {
    await store.state.database.categoryDao.insert(
        //ignore:missing_required_param
        CategoryTableData(
            name: "custom", branchId: store.state.branch.id, focused: true));
  }
}

void _cleanApp(Store<AppState> store) async {
  if (store.state.branch == null) return null;
  ItemTableData item = await store.state.database.itemDao
      .getItemByName(name: 'tmp', branchId: store.state.branch.id);

  if (item == null) return;

  Util.deleteItem(store, item.name, item.id);
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
