// flipper_models/providers/outer_variant_provider.dart

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/cache/cache_export.dart';

part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  // Internal state for pagination, loading, and search.
  int _currentPage = 0;
  final List<Variant> _allLoadedVariants = [];
  int? _totalCount;
  int? _itemsPerPage;
  bool _hasMore = true;
  bool _isLoading = false;
  String? _pendingSearch;
  Timer? _debounce;
  bool _isDisposed = false;
  bool _isVatEnabled = false; // Cached VAT status from EBM

  @override
  FutureOr<List<Variant>> build(int branchId) async {
    // Ensure the provider is not used after being disposed.
    ref.onDispose(() {
      _debounce?.cancel();
      _isDisposed = true;
    });

    // Initialize itemsPerPage once. Use a sane default (20) and cap user
    // preference to avoid extremely large defaults coming from storage
    // (SharedPreferenceStorage previously defaulted to 1000).
    final int _defaultPageSize = 20;
    const int _maxPageSize = 100;
    final int? prefIpp = ProxyService.box.itemPerPage();
    _itemsPerPage ??=
        (prefIpp != null && prefIpp > 0 && prefIpp <= _maxPageSize)
            ? prefIpp
            : _defaultPageSize;

    // Fetch VAT enabled status from EBM and cache it
    _isVatEnabled = await getVatEnabledFromEbm();

    // Load initial variants.
    await _loadInitialVariants(branchId);

    // Watch for search string changes and react accordingly.
    final searchString = ref.watch(searchStringProvider);
    return _handleSearch(branchId, searchString);
  }

  /// Initializes the cache manager.

  /// Loads the very first set of variants when the provider is initialized.
  Future<void> _loadInitialVariants(int branchId) async {
    if (_allLoadedVariants.isEmpty && !_isLoading) {
      _isLoading = true;
      try {
        // Fetch only the first page and store it as the current page.
        final variants = await _fetchVariants(
          branchId: branchId,
          page: 0,
          searchString: '',
        );
        _allLoadedVariants.clear();
        _allLoadedVariants.addAll(variants);
      } catch (e, s) {
        talker.error('Failed to load initial variants: $e', s);
        // Propagate error to the initial state.
        state = AsyncValue.error(e, StackTrace.current);
      } finally {
        _isLoading = false;
      }
    }
  }

  /// Handles search logic by filtering in-memory and triggering debounced background searches.
  List<Variant> _handleSearch(int branchId, String searchString) {
    // Always filter by taxTyCds and search string
    talker.info(
        'OuterVariants: _handleSearch called with searchString="$searchString" (branchId=$branchId)');
    final filteredList = _filterInMemory(searchString);

    // If a search string exists, trigger a background search immediately.
    // The UI/SearchField already debounces input, so we don't debounce here.
    if (searchString.isNotEmpty && !_isDisposed) {
      if (_isLoading) {
        // If a background search is already running, queue the latest
        // search string so it will be processed when the current fetch
        // completes. This prevents missing quick successive searches.
        talker.info(
            'OuterVariants: background search in progress, queueing pending search="$searchString"');
        _pendingSearch = searchString;
      } else {
        talker.info(
            'OuterVariants: triggering background search for "$searchString"');
        // schedule the background search to avoid any sync re-entrancy
        Future.microtask(() => _backgroundSearch(branchId, searchString));
      }
    }

    return filteredList;
  }

  /// Filters the currently loaded variants based on the search string and taxTyCds.
  List<Variant> _filterInMemory(String searchString) {
    final isVatEnabled = _isVatEnabled; // Use cached VAT status

    // Apply the same filtering logic as _fetchVariants
    var filteredVariants = _allLoadedVariants.where((variant) {
      if (isVatEnabled) {
        // VAT enabled: show A, B, C tax types (includes TT items since they have taxTyCd='B')
        return ['A', 'B', 'C', 'TT'].contains(variant.taxTyCd);
      } else {
        // VAT disabled: show D tax type OR TT items (even though they have taxTyCd='B')
        return variant.taxTyCd == 'D' || variant.ttCatCd == 'TT';
      }
    }).toList();

    // Then filter by search string if provided
    if (searchString.isEmpty) return filteredVariants;

    final lowerCaseSearchString = searchString.toLowerCase();
    return filteredVariants
        .where((v) =>
            (v.productName?.toLowerCase().contains(lowerCaseSearchString) ??
                false) ||
            v.name.toLowerCase().contains(lowerCaseSearchString) ||
            (v.bcd?.toLowerCase().contains(lowerCaseSearchString) ?? false))
        .toList();
  }

  /// Performs a background search without setting a loading state.
  Future<void> _backgroundSearch(int branchId, String searchString) async {
    if (_isLoading) return;
    _isLoading = true;

    talker.info(
        'OuterVariants: _backgroundSearch starting for "$searchString" (branchId=$branchId)');
    try {
      final newVariants = await _fetchVariants(
        branchId: branchId,
        page: 0, // Always start search from the beginning.
        searchString: searchString,
      );

      // Replace the cached current page with search results. We don't
      // accumulate pages during searches — server returns the requested page.
      talker.info(
          'OuterVariants: _backgroundSearch fetched ${newVariants.length} items for "$searchString"');
      _allLoadedVariants.clear();
      _allLoadedVariants.addAll(newVariants);

      // Update provider state immediately so UI consumers rebuild with
      // the filtered results that correspond to the fetch we just performed.
      final filteredVariants = _filterInMemory(searchString);
      if (!_isDisposed) {
        state = AsyncValue.data(filteredVariants);
      }

      // If a pending search arrived while we were loading, process it next.
      if (_pendingSearch != null && _pendingSearch != searchString) {
        final nextSearch = _pendingSearch!;
        _pendingSearch = null;
        talker.info('OuterVariants: processing pending search="$nextSearch"');
        // Use microtask to avoid sync re-entrancy
        Future.microtask(() => _backgroundSearch(branchId, nextSearch));
      }
    } catch (e) {
      talker.error('Background search failed: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Centralized method to fetch variants from the repository.
  Future<List<Variant>> _fetchVariants({
    required int branchId,
    required int page,
    required String searchString,
  }) async {
    talker.info(
        'OuterVariants: _fetchVariants called (page=$page, itemsPerPage=${_itemsPerPage ?? 'null'}, searchString="$searchString")');
    // Fetch all possible variants first, then filter based on VAT setting
    final isVatEnabled = _isVatEnabled; // Use cached VAT status
    final taxTyCds = isVatEnabled ? ['A', 'B', 'C', 'TT'] : ['D', 'TT'];
    final currentScanMode = ref.read(scanningModeProvider);

    // Prioritize remote fetch for initial load, otherwise local-first.
    bool fetchRemote = searchString.isEmpty && page == 0;

    final paged = await ProxyService.getStrategy(Strategy.capella).variants(
      name: searchString.toLowerCase(),
      fetchRemote: fetchRemote,
      branchId: branchId,
      page: page,
      itemsPerPage: _itemsPerPage!,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
    );
    List<Variant> fetchedVariants = List<Variant>.from(paged.variants);

    // Record total count when provided by the backend
    _totalCount = paged.totalCount;
    talker.info(
        'OuterVariants: _fetchVariants returned ${fetchedVariants.length} items (totalCount=${_totalCount ?? 'null'})');

    // Apply special filtering for non-VAT mode
    if (!isVatEnabled) {
      fetchedVariants = fetchedVariants.where((variant) {
        // Show D tax type items OR TT items (even though they have taxTyCd='B')
        return variant.taxTyCd == 'D' || variant.ttCatCd == 'TT';
      }).toList();
    }

    // Fallback logic: if the primary fetch returned no results, try the
    // alternate source (remote/local). This is important for pagination
    // when non-zero pages may not be present in the local cache.
    if (fetchedVariants.isEmpty) {
      final fallbackPaged =
          await ProxyService.getStrategy(Strategy.capella).variants(
        name: searchString.toLowerCase(),
        fetchRemote: !fetchRemote, // Try the other source.
        branchId: branchId,
        page: page,
        itemsPerPage: _itemsPerPage!,
        taxTyCds: taxTyCds,
        scanMode: currentScanMode,
      );

      // Extract variants list from the paged fallback
      fetchedVariants = List<Variant>.from(fallbackPaged.variants);

      // Apply special filtering for non-VAT mode to fallback results too
      if (!isVatEnabled) {
        fetchedVariants = fetchedVariants.where((variant) {
          // Show D tax type items OR TT items (even though they have taxTyCd='B')
          return variant.taxTyCd == 'D' || variant.ttCatCd == 'TT';
        }).toList();
      }
    }
    // Update pagination state for non-search loads. We do NOT append pages in
    // the provider; callers control which page to request. Compute hasMore
    // using totalCount when available; otherwise fall back to length check.
    if (searchString.isEmpty) {
      if (_totalCount != null) {
        final total = _totalCount!;
        final loaded = (page + 1) * _itemsPerPage!; // items up to this page
        _hasMore = loaded < total;
      } else {
        _hasMore = fetchedVariants.length == _itemsPerPage;
      }
      // Do not mutate _currentPage here; callers decide when to increment.
    }

    return fetchedVariants;
  }

  /// Loads the next page of variants for pagination.
  Future<void> loadMore() async {
    // Do not load more if a search is active.
    if (_isLoading || !_hasMore || ref.read(searchStringProvider).isNotEmpty) {
      return;
    }

    _isLoading = true;
    try {
      // Request the next page and replace current page results. We avoid
      // accumulating multiple pages in memory.
      final nextPage = _currentPage + 1;
      final newVariants = await _fetchVariants(
        branchId: branchId,
        page: nextPage,
        searchString: '',
      );

      if (newVariants.isNotEmpty) {
        _currentPage = nextPage;
        _allLoadedVariants.clear();
        _allLoadedVariants.addAll(newVariants);
        if (!_isDisposed) {
          // Use _filterInMemory to ensure proper taxTyCd filtering when updating state
          final currentSearchString = ref.read(searchStringProvider);
          final filteredVariants = _filterInMemory(currentSearchString);
          state = AsyncValue.data(filteredVariants);
        }
      }
    } catch (e) {
      talker.error('Failed to load more variants: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Method to be called when VAT settings change to force a full refresh.
  Future<void> resetForVatChange() async {
    // Refresh VAT status from EBM
    _isVatEnabled = await getVatEnabledFromEbm();

    _allLoadedVariants.clear();
    _currentPage = 0;
    _hasMore = true;
    _isLoading = false;
    ref.invalidateSelf();
  }

  /// Method to force a full refresh of variants (e.g., after adding new products).
  Future<void> refresh() async {
    _allLoadedVariants.clear();
    _currentPage = 0;
    _hasMore = true;
    _isLoading = false;

    // Reload variants
    try {
      state = const AsyncValue.loading();
      // Fetch page 0 and replace the current page cache
      final variants = await _fetchVariants(
        branchId: branchId,
        page: 0,
        searchString: '',
      );
      _allLoadedVariants.clear();
      _allLoadedVariants.addAll(variants);

      // Apply current search filter if any
      final currentSearchString = ref.read(searchStringProvider);
      final filteredVariants = _filterInMemory(currentSearchString);
      state = AsyncValue.data(filteredVariants);
    } catch (e, stack) {
      talker.error('Failed to refresh variants: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  /// Add newly created variants to the provider without full reload.
  void addVariants(List<Variant> newVariants) {
    if (newVariants.isEmpty) return;

    // Add to internal list if not already present
    final currentIds = _allLoadedVariants.map((v) => v.id).toSet();
    final uniqueNewVariants =
        newVariants.where((v) => !currentIds.contains(v.id)).toList();

    if (uniqueNewVariants.isNotEmpty) {
      // Insert at the beginning so new variants appear first
      _allLoadedVariants.insertAll(0, uniqueNewVariants);

      // Save to cache asynchronously
      unawaited(_saveStocksToCache(uniqueNewVariants));

      // Force immediate state update
      if (!_isDisposed) {
        final currentSearchString = ref.read(searchStringProvider);
        final filteredVariants = _filterInMemory(currentSearchString);
        state = AsyncValue.data(filteredVariants);

        // Also invalidate to trigger rebuild
        Future.microtask(() {
          if (!_isDisposed) {
            ref.invalidateSelf();
          }
        });
      }
    }
  }

  /// Removes a variant from the state.
  void removeVariantById(String variantId) {
    _allLoadedVariants.removeWhere((v) => v.id == variantId);
    if (!_isDisposed) {
      // Use _filterInMemory to ensure proper taxTyCd filtering when updating state
      final currentSearchString = ref.read(searchStringProvider);
      final filteredVariants = _filterInMemory(currentSearchString);
      state = AsyncValue.data(filteredVariants);
    }
  }

  /// Saves stock data to cache.
  Future<void> _saveStocksToCache(List<Variant> variants) async {
    try {
      final variantsWithStock = variants.where((v) => v.stock != null).toList();
      if (variantsWithStock.isNotEmpty) {
        await CacheManager().saveStocksForVariants(variantsWithStock);
      }
    } catch (e) {
      talker.error('Failed to save stocks to cache: $e');
    }
  }

  /// Public helper: fetch a specific page and merge results into the cache.
  /// This will NOT clear existing items; it appends unique items returned for
  /// that page. It is safe to call from the UI to ensure a page is available.
  Future<void> fetchPage(int page) async {
    if (_isLoading || ref.read(searchStringProvider).isNotEmpty) return;
    _isLoading = true;
    try {
      // Fetch the requested page and replace the current page cache. We do
      // not append pages to the cache.
      final newVariants = await _fetchVariants(
        branchId: branchId,
        page: page,
        searchString: '',
      );

      if (newVariants.isNotEmpty) {
        _currentPage = page;
        _allLoadedVariants.clear();
        _allLoadedVariants.addAll(newVariants);
        if (!_isDisposed) {
          final currentSearchString = ref.read(searchStringProvider);
          final filteredVariants = _filterInMemory(currentSearchString);
          state = AsyncValue.data(filteredVariants);
        }
      }
    } catch (e) {
      talker.error('Failed to fetch page $page: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Return items for a given page (sliced from the locally cached variants).
  List<Variant> getPageItems(int page) {
    // The provider now caches only the current page of results. If caller
    // requests that same page, return the cache; otherwise return empty list
    // (caller should call fetchPage to populate other pages).
    return page == _currentPage
        ? List<Variant>.from(_allLoadedVariants)
        : <Variant>[];
  }

  int get itemsPerPage => _itemsPerPage ?? 10;

  int get loadedCount => _allLoadedVariants.length;

  int? get totalCount => _totalCount;

  /// Current page index (0-based) for the cached page in the provider.
  int get currentPage => _currentPage;

  bool get hasMorePages => _hasMore;

  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  int estimatedTotalPages() {
    if (_totalCount != null) {
      return (_totalCount! / itemsPerPage).ceil();
    }
    final pages = (loadedCount / itemsPerPage).ceil();
    return hasMorePages ? pages + 1 : pages;
  }
}

// Products provider remains the same but with minor optimizations
@riverpod
class Products extends _$Products {
  bool _initialLoadComplete = false;

  @override
  FutureOr<List<Product>> build(int branchId) async {
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
