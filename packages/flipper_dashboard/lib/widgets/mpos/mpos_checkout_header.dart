import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_app_bar.dart';

class MposCheckoutHeader extends StatelessWidget {
  const MposCheckoutHeader({
    super.key,
    required this.itemCount,
    required this.timeLabel,
    required this.status,
    required this.onBack,
  });

  final int itemCount;
  final String timeLabel;
  final String status;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      child: MposAppBar(
        title: context.flipperL10n.checkoutRecoveryCheckout,
        subtitle:
            '${context.flipperL10n.cartItemCount(itemCount)} · $timeLabel',
        status: status,
        onBack: onBack,
        backMaestroId: MaestroIds.mposCheckoutBack,
        backSemanticsLabel: context.flipperL10n.mposBackFromCheckout,
      ),
    );
  }
}
