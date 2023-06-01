import 'package:flipper_dashboard/transactions.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_dashboard/sales_buttons_controller.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:stacked_services/stacked_services.dart';
import 'settings.dart';

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;
// ignore: non_constant_identifier_names
Widget PaymentTicketManager(
    {required BuildContext context,
    required BusinessHomeViewModel model,
    required TextEditingController controller,
    required bool nodeDisabled}) {
  final _routerService = locator<RouterService>();
  return SalesButtonsController(
    tab: model.tab,
    model: model,
    saleCounts: model.keypad.itemsOnSale,
    payable: PayableView(
      model: model,
      saleCounts: model.keypad.itemsOnSale,
      onClick: () {
        if (model.kOrder != null) {
          _routerService.navigateTo(PaymentsRoute(
              order: model.kOrder!,
              duePay: model.items.fold(0, (a, b) => a + (b.price * b.qty))));
        } else {
          showSimpleNotification(
            Text(FLocalization.of(context).noPayable),
            background: Colors.green,
            position: NotificationPosition.bottom,
          );
        }
      },
      tickets: model.keypad.tickets.length.toDouble(),
      orders: model.keypad.itemsOnSale,
      duePay: model.kOrder?.subTotal,
      ticketHandler: () async {
        Order order = await ProxyService.isarApi.manageOrder();
        _routerService.navigateTo(TicketsRoute(order: order));
      },
    ),
    controller: controller,
    amount: double.parse(model.key),
  );
}

class BodyWidget extends StatefulWidget {
  const BodyWidget(
      {Key? key,
      required this.model,
      required this.controller,
      required this.nodeDisabled})
      : super(key: key);
  final BusinessHomeViewModel model;
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
          if (widget.model.tab == 1) Transactions(model: widget.model),
          if (widget.model.tab == 2) Flexible(child: ProductView.normalMode()),
          if (widget.model.tab == 3)
            Flexible(
              child: SettingPage(
                  business: widget.model.businesses,
                  tenant: widget.model.tenant!),
            ),
          if (widget.model.tab == 4)
            Flexible(
              child: SettingPage(
                  business: widget.model.businesses,
                  tenant: widget.model.tenant!),
            )
        ],
      ),
    );
  }
}
