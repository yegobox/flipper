import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';
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
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _sub = GlobalKey<FormState>();

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
              // One input field to receive amount
              GTextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) {
                    return "You need to enter the amount";
                  }
                  return null;
                },
                suffixIcon: const Icon(Icons.money),
                hintText: widget.open == "open"
                    ? "Opening balance"
                    : "Closing balance",
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40,
                  child: GOutlinedButton(
                    widget.open == "open" ? "Open Drawer" : "Close Drawer",
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
                          loginInfo.isLoggedIn = true;

                          GoRouter.of(context).push(Routes.home);
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
                          GoRouter.of(context).go(Routes.boot);
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
