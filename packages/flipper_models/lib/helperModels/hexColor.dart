import 'dart:ui';

bool isValidHexColor(String colorCode) {
  final RegExp hexColorRegex = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');
  return hexColorRegex.hasMatch(colorCode);
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

// Fix this code as it is not properly converting

Color getColorOrDefault(String colorCode) {
  try {
    if (colorCode.startsWith("#")) {
      return HexColor(colorCode);
    } else {
      throw Exception("Invalid hex color code");
    }
  } catch (e) {
    throw Exception(e);
  }
}
