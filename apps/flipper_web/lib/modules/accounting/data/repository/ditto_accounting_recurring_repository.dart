import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_recurring_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

class DittoAccountingRecurringRepository
    implements AccountingRecurringRepository {
  DittoAccountingRecurringRepository(this._ditto);

  final DittoService _ditto;

  @override
  Stream<List<RecurringSchedule>> watchSchedules({required String businessId}) {
    return _ditto
        .watchCollection(
          'accounting_recurring_schedules',
          'SELECT * FROM accounting_recurring_schedules '
              'WHERE businessId = :businessId',
          {'businessId': businessId},
        )
        .map(
          (rows) =>
              rows.map(DocumentRowMapper.recurringScheduleFromRow).toList()
                ..sort((a, b) => a.id.compareTo(b.id)),
        );
  }

  @override
  Future<void> upsertSchedule({
    required String businessId,
    required RecurringSchedule schedule,
  }) async {
    final docId = schedule.uuid ?? '${businessId}_${schedule.id}';
    final row = DocumentRowMapper.recurringScheduleToRow(
      businessId: businessId,
      schedule: schedule,
      id: docId,
    );
    await _ditto.upsertRecurringSchedule(businessId, row, docId);
  }

  @override
  Future<void> deleteSchedule({
    required String businessId,
    required String scheduleId,
  }) async {
    final docId = '${businessId}_$scheduleId';
    await _ditto.deleteRecurringSchedule(docId);
  }
}
