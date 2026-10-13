import 'dart:async';

import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/services/branch_transfer_service.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/taken_over_ticket_exit.dart';
import 'package:flipper_dashboard/widgets/checkout_mode_bar.dart';
import 'package:flipper_dashboard/widgets/checkout_transfer_branch_row.dart';
import 'package:flipper_dashboard/widgets/checkout_transfer_footer.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart' as tv_talk;
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

export 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart'
    show CheckoutCartMode, canOfferBranchTransferProvider;

/// Sale | Transfer strip for mobile checkout, plus the destination picker
/// while in Transfer. Mode is the route's own state, never the desktop
/// [checkoutCartModeProvider].
class MposTransferModeBar extends StatelessWidget {
  const MposTransferModeBar({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  final CheckoutCartMode mode;
  final ValueChanged<CheckoutCartMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckoutModeBar(mode: mode, onModeChanged: onModeChanged),
        if (mode == CheckoutCartMode.transfer)
          const ColoredBox(
            color: PosTokens.surface,
            child: CheckoutTransferBranchRow(),
          ),
      ],
    );
  }
}

/// Mobile checkout footer in Transfer mode: Clear + Transfer to the branch
/// picked in [CheckoutTransferBranchRow].
///
/// Same flow as desktop `QuickSellingView._confirmOutgoingTransfer`; on
/// success the cart is dropped like Send to till and checkout closes back to
/// the catalog, where a fresh pending cart forms.
class MposBranchTransferFooter extends ConsumerStatefulWidget {
  /// Positional to keep `mobile_checkout_screen.dart` under the file-size cap.
  const MposBranchTransferFooter(
    this.transaction,
    this.branchId,
    this.itemCount, {
    super.key,
  });

  final ITransaction transaction;

  /// Source branch (the cart's own branch).
  final String branchId;
  final int itemCount;

  @override
  ConsumerState<MposBranchTransferFooter> createState() =>
      _MposBranchTransferFooterState();
}

class _MposBranchTransferFooterState
    extends ConsumerState<MposBranchTransferFooter> {
  bool _busy = false;

  Future<void> _clear() async {
    final txnId = widget.transaction.id;
    try {
      await BranchTransferService().clearCart(transactionId: txnId);
      if (!mounted) return;
      ref.read(optimisticCartProvider.notifier).clearForTransaction(txnId);
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: txnId,
          branchId: widget.branchId,
        ),
      );
    } catch (e, s) {
      tv_talk.talker.error('Failed to clear mobile transfer cart', e, s);
      if (mounted) {
        showErrorNotification(context, context.flipperL10n.failedToClearCart);
      }
    }
  }

  Future<void> _transfer() async {
    if (!ref.read(canSellProvider)) {
      showErrorNotification(
        context,
        context.flipperL10n.viewOnlyCannotTransferStock,
      );
      return;
    }
    if (_busy) return;
    final txn = widget.transaction;
    final dest = ref.read(transferDestinationBranchProvider);
    if (dest == null) {
      showErrorNotification(
        context,
        context.flipperL10n.selectDestinationBranch,
      );
      return;
    }
    final sourceId = widget.branchId;
    if (sourceId.isEmpty || sourceId == '0') {
      showErrorNotification(
        context,
        context.flipperL10n.currentBranchIsMissing,
      );
      return;
    }
    final items = ref
        .read(posCartDisplayItemsProvider)
        .where((i) => i.active != false)
        .toList();
    if (items.isEmpty) {
      showErrorNotification(
        context,
        context.flipperL10n.addItemsBeforeTransferring,
      );
      return;
    }

    setState(() => _busy = true);
    try {
      final service = BranchTransferService();
      await service.confirmBranchTransfer(
        context: context,
        items: items,
        sourceBranchId: sourceId,
        destinationBranchId: dest.id,
        destinationBranchName: dest.name,
      );
      await service.finalizeCartAfterTransfer(transaction: txn, items: items);

      if (!mounted) return;
      ref.read(transferDestinationBranchProvider.notifier).state = null;
      clearPinnedPosCartTransactionIfWidget(ref, transactionId: txn.id);
      await clearLocalCartForTicket(ref, txn.id, branchId: sourceId);

      if (!mounted) return;
      final destName = dest.name ?? context.flipperL10n.branch;
      showSuccessNotification(
        context,
        context.flipperL10n.transferredItemsToBranch(items.length, destName),
      );
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) {
        await rootNav.maybePop();
      }
    } catch (e, s) {
      tv_talk.talker.error('Mobile outgoing branch transfer failed', e, s);
      if (mounted) {
        showErrorNotification(
          context,
          e is StateError || e is Exception
              ? e.toString().replaceFirst(RegExp(r'^Exception: '), '')
              : context.flipperL10n.transferFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PosTokens.surface,
        border: Border(top: BorderSide(color: PosTokens.line)),
      ),
      padding: EdgeInsets.fromLTRB(
        8,
        4,
        8,
        8 + MediaQuery.paddingOf(context).bottom,
      ),
      child: CheckoutTransferFooter(
        itemCount: widget.itemCount,
        busy: _busy,
        onClear: () => unawaited(_clear()),
        onTransfer: () => unawaited(_transfer()),
      ),
    );
  }
}
