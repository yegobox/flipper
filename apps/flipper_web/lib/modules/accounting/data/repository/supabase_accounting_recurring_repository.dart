import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_recurring_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAccountingRecurringRepository
    implements AccountingRecurringRepository {
  const SupabaseAccountingRecurringRepository(this._client);

  final SupabaseClient _client;

  static const _table = 'accounting_recurring_schedules';

  // camelCase mirrors are written for Ditto only; PostgREST uses snake_case.
  static const _dittoOnlyKeys = {
    'businessId',
    'localId',
    'dayLabel',
    'nextRun',
    'debitCode',
    'creditCode',
    'iconName',
  };

  static Map<String, dynamic> _forPostgrest(Map<String, dynamic> row) {
    final out = Map<String, dynamic>.from(row);
    for (final key in _dittoOnlyKeys) {
      out.remove(key);
    }
    return out;
  }

  @override
  Stream<List<RecurringSchedule>> watchSchedules({required String businessId}) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
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
    final row = _forPostgrest(
      DocumentRowMapper.recurringScheduleToRow(
        businessId: businessId,
        schedule: schedule,
        id: schedule.uuid,
      ),
    );
    await _client.from(_table).upsert(row, onConflict: 'business_id,local_id');
  }

  @override
  Future<void> deleteSchedule({
    required String businessId,
    required String scheduleId,
  }) async {
    await _client
        .from(_table)
        .delete()
        .eq('business_id', businessId)
        .eq('local_id', scheduleId);
  }
}
