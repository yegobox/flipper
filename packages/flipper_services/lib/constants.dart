import 'package:flutter/material.dart';

String appFont = 'HelveticaNeuea';
String dbName = 'main';
String parkedStatus = 'parked';
String pendingStatus = 'pending';
String completeStatus = 'completed';
const double kPadding = 10.0;
const Color purpleLight = Color(0XFF1e224c);
const Color purpleDark = Color(0XFF0d193e);
const Color orange = Color(0XFFec8d2f);
const Color red = Color(0XFFf44336);
// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Only put constants shared between files here.

// height of the 'Gallery' header
const double galleryHeaderHeight = 64;

// The font size delta for headline4 font.
const double desktopDisplay1FontDelta = 16;

// The width of the settingsDesktop.
const double desktopSettingsWidth = 520;

// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

// The splash page animation duration.
const splashPageAnimationDurationInMilliseconds = 300;

// The desktop top padding for a page's first header (e.g. Gallery, Settings)
const firstHeaderDesktopTopPadding = 5.0;

// Pages
const String pageKey = 'page';
bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

// ignore: avoid_classes_with_only_static_members
// @Deprecated use app_services constants
class AppTables {
  //table name used to query couchbase_lite data
  static const String business = 'businesses';
  static const String branch = 'branches';
  static const String tax = 'taxes';
  static const String category = 'categories';
  static const String variation = 'variants';
  static const String product = 'products';
  static const String stockHistories = 'stocks_histories';
  static const String order = 'orders';
  static const String orderDetail = 'orderDetails';
  static const String branchProduct = 'branchProducts';
  static const String unit = 'units';
  static const String stock = 'stocks';
  static const String drawerHistories = 'drawerHistories';
  static const String cart = 'cart';
  static const String color = 'colors';

  static const String user = 'users';

  static const String tickets = 'tickets';
}
