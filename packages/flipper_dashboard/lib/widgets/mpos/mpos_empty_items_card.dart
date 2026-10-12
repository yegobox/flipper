import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Items section of mobile checkout when the sale has no lines.
///
/// A collected ticket whose lines have not synced to this phone yet is not an
/// empty sale, so it says what it is waiting for instead of "no items".
class MposEmptyItemsCard extends ConsumerWidget {
  const MposEmptyItemsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    if (!ref.watch(settlingTicketAwaitingLinesProvider)) {
      return MposCard(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            l10n.mposNoItemsInCart,
            style: const TextStyle(color: PosTokens.ink3),
          ),
        ),
      );
    }
    return MposCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: PosTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.ticketLinesSyncingTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: PosTokens.ink2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.ticketLinesSyncing,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: PosTokens.ink3,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
