/// Posts the value of goods made without a recipe to the Books ledger.
///
/// A product made in Production Output with no recipe (no components) has no
/// way to know what it cost to make: its ingredients and labour were recorded
/// as expenses when bought and paid. Each batch is therefore valued at the
/// product's own cost (its supply price, set by the owner) and moved out of
/// expenses into stock:
///
/// | Batch recorded | Debit | Credit |
/// |---|---|---|
/// | qty × cost | 1200 Inventory | 5020 Production Cost Absorbed |
///
/// Selling it then books Dr 5010 COGS / Cr 1200 (data-connector), so over
/// what is sold the two cancel and profit shows the real expenses, while what
/// is still on the shelf keeps its value in stock (absorption costing).
///
/// A made-in-production combo needs none of this: its components move from
/// stock to stock within 1200.
///
/// Ids are deterministic (`je_<businessId>_prodout_<outputId>`), so posting is
/// idempotent; an entry cut short (header without all lines) is written again
/// over the same ids, as in [PayrollJournalPoster].
library;

import 'package:flipper_accounting/accounting_ditto_store.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/journal_entry_id.dart';
import 'package:flipper_accounting/statutory_accounts.dart';
import 'package:flutter/foundation.dart';

const inventoryCode = '1200';

/// Contra-expense: production costs (expensed when paid) moved into stock.
const productionCostAbsorbedCode = '5020';

/// One batch of output recorded against a work order.
class ProductionOutputRecord {
  const ProductionOutputRecord({
    required this.outputId,
    required this.productName,
    required this.qty,
    required this.unitCost,
    required this.recordedAt,
  });

  /// The `actual_outputs` document id.
  final String outputId;
  final String productName;
  final double qty;

  /// The product's cost price when the batch was recorded.
  final double unitCost;
  final DateTime recordedAt;

  /// The batch's value in whole francs.
  int get value => (qty * unitCost).round();
}

/// One entry [ProductionJournalPoster.sync] wants in the ledger.
class ProductionPosting {
  const ProductionPosting({
    required this.entryId,
    required this.ref,
    required this.date,
    required this.memo,
    required this.lines,
  });

  final String entryId;
  final String ref;
  final DateTime date;
  final String memo;
  final List<JournalLine> lines;
}

class ProductionJournalPoster {
  ProductionJournalPoster(this._ditto);

  final AccountingDittoStore _ditto;

  static String outputEntryId(String businessId, String outputId) =>
      'je_${businessId}_prodout_${slugifyJournalIdPart(outputId)}';

  /// Every entry the records call for. A batch worth nothing (no cost set,
  /// or no quantity) posts nothing.
  static List<ProductionPosting> plan({
    required String businessId,
    required Iterable<ProductionOutputRecord> outputs,
  }) => [
    for (final o in outputs)
      if (o.value > 0)
        ProductionPosting(
          entryId: outputEntryId(businessId, o.outputId),
          ref: _ref(o.outputId),
          date: o.recordedAt,
          memo: 'Production: ${o.productName}',
          lines: [
            JournalLine(ac: inventoryCode, dr: o.value),
            JournalLine(ac: productionCostAbsorbedCode, cr: o.value),
          ],
        ),
  ];

  static String _ref(String outputId) {
    final short = slugifyJournalIdPart(outputId);
    return 'PRD-${short.length > 8 ? short.substring(0, 8) : short}';
  }

  /// Posts whatever [plan] wants that the ledger does not hold yet. Returns
  /// how many entries were written.
  Future<int> sync({
    required String businessId,
    required Iterable<ProductionOutputRecord> outputs,
  }) async {
    if (businessId.isEmpty || !_ditto.isReady()) return 0;
    final wanted = plan(businessId: businessId, outputs: outputs);
    if (wanted.isEmpty) return 0;

    final ids = [for (final p in wanted) p.entryId];
    final headers = await _ditto.queryCollection(
      'journal_entries',
      'SELECT _id FROM journal_entries WHERE _id IN :ids',
      {'ids': ids},
    );
    final lines = await _ditto.queryCollection(
      'journal_lines',
      'SELECT _id FROM journal_lines WHERE journalEntryId IN :ids',
      {'ids': ids},
    );
    String docId(Map<String, dynamic> r) => (r['_id'] ?? r['id']).toString();
    final haveHeaders = {for (final r in headers) docId(r)};
    final haveLines = {for (final r in lines) docId(r)};
    bool complete(ProductionPosting p) =>
        haveHeaders.contains(p.entryId) &&
        p.lines.every((l) => haveLines.contains('${p.entryId}_${l.ac}'));
    final missing = [
      for (final p in wanted)
        if (!complete(p)) p,
    ];
    if (missing.isEmpty) return 0;

    final ledger = DittoAccountingLedgerRepository(_ditto);
    await ledger.ensureSeeded(businessId: businessId);
    final chart = await _ditto.queryCollection(
      'chart_of_accounts',
      'SELECT code FROM chart_of_accounts WHERE businessId = :businessId',
      {'businessId': businessId},
    );
    // A chart seeded before 5020 existed gets it on first use.
    await ensureChartAccounts(
      ledger,
      businessId: businessId,
      codes: const [inventoryCode, productionCostAbsorbedCode],
      existingCodes: {for (final r in chart) '${r['code']}'},
    );

    return ledger.batchWrites(
      businessId: businessId,
      perfLabel: 'books.save_production',
      writes: () async {
        var written = 0;
        for (final p in missing) {
          try {
            await ledger.createJournalEntry(
              businessId: businessId,
              entry: JournalEntry(
                id: p.ref,
                date: billDateFormat.format(p.date),
                memo: p.memo,
                ref: p.ref,
                status: JournalStatus.posted,
                src: 'Production',
                lines: p.lines,
              ),
              journalCode: 'misc',
              entryId: p.entryId,
            );
            await ledger.postJournalEntry(
              businessId: businessId,
              entryId: p.entryId,
            );
            written++;
          } catch (e) {
            // The next record retries it; one bad batch must not stop others.
            debugPrint('[Production→Books] ${p.entryId} not posted: $e');
          }
        }
        return written;
      },
    );
  }
}
