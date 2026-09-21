import 'package:flipper_web/modules/accounting/data/fiscal_period_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/fiscal_period_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_periods_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Ditto is the authoritative store for accounting, so periods are written
/// here and data-connector mirrors them into Postgres with the rest of the
/// ledger. Writing to Supabase directly would also be refused: `fiscal_periods`
/// grants `authenticated` SELECT only, so that a period lock is not something
/// any signed-in client can flip.
class DittoAccountingPeriodsRepository implements AccountingPeriodsRepository {
  DittoAccountingPeriodsRepository(this._ditto);

  static const collection = 'fiscal_periods';

  final DittoService _ditto;

  @override
  Stream<List<FiscalPeriod>> watchPeriods({required String businessId}) {
    return _ditto
        .watchCollection(
          collection,
          'SELECT * FROM $collection WHERE businessId = :businessId',
          {'businessId': businessId},
        )
        .map(
          (rows) => rows.map(FiscalPeriodRowMapper.fromRow).toList()
            ..sort((a, b) => a.key.compareTo(b.key)),
        );
  }

  @override
  Future<void> upsertPeriod({
    required String businessId,
    required FiscalPeriod period,
  }) async {
    final docId = '${businessId}_${period.key}';
    await _ditto.upsertFiscalPeriod(
      businessId,
      FiscalPeriodRowMapper.toRow(
        businessId: businessId,
        period: period,
        id: docId,
      ),
      docId,
    );
  }
}
