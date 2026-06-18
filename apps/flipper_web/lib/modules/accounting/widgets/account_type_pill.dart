import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flutter/material.dart';

class AccountTypePill extends StatelessWidget {
  const AccountTypePill({super.key, required this.type});

  final AccountType type;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (type) {
      AccountType.asset => (const Color(0xFFEAF1FE), AccountingTokens.accent),
      AccountType.liability => (AccountingTokens.warnTint, AccountingTokens.warnAmber),
      AccountType.equity => (const Color(0xFFF1EBFB), AccountingTokens.violet),
      AccountType.income => (AccountingTokens.gainTint, AccountingTokens.gainInk),
      AccountType.expense => (AccountingTokens.lossTint, AccountingTokens.lossInk),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        type.name,
        style: AccountingTokens.sans(fontSize: 11.5, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
