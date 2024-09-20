import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PayableView extends StatefulHookConsumerWidget {
  PayableView(
      {Key? key,
      required this.ticketHandler,
      this.completeTransaction,
      required this.model,
      this.previewCart,
      this.wording,
      required this.mode,
      required WidgetRef ref})
      : super(key: key);
  final Function ticketHandler;
  final CoreViewModel model;
  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String? wording;
  final SellingMode mode;
  @override
  _PayableViewState createState() => _PayableViewState();
}

class _PayableViewState extends ConsumerState<PayableView> {
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
                widget.ticketHandler();
              },
              child: StreamBuilder<List<ITransaction>>(
                stream: ProxyService.local.ticketsStreams(),
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
          PreviewSaleButton(
            mode: widget.mode,
            wording: widget.wording,
            completeTransaction: widget.completeTransaction ?? null,
            previewCart: widget.previewCart ?? null,
          )
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
