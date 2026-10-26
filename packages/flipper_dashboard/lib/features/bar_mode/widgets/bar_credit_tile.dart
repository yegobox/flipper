import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Credit" tender on the settle screen.
///
/// Full width like [BarRoomChargeTile], and for the same reason: no money is
/// taken now, and it has a person (and a due date) to name once chosen.
class BarCreditTile extends StatelessWidget {
  const BarCreditTile({
    super.key,
    required this.selected,
    required this.terms,
    required this.onTap,
  });

  final bool selected;

  /// The debtor and due date picked so far — null until chosen.
  final BarCreditTerms? terms;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ink = selected ? BarTokens.blue : BarTokens.ink3;
    final chosen = terms;
    final l10n = context.flipperL10n;

    return Material(
      color: selected ? BarTokens.blueTint : BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(
              color: selected ? BarTokens.blue : BarTokens.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule_outlined, size: 22, color: ink),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.barCredit,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: selected ? BarTokens.blue : BarTokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      chosen == null
                          ? l10n.barCreditTileSubtitle
                          : '${chosen.customerName} · '
                                '${l10n.barCreditDue(barCreditDate(context, chosen.dueDate))}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        color: chosen == null ? BarTokens.ink3 : ink,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                chosen == null ? l10n.barChoose : l10n.barChange,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: BarTokens.blue,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 18, color: BarTokens.blue),
            ],
          ),
        ),
      ),
    );
  }
}
