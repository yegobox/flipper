import 'dart:developer';

import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'proxy.dart';

Color hexToColor(String hexString) {
  final hexCode = hexString.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
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
    ProxyService.box.writeInt(key: "userId", value: 1);
    log(ProxyService.box.readInt(key: 'userId').toString());
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
