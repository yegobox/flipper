import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_fonts/google_fonts.dart';

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
bool isMacOs = UniversalPlatform.isMacOS;
bool isIos = UniversalPlatform.isIOS;
bool isAndroid = UniversalPlatform.isAndroid;
bool isWeb = UniversalPlatform.isWeb;
bool isWindows = UniversalPlatform.isWindows;
bool isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
ButtonStyle primaryButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: MaterialStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: const Color(0xff006AFE),
      )),
  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.blue.withOpacity(0.04);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return Colors.blue.withOpacity(0.12);
      }
      return null;
    },
  ),
);
TextStyle primaryTextStyle = GoogleFonts.poppins(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
