import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

const String defaultApp = 'defaultApp';
String parkedStatus = 'parked';
const String pendingStatus = 'pending';
const String postPonedStatus = 'postponed';
String addBarCode = 'addBarCode';
Map actions = {
  "update": "update",
  "afterUpdate": "afterUpdate",
  "delete": "delete",
  "afterDelete": "afterDelete",
  "create": "create",
  "afterCreate": "afterCreate"
};
String attendance = 'attendance';
String login = 'login';
String selling = 'selling';
const String completeStatus = 'completed';
bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

const Color primary = Color(0xFF399df8);
final isMacOs = UniversalPlatform.isMacOS;
final isIos = UniversalPlatform.isIOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;
final isWindows = UniversalPlatform.isWindows;

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
