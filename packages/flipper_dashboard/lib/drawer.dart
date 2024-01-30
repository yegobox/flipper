import 'package:flipper_dashboard/customappbar.dart';
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

import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:intl/intl.dart';

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
  String? value = "0.0";

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
      appBar: CustomAppBar(
        closeButton: CLOSEBUTTON.WIDGET,
        isDividerVisible: false,
        customLeadingWidget: back.BackButton(),
        onPop: () async {
          // _routerService.back();
        },
      ),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: isDesktopOrWeb ? 380 : double.infinity,
          child: buildForm(isProcessing),
        ),
      ),
    );
  }

  Widget buildForm(bool isProcessing) {
    return Form(
      key: _sub,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktopOrWeb ? 0 : 13),
        child: Column(
          children: [
            const Spacer(),
            buildHeader(),
            buildTextFormField(),
            buildSubmitButton(isProcessing),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _formatClosingBalance(double balance) {
    return "${NumberFormat.currency(locale: 'en', symbol: 'RWF ').format(balance)}";
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.open == "close" ? "Close a Business" : "Open Business",
          style: GoogleFonts.poppins(
            fontSize: 36.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (widget.open == "close") ...[
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Text(
              _formatClosingBalance(widget.drawer.closingBalance),
              style: GoogleFonts.poppins(
                fontSize: 38.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
        if (widget.open != "close") ...[
          Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Text(
              _formatClosingBalance(double.tryParse(value ?? "0.0") ?? 0.0),
              style: GoogleFonts.poppins(
                fontSize: 38.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildTextFormField() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: (v) {
        setState(() {
          value = v.isEmpty ? "0.0" : v;
        });
      },
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
        hintText: widget.open == "open" ? "Opening balance" : "Closing balance",
      ),
    );
  }

  Widget buildSubmitButton(bool isProcessing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
      child: Container(
        color: Colors.white70,
        width: double.infinity,
        height: 60,
        child: BoxButton(
          title: widget.open == "open" ? "Open Drawer" : "Close Drawer",
          onTap: () async {
            if (_sub.currentState!.validate()) {
              setState(() {
                isProcessing = true;
              });
              if (widget.open == "open") {
                handleOpenDrawer();
              } else {
                handleCloseDrawer();
              }
            }
          },
          busy: isProcessing,
        ),
      ),
    );
  }

  void handleOpenDrawer() {
    ProxyService.isar.openDrawer(
      drawer: widget.drawer
        ..openingBalance = double.tryParse(_controller.text) ?? 0,
    );

    LoginInfo().isLoggedIn = true;
    _routerService.navigateTo(FlipperAppRoute());
  }

  void handleCloseDrawer() async {
    ProxyService.isar.update(
      data: widget.drawer
        ..closingBalance = double.parse(_controller.text)
        ..closingDateTime = DateTime.now().toIso8601String()
        ..open = false,
    );

    await ProxyService.isar.logOut();
    _routerService.navigateTo(LoginViewRoute());
  }
}
