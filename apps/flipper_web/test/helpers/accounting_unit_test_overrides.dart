import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Overrides for accounting provider unit tests.
///
/// Default runtime strategy is Ditto; until [dittoReadyProvider] is true the
/// transaction/ledger stream providers emit nothing and `.future` never
/// completes. Tests use in-memory fakes — force Supabase strategy here.
List<Override> accountingUnitTestOverrides() => [
  accountingBackendStrategyProvider.overrideWithValue(
    AccountingBackendStrategy.supabase,
  ),
];
