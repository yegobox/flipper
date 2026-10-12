import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Call from a checkout route's `build`: when another till takes over the
/// resumed ticket this route holds ([pinnedCartTakenOverIdProvider]), drop it
/// from this till's cart and close the route.
///
/// It does not re-park: the ticket belongs to the other till now. [onLeaving]
/// runs before the pop so the route's dispose can skip its own re-park.
void listenForTakenOverTicket(
  WidgetRef ref,
  BuildContext context,
  VoidCallback onLeaving,
) {
  ref.listen<String?>(pinnedCartTakenOverIdProvider, (previous, next) {
    if (next == null || next == previous) return;
    unawaited(() async {
      if (!await confirmPinnedCartTakenOver(ref, next) || !context.mounted) {
        return;
      }
      if (ref.read(settlingTillTicketProvider)?.transactionId == next) {
        ref.read(settlingTillTicketProvider.notifier).state = null;
      }
      clearPinnedPosCartTransactionIfWidget(ref, transactionId: next);
      ref.read(suppressedCartTransactionIdProvider.notifier).state = next;
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
      onLeaving();
      showErrorNotification(
        context,
        context.flipperL10n.ticketTakenOverByAnotherTill,
      );
      Navigator.of(context).pop();
    }());
  });
}
