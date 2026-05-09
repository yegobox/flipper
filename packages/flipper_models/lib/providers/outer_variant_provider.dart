// flipper_models/providers/outer_variant_provider.dart

import 'dart:async';
import 'dart:math' as math;
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
  /// In-memory pages `[firstCachedPage … lastCachedPage]`; oldest dropped when
  /// count exceeds [_maxCachedPages] so scroll "load more" cannot grow without bound.
  final Map<int, List<Variant>> _pageCache = {};
  int _firstCachedPage = 0;
  int _lastCachedPage = -1;

  static const int _maxCachedPages = 10;

  String _currentSearch = '';
  int? _totalCount;
  int? _itemsPerPage;
  bool _isVatEnabled = false;

  List<Variant> _flattenContiguousPages() {
    if (_pageCache.isEmpty) return [];
    final keys = _pageCache.keys.toList()..sort();
    final out = <Variant>[];
    for (final k in keys) {
      out.addAll(_pageCache[k]!);
    }
    return out;
  }

  void _repackFromFlatList(List<Variant> flat) {
    _pageCache.clear();
    final ipp = _itemsPerPage;
    if (ipp == null || ipp <= 0 || flat.isEmpty) {
      _firstCachedPage = 0;
      _lastCachedPage = -1;
      return;
    }
    for (var i = 0; i < flat.length; i += ipp) {
      final pageIdx = i ~/ ipp;
      _pageCache[pageIdx] = flat.sublist(i, math.min(i + ipp, flat.length));
    }
    _firstCachedPage = _pageCache.keys.reduce(math.min);
    _lastCachedPage = _pageCache.keys.reduce(math.max);
  }

  void _syncBoundsFromCache() {
    if (_pageCache.isEmpty) {
      _firstCachedPage = 0;
      _lastCachedPage = -1;
    } else {
      _firstCachedPage = _pageCache.keys.reduce(math.min);
      _lastCachedPage = _pageCache.keys.reduce(math.max);
    }
  }

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
    talker.info(
      'OuterVariants: itemsPerPage=${_itemsPerPage ?? 'null'} '
      '(pref=${prefIpp ?? 'null'}, default=$_defaultPageSize, max=$_maxPageSize)',
    );

    // Fetch VAT enabled status from EBM and cache it
    _isVatEnabled = await getVatEnabledFromEbm();

    // Watch for search string changes and react accordingly.
    final searchString = ref.watch(searchStringProvider);

    // Always update current search and page when they change
    if (searchString != _currentSearch) {
      _currentSearch = searchString;
      _pageCache.clear();
      _firstCachedPage = 0;
      _lastCachedPage = -1;
    }

    const int fetchPageIndex = 0;

    // First page + no search: Ditto may still be pulling from the mesh after
    // app start. A single empty success would cache forever unless we retry.
    final PagedVariants paged;
    if (fetchPageIndex == 0 && _currentSearch.isEmpty && branchId.isNotEmpty) {
      paged = await _fetchVariantsWithColdStartGrace(branchId);
    } else {
      paged = await _fetchVariants(branchId, fetchPageIndex, _currentSearch);
    }
    _totalCount = paged.totalCount;

    _pageCache.clear();
    _pageCache[0] = List<Variant>.from(paged.variants);
    _firstCachedPage = 0;
    _lastCachedPage = 0;

    return _flattenContiguousPages();
  }

  /// Extra backoff after an empty first fetch so products appear on cold start
  /// without requiring the user to search or navigate away.
  Future<PagedVariants> _fetchVariantsWithColdStartGrace(
    String branchId,
  ) async {
    var paged = await _fetchVariants(branchId, 0, '', fetchRemote: true);
    if (paged.variants.isNotEmpty) return paged;

    const delays = <Duration>[
      Duration(milliseconds: 2000),
      Duration(milliseconds: 3500),
      Duration(milliseconds: 5000),
    ];
    for (final d in delays) {
      talker.info(
        'OuterVariants: first load empty, retry after ${d.inMilliseconds}ms '
        '(Ditto / cloud sync)',
      );
      await Future.delayed(d);
      paged = await _fetchVariants(branchId, 0, '', fetchRemote: true);
      if (paged.variants.isNotEmpty) break;
    }
    return paged;
  }

  Future<PagedVariants> _fetchVariants(
    String branchId,
    int page,
    String searchString, {
    bool fetchRemote = false,
  }) async {
    talker.info(
      'OuterVariants: _fetchVariants called (page=$page, itemsPerPage=${_itemsPerPage ?? 'null'}, searchString="$searchString")',
    );

    final taxTyCds = _isVatEnabled ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'];
    final currentScanMode = ref.read(scanningModeProvider);

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
      'OuterVariants: _fetchVariants returned ${paged.variants.length} items (totalCount=${paged.totalCount ?? 'null'})',
    );

    return paged;
  }

  /// Loads the next page of variants for pagination.
  Future<void> loadMore() async {
    if (_totalCount == null ||
        (_lastCachedPage + 1) * _itemsPerPage! >= _totalCount!) {
      return;
    }

    final nextPage = _lastCachedPage + 1;
    final paged = await _fetchVariants(branchId, nextPage, _currentSearch);
    _pageCache[nextPage] = List<Variant>.from(paged.variants);
    _lastCachedPage = nextPage;

    while (_pageCache.length > _maxCachedPages) {
      final first = _pageCache.keys.reduce(math.min);
      _pageCache.remove(first);
      talker.info(
        'OuterVariants: evicted page $first from cache '
        '(max $_maxCachedPages pages in memory)',
      );
    }
    _syncBoundsFromCache();

    state = AsyncValue.data(_flattenContiguousPages());
  }

  /// Method to be called when VAT settings change to force a full refresh.
  Future<void> resetForVatChange() async {
    // Refresh VAT status from EBM
    _isVatEnabled = await getVatEnabledFromEbm();
    ref.invalidateSelf();
  }

  /// Method to force a full refresh of variants (e.g., after adding new products).
  Future<void> refresh() async {
    final paged = await _fetchVariants(branchId, 0, '', fetchRemote: true);
    _currentSearch = '';
    _totalCount = paged.totalCount;
    _pageCache.clear();
    _pageCache[0] = List<Variant>.from(paged.variants);
    _firstCachedPage = 0;
    _lastCachedPage = 0;
    state = AsyncValue.data(_flattenContiguousPages());
  }

  /// Add newly created variants to the provider without full reload.
  void addVariants(List<Variant> newVariants) {
    if (newVariants.isEmpty || state.value == null) return;

    // Get IDs of new/updated variants
    final newVariantIds = newVariants.map((v) => v.id).toSet();

    final existingFlat = _pageCache.isEmpty
        ? List<Variant>.from(state.value!)
        : _flattenContiguousPages();

    // Filter out existing variants that match the new IDs to prevent duplicates
    final filteredExisting = existingFlat
        .where((v) => !newVariantIds.contains(v.id))
        .toList();

    // Prepend the new/updated variants to the list
    var newList = [...newVariants, ...filteredExisting];
    final ipp = _itemsPerPage ?? 15;
    final maxItems = _maxCachedPages * ipp;
    if (newList.length > maxItems) {
      newList = newList.sublist(0, maxItems);
    }
    _repackFromFlatList(newList);
    state = AsyncValue.data(_flattenContiguousPages());
  }

  /// Removes a variant from the state.
  void removeVariantById(String variantId) {
    if (state.value == null) return;
    if (_pageCache.isEmpty) {
      final newList = state.value!.where((v) => v.id != variantId).toList();
      if (newList.isEmpty) {
        _firstCachedPage = 0;
        _lastCachedPage = -1;
        state = AsyncValue.data([]);
        return;
      }
      _repackFromFlatList(newList);
      state = AsyncValue.data(_flattenContiguousPages());
      return;
    }
    final keys = _pageCache.keys.toList();
    for (final k in keys) {
      final chunk = _pageCache[k];
      if (chunk == null) continue;
      _pageCache[k] = chunk.where((v) => v.id != variantId).toList();
      if (_pageCache[k]!.isEmpty) {
        _pageCache.remove(k);
      }
    }
    _syncBoundsFromCache();
    state = AsyncValue.data(_flattenContiguousPages());
  }

  /// Saves stock data to cache.

  /// Public helper: fetch a specific page and replace current cache.
  Future<void> fetchPage(int page) async {
    final paged = await _fetchVariants(branchId, page, _currentSearch);
    _pageCache
      ..clear()
      ..[page] = List<Variant>.from(paged.variants);
    _firstCachedPage = page;
    _lastCachedPage = page;
    _totalCount = paged.totalCount;
    state = AsyncValue.data(_flattenContiguousPages());
  }

  /// Return items for a given page (sliced from the locally cached variants).
  List<Variant> getPageItems(int page) {
    return List<Variant>.from(_pageCache[page] ?? const <Variant>[]);
  }

  int get itemsPerPage => _itemsPerPage ?? 10;

  int get loadedCount => state.value?.length ?? 0;

  int? get totalCount => _totalCount;

  /// Highest page index currently present in the page cache (0-based).
  int get currentPage => _lastCachedPage;

  /// Lowest page index currently held in memory (after evictions, can be > 0).
  int get firstCachedPage => _firstCachedPage;

  bool get hasMorePages =>
      _totalCount == null ||
      (_lastCachedPage + 1) * _itemsPerPage! < _totalCount!;

  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  int estimatedTotalPages() {
    if (_totalCount != null) {
      return (_totalCount! / itemsPerPage).ceil();
    }
    return 1;
  }

  /// Fetches all variants for the branch, bypassing pagination.
  /// Useful for data export (e.g., Excel).
  Future<List<Variant>> futureFetchAllVariants() async {
    final taxTyCds = _isVatEnabled ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'];
    final currentScanMode = ref.read(scanningModeProvider);

    final paged = await ProxyService.getStrategy(Strategy.capella).variants(
      branchId: branchId,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
      fetchRemote: true, // Ensure we have latest data for export
    );

    return List<Variant>.from(paged.variants);
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
      List<Product> products = await ProxyService.strategy.productsFuture(
        branchId: branchId,
      );

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
          .where(
            (product) =>
                product.name.toLowerCase().contains(searchString.toLowerCase()),
          )
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
      final updatedProducts = currentData
          .where((product) => product.id != productId)
          .toList();
      state = AsyncData(updatedProducts);
    });
  }
}
