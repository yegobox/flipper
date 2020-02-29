import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/cart.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/couch_db_client_instance.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/item.dart';
import 'package:flipper/model/key_pad.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/user.dart';
import 'package:redux/redux.dart';

part 'common_view_model.g.dart';

abstract class CommonViewModel
    implements Built<CommonViewModel, CommonViewModelBuilder> {
  bool get hasUser;
  bool get hasSheet;
  @nullable
  bool get hasHint;

  @nullable
  BuiltList<Unit> get units;

  @nullable
  int get tab;

  @nullable
  Business get currentBusiness;

  bool get hasAction;

  List<Branch> get branches;

  List<Business> get businesses;

  @nullable
  AppActions get appAction;

  Hint get hint;

  @nullable
  Category get category;

  @nullable
  Unit get currentUnit;

  @nullable
  FlipperColor get currentColor;

  @nullable
  Branch get branch;

  @nullable
  Item get cartItem;

  @nullable
  BuiltList<Item> get itemVariations;

  BuiltList<Item> get items;

  @nullable
  int get currentIncrement;
  @nullable
  Item get currentActiveSaleItem;

  Database get database;

  CouchBase get couch;

  BuiltList<Cart> get carts;

  @nullable
  int get cartQuantities;

  @nullable
  Order get order;

  @nullable
  User get user;

  @nullable
  KeyPad get keypad;

  @nullable
  Unit get customUnit;

  @nullable
  Category get customCategory;

  @nullable
  Item get customItem;

  @nullable
  int get tempCategoryId;

  @nullable
  Item get tmpItem;

  @nullable
  CouchDbClient get couchDbClient;

  CommonViewModel._();
  factory CommonViewModel([void Function(CommonViewModelBuilder) updates]) =
      _$CommonViewModel;

  static bool _hasUser(Store<AppState> store) {
    return store.state.user != null;
  }

  static bool _hasAction(Store<AppState> store) {
    return store.state.action != null;
  }

  static bool _hasSheet(Store<AppState> store) {
    return store.state.sheet != null;
  }

  static Hint _hasHint(Store<AppState> store) {
    return store.state.hint;
  }

  static CommonViewModel fromStore(Store<AppState> store) {
    return CommonViewModel((vm) => vm
      ..hasUser = _hasUser(store)
      ..hasSheet = _hasSheet(store)
      ..hasAction = _hasAction(store)
      ..businesses = store.state.businesses
      ..tab = store.state.tab
      ..currentIncrement = store.state.currentIncrement
      ..cartItem =
          store.state.cartItem == null ? null : store.state.cartItem.toBuilder()
      ..items = store.state.items.toBuilder()
      ..currentUnit = store.state.currentUnit == null
          ? null
          : store.state.currentUnit.toBuilder()
      ..currentActiveSaleItem = store.state.currentActiveSaleItem == null
          ? null
          : store.state.currentActiveSaleItem.toBuilder()
      ..units = store.state.units.toBuilder()
      ..itemVariations = store.state.itemVariations.toBuilder()
      ..currentColor = store.state.currentColor == null
          ? null
          : store.state.currentColor.toBuilder()
      ..appAction =
          store.state.action == null ? null : store.state.action.toBuilder()
      ..currentBusiness = store.state.currentActiveBusiness == null
          ? null
          : store.state.currentActiveBusiness.toBuilder()
      ..database = store.state.database
      ..couch = store.state.couch
      ..hint = _hasHint(store) == null ? null : store.state.hint.toBuilder()
      ..carts = store.state.carts.toBuilder()
      ..cartQuantities = store.state.cartQuantities
      ..order = store.state.order == null ? null : store.state.order.toBuilder()
      ..user = store.state.user == null ? null : store.state.user.toBuilder()
      ..keypad =
          store.state.keypad == null ? null : store.state.keypad.toBuilder()
      ..customCategory = store.state.customCategory == null
          ? null
          : store.state.customCategory.toBuilder()
      ..customUnit = store.state.customUnit == null
          ? null
          : store.state.customUnit.toBuilder()
      ..tempCategoryId =
          store.state.tempCategoryId == null ? null : store.state.tempCategoryId
      ..customItem = store.state.customItem == null
          ? null
          : store.state.customItem.toBuilder()
      ..couchDbClient = store.state.couchDbClient == null
          ? null
          : store.state.couchDbClient.toBuilder()
      ..branches = store.state.branches
      ..tmpItem =
          store.state.tmpItem == null ? null : store.state.tmpItem.toBuilder()
      ..branch =
          store.state.branch == null ? null : store.state.branch.toBuilder());
  }
}
