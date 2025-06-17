import 'package:flipper_dashboard/export/export_import.dart';
import 'package:flipper_dashboard/export/export_purchase.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:supabase_models/brick/models/variant.model.dart';

final importPurchaseViewModelProvider = StateNotifierProvider.autoDispose<
    ImportPurchaseViewModel, AsyncValue<ImportPurchaseState>>(
  (ref) => ImportPurchaseViewModel(),
);

class ImportPurchaseViewModel
    extends StateNotifier<AsyncValue<ImportPurchaseState>> {
  ImportPurchaseViewModel()
      : super(AsyncValue.data(ImportPurchaseState(
            selectedDate: DateTime.now(), isImport: true))) {}

  void toggleImportPurchase(bool isImport) {
    state = AsyncValue.data(
      state.value!.copyWith(isImport: isImport),
    );
  }

  Future<void> exportImport() async {
    List<Variant> imports = await ProxyService.strategy.allImportsToDate();
    if (imports.isNotEmpty) {
      await ExportImport().export(imports);
    }
  }

    Future<void> exportPurchase() async {
    List<PurchaseReportItem> purchases = await ProxyService.strategy.allPurchasesToDate();
    if (purchases.isNotEmpty) {
      await ExportPurchase().export(purchases);
    } else {
      talker.info('No purchases to export');
    }
  }
}

class ImportPurchaseState {
  final List<model.Variant> importItems;
  final List<model.Variant> purchaseItems;
  final List<model.Purchase> purchases;
  final DateTime selectedDate;
  final bool isImport;
  final String? error;

  const ImportPurchaseState({
    this.importItems = const [],
    this.purchaseItems = const [],
    this.purchases = const [],
    required this.selectedDate,
    required this.isImport,
    this.error,
  });

  ImportPurchaseState copyWith({
    List<model.Variant>? importItems,
    List<model.Variant>? purchaseItems,
    List<model.Purchase>? purchases,
    DateTime? selectedDate,
    bool? isImport,
    String? error,
  }) {
    return ImportPurchaseState(
      importItems: importItems ?? this.importItems,
      purchaseItems: purchaseItems ?? this.purchaseItems,
      purchases: purchases ?? this.purchases,
      selectedDate: selectedDate ?? this.selectedDate,
      isImport: isImport ?? this.isImport,
      error: error ?? this.error,
    );
  }
}
