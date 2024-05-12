import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar(BuildContext context, String message,
    {required Color textColor, required Color backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: 400,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: textColor,
        ),
      ),
    ),
  );
}

enum FilterType { CUSTOMER, TRANSACTION, NS, CS, NR, TS, PS }

class AppActions {
  static const String updated = "updated";
  static const String synchronized = "synchronized";
  static const String deleted = "deleted";
  static const String created = "created";
  static const String defaultCategory = "default";
  static const String remote = "remote";
}

class TransactionReceptType {
  static const NS = "NS";
  static const NR = "NR";
  static const CS = "CS";
  static const TS = "TS";
  static const PS = "PS";
}

class TransactionType {
  static String cashIn = 'Cash In';
  static String cashOut = 'Cash Out';
  static String sale = 'Sale';
  static String custom = 'custom';
  static String onlineSale = 'Online Sale';
  static String salary = 'Salary';
  static String transport = 'Transport';
  static String airtime = 'Airtime';
  static List<String> acceptedCashOuts = [salary, transport, airtime];
}

class TransactionPeriod {
  static String today = 'Today';
  static String thisWeek = 'This Week';
  static String thisMonth = 'This Month';
}

class NavigationPurpose {
  static String home = 'Home';
  static String back = 'Back';
}

const String defaultApp = 'defaultApp';
const String PARKED = 'parked';
const String PENDING = 'pending';
const String BARCODE = 'addBarCode';
const String CUSTOM_PRODUCT = "Custom Amount";
const String TEMP_PRODUCT = "temp";
const String COLOR = "#e74c3c";
const String ATTENDANCE = 'attendance';
const String LOGIN = 'login';
const String SELLING = 'selling';
const String COMPLETE = 'completed';

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

const Color primary = Color(0xFF399df8);
bool isMacOs = UniversalPlatform.isMacOS;
bool isIos = UniversalPlatform.isIOS;
bool isAndroid = UniversalPlatform.isAndroid;
bool isWeb = UniversalPlatform.isWeb;
bool isWindows = UniversalPlatform.isWindows;
bool isLinux = UniversalPlatform.isLinux;
bool isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
ButtonStyle primaryButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(Color(0xff006AFE)),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Color(0xff006AFE);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return Color(0xff006AFE);
      }
      return null;
    },
  ),
);
ButtonStyle secondaryButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffF2F2F2)),
  overlayColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.blue.withOpacity(0.04);
      }
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return Colors.blue.withOpacity(0.12);
      }
      return null; // Defer to the widget's default.
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

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
