import 'package:flipper_dashboard/preview_sale_button.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class PayableView extends StatelessWidget {
  const PayableView(
      {Key? key,
      this.duePay = 0,
      required this.onClick,
      required this.ticketHandler,
      required this.model})
      : super(key: key);
  final double? duePay;
  final Function onClick;
  final Function ticketHandler;
  final BusinessHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: SizedBox(
            height: 64,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xffF2F2F2)),
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
              onPressed: () {
                ticketHandler();
              },
              child: StreamBuilder<List<Order>>(
                stream: ProxyService.isar.ticketsStreams(),
                builder: (context, snapshot) {
                  final List<Order> orders = snapshot.data ?? [];
                  final int tickets = orders.length;

                  return StreamBuilder<List<Order>>(
                    stream: ProxyService.isar.pendingOrderStreams(),
                    builder: (context, snapshot) {
                      final List<Order> pendingOrders = snapshot.data ?? [];
                      final int ordersCount = pendingOrders.length;

                      return Ticket(
                        tickets: tickets,
                        orders: ordersCount,
                        context: context,
                      );
                    },
                  );
                },
              ),
            ),
          )),
          const SizedBox(
            width: 10,
          ),
          PreviewSaleButton(model: model)
        ],
      ),
    );
  }

  Widget Ticket({
    required int tickets,
    required int orders,
    required BuildContext context,
  }) {
    final bool hasTickets = tickets > 0;
    final bool hasNoOrders = orders == 0;

    return hasTickets || hasNoOrders
        ? Text(
            FLocalization.of(context).tickets,
            textAlign: TextAlign.center,
            style: primaryTextStyle.copyWith(
                fontWeight: FontWeight.w400, fontSize: 17),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                FLocalization.of(context).save,
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 17),
              ),
              Text(
                'New Order${tickets > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 17),
              ),
            ],
          );
  }
}
