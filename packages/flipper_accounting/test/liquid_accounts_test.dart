import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/liquid_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a provider account rolls up into its group', () {
    expect(liquidGroupOf('1021'), kBankAccountCode);
    expect(liquidGroupOf('1024'), kBankAccountCode);
    expect(liquidGroupOf('1031'), kMobileMoneyAccountCode);
    expect(liquidGroupOf('1020'), kBankAccountCode);
    expect(liquidGroupOf('1010'), kCashAccountCode);
    expect(liquidGroupOf('1100'), '1100');
    expect(liquidGroupOf('10210'), '10210');
  });

  test('only cash, banks and wallets are money accounts', () {
    for (final code in ['1010', '1020', '1022', '1030', '1032']) {
      expect(isLiquidAccount(code), isTrue, reason: code);
    }
    for (final code in ['1100', '1200', '4010', '']) {
      expect(isLiquidAccount(code), isFalse, reason: code);
    }
  });

  test('provider accounts sit in a group and are never seeded', () {
    final seeded = {for (final a in defaultChartOfAccountsSeed) a.code};
    for (final p in providerAccounts) {
      expect(liquidGroupOf(p.code), isNot(p.code), reason: p.code);
      expect(seeded, isNot(contains(p.code)), reason: p.code);
      expect(providerAccountFor(p.code), p);
      expect(providerChartAccount(p).code, p.code);
    }
    expect(providerAccountFor('1020'), isNull);
  });
}
