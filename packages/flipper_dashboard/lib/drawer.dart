import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart' as model;

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.open, this.drawer})
      : super(key: key);
  final String open;
  final model.Drawers? drawer;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _controller = TextEditingController();
  final _sub = GlobalKey<FormState>();
  final _routerService = locator<RouterService>();
  @override
  void dispose() {
    // Dispose of the TextEditingController
    _controller.dispose();

    // Dispose of the GlobalKey<FormState>
    _sub.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 140, 15, 8),
        child: Form(
          key: _sub,
          child: Column(
            children: [
              Text(widget.open == "close"
                  ? "Close a Business"
                  : "Open Business"),
              const Spacer(),
              TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null) {
                      return "You need to enter the amount";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      enabled: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.money),
                      hintText: widget.open == "open"
                          ? "Opening balance"
                          : "Closing balance")),
              Padding(
                padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    child: Text(
                        widget.open == "open" ? "Open Drawer" : "Close Drawer",
                        style: const TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff006AFE)),
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
                    ),
                    onPressed: () async {
                      if (_sub.currentState!.validate()) {
                        if (widget.open == "open") {
                          ProxyService.isarApi.openDrawer(
                            drawer: model.Drawers()
                              ..cashierId = ProxyService.box.getBusinessId()!
                              ..openingBalance = double.parse(_controller.text)
                              ..closingBalance = 0
                              ..tradeName =
                                  ProxyService.appService.business.name
                              ..nsSaleCount = 0
                              ..trSaleCount = 0
                              ..psSaleCount = 0
                              ..incompleteSale = 0
                              ..totalCsSaleIncome = 0
                              ..totalNsSaleIncome = 0
                              ..csSaleCount = 0
                              ..nrSaleCount = 0
                              ..openingDateTime =
                                  DateTime.now().toIso8601String()
                              ..open = true,
                          );
                          LoginInfo().isLoggedIn = true;

                          _routerService.navigateTo(FlipperAppRoute());
                        } else {
                          ProxyService.isarApi.update(
                              data: widget.drawer!
                                ..closingBalance =
                                    double.parse(_controller.text)
                                ..closingDateTime =
                                    DateTime.now().toIso8601String()
                                ..open = false);

                          /// when you close a drawer we asume you also closed a business day
                          /// therefore we log you out for next day log in.
                          await ProxyService.isarApi.logOut();
                          _routerService.navigateTo(LoginViewRoute());
                        }
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
