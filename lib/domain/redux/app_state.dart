import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flipper/data/main_database.dart';
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
import 'package:flipper/model/in_app_notification.dart';
import 'package:flipper/model/key_pad.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/permission.dart';
import 'package:flipper/model/price.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/report.dart';
import 'package:flipper/model/sheet.dart';
import 'package:flipper/model/tax.dart';
import 'package:flipper/model/total.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  @nullable
  FUser get user;

  @nullable
  int get userId;

  @nullable
  Business get currentActiveBusiness;

  @nullable
  int get tab;

  @nullable
  Business get nextActiveBusiness;

  @nullable
  Sheets get sheet;

  @nullable
  AppActions get action;

  @nullable
  Price get price;

  @nullable
  String get businessId;

  @nullable
  Unit get unit;

  @nullable
  Unit get customUnit;
  @nullable
  Product get customItem;

  @nullable
  BuiltList<Unit> get units;

  @nullable
  BuiltList<FUser> get users;

  @nullable
  int get focusedUnit;

  @nullable
  Category get category;

  @nullable
  Permission get permissions;

  @nullable
  List<Branch> get branches;

  @nullable
  List<Business> get businesses;

  @nullable
  Branch get branch;

  @nullable
  Business get business;

  @nullable
  Hint get hint;

  Database get database;


  @nullable
  int get tempCategoryId;

  @nullable
  Unit get currentUnit;

  @nullable
  FlipperColor get currentColor;

  @nullable
  Variation get variant;

  BuiltList<Variation> get itemVariations;

  @nullable
  Product get currentActiveSaleProduct;

  @nullable
  Variation get currentActiveSaleVariant;

  @nullable
  Product get cartItem;

  BuiltList<Product> get items;

  @nullable
  int get currentIncrement;

  BuiltList<Cart> get carts;

  @nullable
  int get cartQuantities;
  @nullable
  Order get order;

  @nullable
  KeyPad get keypad;

  @nullable
  Product get tmpItem;

  @nullable
  Total get total;

  @nullable
  Tax get defaultTax;


  @nullable
  String get fcmToken;

  @nullable
  ImageP get image;

  @nullable
  String get note;

  @nullable
  InAppNotification get inAppNotification;

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

  AppState._();
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  factory AppState.init() => AppState((a) => a
    ..database = Database()
    ..units = ListBuilder()
    ..carts = ListBuilder()
    ..itemVariations = ListBuilder()
    ..items = ListBuilder()
    ..businesses = List<Business>()
    ..branches = List<Branch>());

  AppState clear() {
    // Add here anything else that also needs to be carried over.
    return AppState.init().rebuild((s) => s..fcmToken = fcmToken);
  }
}
