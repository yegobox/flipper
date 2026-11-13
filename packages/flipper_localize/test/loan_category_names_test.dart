import 'package:flipper_localize/src/l10n/flipper_app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// data-connector routes Cash Book movements to 2200 Bank Loan by category
/// name (`accounting::semantics::LOAN_RECEIVED_NAMES` /
/// `LOAN_REPAYMENT_NAMES`). Categories are created from these translated
/// suggestions, so a translation that changes here must change there too,
/// or that language's loans silently land in Owner's Capital / expenses.
const _connectorLoanReceived = {
  'Loan received',
  'Prêt reçu',
  'Inguzanyo yakiriwe',
  'Mkopo uliopokelewa',
};
const _connectorLoanRepayment = {
  'Loan repayment',
  'Remboursement de prêt',
  'Kwishyura inguzanyo',
  'Marejesho ya mkopo',
};

void main() {
  for (final code in ['en', 'fr', 'rw', 'sw']) {
    test('$code loan category names match data-connector', () {
      final l10n = lookupFlipperAppLocalizations(Locale(code));
      expect(
        _connectorLoanReceived,
        contains(l10n.cashbookSuggestLoanReceived),
      );
      expect(
        _connectorLoanRepayment,
        contains(l10n.cashbookSuggestLoanRepayment),
      );
      // Interest is an expense: it must never read as a repayment.
      expect(
        _connectorLoanRepayment,
        isNot(contains(l10n.cashbookSuggestLoanInterest)),
      );
    });
  }
}
