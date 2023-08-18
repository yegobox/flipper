import 'package:flutter/material.dart';

/// Take the passed [address] or serverAddress from Settings
/// and sanitize it, making sure it includes an http schema
String? getServerAddress({String? address}) {
  String serverAddress = address ?? "https://flipper.yegobox.com";

  String sanitized =
      serverAddress.replaceAll("https://", "").replaceAll("http://", "").trim();
  if (sanitized.isEmpty) return null;

  Uri? uri = Uri.tryParse(serverAddress);
  if (uri?.scheme.isEmpty ?? true) {
    if (serverAddress.contains("ngrok.io")) {
      serverAddress = "https://$serverAddress";
    } else {
      serverAddress = "https://$serverAddress";
    }
  }

  return serverAddress;
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
