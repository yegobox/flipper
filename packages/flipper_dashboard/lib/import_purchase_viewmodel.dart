import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:talker_flutter/talker_flutter.dart';

// Extension to format DateTime to YYYYMMddHHmmss format
extension DateTimeExtension on DateTime {
  String toYYYYMMddHHmmss() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    final h = hour.toString().padLeft(2, '0');
    final min = minute.toString().padLeft(2, '0');
    final s = second.toString().padLeft(2, '0');
    return '$y$m${d}${h}${min}${s}';
  }
}

final importPurchaseViewModelProvider = StateNotifierProvider.autoDispose<
    ImportPurchaseViewModel, AsyncValue<ImportPurchaseState>>(
  (ref) => ImportPurchaseViewModel(),
);

class ImportPurchaseViewModel
    extends StateNotifier<AsyncValue<ImportPurchaseState>> {
  ImportPurchaseViewModel() : super(const AsyncValue.loading()) {
    _initialize();
  }

  final Talker talker = Talker();
  DateTime _selectedDate = DateTime.now();
  bool _isImport = true;

  Future<void> _initialize() async {
    state = const AsyncValue.loading();
    try {
      await _loadData();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> _loadData() async {
    try {
      if (_isImport) {
        final importResponse =
            await _fetchDataImport(selectedDate: _selectedDate);
        state = AsyncValue.data(ImportPurchaseState(
          importItems: importResponse,
          selectedDate: _selectedDate,
          isImport: _isImport,
        ));
      } else {
        final purchaseResponse =
            await _fetchDataPurchase(selectedDate: _selectedDate);
        final purchases = await ProxyService.strategy.purchases();

        state = AsyncValue.data(ImportPurchaseState(
          purchaseItems: purchaseResponse,
          purchases: purchases,
          selectedDate: _selectedDate,
          isImport: _isImport,
        ));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<List<model.Variant>> _fetchDataImport(
      {required DateTime selectedDate}) async {
    try {
      final convertedDate = selectedDate.toYYYYMMddHHmmss();
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final data = await ProxyService.strategy.selectImportItems(
        tin: business?.tinNumber ?? ProxyService.box.tin(),
        lastRequestdate: convertedDate,
        bhfId: (await ProxyService.box.bhfId()) ?? "00",
      );
      return data;
    } catch (e, stack) {
      talker.error('Error in _fetchDataImport', e, stack);
      rethrow;
    }
  }

  Future<List<model.Variant>> _fetchDataPurchase(
      {required DateTime selectedDate}) async {
    try {
      final convertedDate = selectedDate.toYYYYMMddHHmmss();
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);
      final url = await ProxyService.box.getServerUrl();
      final rwResponse = await ProxyService.strategy.selectPurchases(
        lastRequestdate: convertedDate,
        bhfId: (await ProxyService.box.bhfId()) ?? "00",
        tin: business?.tinNumber ?? ProxyService.box.tin(),
        url: url!,
      );
      talker.info('Fetched purchase data', rwResponse);
      return rwResponse;
    } catch (e) {
      talker.error('Error fetching purchase data', e);
      rethrow;
    }
  }

  Future<void> toggleImportPurchase(bool value) async {
    _isImport = value;
    await _loadData();
  }

  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    await _loadData();
  }

  // Import actions
  Future<void> approveImport(model.Variant variant) async {
    try {
      final updatedVariant = variant.copyWith(
        imptItemSttsCd: '3', // Approved status
      );

      await ProxyService.strategy.updateVariant(
        updatables: [updatedVariant],
      );

      await _loadData(); // Refresh data after update
    } catch (e, stack) {
      talker.error('Error approving import', e, stack);
      rethrow;
    }
  }

  Future<void> rejectImport(model.Variant variant) async {
    try {
      final updatedVariant = variant.copyWith(
        imptItemSttsCd: '4', // Rejected status
      );

      await ProxyService.strategy.updateVariant(
        updatables: [updatedVariant],
      );

      await _loadData(); // Refresh data after update
    } catch (e, stack) {
      talker.error('Error rejecting import', e, stack);
      rethrow;
    }
  }

  // Purchase actions
  Future<void> acceptPurchases({
    required List<model.Variant> variants,
    required String pchsSttsCd,
    required model.Purchase purchase,
  }) async {
    try {
      // Update all variants with the new status
      final updatedVariants = variants
          .map((variant) => variant.copyWith(
                purchaseId: pchsSttsCd, // Using purchaseId to track status
              ))
          .toList();

      await ProxyService.strategy.updateVariant(
        updatables: updatedVariants,
      );

      // Note: The original implementation doesn't update the purchase status
      // as there's no updatePurchase method in the interface

      await _loadData(); // Refresh data after update
    } catch (e, stack) {
      talker.error('Error accepting purchases', e, stack);
      rethrow;
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
    this.isImport = true,
    this.error,
  });

  bool get isLoading => false; // Derived from state

  List<model.Variant> get currentItems =>
      isImport ? importItems : purchaseItems;

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
      error: error,
    );
  }
}
