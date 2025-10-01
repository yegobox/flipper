import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/counter.model.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';

/// Ditto synchronisation adapter for `Counter` objects.
class CounterDittoAdapter extends DittoSyncAdapter<Counter> {
  CounterDittoAdapter._internal();

  static final CounterDittoAdapter instance = CounterDittoAdapter._internal();

  static int? Function()? _branchIdProviderOverride;
  static int? Function()? _businessIdProviderOverride;

  /// Allows tests to override how the current branch ID is resolved.
  void overrideBranchIdProvider(int? Function()? provider) {
    _branchIdProviderOverride = provider;
  }

  /// Allows tests to override how the current business ID is resolved.
  void overrideBusinessIdProvider(int? Function()? provider) {
    _businessIdProviderOverride = provider;
  }

  /// Clears any provider overrides (intended for tests).
  void resetOverrides() {
    _branchIdProviderOverride = null;
    _businessIdProviderOverride = null;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  String get collectionName => 'counters';

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    final branchId =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (branchId == null) {
      return const DittoSyncQuery(query: 'SELECT * FROM counters');
    }
    return DittoSyncQuery(
      query: 'SELECT * FROM counters WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
  }

  @override
  Future<String?> documentIdForModel(Counter model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(Counter model) async {
    return {
      'id': model.id,
      'branchId': model.branchId,
      'businessId': model.businessId,
      'receiptType': model.receiptType,
      'totRcptNo': model.totRcptNo,
      'curRcptNo': model.curRcptNo,
      'invcNo': model.invcNo,
      'lastTouched': model.lastTouched?.toIso8601String(),
      'createdAt': model.createdAt?.toIso8601String(),
      'bhfId': model.bhfId,
    };
  }

  @override
  Future<Counter?> fromDittoDocument(Map<String, dynamic> document) async {
    final branchId = _toInt(document['branchId'] ?? document['branch_id']);
    if (branchId == null) {
      return null;
    }

    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (currentBranch != null && currentBranch != branchId) {
      return null;
    }

    final businessId =
        _toInt(document['businessId'] ?? document['business_id']) ??
            (_businessIdProviderOverride?.call() ??
                ProxyService.box.getBusinessId());
    final receiptType =
        (document['receiptType'] ?? document['receipt_type'])?.toString();
    final curRcptNo = _toInt(document['curRcptNo'] ?? document['cur_rcpt_no']);
    final totRcptNo = _toInt(document['totRcptNo'] ?? document['tot_rcpt_no']);
    final invcNo = _toInt(document['invcNo'] ?? document['invc_no']);
    final bhfId =
        (document['bhfId'] ?? document['bhf_id'] ?? '').toString().trim();

    if (receiptType == null ||
        curRcptNo == null ||
        totRcptNo == null ||
        invcNo == null ||
        businessId == null ||
        bhfId.isEmpty) {
      return null;
    }

    final createdAt = _toDate(document['createdAt'] ?? document['created_at']);
    final lastTouched =
        _toDate(document['lastTouched'] ?? document['last_touched']);

    final id = (document['_id'] ?? document['id'] ?? '').toString().trim();
    if (id.isEmpty) {
      return null;
    }

    return Counter(
      id: id,
      branchId: branchId,
      curRcptNo: curRcptNo,
      totRcptNo: totRcptNo,
      invcNo: invcNo,
      businessId: businessId,
      createdAt: createdAt ?? DateTime.now().toUtc(),
      lastTouched: lastTouched ?? DateTime.now().toUtc(),
      receiptType: receiptType,
      bhfId: bhfId,
    );
  }

  @override
  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async {
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (currentBranch == null) {
      return true;
    }
    final docBranch = _toInt(document['branchId'] ?? document['branch_id']);
    return docBranch == currentBranch;
  }
}
