import 'package:flipper_dashboard/export/export_import.dart';
import 'package:flipper_dashboard/export/export_purchase.dart';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/imports_purchases_client.dart';
import 'package:flipper_models/imports_purchases_map.dart';
import 'package:flipper_models/services/pos_purchase_journal_poster.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/all_models.dart' as model;

final importsPurchasesClientProvider =
    FutureProvider<ImportsPurchasesClient>((ref) async {
      final branchId = ProxyService.box.getBranchId();
      final ebm = branchId == null
          ? null
          : await ProxyService.strategy.ebm(branchId: branchId);
      return createImportsPurchasesClient(
        dataConnectorUrl: ebm?.dataConnectorUrl,
      );
    });

final importPurchaseViewModelProvider =
    StateNotifierProvider<ImportPurchaseViewModel, ImportPurchaseState>(
  (ref) => ImportPurchaseViewModel(ref),
);

class ImportPurchaseViewModel extends StateNotifier<ImportPurchaseState> {
  ImportPurchaseViewModel(this._ref)
    : super(ImportPurchaseState.initial());

  final Ref _ref;

  /// No-op when this notifier was disposed during an async gap.
  bool _patchState(ImportPurchaseState Function(ImportPurchaseState s) patch) {
    if (!mounted) return false;
    state = patch(state);
    return true;
  }

  Future<ImportPurchaseContext> _resolveContext() async {
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();
    if (branchId == null || businessId == null) {
      throw Exception('Active branch and business are required');
    }

    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    final tin = await effectiveTin(branchId: branchId);
    if (tin == null) {
      throw Exception('TIN is required for import/purchase sync');
    }

    return buildImportPurchaseContext(
      tinNumber: tin,
      branchId: branchId,
      businessId: businessId,
      bhfId: ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? '00',
      taxServerUrl: ebm?.taxServerUrl,
      vatEnabled: ebm?.vatEnabled ?? true,
    );
  }

  Future<ImportsPurchasesClient> _client() async {
    return _ref.read(importsPurchasesClientProvider.future);
  }

  void toggleImportPurchase(bool isImport) {
    state = state.copyWith(isImport: isImport, clearError: true);
    loadList();
  }

  void setImportStatusFilter(String filter) {
    state = state.copyWith(importStatusFilter: filter, clearError: true);
    if (state.isImport) loadList();
  }

  void setPurchaseStatusFilter(String filter) {
    state = state.copyWith(purchaseStatusFilter: filter, clearError: true);
    if (!state.isImport) loadList();
  }

  Future<void> loadList() async {
    if (!mounted) return;
    final isImport = state.isImport;
    final importStatusFilter = state.importStatusFilter;
    final purchaseStatusFilter = state.purchaseStatusFilter;
    _patchState((s) => s.copyWith(isLoading: true, clearError: true));
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw Exception('No active branch');
      }
      final client = await _client();
      if (!mounted) return;
      if (isImport) {
        final items = await _listImports(
          client,
          branchId,
          importStatusFilter,
        );
        _patchState((s) => s.copyWith(importItems: items, isLoading: false));
      } else {
        final purchases = await _listPurchases(
          client,
          branchId,
          purchaseStatusFilter,
        );
        if (!mounted) return;
        final manual = await ManualPurchaseDitto.listForBranch(
          branchId,
          statusFilter: purchaseStatusFilter,
        );
        final merged = _mergePurchases(purchases, manual);
        _patchState((s) => s.copyWith(purchases: merged, isLoading: false));
      }
    } catch (e, s) {
      talker.error('Failed to load import/purchase list', e, s);
      _patchState((s) => s.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<List<model.Variant>> _listImports(
    ImportsPurchasesClient client,
    String branchId,
    String importStatusFilter,
  ) async {
    try {
      return await client.listImports(
        branchId,
        status: importStatusApiParam(importStatusFilter),
      );
    } on ImportsPurchasesApiException catch (e) {
      if (e.isNotFound) {
        talker.warning(
          'Data connector imports API not found (404) at ${client.baseUrl}; '
          'deploy data-connector with /imports routes or fix dataConnectorUrl',
        );
        return const [];
      }
      rethrow;
    }
  }

  Future<List<model.Purchase>> _listPurchases(
    ImportsPurchasesClient client,
    String branchId,
    String purchaseStatusFilter,
  ) async {
    try {
      return await client.listPurchases(
        branchId,
        status: purchaseStatusApiParam(purchaseStatusFilter),
      );
    } on ImportsPurchasesApiException catch (e) {
      if (e.isNotFound) {
        talker.warning(
          'Data connector purchases API not found (404) at ${client.baseUrl}; '
          'showing Ditto manual purchases only. Deploy latest data-connector or '
          'fix dataConnectorUrl in EBM settings.',
        );
        return const [];
      }
      rethrow;
    }
  }

  Future<String?> syncFromRra() async {
    if (!mounted || state.syncing) return null;
    _patchState((s) => s.copyWith(syncing: true, clearError: true));
    final isImport = state.isImport;
    try {
      final ctx = await _resolveContext();
      final client = await _client();
      if (!mounted) return null;
      final accepted = isImport
          ? await client.syncImports(ctx)
          : await client.syncPurchases(ctx);
      final result = await client.pollJobUntilTerminal(accepted.jobId);
      if (!result.isSuccess) {
        throw Exception(result.error ?? result.resultMsg ?? 'Sync failed');
      }
      await loadList();
      if (!mounted) return null;
      _patchState(
        (s) => s.copyWith(syncing: false, lastSyncAt: DateTime.now()),
      );
      final fetched = result.fetched;
      if (fetched != null && fetched > 0) {
        return 'Fetched $fetched new ${isImport ? 'items' : 'invoices'} from RRA';
      }
      return 'Sync complete — no new ${isImport ? 'items' : 'invoices'}';
    } catch (e, s) {
      talker.error('Sync from RRA failed', e, s);
      _patchState((s) => s.copyWith(syncing: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> approveImport({
    required model.Variant variant,
    String? targetVariantId,
  }) async {
    await _runRowJob(
      rowId: variant.id,
      action: () async {
        final ctx = await _resolveContext();
        final client = await _client();
        final accepted = await client.approveImport(
          ctx,
          variantId: variant.id,
          targetVariantId: targetVariantId,
        );
        return client.pollJobUntilTerminal(accepted.jobId);
      },
      successMessage: 'Approved "${variant.itemNm ?? variant.name}"',
    );
  }

  Future<void> rejectImport({required model.Variant variant}) async {
    await _runRowJob(
      rowId: variant.id,
      action: () async {
        final ctx = await _resolveContext();
        final client = await _client();
        final accepted = await client.rejectImport(
          ctx,
          variantId: variant.id,
        );
        return client.pollJobUntilTerminal(accepted.jobId);
      },
      successMessage: 'Rejected "${variant.itemNm ?? variant.name}"',
    );
  }

  Future<void> approveAllImports({
    required List<model.Variant> variants,
    required Map<String, List<model.Variant>> variantMap,
  }) async {
    for (final variant in variants) {
      if (variant.imptItemSttsCd != '2') continue;
      String? targetId;
      for (final entry in variantMap.entries) {
        if (entry.value.any((v) => v.id == variant.id)) {
          targetId = entry.key;
          break;
        }
      }
      await approveImport(variant: variant, targetVariantId: targetId);
    }
  }

  Future<void> approvePurchase({
    required model.Purchase purchase,
    Map<String, List<model.Variant>> itemMapper = const {},
  }) async {
    if (purchase.regTyCd == 'M') {
      await _runManualPurchaseAction(
        purchase: purchase,
        pchsSttsCd: '02',
        successMessage: 'Purchase accepted',
        postToLedger: true,
      );
      return;
    }
    await _runRowJob(
      rowId: purchase.id,
      action: () async {
        final ctx = await _resolveContext();
        final client = await _client();
        final accepted = await client.approvePurchase(
          ctx,
          purchaseId: purchase.id,
          itemMapper: buildPurchaseItemMapper(itemMapper),
        );
        return client.pollJobUntilTerminal(accepted.jobId);
      },
      successMessage: 'Purchase accepted',
    );
  }

  Future<void> rejectPurchase({required model.Purchase purchase}) async {
    if (purchase.regTyCd == 'M') {
      await _runManualPurchaseAction(
        purchase: purchase,
        pchsSttsCd: '04',
        successMessage: 'Purchase declined',
        postToLedger: false,
      );
      return;
    }
    await _runRowJob(
      rowId: purchase.id,
      action: () async {
        final ctx = await _resolveContext();
        final client = await _client();
        final accepted = await client.rejectPurchase(
          ctx,
          purchaseId: purchase.id,
        );
        return client.pollJobUntilTerminal(accepted.jobId);
      },
      successMessage: 'Purchase declined',
    );
  }

  Future<void> _runManualPurchaseAction({
    required model.Purchase purchase,
    required String pchsSttsCd,
    required String successMessage,
    required bool postToLedger,
  }) async {
    if (!mounted) return;
    final processing = {...state.processingIds, purchase.id};
    _patchState((s) => s.copyWith(processingIds: processing, clearError: true));
    try {
      await ManualPurchaseDitto.setPurchaseStatus(
        purchase: purchase,
        pchsSttsCd: pchsSttsCd,
      );
      await PosPurchaseJournalPoster.postPurchase(
        purchase: purchase,
        postToLedger: postToLedger,
      );
      await loadList();
      talker.info(successMessage);
    } catch (e, s) {
      talker.error('Manual purchase action failed', e, s);
      _patchState((s) => s.copyWith(error: e.toString()));
      rethrow;
    } finally {
      if (!mounted) return;
      final next = {...state.processingIds}..remove(purchase.id);
      _patchState((s) => s.copyWith(processingIds: next));
    }
  }

  List<model.Purchase> _mergePurchases(
    List<model.Purchase> fromApi,
    List<model.Purchase> fromDitto,
  ) {
    final apiIds = fromApi.map((p) => p.id).toSet();
    final merged = [
      ...fromApi,
      ...fromDitto.where((p) => !apiIds.contains(p.id)),
    ];
    merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return merged;
  }

  Future<void> _runRowJob({
    required String rowId,
    required Future<ImportPurchaseJobStatus> Function() action,
    required String successMessage,
  }) async {
    if (!mounted) return;
    final processing = {...state.processingIds, rowId};
    _patchState((s) => s.copyWith(processingIds: processing, clearError: true));
    try {
      final result = await action();
      if (!result.isSuccess) {
        throw Exception(result.error ?? result.resultMsg ?? 'Job failed');
      }
      await loadList();
    } catch (e, s) {
      talker.error('Import/purchase job failed', e, s);
      _patchState((s) => s.copyWith(error: e.toString()));
      rethrow;
    } finally {
      if (!mounted) return;
      final next = {...state.processingIds}..remove(rowId);
      _patchState((s) => s.copyWith(processingIds: next));
    }
  }

  bool isProcessing(String id) => state.processingIds.contains(id);

  Future<void> exportImport() async {
    if (!mounted) return;
    _patchState((s) => s.copyWith(isExporting: true));
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;
      final client = await _client();
      final imports = await client.listImports(branchId);
      if (imports.isNotEmpty) {
        await ExportImport().export(imports);
      } else {
        talker.info('No imports to export');
      }
    } catch (e, s) {
      talker.error('Failed to export imports', e, s);
    } finally {
      _patchState((s) => s.copyWith(isExporting: false));
    }
  }

  Future<void> exportPurchase() async {
    if (!mounted) return;
    _patchState((s) => s.copyWith(isExporting: true));
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;
      final client = await _client();
      final purchaseStatusFilter = state.purchaseStatusFilter;
      final purchases = await _listPurchases(
        client,
        branchId,
        purchaseStatusFilter,
      );
      final manual = await ManualPurchaseDitto.listForBranch(branchId);
      final merged = _mergePurchases(purchases, manual);
      if (merged.isEmpty) {
        talker.info('No purchases to export');
        return;
      }
      final reportItems = merged
          .where((p) => p.variants?.isNotEmpty ?? false)
          .map(
            (p) => PurchaseReportItem(
              purchase: p,
              variant: p.variants!.first,
            ),
          )
          .toList();
      if (reportItems.isNotEmpty) {
        await ExportPurchase().export(reportItems);
      }
    } catch (e, s) {
      talker.error('Failed to export purchases', e, s);
    } finally {
      _patchState((s) => s.copyWith(isExporting: false));
    }
  }
}

class ImportPurchaseState {
  const ImportPurchaseState({
    required this.isImport,
    required this.importStatusFilter,
    required this.purchaseStatusFilter,
    this.importItems = const [],
    this.purchases = const [],
    this.isLoading = false,
    this.syncing = false,
    this.isExporting = false,
    this.processingIds = const {},
    this.lastSyncAt,
    this.error,
  });

  factory ImportPurchaseState.initial() => ImportPurchaseState(
    isImport: false,
    importStatusFilter: 'pending',
    purchaseStatusFilter: 'pending',
  );

  final bool isImport;
  final String importStatusFilter;
  final String purchaseStatusFilter;
  final List<model.Variant> importItems;
  final List<model.Purchase> purchases;
  final bool isLoading;
  final bool syncing;
  final bool isExporting;
  final Set<String> processingIds;
  final DateTime? lastSyncAt;
  final String? error;

  ImportPurchaseState copyWith({
    bool? isImport,
    String? importStatusFilter,
    String? purchaseStatusFilter,
    List<model.Variant>? importItems,
    List<model.Purchase>? purchases,
    bool? isLoading,
    bool? syncing,
    bool? isExporting,
    Set<String>? processingIds,
    DateTime? lastSyncAt,
    String? error,
    bool clearError = false,
  }) {
    return ImportPurchaseState(
      isImport: isImport ?? this.isImport,
      importStatusFilter: importStatusFilter ?? this.importStatusFilter,
      purchaseStatusFilter: purchaseStatusFilter ?? this.purchaseStatusFilter,
      importItems: importItems ?? this.importItems,
      purchases: purchases ?? this.purchases,
      isLoading: isLoading ?? this.isLoading,
      syncing: syncing ?? this.syncing,
      isExporting: isExporting ?? this.isExporting,
      processingIds: processingIds ?? this.processingIds,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Legacy bootstrap helper (tests may inject [httpClient] via provider override).
ImportsPurchasesClient createDefaultImportsPurchasesClient({
  http.Client? httpClient,
  String? dataConnectorUrl,
}) {
  final base = dataConnectorUrl?.trim();
  final normalized = (base != null && base.isNotEmpty)
      ? (base.endsWith('/') ? base : '$base/')
      : 'http://127.0.0.1:8084/';
  return ImportsPurchasesClient(baseUrl: normalized, httpClient: httpClient);
}
