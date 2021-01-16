import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:flipper_models/branch.dart';
import 'package:flipper_models/business.dart';

import 'package:flipper_models/category.dart';

import 'package:flipper_models/fuser.dart';
import 'package:flipper_models/hint.dart';
import 'package:flipper_models/image.dart';
import 'package:flipper_models/in_app_notification.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/permission.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/report.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_models/pcolor.dart';

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

  @nullable
  BuiltList<Variation> get variants;

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

  @nullable
  PColor get currentColor;
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
    return AppState.init()
        .rebuild((AppStateBuilder s) => s..fcmToken = fcmToken);
  }
}
