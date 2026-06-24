import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/local_inference_engine.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';

/// Indexes the branch's completed sales into the on-device vector store so the
/// local model can answer sales questions offline with grounded context.
///
/// One transaction → one short, embeddable text document. Runs at most once per
/// branch per session and skips entirely when the store is already populated,
/// so it's cheap to call on every app open / first local query.
class SalesRagIndexer {
  const SalesRagIndexer._();

  static final Set<String> _indexedThisSession = <String>{};

  /// Window of history to embed. Keeps the store small and recent.
  static const int _lookbackDays = 90;
  static const int _maxDocuments = 2000;

  /// Index recent completed sales for [branchId] if not already done.
  static Future<void> maybeIndex(String branchId) async {
    final engine = LocalInferenceRegistry.engine;
    if (engine == null || !engine.supportsRag) return;
    if (_indexedThisSession.contains(branchId)) return;
    _indexedThisSession.add(branchId);

    try {
      await engine.ensureRagReady();
      // Already populated (e.g. from a previous launch) → nothing to do.
      if (await engine.ragDocumentCount() > 0) return;

      final now = DateTime.now();
      final start = now.subtract(const Duration(days: _lookbackDays));
      final txns = await ProxyService.getStrategy(Strategy.capella).transactions(
        branchId: branchId,
        status: COMPLETE,
        startDate: start,
        endDate: now,
      );

      final docs = <RagDocument>[];
      for (final t in txns) {
        final doc = _toDocument(t);
        if (doc != null) docs.add(doc);
        if (docs.length >= _maxDocuments) break;
      }

      if (docs.isEmpty) return;
      await engine.indexDocuments(docs);
      talker.info('SalesRagIndexer: indexed ${docs.length} sales for $branchId');
    } catch (e) {
      talker.warning('SalesRagIndexer: indexing failed for $branchId: $e');
    }
  }

  static final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');

  static RagDocument? _toDocument(dynamic t) {
    final total = (t.subTotal as num?)?.toDouble();
    if (total == null || total <= 0) return null;
    final date = (t.createdAt as DateTime?) ?? (t.lastTouched as DateTime?);
    final dateStr = date != null ? _dateFmt.format(date) : 'unknown date';
    final receipt = t.receiptNumber?.toString();
    final customer = (t.customerName as String?)?.trim();
    final type = (t.transactionType as String?)?.trim();

    final parts = <String>[
      'Sale on $dateStr',
      'total RWF ${total.toStringAsFixed(0)}',
      if (receipt != null && receipt.isNotEmpty) 'receipt #$receipt',
      if (customer != null && customer.isNotEmpty) 'customer $customer',
      if (type != null && type.isNotEmpty) 'type $type',
    ];

    return RagDocument(
      id: t.id as String,
      content: '${parts.join(', ')}.',
      metadata: date?.toIso8601String(),
    );
  }
}
