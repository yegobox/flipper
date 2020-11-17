import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:flipper/model/branch.dart';
import 'package:flipper/model/business.dart';

import 'package:flipper/model/category.dart';

import 'package:flipper/model/fuser.dart';
import 'package:flipper/model/hint.dart';
import 'package:flipper/model/image.dart';
import 'package:flipper/model/in_app_notification.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/model/permission.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/report.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/model/variation.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  
  @nullable
  FUser get user;

  @nullable
  Business get currentActiveBusiness;

  @nullable
  Unit get unit;

  @nullable
  String get otpcode;

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


  @nullable
  String get tempCategoryId;

  @nullable
  Variation get variant;


  BuiltList<Product> get items;


  @nullable
  Order get order;

  @nullable
  Product get tmpItem;

  
  @nullable
  String get fcmToken;

  @nullable
  ImageP get image;

  @nullable
  String get note;

  @nullable
  InAppNotification get inAppNotification;

  
  @nullable
  Report get report;

  
  // ignore: sort_constructors_first
  AppState._();
  // ignore: sort_constructors_first
  // ignore: sort_unnamed_constructors_first
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  // ignore: sort_constructors_first
  factory AppState.init() => AppState((AppStateBuilder a) => a
   
    // ignore: always_specify_types
    ..units = ListBuilder()
    // ignore: always_specify_types
    // ignore: always_specify_types
    ..businesses = <Business>[]
    // ignore: always_specify_types
    ..branches = <Branch>[]);

  AppState clear() {
    // Add here anything else that also needs to be carried over.
    return AppState.init().rebuild((AppStateBuilder s) => s..fcmToken = fcmToken);
  }
}
