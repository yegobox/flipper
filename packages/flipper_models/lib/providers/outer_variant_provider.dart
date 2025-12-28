// flipper_models/providers/outer_variant_provider.dart

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  int _currentPage = 0;
  String _currentSearch = '';
  int? _totalCount;
  int? _itemsPerPage;
  bool _isVatEnabled = false;

  @override
  FutureOr<List<Variant>> build(String branchId) async {
    // Initialize itemsPerPage once. Use a smaller default for better performance
    final int _defaultPageSize = 15; // Reduced from 20 for better performance
    const int _maxPageSize = 50; // Reduced max from 100
    final int? prefIpp = ProxyService.box.itemPerPage();
    _itemsPerPage ??=
        (prefIpp != null && prefIpp > 0 && prefIpp <= _maxPageSize)
            ? prefIpp
            : _defaultPageSize;

    // Fetch VAT enabled status from EBM and cache it
    _isVatEnabled = await getVatEnabledFromEbm();

    // Watch for search string changes and react accordingly.
    final searchString = ref.watch(searchStringProvider);
    if (searchString != _currentSearch || state.value == null) {
      _currentSearch = searchString;
      _currentPage = 0;
      final paged = await _fetchVariants(branchId, 0, searchString);
      _totalCount = paged.totalCount;
      state = AsyncValue.data(List<Variant>.from(paged.variants));
    }

    return state.value ?? [];
  }

  Future<PagedVariants> _fetchVariants(
      String branchId, int page, String searchString) async {
    talker.info(
        'OuterVariants: _fetchVariants called (page=$page, itemsPerPage=${_itemsPerPage ?? 'null'}, searchString="$searchString")');

    final taxTyCds = _isVatEnabled ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'];
    final currentScanMode = ref.read(scanningModeProvider);

    // Always fetch remote for searches to get server-side filtering
    bool fetchRemote = searchString.isNotEmpty || page == 0;

    // For subsequent pages of the same search, don't fetch remote again
    if (page > 0 && searchString == _currentSearch) {
      fetchRemote = false;
    }

    final paged = await ProxyService.getStrategy(Strategy.capella).variants(
      name: searchString.toLowerCase(),
      fetchRemote: fetchRemote,
      branchId: branchId,
      page: page,
      itemsPerPage: _itemsPerPage!,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
    );

    talker.info(
        'OuterVariants: _fetchVariants returned ${paged.variants.length} items (totalCount=${paged.totalCount ?? 'null'})');

    return paged;
  }

  /// Loads the next page of variants for pagination.
  Future<void> loadMore() async {
    if (_totalCount == null ||
        (_currentPage + 1) * _itemsPerPage! >= _totalCount!) return;

    final paged =
        await _fetchVariants(branchId, _currentPage + 1, _currentSearch);
    _currentPage++;
    final newList = [...state.value!, ...List<Variant>.from(paged.variants)];
    state = AsyncValue.data(newList);
  }

  /// Method to be called when VAT settings change to force a full refresh.
  Future<void> resetForVatChange() async {
    // Refresh VAT status from EBM
    _isVatEnabled = await getVatEnabledFromEbm();
    ref.invalidateSelf();
  }

  /// Method to force a full refresh of variants (e.g., after adding new products).
  Future<void> refresh() async {
    final paged = await _fetchVariants(branchId, 0, '');
    _currentPage = 0;
    _currentSearch = '';
    _totalCount = paged.totalCount;
    state = AsyncValue.data(List<Variant>.from(paged.variants));
  }

  /// Add newly created variants to the provider without full reload.
  void addVariants(List<Variant> newVariants) {
    if (newVariants.isEmpty || state.value == null) return;
  }

  /// Removes a variant from the state.
  void removeVariantById(String variantId) {
    if (state.value == null) return;
    final newList = state.value!.where((v) => v.id != variantId).toList();
    state = AsyncValue.data(newList);
  }

  /// Saves stock data to cache.

  /// Public helper: fetch a specific page and replace current cache.
  Future<void> fetchPage(int page) async {
    final paged = await _fetchVariants(branchId, page, _currentSearch);
    _currentPage = page;
    state = AsyncValue.data(List<Variant>.from(paged.variants));
  }

  /// Return items for a given page (sliced from the locally cached variants).
  List<Variant> getPageItems(int page) {
    return page == _currentPage ? state.value ?? [] : [];
  }

  int get itemsPerPage => _itemsPerPage ?? 10;

  int get loadedCount => state.value?.length ?? 0;

  int? get totalCount => _totalCount;

  /// Current page index (0-based) for the cached page in the provider.
  int get currentPage => _currentPage;

  bool get hasMorePages =>
      _totalCount == null || (_currentPage + 1) * _itemsPerPage! < _totalCount!;

  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  int estimatedTotalPages() {
    if (_totalCount != null) {
      return (_totalCount! / itemsPerPage).ceil();
    }
    return 1;
  }
}

// Products provider remains the same but with minor optimizations
@riverpod
class Products extends _$Products {
  bool _initialLoadComplete = false;

  @override
  FutureOr<List<Product>> build(String branchId) async {
    final searchString = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);

    if (!scanMode && !_initialLoadComplete) {
      await loadProducts(searchString: searchString, scanMode: scanMode);
      _initialLoadComplete = true;
    }

    return state.value ?? [];
  }

  Future<void> loadProducts({
    required String searchString,
    required bool scanMode,
  }) async {
    try {
      List<Product> products =
          await ProxyService.strategy.productsFuture(branchId: branchId);

      if (searchString.isNotEmpty) {
        final additionalProduct = await ProxyService.strategy.getProduct(
          name: searchString.toLowerCase(),
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
        );

        if (additionalProduct != null) {
          products = [...products, additionalProduct];
        }
      }

      final matchingProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();

      state = AsyncData(matchingProducts);

      if (matchingProducts.isNotEmpty) {
        _expandProduct(matchingProducts.first);
      } else if (searchString.isEmpty) {
        state = AsyncData(products);
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void _expandProduct(Product product) {
    state.whenData((currentData) {
      final updatedProducts = currentData.map((p) {
        p.searchMatch = p.id == product.id;
        return p;
      }).toList();

      const equality = ListEquality();
      if (!equality.equals(currentData, updatedProducts)) {
        state = AsyncData(updatedProducts);
      }
    });
  }

  void addProducts({required List<Product> products}) {
    state.whenData((currentData) {
      final updatedProducts = [...currentData, ...products];
      state = AsyncData(updatedProducts);
    });
  }

  void deleteProduct(int productId) {
    state.whenData((currentData) {
      final updatedProducts =
          currentData.where((product) => product.id != productId).toList();
      state = AsyncData(updatedProducts);
    });
  }
}
