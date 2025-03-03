import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:google_fonts/google_fonts.dart';

// Constants
const String PAYMENT_UPDATE_REQUIRED =
    "Please update the payment as payment has failed";
const String PAYMENT_REACTIVATION_REQUIRED =
    "Payment failed. Please re-activate your payment method";

// Enums
enum FilterType { CUSTOMER, TRANSACTION, NS, CS, NR, TS, PS, CR, CP, PR, TR }

class TransactionReceptType {
  static const NS = "NS";
  static const NR = "NR";
  static const CS = "CS";
  static const TS = "TS";
  static const PS = "PS";
  static const CR = "CR";
  static const TR = "TR";
}

// Classes
class RequestStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String partiallyApproved = 'partiallyApproved';
  static const String rejected = 'rejected';
  static const String fulfilled = 'fulfilled';
}

final features = [
  AppFeature.Inventory,
  AppFeature.Settings,
  AppFeature.Reports,
  AppFeature.Tickets,
  AppFeature.Orders,
  AppFeature.AddProduct,
  AppFeature.CustomAmount,
  AppFeature.Sales,
  AppFeature.Driver,
];

class AppFeature {
  static const String Sales = "Sales";
  static const String Inventory = "Inventory";
  static const String Reports = "Reports";
  static const String Settings = "Settings";
  static const String Tickets = "Tickets";
  static const String AddProduct = "Add Product";
  static const String Orders = "Orders";
  static const String CustomAmount = "Custom Amount";
  static const String Driver = "Driver";
}

class AccessLevel {
  static const String WRITE = "write";
  static const String ADMIN = "admin";
  static const String READ = "read";
}

class AppActions {
  static const String updated = "updated";
  static const String synchronized = "synchronized";
  static const String deleted = "deleted";
  static const String created = "created";
  static const String defaultCategory = "default";
  static const String remote = "remote";
}

class TransactionType {
  static const String cashIn = 'Cash In';
  static const String cashOut = 'Cash Out';
  static const String sale = 'Sale';
  static const String purchase = 'Purchase';
  static const String adjustment = 'adjustment';
  static const String importation = 'Import';
  static const String salary = 'Salary';
  static const String transport = 'Transport';
  static const String airtime = 'Airtime';
  static const List<String> acceptedCashOuts = [salary, transport, airtime];
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

// Lists
const List<String> paymentTypes = [
  'Cash',
  'MOMO MTN',
  'Card',
  'Credit',
  'Bank'
];

List<String> accessLevels = ['No Access', 'read', 'write', 'admin'];

// Functions
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

// Variables
// String EBMURL = "http://localhost:8080/rra";
// String EBMURL = "https://turbo.yegobox.com/rra";

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
const String ORDERING = 'ordering';
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

// Styles
ButtonStyle primaryButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  backgroundColor: WidgetStateProperty.all<Color>(Color(0xff006AFE)),
  overlayColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return Color(0xff006AFE);
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return Color(0xff006AFE);
      }
      return null;
    },
  ),
);

ButtonStyle secondaryButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xffF2F2F2)),
  overlayColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.blue.withOpacity(0.04);
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return Colors.blue.withOpacity(0.12);
      }
      return null; // Defer to the widget's default.
    },
  ),
);

ButtonStyle primary2ButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: WidgetStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF98C3FE).withOpacity(0.8),
      )),
  backgroundColor:
      WidgetStateProperty.all<Color>(const Color(0xFF98C3FE).withOpacity(0.8)),
  overlayColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return Color(0xFF98C3FE).withOpacity(0.8);
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return Color(0xFF98C3FE).withOpacity(0.8);
      }
      return null;
    },
  ),
);

ButtonStyle primary3ButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: WidgetStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF98C3FE).withOpacity(0.8),
      )),
);

ButtonStyle primary4ButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
  side: WidgetStateProperty.resolveWith<BorderSide>((states) => BorderSide(
        color: Color(0xFF00FE38).withOpacity(0.8),
      )),
  backgroundColor:
      WidgetStateProperty.all<Color>(const Color(0xFF00FE38).withOpacity(0.8)),
  overlayColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return Color(0xFF00FE38).withOpacity(0.8);
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
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
