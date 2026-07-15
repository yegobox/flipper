import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class PayableView extends HookConsumerWidget {
  static const double _kBarButtonHeight = PosTokens.payButtonHeight;
  static const double _kVerticalGap = 10;
  static const Color _kBadgeRed = Color(0xFFDC2626);
  static const Color _kPrimaryBlue = Color(0xFF2F6FED);

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
    this.canCollectPayment = true,
    this.sendToTill,
    this.cartHasItems = false,
    this.sendToTillBusy = false,
  }) : super(key: key);

  final Function ticketHandler;
  final CoreViewModel model;
  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String transactionId;
  final String? wording;
  final SellingMode mode;
  final bool digitalPaymentEnabled;

  /// When false, tender UI's Pay is replaced by Send to Till.
  final bool canCollectPayment;

  /// Parks the cart for till collection (staff only).
  final VoidCallback? sendToTill;

  final bool cartHasItems;
  final bool sendToTillBusy;

  /// Stacked Tickets / Pay instead of a single row.
  ///
  /// We avoid [LayoutBuilder] here: combining it with Riverpod rebuilds and
  /// [Consumer] descendants (e.g. [PreviewSaleButton]) has triggered
  /// re-entrant layout (`!_debugDoingThisLayout`) and unpainted
  /// [_RenderLayoutBuilder] in production.
  ///
  /// Heuristic: narrow checkout pane, or landscape with a short viewport.
  /// Prefers [constraints] from the parent when bounded; falls back to
  /// [MediaQuery] for loose/unbounded parents.
  static bool _useVerticalCheckoutBar(
    BuildContext context, {
    BoxConstraints? constraints,
  }) {
    final width = constraints != null && constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : MediaQuery.sizeOf(context).width;
    final height = constraints != null && constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : MediaQuery.sizeOf(context).height;
    final landscape = constraints != null &&
            constraints.maxWidth.isFinite &&
            constraints.maxHeight.isFinite
        ? constraints.maxWidth > constraints.maxHeight
        : MediaQuery.orientationOf(context) == Orientation.landscape;
    if (width < PosLayoutBreakpoints.payableVerticalBarMaxWidth) return true;
    if (landscape &&
        height < PosLayoutBreakpoints.payableVerticalBarMaxLandscapeHeight) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTickets = ref.watch(
      featureAccessProvider(
        userId: ProxyService.box.getUserId() ?? '',
        featureName: AppFeature.Tickets,
      ),
    );
    // Staff must always reach My Tickets after Send to Till.
    final ticketsVisible = showTickets || !canCollectPayment;
    final pendingCount = ref.watch(pendingTillTicketsCountProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final body = _useVerticalCheckoutBar(
          context,
          constraints: constraints,
        )
            ? _buildVerticalLayout(
                context,
                ref,
                ticketsVisible,
                pendingCount,
              )
            : _buildHorizontalLayout(
                context,
                ref,
                ticketsVisible,
                pendingCount,
              );

        return Padding(
          padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
          child: body,
        );
      },
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    WidgetRef ref,
    bool showTickets,
    int pendingCount,
  ) {
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
              child: _ticketsButton(
                context,
                pendingCount: pendingCount,
                isCompact: true,
              ),
            ),
            const SizedBox(height: _kVerticalGap),
          ],
          SizedBox(
            height: _kBarButtonHeight,
            child: canCollectPayment
                ? PreviewSaleButton(
                    digitalPaymentEnabled: digitalPaymentEnabled,
                    transactionId: transactionId,
                    mode: mode,
                    wording: wording ?? "Pay",
                    completeTransaction: completeTransaction,
                    previewCart: previewCart,
                  )
                : _sendToTillButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    WidgetRef ref,
    bool showTickets,
    int pendingCount,
  ) {
    Widget primaryExpanded({required int flex}) {
      return Expanded(
        flex: flex,
        child: canCollectPayment
            ? PreviewSaleButton(
                digitalPaymentEnabled: digitalPaymentEnabled,
                transactionId: transactionId,
                mode: mode,
                wording: wording ?? "Pay",
                completeTransaction: completeTransaction,
                previewCart: previewCart,
              )
            : _sendToTillButton(context),
      );
    }

    if (!showTickets) {
      return SizedBox(
        width: double.infinity,
        height: _kBarButtonHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[primaryExpanded(flex: 1)],
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
            child: _ticketsButton(
              context,
              pendingCount: pendingCount,
              isCompact: false,
            ),
          ),
          const SizedBox(width: 10),
          primaryExpanded(flex: 3),
        ],
      ),
    );
  }

  Widget _ticketsButton(
    BuildContext context, {
    required int pendingCount,
    required bool isCompact,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: PosTokens.surface,
        foregroundColor: PosTokens.ink2,
        side: const BorderSide(color: PosTokens.line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        ),
      ),
      onPressed: () => ticketHandler(),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(
            FLocalization.of(context).tickets,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: isCompact ? 16 : 17,
            ),
          ),
          if (pendingCount > 0)
            Positioned(
              top: -10,
              right: -16,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(
                  color: _kBadgeRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  pendingCount > 99 ? '99+' : '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sendToTillButton(BuildContext context) {
    final enabled = cartHasItems && !sendToTillBusy && sendToTill != null;
    return SizedBox(
      height: _kBarButtonHeight,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: enabled ? _kPrimaryBlue : const Color(0xFF9CA3AF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9CA3AF),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          ),
        ),
        onPressed: enabled ? sendToTill : null,
        child: sendToTillBusy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'Send to Till →',
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
