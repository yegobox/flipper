import 'package:flipper_accounting/accounting_ledger_repository.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';

/// Accounts for payroll and the money a business pays to RRA and RSSB.
///
/// New charts get them from [defaultChartOfAccountsSeed]. A chart seeded
/// before they existed gets each one the first time something posts to it,
/// through [ensureChartAccounts].
const staffAdvancesCode = '1150';
const wagesPayableCode = '2300';
const payePayableCode = '2310';
const rssbPayableCode = '2320';
const salariesCode = '6020';
const employerRssbCode = '6025';

/// The seed's definition of [code], or null when the seed has no such code.
Account? seedAccount(String code) {
  for (final a in defaultChartOfAccountsSeed) {
    if (a.code == code) return a;
  }
  return null;
}

/// Adds each seed account in [codes] that [existingCodes] does not hold.
///
/// A code another device added in the meantime is left alone:
/// [AccountingLedgerRepository.createChartOfAccount] refuses a duplicate with
/// a [StateError], which is the outcome wanted here. Codes the seed does not
/// define are skipped, so a chart that renamed or renumbered an account keeps
/// its own.
Future<void> ensureChartAccounts(
  AccountingLedgerRepository repo, {
  required String businessId,
  required Iterable<String> codes,
  required Set<String> existingCodes,
}) async {
  for (final code in codes.toSet()) {
    if (existingCodes.contains(code)) continue;
    final account = seedAccount(code);
    if (account == null) continue;
    try {
      await repo.createChartOfAccount(businessId: businessId, account: account);
    } on StateError {
      // Already there.
    }
  }
}
