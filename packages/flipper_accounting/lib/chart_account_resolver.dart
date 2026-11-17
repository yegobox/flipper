import 'package:flipper_accounting/accounting_models.dart';

/// Resolves standard ledger roles to account codes from the live chart of accounts.
class ChartAccountResolver {
  ChartAccountResolver(this.accounts);

  final List<Account> accounts;

  String? get cashOnHand => _byCode('1010') ?? _byName('cash on hand');

  String? get bank => _byCode('1020') ?? _byName('bank', exclude: 'loan');

  String? get mobileMoney =>
      _byCode('1030') ?? _byName('mobile money') ?? _byName('momo');

  String? get receivable => _byCode('1100') ?? _byName('accounts receivable');

  String? get payable =>
      _byCode('2010') ??
      _firstWhere(
        (a) =>
            a.type == AccountType.liability &&
            a.name.toLowerCase().contains('accounts payable'),
      );

  String? get salesRevenue =>
      _byCode('4010') ?? _byName('sales revenue') ?? _byName('sales');

  String? get vatPayable => _byCode('2100') ?? _byName('vat payable');

  /// PAYE withheld from salaries and owed to RRA.
  String? get payePayable => _byCode('2310') ?? _byName('paye payable');

  /// Pension, maternity, occupational hazards and CBHI owed to RSSB.
  String? get rssbPayable => _byCode('2320') ?? _byName('rssb payable');

  /// Net pay owed to staff.
  String? get wagesPayable => _byCode('2300') ?? _byName('wages payable');

  /// Salary advances staff still owe the business.
  String? get staffAdvances => _byCode('1150') ?? _byName('staff advances');

  /// Gross salaries. The name fallbacks take expense accounts only, so a
  /// liability such as "Salaries payable" is never picked as the cost.
  String? get salaries =>
      _byCode('6020') ??
      _byName('salaries', type: AccountType.expense) ??
      _byName('wages', exclude: 'payable', type: AccountType.expense);

  /// The employer's own RSSB contributions (on top of gross pay).
  String? get employerRssb => _byCode('6025') ?? _byName('employer rssb');

  String? get inventory => _byCode('1200') ?? _byName('inventory');

  String? get operatingExpense =>
      _byCode('6000') ??
      _byCode('6010') ??
      _firstWhere(
        (a) =>
            a.type == AccountType.expense &&
            a.sub.toLowerCase().contains('operating'),
      );

  /// Expense accounts sorted by code (for category pickers).
  List<Account> get expenseCategories {
    final rows = accounts.where((a) => a.type == AccountType.expense).toList()
      ..sort((a, b) => a.code.compareTo(b.code));
    return rows;
  }

  /// Credit account for a purchase recorded with [pmtTyCd] (RRA payment codes).
  String? purchaseCreditAccount(String pmtTyCd) {
    switch (pmtTyCd) {
      case '02':
      case '03':
        return payable;
      case '04':
      case '05':
        return bank;
      case '06':
        return mobileMoney;
      case '01':
      case '07':
      default:
        return cashOnHand;
    }
  }

  String? _byCode(String code) =>
      accounts.any((a) => a.code == code) ? code : null;

  String? _byName(String fragment, {String? exclude, AccountType? type}) {
    final q = fragment.toLowerCase();
    final ex = exclude?.toLowerCase();
    return _firstWhere((a) {
      if (type != null && a.type != type) return false;
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
