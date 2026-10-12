import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';

class MposCheckoutFooter extends StatelessWidget {
  const MposCheckoutFooter({
    super.key,
    required this.total,
    required this.ready,
    required this.isLoading,
    required this.primaryLabel,
    required this.onSaveTicket,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryLoading = false,
    this.primaryNeedsInput = false,
  });

  final double total;
  final bool ready;
  final bool isLoading;
  final String primaryLabel;
  final VoidCallback? onSaveTicket;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool secondaryLoading;

  /// The primary button collects something the sale still needs (a customer)
  /// rather than charging: tappable while not [ready], blue, no check mark.
  final bool primaryNeedsInput;

  @override
  Widget build(BuildContext context) {
    final hasSecondary = secondaryLabel != null && onSecondary != null;

    return Container(
      decoration: const BoxDecoration(
        color: PosTokens.surface,
        border: Border(top: BorderSide(color: PosTokens.line)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          if (onSaveTicket != null)
            MaestroSemantics(
              id: MaestroIds.mposSaveTicket,
              label: context.flipperL10n.saveTicketAction,
              button: true,
              enabled: true,
              child: TextButton(
                onPressed: onSaveTicket,
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    110,
                    MposTokens.checkoutPrimaryHeight,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: PosTokens.surface2,
                  foregroundColor: PosTokens.ink2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: PosTokens.line, width: 1.5),
                  ),
                ),
                child: Text(
                  context.flipperL10n.saveTicketAction,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (onSaveTicket != null) const SizedBox(width: 11),
          if (hasSecondary) ...[
            Expanded(
              child: _PayButton(
                semanticId: MaestroIds.mposCheckoutSecondary,
                label: secondaryLabel!,
                total: total,
                ready: ready,
                isLoading: secondaryLoading,
                onPressed: onSecondary,
                // Two actions side by side: the secondary is outlined so the
                // pair reads apart without leaving the brand blue.
                outlined: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PayButton(
                semanticId: MaestroIds.mposCheckoutPrimary,
                label: primaryLabel,
                total: total,
                ready: ready,
                isLoading: isLoading,
                onPressed: onPrimary,
              ),
            ),
          ] else
            Expanded(
              child: _PayButton(
                semanticId: MaestroIds.mposCheckoutPrimary,
                label: primaryLabel,
                total: total,
                ready: ready,
                isLoading: isLoading,
                onPressed: onPrimary,
                needsInput: primaryNeedsInput,
              ),
            ),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton({
    required this.semanticId,
    required this.label,
    required this.total,
    required this.ready,
    required this.isLoading,
    required this.onPressed,
    this.outlined = false,
    this.needsInput = false,
  });

  final String semanticId;
  final String label;
  final double total;
  final bool ready;
  final bool isLoading;
  final VoidCallback? onPressed;

  /// Brand-blue outline on a blue tint instead of the filled gradient.
  final bool outlined;
  final bool needsInput;

  @override
  Widget build(BuildContext context) {
    final enabled = (ready || needsInput) && onPressed != null && !isLoading;
    // Brand blue only — the POS has no green action colour.
    final ink = outlined ? PosTokens.blue : Colors.white;

    return MaestroSemantics(
      id: semanticId,
      label: label,
      button: true,
      enabled: enabled,
      value: 'RWF ${mposMoneyLabel(total)}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            height: MposTokens.checkoutPrimaryHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: enabled && !outlined ? MposTokens.gradBtn : null,
              color: !enabled
                  ? PosTokens.ink4.withValues(alpha: 0.35)
                  : outlined
                  ? PosTokens.blueTint
                  : null,
              border: enabled && outlined
                  ? Border.all(color: PosTokens.blue, width: 1.5)
                  : null,
              boxShadow: enabled && !outlined ? MposTokens.shadowBlue : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ink,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ready) ...[
                          Icon(Icons.check_rounded, size: 19, color: ink),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            label.contains('RWF')
                                ? label
                                : '$label · RWF ${mposMoneyLabel(total)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
