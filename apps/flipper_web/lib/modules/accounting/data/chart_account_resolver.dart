import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Resolves standard ledger roles to account codes from the live chart of accounts.
class ChartAccountResolver {
  ChartAccountResolver(this.accounts);

  final List<Account> accounts;

  /// Cash on hand (1010 in default COA).
  String? get cashOnHand => _byCode('1010') ?? _byName('cash on hand');

  /// Bank (1020).
  String? get bank => _byCode('1020') ?? _byName('bank', exclude: 'loan');

  /// Mobile money (1030).
  String? get mobileMoney =>
      _byCode('1030') ?? _byName('mobile money') ?? _byName('momo');

  /// Accounts receivable (1100).
  String? get receivable =>
      _byCode('1100') ?? _byName('accounts receivable');

  /// Accounts payable (2010), excluding VAT/wages payables.
  String? get payable =>
      _byCode('2010') ??
      _firstWhere(
        (a) =>
            a.type == AccountType.liability &&
            a.name.toLowerCase().contains('accounts payable'),
      );

  /// Sales revenue (4010).
  String? get salesRevenue =>
      _byCode('4010') ?? _byName('sales revenue') ?? _byName('sales');

  /// VAT payable (2100).
  String? get vatPayable =>
      _byCode('2100') ?? _byName('vat payable');

  /// Inventory (1200).
  String? get inventory =>
      _byCode('1200') ?? _byName('inventory');

  /// Generic operating expense bucket (6000) or first opex line.
  String? get operatingExpense =>
      _byCode('6000') ??
      _byCode('6010') ??
      _firstWhere(
        (a) =>
            a.type == AccountType.expense &&
            a.sub.toLowerCase().contains('operating'),
      );

  String? _byCode(String code) =>
      accounts.any((a) => a.code == code) ? code : null;

  String? _byName(String fragment, {String? exclude}) {
    final q = fragment.toLowerCase();
    final ex = exclude?.toLowerCase();
    return _firstWhere((a) {
      final name = a.name.toLowerCase();
      if (!name.contains(q)) return false;
      if (ex != null && name.contains(ex)) return false;
      return true;
    });
  }

  String? _firstWhere(bool Function(Account a) test) {
    for (final a in accounts) {
      if (test(a)) return a.code;
    }
    return null;
  }
}
