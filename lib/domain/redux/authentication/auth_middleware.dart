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
      Router.navigator.pushNamed(Router.login);
      store.dispatch(Unauthenticated);
      return;
    }

    //end of streaming new order to part of apps's store
    UserTableData user = await userRepository.checkAuth(store);

    TabsTableData tab = await generalRepository.getTab(store);

    List<ItemTableData> items = await generalRepository.getItems(store);

    List<UnitTableData> unitsList = await generalRepository.getUnits(store);

    List<CategoryTableData> categoryList =
        await generalRepository.getCategories(store);

    List<BranchTableData> branch = await branchRepository.getBranches(store);

    List<BusinessTableData> businesses =
        await businessRepository.getBusinesses(store);

    if (businesses.length == 0 || user == null) {
      Router.navigator.pushNamed(Router.afterSplash);
      return;
    } else {
      final _user = User(
        (u) => u
          ..id = user.id
          ..bearerToken = user.bearerToken
          ..username = user.username
          ..refreshToken = user.refreshToken
          ..status = user.status
          ..avatar = user.avatar
          ..email = user.email,
      );

      Hint hint = Hint((b) => b
        ..type = HintType.Branch
        ..name = branch[0].name);

      store.dispatch(OnHintLoaded(hint: hint));

      List<Branch> branches = [];
      branch.forEach((b) => {
            branches.add(
              Branch(
                (bu) => bu
                  ..name = b.name
                  ..id = b.id,
              ),
            )
          });

      List<Unit> units = [];

      unitsList.forEach((b) => {
            units.add(Unit((u) => u
              ..name = b.name
              ..branchId = b.businessId
              ..businessId = b.businessId
              ..focused = b.focused
              ..id = b.id))
          });

      List<Category> categories = [];
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

      //set focused Unit
      store.dispatch(UnitR(units));

      store.dispatch(CategoryAction(categories));

      store.dispatch(OnBranchLoaded(branches: branches));

      store.dispatch(OnAuthenticated(user: _user));

      List<Business> businessList = [];
      businesses.forEach((b) => {
            businessList.add(
              Business(
                (bu) => bu
                  ..id = b.id
                  ..abbreviation = b.name
                  ..isActive = b.isActive
                  ..name = b.name,
              ),
            )
          });

      //setActive branch.
      for (var i = 0; i < branch.length; i++) {
        if (branch[i].isActive) {
          store.dispatch(
            OnCurrentBranchAction(
              branch: Branch(
                (b) => b
                  ..id = branch[i].id
                  ..name = branch[i].name
                  ..isActive = branch[i].isActive
                  ..description = "desc",
              ),
            ),
          );
        }
      }

      //create app actions
      ActionsTableData action =
          await store.state.database.actionsDao.getActionBy('save');

      ActionsTableData saveItem =
          await store.state.database.actionsDao.getActionBy('saveItem');
      if (saveItem == null) {
        await store.state.database.actionsDao.insert(
            //ignore:missing_required_param
            ActionsTableData(name: 'saveItem', isLocked: true));
      }
      if (action == null) {
        await store.state.database.actionsDao.insert(
            //ignore:missing_required_param
            ActionsTableData(name: 'save', isLocked: true));
      }
      //start by creating a draft order it it does not exist
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
      //set current active business to be used throughout the entire app transaction
      for (var i = 0; i < businesses.length; i++) {
        if (businesses[i].isActive) {
          store.dispatch(
            ActiveBusinessAction(
              Business(
                (b) => b
                  ..id = businesses[i].id
                  ..isActive = businesses[i].isActive
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
      //end of setting current active business.
      // Logger.d("Successfully loaded the app");
      store.dispatch(
        OnBusinessLoaded(business: businessList),
      );
      final currentTab = tab == null ? 0 : tab.tab;
      store.dispatch(
        CurrentTab(tab: currentTab),
      );

      //end setting active branch.
      //create custom category if does not exist
      await generalRepository.insertCustomCategory(
        store,
        //ignore: missing_required_param
        CategoryTableData(
            branchId: store.state.branch.id, focused: false, name: 'custom'),
      );

      //if no reason found then create app defaults reasons
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
            ReasonTableData(
                name: 'Inventory Re-counted', action: 'Re-counted'));
        await store.state.database.reasonDao.insert(
            //ignore:missing_required_param
            ReasonTableData(
                name: 'Restocked Return', action: 'Restocked Return'));
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
      //create custom item if does not exist
      await Util.createCustomItem(store, "custom");
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

      _createCustomCategory(store);
      _cleanApp(store);
      //branch
      if (businesses.length == 0) {
        Router.navigator.pushNamed(Router.signUpScreen);
      } else {
        Router.navigator.pushNamed(Router.dashboard);
      }
    }
  };
}

void _createCustomCategory(Store<AppState> store) async {
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
  ItemTableData item = await store.state.database.itemDao
      .getItemByName(name: 'tmp', branchId: store.state.branch.id);

  if (item == null) return;

  Util.deleteItem(store, item.name,item.id);
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
