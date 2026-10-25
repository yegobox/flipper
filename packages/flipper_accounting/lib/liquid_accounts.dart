import 'package:flipper_accounting/accounting_models.dart';

/// The money accounts: Cash on Hand, Bank and Mobile Money (seeded), and one
/// account per real bank account or wallet under Bank (102x) and Mobile Money
/// (103x), as an accountant keeps them. BK to Equity is then a transfer
/// between two accounts, not a move within one.
///
/// The provider accounts are not seeded: the data-connector adds one the
/// first time that provider's SMS lands (`PROVIDER_ACCOUNTS` in
/// `data-connector/src/accounting/bootstrap.rs`; keep the two lists equal).
/// Bank (1020) and Mobile Money (1030) stay as clearing accounts for tenders
/// that do not say which bank or wallet, such as a POS card sale; the SMS
/// review moves the money from there into the provider's account.
const kCashAccountCode = '1010';
const kBankAccountCode = '1020';
const kMobileMoneyAccountCode = '1030';

/// A provider's own account. [providerLabel] is the name the SMS review and
/// the bank-balance API use for it.
typedef ProviderAccount = ({String code, String name, String providerLabel});

const providerAccounts = <ProviderAccount>[
  (code: '1021', name: 'Bank · BK', providerLabel: 'BK'),
  (code: '1022', name: 'Bank · Equity', providerLabel: 'Equity'),
  (code: '1023', name: 'Bank · I&M', providerLabel: 'I&M'),
  (code: '1024', name: 'Bank · BPR', providerLabel: 'BPR'),
  (code: '1031', name: 'Mobile Money · MTN', providerLabel: 'MTN MoMo'),
  (code: '1032', name: 'Mobile Money · Airtel', providerLabel: 'Airtel Money'),
];

ProviderAccount? providerAccountFor(String code) {
  for (final a in providerAccounts) {
    if (a.code == code) return a;
  }
  return null;
}

/// The group a money account rolls up into: 1021 → Bank (1020), 1031 →
/// Mobile Money (1030). Any other code is its own group.
String liquidGroupOf(String code) {
  if (code.length == 4 && code.startsWith('102')) return kBankAccountCode;
  if (code.length == 4 && code.startsWith('103')) {
    return kMobileMoneyAccountCode;
  }
  return code;
}

/// Cash, a bank or a wallet: an account money can be moved between.
bool isLiquidAccount(String code) => switch (liquidGroupOf(code)) {
  kCashAccountCode || kBankAccountCode || kMobileMoneyAccountCode => true,
  _ => false,
};

/// [provider] as a chart-of-accounts account, for adding it when an SMS
/// names it before the connector's copy has synced.
Account providerChartAccount(ProviderAccount provider) => Account(
  code: provider.code,
  name: provider.name,
  type: AccountType.asset,
  sub: 'Current assets',
  normal: AccountNormal.debit,
  bal: 0,
);
