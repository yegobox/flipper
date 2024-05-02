import 'package:flipper_dashboard/transactions.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_dashboard/sales_buttons_controller.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:stacked_services/stacked_services.dart';
import 'settings.dart';
import 'tickets.dart';

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
// ignore: non_constant_identifier_names
Widget PaymentTicketManager(
    {required BuildContext context,
    required CoreViewModel model,
    required TextEditingController controller,
    required bool nodeDisabled}) {
  final _routerService = locator<RouterService>();
  return SalesButtonsController(
    tab: model.tab,
    model: model,
    payable: PayableView(
      model: model,
      onClick: () async {
        final transaction = await ProxyService.isar
            .manageTransaction(transactionType: TransactionType.custom);
        if (transaction.subTotal == 0) {
          _routerService.navigateTo(PaymentsRoute(transaction: transaction));
        } else {
          showSimpleNotification(
            Text(FLocalization.of(context).noPayable),
            background: Colors.green,
            position: NotificationPosition.bottom,
          );
        }
      },
      ticketHandler: () async {
        ITransaction transaction = await ProxyService.isar
            .manageTransaction(transactionType: TransactionType.custom);
        showModalBottomSheet(
          backgroundColor: Colors.red,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          useRootNavigator: true,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Tickets(transaction: transaction),
            );
          },
        );
      },
    ),
    controller: controller,
    amount: double.tryParse(model.key) ?? 0.0,
  );
}

class BodyWidget extends StatefulWidget {
  const BodyWidget(
      {Key? key,
      required this.model,
      required this.controller,
      required this.nodeDisabled})
      : super(key: key);
  final CoreViewModel model;
  final TextEditingController controller;
  final bool nodeDisabled;
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (widget.model.tab == 2)
            PaymentTicketManager(
                context: context,
                model: widget.model,
                controller: widget.controller,
                nodeDisabled: widget.nodeDisabled),
          if (widget.model.tab == 0)
            PaymentTicketManager(
                context: context,
                model: widget.model,
                controller: widget.controller,
                nodeDisabled: widget.nodeDisabled),
          if (widget.model.tab == 0) KeyPadView(model: widget.model),
          if (widget.model.tab == 1) Transactions(),
          if (widget.model.tab == 2) Flexible(child: ProductView.normalMode()),
          if (widget.model.tab == 3)
            Flexible(
              child: SettingPage(),
            ),
        ],
      ),
    );
  }
}
