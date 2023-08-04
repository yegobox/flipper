import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_fonts/google_fonts.dart';

class AppActions {
  static const String update = "update";
  static const String updated = "updated";
  static const String delete = "delete";
  static const String deleted = "deleted";
  static const String create = "create";
  static const String remote = "remote";
  static const String created = "created";
}

const String defaultApp = 'defaultApp';
String parkedStatus = 'parked';
const String pendingStatus = 'pending';
const String postPonedStatus = 'postponed';
String addBarCode = 'addBarCode';

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
bool isLinux = UniversalPlatform.isLinux;
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
ButtonStyle primary2ButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: MaterialStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF98C3FE).withOpacity(0.8),
      )),
  backgroundColor: MaterialStateProperty.all<Color>(
      const Color(0xFF98C3FE).withOpacity(0.8)),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Color(0xFF98C3FE).withOpacity(0.8);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return Color(0xFF98C3FE).withOpacity(0.8);
      }
      return null;
    },
  ),
);

ButtonStyle primary3ButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: MaterialStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF98C3FE).withOpacity(0.8),
      )),
);

ButtonStyle primary4ButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: MaterialStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF00FE38).withOpacity(0.8),
      )),
  backgroundColor: MaterialStateProperty.all<Color>(
      const Color(0xFF00FE38).withOpacity(0.8)),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Color(0xFF00FE38).withOpacity(0.8);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return Color(0xFF00FE38).withOpacity(0.8);
      }
      return null;
    },
  ),
);
TextStyle primaryTextStyle = GoogleFonts.poppins(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
const String kPackageId = 'rw.flipper';
final Color activeColor = Colors.blue.withOpacity(0.04);

/// The paths to the app's icons.
abstract class AppIcons {
  /// Asset directory containing the app's icons.
  static const String path = 'assets';

  /// Normal icon as an SVG.
  static const String linux = '$path/$kPackageId.svg';

  /// Normal icon as an ICO.
  static const String windows = '$path/$kPackageId.ico';

  /// Normal icon with a red dot indicating a notification, as an SVG.
  static const String linuxWithNotificationBadge =
      '$path/$kPackageId-with-notification-badge.svg';

  /// Normal icon with a red dot indicating a notification, as an ICO.
  static const String windowsWithNotificationBadge =
      '$path/$kPackageId-with-notification-badge.ico';

  /// Symbolic icon as an SVG.
  static const String linuxSymbolic = '$path/$kPackageId-symbolic.svg';

  /// Symbolic icon as an ICO.
  static const String windowsSymbolic = '$path/$kPackageId-symbolic.ico';

  /// Symbolic icon with a red dot indicating a notification, as an SVG.
  static const String linuxSymbolicWithNotificationBadge =
      '$path/$kPackageId-symbolic-with-notification-badge.svg';

  /// Symbolic icon with a red dot indicating a notification, as an ICO.
  static const String windowsSymbolicWithNotificationBadge =
      '$path/$kPackageId-symbolic-with-notification-badge.ico';
}
