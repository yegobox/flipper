import 'dart:developer';

import 'package:flipper_services/proxy.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'proxy.dart';

/// Safely converts a hex color string to a Color object.
/// Returns a default grey color if the input is invalid.
///
/// Valid format: \"#RRGGBB\" or \"RRGGBB\" where RR, GG, BB are hex digits (0-9, A-F)
Color hexToColor(String? hexString) {
  // Default fallback color (grey)
  const defaultColor = Color(0xFF9E9E9E);

  // Null or empty check
  if (hexString == null || hexString.isEmpty) {
    return defaultColor;
  }

  // Remove any whitespace and '#' prefix
  final cleanHex = hexString.trim().replaceAll('#', '');

  // Check minimum length (RRGGBB = 6 characters)
  if (cleanHex.length < 6) {
    return defaultColor;
  }

  // Take first 6 characters
  final hexCode = cleanHex.substring(0, 6);

  // Validate that all characters are valid hex digits
  final hexPattern = RegExp(r'^[0-9A-Fa-f]{6}$');
  if (!hexPattern.hasMatch(hexCode)) {
    return defaultColor;
  }

  // Parse and return the color
  try {
    return Color(int.parse('FF$hexCode', radix: 16));
  } catch (e) {
    // If parsing fails for any reason, return default
    return defaultColor;
  }
}

class Actionable extends StatelessWidget {
  const Actionable(
      {Key? key,
      required this.widgets,
      required this.backView,
      this.showActionalView = false,
      this.spaceOnTop = 10,
      this.grandTotal = 130960,
      this.withRadius = 20,
      this.proceed})
      : super(key: key);

  final List<Widget> widgets;
  final double spaceOnTop;
  final Widget backView;
  final bool showActionalView;
  final double grandTotal;
  final double withRadius;
  final VoidCallback? proceed;

  @override
  Widget build(BuildContext context) {
    const containerWidth = 382.78;

    return Scaffold(
      body: Stack(
        children: [
          // Back widget
          backView,
          // Front widget
          showActionalView
              ? Positioned(
                  top: 30,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(withRadius),
                      topRight: Radius.circular(withRadius),
                    ),
                    child: Container(
                      width: containerWidth,
                      height: MediaQuery.of(context).size.height * 0.9,
                      color: hexToColor('FDFDFD'),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: spaceOnTop,
                                  bottom: 70, // Height of the button
                                ),
                                child: Column(
                                  children: [
                                    ...widgets,
                                    if (widgets.length == 1) const Spacer(),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              bottom: 20,
                            ),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Grand Total',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          NumberFormat('#,###')
                                              .format(grandTotal),
                                          style: const TextStyle(
                                            fontSize: 30,
                                          ),
                                        ),
                                        Text(
                                          ProxyService.box.defaultCurrency(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.resolveWith<
                                          OutlinedBorder>(
                                        (states) => RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                        const Color(0xff006AFE),
                                      ),
                                      overlayColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Colors.blue;
                                          }
                                          if (states.contains(
                                                  WidgetState.focused) ||
                                              states.contains(
                                                  WidgetState.pressed)) {
                                            return Colors.blue;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    onPressed: proceed,
                                    child: const Text(
                                      "Proceed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
