import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/cart.dart';
import 'package:flipper/model/category.dart';
import 'package:flipper/model/date_filter.dart';
import 'package:flipper/model/flipper_color.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/key_pad.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/report.dart';
import 'package:flipper/model/total.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';
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
  Product get cartItem;

  @nullable
  BuiltList<Variation> get itemVariations;

  @nullable
  Variation get variant;

  BuiltList<Product> get items;

  @nullable
  int get currentIncrement;
  @nullable
  Product get currentActiveSaleProduct;

  Database get database;

  BuiltList<Cart> get carts;

  @nullable
  int get cartQuantities;

  @nullable
  Order get order;

  
  FUser get user;

  @nullable
  KeyPad get keypad;

  @nullable
  Unit get customUnit;

  @nullable
  Product get customItem;

  @nullable
  String get tempCategoryId;

  @nullable
  Product get tmpItem;

  @nullable
  Variation get currentActiveSaleVariant;

  @nullable
  Total get total;

  @nullable
  ImageP get image;


  @nullable
  String get note;

  @nullable
  DateFilter get dateFilter;

  @nullable
  Report get report;

  @nullable
  String get navigate;

  @nullable
  String get phone;

  @nullable
  String get otpcode;



  @nullable
  String get businessId;

  // ignore: sort_constructors_first
  CommonViewModel._();
  // ignore: sort_unnamed_constructors_first
  factory CommonViewModel([void Function(CommonViewModelBuilder) updates]) =
      _$CommonViewModel;

  static bool _hasUser(Store<AppState> store) {
    return store.state.user.id != null;
  }

  static bool _hasAction(Store<AppState> store) {
    return store.state.action != null;
  }

  static bool _hasSheet(Store<AppState> store) {
    return store.state.sheet != null;
  }

  static CommonViewModel fromStore(Store<AppState> store) {
    return CommonViewModel(
      (vm) => vm
        ..hasUser = _hasUser(store)
        ..hasSheet = _hasSheet(store)
        ..hasAction = _hasAction(store)
        ..businesses = store.state.businesses
        ..tab = store.state.tab
        ..currentIncrement = store.state.currentIncrement
        ..cartItem = store.state.cartItem?.toBuilder()
        ..items = store.state.items.toBuilder()
        ..currentUnit = store.state.currentUnit?.toBuilder()
        ..currentActiveSaleProduct =
            store.state.currentActiveSaleProduct?.toBuilder()
        ..units = store.state.units.toBuilder()
        ..itemVariations = store.state.itemVariations.toBuilder()
        ..currentColor = store.state.currentColor?.toBuilder()
        ..appAction = store.state.action?.toBuilder()
        ..currentBusiness = store.state.currentActiveBusiness?.toBuilder()
        ..database = store.state.database
        ..hint = store.state.hint?.toBuilder()
        ..carts = store.state.carts.toBuilder()
        ..cartQuantities = store.state.cartQuantities
        ..order = store.state.order?.toBuilder()
        ..user = store.state.user?.toBuilder()
        ..businessId = store.state.businessId
        ..keypad = store.state.keypad?.toBuilder()
        ..category = store.state.category?.toBuilder()
        ..customUnit = store.state.customUnit?.toBuilder()
        ..tempCategoryId = store.state.tempCategoryId
        ..customItem = store.state.customItem?.toBuilder()
        ..dateFilter = store.state.dateFilter?.toBuilder()
        ..report = store.state.report?.toBuilder()
        ..currentActiveSaleVariant =
            store.state.currentActiveSaleVariant?.toBuilder()
        ..total = store.state.total?.toBuilder()
        ..variant = store.state.variant?.toBuilder()
        ..branches = store.state.branches
        ..tmpItem = store.state.tmpItem?.toBuilder()
        ..note = store.state.note
        ..otpcode = store.state.otpcode
        ..navigate = store.state.navigate
        ..phone = store.state.phone
        ..image = store.state.image?.toBuilder()
        ..branch = store.state.branch?.toBuilder(),
    );
  }
}
