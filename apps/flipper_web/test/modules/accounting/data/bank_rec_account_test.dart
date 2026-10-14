import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import '../../../helpers/accounting_unit_test_overrides.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records which ledger account the bank-rec screen asked for.
class _RecordingLedger extends FakeAccountingLedgerRepository {
  final codes = <String>[];

  @override
  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) {
    codes.add(bankAccountCode);
    return Stream.value(const []);
  }
}

void main() {
  test(
    'bank reconciliation reads the account picked: Bank, then MoMo',
    () async {
      final ledger = _RecordingLedger();
      final container = ProviderContainer(
        overrides: [
          ...accountingUnitTestOverrides(),
          accountingLedgerRepositoryProvider.overrideWithValue(ledger),
          accountingBusinessIdProvider.overrideWithValue('biz'),
        ],
      );
      addTearDown(container.dispose);

      container.listen(bankLinesStreamProvider, (_, _) {});
      await container.read(bankLinesStreamProvider.future);
      expect(ledger.codes.last, '1020');

      // SMS Bridge MoMo / Airtel lines live on Mobile money (1030).
      container.read(bankRecAccountCodeProvider.notifier).state = '1030';
      await container.read(bankLinesStreamProvider.future);
      expect(ledger.codes.last, '1030');
    },
  );
}
