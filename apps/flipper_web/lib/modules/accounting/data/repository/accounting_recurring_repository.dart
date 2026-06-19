import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';

/// Backend-agnostic contract for recurring-schedule persistence.
abstract class AccountingRecurringRepository {
  Stream<List<RecurringSchedule>> watchSchedules({required String businessId});

  Future<void> upsertSchedule({
    required String businessId,
    required RecurringSchedule schedule,
  });

  Future<void> deleteSchedule({
    required String businessId,
    required String scheduleId,
  });
}
