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
              label: 'Save ticket',
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
                child: const Text(
                  'Save ticket',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
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
                useGreen: false,
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
                useGreen: true,
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
                useGreen: ready,
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
    required this.useGreen,
  });

  final String semanticId;
  final String label;
  final double total;
  final bool ready;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool useGreen;

  @override
  Widget build(BuildContext context) {
    final enabled = ready && onPressed != null && !isLoading;
    final gradient = useGreen && ready
        ? MposTokens.gradPayReady
        : MposTokens.gradBtn;
    final shadows = useGreen && ready
        ? MposTokens.shadowPayReady
        : MposTokens.shadowBlue;

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
              gradient: enabled ? gradient : null,
              color: enabled ? null : PosTokens.ink4.withValues(alpha: 0.35),
              boxShadow: enabled ? shadows : null,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ready) ...[
                          const Icon(
                            Icons.check_rounded,
                            size: 19,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Text(
                            label.contains('RWF')
                                ? label
                                : '$label · RWF ${mposMoneyLabel(total)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
