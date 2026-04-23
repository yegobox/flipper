import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class PayableView extends HookConsumerWidget {
  static const double _kBarButtonHeight = 64;
  static const double _kVerticalGap = 10;

  const PayableView({
    Key? key,
    required this.ticketHandler,
    this.completeTransaction,
    required this.model,
    this.previewCart,
    this.wording,
    required this.transactionId,
    required this.mode,
    required this.digitalPaymentEnabled,
  }) : super(key: key);

  final Function ticketHandler;
  final CoreViewModel model;
  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String transactionId;
  final String? wording;
  final SellingMode mode;
  final bool digitalPaymentEnabled;

  /// Stacked Tickets / Pay instead of a single row.
  ///
  /// We avoid [LayoutBuilder] here: combining it with Riverpod rebuilds and
  /// [Consumer] descendants (e.g. [PreviewSaleButton]) has triggered
  /// re-entrant layout (`!_debugDoingThisLayout`) and unpainted
  /// [_RenderLayoutBuilder] in production.
  ///
  /// Heuristic: narrow window, or landscape with a short viewport (typical
  /// phone landscape with POS split — full [MediaQuery] width is still large).
  static bool _useVerticalCheckoutBar(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    if (size.width < 560) return true;
    if (landscape && size.height < 600) return true;
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync =
        ref.watch(transactionsProvider(forceRealData: true));
    final showTickets = ref.watch(
      featureAccessProvider(
        userId: ProxyService.box.getUserId() ?? '',
        featureName: AppFeature.Tickets,
      ),
    );

    final body = _useVerticalCheckoutBar(context)
        ? _buildVerticalLayout(
            context,
            ref,
            transactionsAsync,
            showTickets,
          )
        : _buildHorizontalLayout(
            context,
            ref,
            transactionsAsync,
            showTickets,
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
      child: body,
    );
  }

  // Vertical layout for small screens and mobile
  Widget _buildVerticalLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ITransaction>> transactionsAsync,
    bool showTickets,
  ) {
    // Fixed outer height so parents (Scaffold bottomNavigationBar, Column
    // siblings) get a stable intrinsic height. Row/Column + [Expanded] under a
    // loose vertical max otherwise leaves RenderPadding without a laid-out
    // child during intrinsic measurement.
    final barHeight = showTickets
        ? (_kBarButtonHeight + _kVerticalGap + _kBarButtonHeight)
        : _kBarButtonHeight;

    return SizedBox(
      width: double.infinity,
      height: barHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (showTickets) ...[
            SizedBox(
              height: _kBarButtonHeight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ticketHandler();
                },
                child: transactionsAsync.when(
                  data: (transactions) => _buildTicket(
                    tickets: transactions.length,
                    transactions: transactions.length,
                    context: context,
                    isCompact: true,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ),
            ),
            const SizedBox(height: _kVerticalGap),
          ],
          SizedBox(
            height: _kBarButtonHeight,
            child: PreviewSaleButton(
              digitalPaymentEnabled: digitalPaymentEnabled,
              transactionId: transactionId,
              mode: mode,
              wording: wording ?? "Pay",
              completeTransaction: completeTransaction,
              previewCart: previewCart,
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal layout for larger screens
  Widget _buildHorizontalLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ITransaction>> transactionsAsync,
    bool showTickets,
  ) {
    Widget payExpanded({required int flex}) {
      return Expanded(
        flex: flex,
        child: PreviewSaleButton(
          digitalPaymentEnabled: digitalPaymentEnabled,
          transactionId: transactionId,
          mode: mode,
          wording: wording ?? "Pay",
          completeTransaction: completeTransaction,
          previewCart: previewCart,
        ),
      );
    }

    if (!showTickets) {
      return SizedBox(
        width: double.infinity,
        height: _kBarButtonHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[payExpanded(flex: 1)],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: _kBarButtonHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ticketHandler();
              },
              child: transactionsAsync.when(
                data: (transactions) => _buildTicket(
                  tickets: transactions.length,
                  transactions: transactions.length,
                  context: context,
                  isCompact: false,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          payExpanded(flex: 3),
        ],
      ),
    );
  }

  Widget _buildTicket({
    required int tickets,
    required int transactions,
    required BuildContext context,
    required bool isCompact,
  }) {
    final bool hasTickets = tickets > 0;
    final bool hasNoTransactions = transactions == 0;

    if (isCompact) {
      // More compact version for small screens
      return hasTickets || hasNoTransactions
          ? Text(
              FLocalization.of(context).tickets,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: primaryTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            )
          : Text(
              FLocalization.of(context).save,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: primaryTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            );
    }

    // Original version for larger screens
    return hasTickets || hasNoTransactions
        ? Text(
            FLocalization.of(context).tickets,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                FLocalization.of(context).save,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              Text(
                'New Transaction${tickets > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ],
          );
  }
}
