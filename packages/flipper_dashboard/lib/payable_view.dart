import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';

class PayableView extends HookConsumerWidget {
  const PayableView({
    Key? key,
    required this.ticketHandler,
    this.completeTransaction,
    required this.model,
    this.previewCart,
    this.wording,
    required this.mode,
  }) : super(key: key);

  final Function ticketHandler;
  final CoreViewModel model;
  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String? wording;
  final SellingMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

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
                child: transactionsAsync.when(
                  data: (transactions) => _buildTicket(
                    tickets: transactions.length,
                    transactions: transactions.length,
                    context: context,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          PreviewSaleButton(
            mode: mode,
            wording: wording ?? "Pay",
            completeTransaction: completeTransaction,
            previewCart: previewCart,
          )
        ],
      ),
    );
  }

  Widget _buildTicket({
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
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                FLocalization.of(context).save,
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              Text(
                'New Transaction${tickets > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ],
          );
  }
}
