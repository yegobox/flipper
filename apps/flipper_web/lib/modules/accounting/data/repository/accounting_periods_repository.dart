import 'package:flipper_web/modules/accounting/data/fiscal_period_models.dart';

/// Backend-agnostic contract for fiscal periods.
abstract class AccountingPeriodsRepository {
  Stream<List<FiscalPeriod>> watchPeriods({required String businessId});

  /// Creates or updates the period row. Used for both close and reopen, so the
  /// caller decides the new status and the audit fields that go with it.
  Future<void> upsertPeriod({
    required String businessId,
    required FiscalPeriod period,
  });
}
