import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.open, required this.drawer})
      : super(key: key);
  final String open;
  final Drawers drawer;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _controller = TextEditingController();
  final _sub = GlobalKey<FormState>();
  final _routerService = locator<RouterService>();
  @override
  void dispose() {
    _controller.dispose();
    _sub.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isProcessing = false;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: isDesktopOrWeb ? 380 : double.infinity,
          child: Form(
            key: _sub,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  widget.open == "close"
                      ? "Close a Business  with ${widget.drawer.closingBalance} Balance"
                      : "Open Business",
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "You need to enter the amount";
                    }
                    final numericValue = num.tryParse(value);
                    if (numericValue == null) {
                      return "Only numeric values are allowed";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabled: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.money),
                    hintText: widget.open == "open"
                        ? "Opening balance"
                        : "Closing balance",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
                  child: Container(
                    color: Colors.white70,
                    width: double.infinity,
                    height: 60,
                    child: BoxButton(
                        title: widget.open == "open"
                            ? "Open Drawer"
                            : "Close Drawer",
                        onTap: () async {
                          if (_sub.currentState!.validate()) {
                            setState(() {
                              isProcessing = true;
                            });
                            if (widget.open == "open") {
                              ProxyService.isar.openDrawer(
                                drawer: widget.drawer
                                  ..openingBalance =
                                      double.tryParse(_controller.text) ?? 0,
                              );
                              LoginInfo().isLoggedIn = true;

                              _routerService.navigateTo(FlipperAppRoute());
                            } else {
                              ProxyService.isar.update(
                                  data: widget.drawer
                                    ..closingBalance =
                                        double.parse(_controller.text)
                                    ..closingDateTime =
                                        DateTime.now().toIso8601String()
                                    ..open = false);

                              /// when you close a drawer we asume you also closed a business day
                              /// therefore we log you out for next day log in.
                              await ProxyService.isar.logOut();
                              _routerService.navigateTo(LoginViewRoute());
                            }
                          }
                        },
                        busy: isProcessing),
                  ),
                ),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
