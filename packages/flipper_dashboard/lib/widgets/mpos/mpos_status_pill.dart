import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';

class MposStatusPill extends StatelessWidget {
  const MposStatusPill({super.key, required this.status});

  final String status;

  (Color bg, Color fg) _colors() {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'PAID':
        return (MposTokens.gainTint, MposTokens.gainInk);
      case 'CANCELLED':
        return (MposTokens.lossTint, MposTokens.lossInk);
      default:
        return (MposTokens.pendTint, MposTokens.pend);
    }
  }

  /// [status] is the raw transaction status; only the label is localized.
  String _label(FlipperAppLocalizations l10n) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return l10n.mposStatusPending;
      case 'COMPLETED':
        return l10n.mposStatusCompleted;
      case 'PAID':
        return l10n.mposStatusPaid;
      case 'CANCELLED':
        return l10n.mposStatusCancelled;
      case 'PARKED':
        return l10n.mposStatusParked;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors();
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _label(context.flipperL10n).toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.04 * 11.5,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
