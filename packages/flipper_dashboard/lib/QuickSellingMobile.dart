// ignore_for_file: unused_result

import 'package:flipper_dashboard/mobile_checkout_screen.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

export 'package:flipper_dashboard/mobile_checkout_screen.dart' show ChargeButtonState;

/// Mobile POS checkout entry ([design_handoff_mobile_pos]).
class QuickSellingMobile {
  /// Opens full-screen checkout (replaces legacy bottom sheet).
  static Future<void> openCheckout({
    required BuildContext context,
    required WidgetRef ref,
    required Function doneDelete,
    required Function onCharge,
    ITransaction? transaction,
  }) async {
    if (transaction == null) return;

    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => MobileCheckoutScreen(
            transaction: transaction,
            doneDelete: doneDelete,
            onCharge: onCharge,
          ),
        ),
      );
    } finally {
      clearPinnedPosCartTransactionContainer(ref.container);
    }
  }

  @Deprecated('Use openCheckout')
  static void showBottom({
    required BuildContext context,
    required WidgetRef ref,
    required Function doneDelete,
    required Function onCharge,
    ITransaction? transaction,
  }) {
    openCheckout(
      context: context,
      ref: ref,
      doneDelete: doneDelete,
      onCharge: onCharge,
      transaction: transaction,
    );
  }
}
