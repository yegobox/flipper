import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

/// Handoff `.tag` pill (frequency, terms, etc.).
class AccountingTag extends StatelessWidget {
  const AccountingTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AccountingTokens.surface2,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AccountingTokens.line),
      ),
      child: Text(
        label,
        style: AccountingTokens.sans(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AccountingTokens.ink2,
        ),
      ),
    );
  }
}
