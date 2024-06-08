import 'package:flipper_dashboard/preview_sale_button.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class PayableView extends StatelessWidget {
  const PayableView(
      {Key? key,
      required this.onClick,
      required this.ticketHandler,
      required this.model})
      : super(key: key);
  final Function onClick;
  final Function ticketHandler;
  final CoreViewModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: SizedBox(
            height: 64,
            child: TextButton(
              style: secondaryButtonStyle,
              onPressed: () {
                ticketHandler();
              },
              child: StreamBuilder<List<ITransaction>>(
                stream: ProxyService.realm.ticketsStreams(),
                builder: (context, snapshot) {
                  final List<ITransaction> transactions = snapshot.data ?? [];
                  final int tickets = transactions.length;

                  return Ticket(
                    tickets: tickets,
                    transactions: tickets,
                    context: context,
                  );
                },
              ),
            ),
          )),
          const SizedBox(
            width: 10,
          ),
          PreviewSaleButton()
        ],
      ),
    );
  }

  Widget Ticket({
    required int tickets,
    required int transactions,
    required BuildContext context,
  }) {
    final bool hasTickets = tickets > 0;
    final bool hasNoTransactions = transactions == 0;

    return hasTickets || hasNoTransactions
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
                'New Transaction${tickets > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 17),
              ),
            ],
          );
  }
}
