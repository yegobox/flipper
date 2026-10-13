import 'dart:async';

import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/mpos_momo_phone_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Call from a checkout route's `build`: when another till takes over the
/// resumed ticket this route holds ([pinnedCartTakenOverIdProvider]), drop it
/// from this till's cart and close the route.
///
/// It does not re-park: the ticket belongs to the other till now. It clears
/// every local copy of the ticket itself ([clearLocalCartForTicket]): the
/// catalog underneath may not be mounted to do it, and once the pin is gone it
/// no longer would. [onLeaving] runs before the route closes so its dispose can
/// skip its own re-park.
void listenForTakenOverTicket(
  WidgetRef ref,
  BuildContext context, {
  required String branchId,
  required VoidCallback onLeaving,
}) {
  ref.listen<String?>(pinnedCartTakenOverIdProvider, (previous, next) {
    if (next == null || next == previous) return;
    // Captured now: by the time the confirmation returns, a dialog or sheet
    // may cover this route, and a plain pop would close only that.
    final route = ModalRoute.of(context);
    unawaited(() async {
      if (!await confirmPinnedCartTakenOver(ref, next) || !context.mounted) {
        return;
      }
      if (ref.read(settlingTillTicketProvider)?.transactionId == next) {
        ref.read(settlingTillTicketProvider.notifier).state = null;
      }
      clearPinnedPosCartTransactionIfWidget(ref, transactionId: next);
      await clearLocalCartForTicket(ref, next, branchId: branchId);
      if (!context.mounted) return;
      onLeaving();
      showErrorNotification(
        context,
        context.flipperL10n.ticketTakenOverByAnotherTill,
      );
      // Close whatever covers checkout, then checkout itself; a route that is
      // already gone is left alone rather than popping an unrelated one.
      final navigator = route?.navigator;
      if (route == null || navigator == null || !route.isActive) return;
      navigator.popUntil((r) => r == route);
      navigator.pop();
    }());
  });
}

/// Clears every local representation of [transactionId] — cached pending
/// cart, optimistic lines, item stream and customer / tender fields — so a
/// ticket that left this device cannot flash as the next sale's cart.
Future<void> clearLocalCartForTicket(
  WidgetRef ref,
  String transactionId, {
  required String branchId,
}) async {
  ref.read(suppressedCartTransactionIdProvider.notifier).state = transactionId;
  ref.read(optimisticCartProvider.notifier).clearForTransaction(transactionId);
  clearCachedPendingCartTransactionWidget(ref, isExpense: false);
  ref.invalidate(
    transactionItemsStreamProvider(
      transactionId: transactionId,
      branchId: branchId,
    ),
  );
  ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
  ref.read(customerPhoneNumberProvider.notifier).state = null;
  ref.read(mposMomoPhoneProvider.notifier).state = null;
  await ProxyService.box.writeString(key: 'customerName', value: '');
  await ProxyService.box.writeString(
    key: 'currentSaleCustomerPhoneNumber',
    value: '',
  );
}
