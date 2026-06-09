import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flutter/material.dart';

enum AccountingToastTone { info, success, warn }

void showAccountingToast(
  BuildContext context,
  String title, {
  String? subtitle,
  AccIcon? accIcon,
  IconData? icon,
  AccountingToastTone tone = AccountingToastTone.info,
}) {
  final (Color bg, Color fg) = switch (tone) {
    AccountingToastTone.success => (AccountingTokens.gainInk, Colors.white),
    AccountingToastTone.warn => (const Color(0xFFE89A2A), const Color(0xFF3A2400)),
    AccountingToastTone.info => (AccountingTokens.accent, Colors.white),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0E1626),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: accIcon != null
                  ? AccountingIcon(icon: accIcon, size: 18, color: fg)
                  : Icon(icon ?? Icons.info_outline, size: 18, color: fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AccountingTokens.sans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AccountingTokens.sans(
                        fontSize: 12,
                        color: const Color(0xFF97A6C2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
