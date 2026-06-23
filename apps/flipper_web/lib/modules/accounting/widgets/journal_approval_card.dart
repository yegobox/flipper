import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

/// Pending journal entry card — matches design handoff `.macc-je` (mobile.css).
class JournalApprovalCard extends StatelessWidget {
  const JournalApprovalCard({
    super.key,
    required this.entry,
    required this.action,
    required this.accountMap,
    required this.onApprove,
    required this.onReject,
    this.isApproving = false,
  });

  final JournalEntry entry;
  final ApprovalAction? action;
  final Map<String, Account> accountMap;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isApproving;

  static const _cardShadow = [
    BoxShadow(
      color: Color(0x0F0B1220),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A0B1220),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const _approveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  );

  static const _approveShadow = [
    BoxShadow(
      color: Color(0x382563EB),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = jeTotals(entry);
    final done = action != null;
    final busy = isApproving && !done;

    return Opacity(
      opacity: done ? 0.55 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AccountingTokens.surface,
          borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
          border: Border.all(color: AccountingTokens.line),
          boxShadow: _cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        entry.id,
                        style: AccountingTokens.mono(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AccountingTokens.ink2,
                        ),
                      ),
                      const Spacer(),
                      _PendingPill(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.memo,
                    style: AccountingTokens.sans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${entry.date} · ${entry.ref} · via ${entry.src}',
                    style: AccountingTokens.sans(
                      fontSize: 11.5,
                      color: AccountingTokens.ink3,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                children: [
                  for (var i = 0; i < entry.lines.length; i++)
                    _JournalLineRow(
                      line: entry.lines[i],
                      accountMap: accountMap,
                      showTopBorder: true,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 9),
              color: AccountingTokens.gainTint,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check,
                    size: 14,
                    color: AccountingTokens.gainInk,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Balanced · ${money(t.dr)} = ${money(t.cr)}',
                    style: AccountingTokens.sans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AccountingTokens.gainInk,
                    ),
                  ),
                ],
              ),
            ),
            if (done)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action == ApprovalAction.approve
                          ? Icons.check
                          : Icons.close,
                      size: 16,
                      color: AccountingTokens.gainInk,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      action == ApprovalAction.approve
                          ? 'Approved & posted'
                          : 'Sent back to drafts',
                      style: AccountingTokens.sans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AccountingTokens.gainInk,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Reject',
                        icon: Icons.close,
                        onPressed: busy ? null : onReject,
                        filled: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        label: 'Approve',
                        icon: Icons.check,
                        onPressed: busy ? null : onApprove,
                        filled: true,
                        isLoading: busy,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PendingPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AccountingTokens.warnTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFE89A2A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'pending',
            style: AccountingTokens.sans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AccountingTokens.warnAmber,
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalLineRow extends StatelessWidget {
  const _JournalLineRow({
    required this.line,
    required this.accountMap,
    required this.showTopBorder,
  });

  final JournalLine line;
  final Map<String, Account> accountMap;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final isDr = line.dr > 0;
    final amount = isDr ? line.dr : line.cr;
    final name = acctName(line.ac, accountMap);

    return Column(
      children: [
        if (showTopBorder) const _DashedTopBorder(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDr
                      ? const Color(0x1A1D4ED8)
                      : const Color(0x1A0F766E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isDr ? 'Dr' : 'Cr',
                  style: AccountingTokens.sans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDr ? AccountingTokens.drInk : AccountingTokens.crInk,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: AccountingTokens.sans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' ${line.ac}',
                        style: AccountingTokens.mono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AccountingTokens.ink4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                money(amount),
                style: AccountingTokens.mono(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDr ? AccountingTokens.drInk : AccountingTokens.crInk,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedTopBorder extends StatelessWidget {
  const _DashedTopBorder();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          children: [
            for (var i = 0; i < count; i++) ...[
              Container(
                width: dashWidth,
                height: 1,
                color: AccountingTokens.line,
              ),
              if (i < count - 1) SizedBox(width: gap),
            ],
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.filled,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: filled ? 20 : 18,
            height: filled ? 20 : 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: filled ? Colors.white : AccountingTokens.accent,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: filled ? 17 : 16, color: filled ? Colors.white : AccountingTokens.ink2),
              const SizedBox(width: 7),
              Text(
                label,
                style: AccountingTokens.sans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: filled ? Colors.white : AccountingTokens.ink2,
                ),
              ),
            ],
          );

    if (filled) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
          child: Ink(
            height: 46,
            decoration: BoxDecoration(
              gradient: JournalApprovalCard._approveGradient,
              borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
              boxShadow: JournalApprovalCard._approveShadow,
            ),
            child: Center(child: child),
          ),
        ),
      );
    }

    return Material(
      color: AccountingTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
        side: const BorderSide(color: AccountingTokens.lineStrong, width: 1.5),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusMd),
        child: SizedBox(
          height: 46,
          child: Center(child: child),
        ),
      ),
    );
  }
}
