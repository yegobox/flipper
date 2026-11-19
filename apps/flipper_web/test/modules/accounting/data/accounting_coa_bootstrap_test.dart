import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/accounting_unit_test_overrides.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

void main() {
  test(
    'opening Books seeds the chart and logs diagnostics in debug only',
    () async {
      final logs = <String>[];
      final print = debugPrint;
      debugPrint = (String? m, {int? wrapWidth}) => logs.add(m ?? '');
      addTearDown(() => debugPrint = print);

      final container = ProviderContainer(
        overrides: [
          ...accountingUnitTestOverrides(),
          selectedBusinessRestoreProvider.overrideWith((ref) async {}),
          accountingBusinessIdProvider.overrideWithValue('biz'),
          accountingBranchIdProvider.overrideWithValue('branch'),
          accountingLedgerRepositoryProvider.overrideWithValue(
            FakeAccountingLedgerRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(accountingCoaBootstrapProvider.future);

      expect(logs, contains(contains('ensureSeeded OK')));
      // Tests run in debug mode, where the startup diagnostics still run.
      expect(kDebugMode, isTrue);
      expect(logs, contains(contains('── startup complete ──')));
    },
  );
}
