// flipper_models/providers/outer_variant_provider.dart

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/cache/cache_export.dart';

part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  // Internal state for pagination, loading, and search.
  int _currentPage = 0;
  final List<Variant> _allLoadedVariants = [];
  int? _itemsPerPage;
  bool _hasMore = true;
  bool _isLoading = false;
  Timer? _debounce;
  bool _isDisposed = false;

  @override
  FutureOr<List<Variant>> build(int branchId) async {
    // Ensure the provider is not used after being disposed.
    ref.onDispose(() {
      _debounce?.cancel();
      _isDisposed = true;
    });

    // Initialize itemsPerPage once.
    _itemsPerPage ??= ProxyService.box.itemPerPage() ?? 10;

    // Initialize the cache manager once.
    await _initializeCacheManager();

    // Load initial variants.
    await _loadInitialVariants(branchId);

    // Watch for search string changes and react accordingly.
    final searchString = ref.watch(searchStringProvider);
    return _handleSearch(branchId, searchString);
  }

  /// Initializes the cache manager.
  Future<void> _initializeCacheManager() async {
    try {
      await CacheManager().initialize();
    } catch (e) {
      talker.error('Failed to initialize cache manager: $e');
    }
  }

  /// Loads the very first set of variants when the provider is initialized.
  Future<void> _loadInitialVariants(int branchId) async {
    if (_allLoadedVariants.isEmpty && !_isLoading) {
      _isLoading = true;
      try {
        final variants = await _fetchVariants(
          branchId: branchId,
          page: 0,
          searchString: '',
        );
        _allLoadedVariants.addAll(variants);
      } catch (e) {
        talker.error('Failed to load initial variants: $e');
        // Propagate error to the initial state.
        state = AsyncValue.error(e, StackTrace.current);
      } finally {
        _isLoading = false;
      }
    }
  }

  /// Handles search logic by filtering in-memory and triggering debounced background searches.
  List<Variant> _handleSearch(int branchId, String searchString) {
    // Cancel any previous debounce timer.
    _debounce?.cancel();

    // If search string is empty, return all loaded variants.
    if (searchString.isEmpty) {
      return _allLoadedVariants;
    }

    // Immediately filter the current list for a responsive UI.
    final filteredList = _filterInMemory(searchString);

    // Trigger a debounced background search for more results.
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed) {
        _backgroundSearch(branchId, searchString);
      }
    });

    return filteredList;
  }

  /// Filters the currently loaded variants based on the search string.
  List<Variant> _filterInMemory(String searchString) {
    if (searchString.isEmpty) return _allLoadedVariants;
    final lowerCaseSearchString = searchString.toLowerCase();
    return _allLoadedVariants
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

    try {
      final newVariants = await _fetchVariants(
        branchId: branchId,
        page: 0, // Always start search from the beginning.
        searchString: searchString,
      );

      // Merge new unique variants into the main list.
      final currentIds = _allLoadedVariants.map((v) => v.id).toSet();
      final uniqueNewVariants =
          newVariants.where((v) => !currentIds.contains(v.id)).toList();

      if (uniqueNewVariants.isNotEmpty) {
        _allLoadedVariants.addAll(uniqueNewVariants);
        // Update the state with the new combined list, which will be re-filtered.
        if (!_isDisposed) {
          state = AsyncValue.data(_allLoadedVariants);
        }
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
    final taxTyCds = ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'];
    final currentScanMode = ref.read(scanningModeProvider);

    // Prioritize remote fetch for initial load, otherwise local-first.
    bool fetchRemote = searchString.isEmpty && page == 0;

    List<Variant> fetchedVariants = await ProxyService.strategy.variants(
      name: searchString.toLowerCase(),
      fetchRemote: fetchRemote,
      branchId: branchId,
      page: page,
      itemsPerPage: _itemsPerPage!,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
    );

    // Fallback logic.
    if (fetchedVariants.isEmpty && searchString.isNotEmpty) {
      fetchedVariants = await ProxyService.strategy.variants(
        name: searchString.toLowerCase(),
        fetchRemote: !fetchRemote, // Try the other source.
        branchId: branchId,
        page: page,
        itemsPerPage: _itemsPerPage!,
        taxTyCds: taxTyCds,
        scanMode: currentScanMode,
      );
    }

    // Save to cache asynchronously.
    if (fetchedVariants.isNotEmpty) {
      unawaited(_saveStocksToCache(fetchedVariants));
    }

    // Update pagination state for non-search loads.
    if (searchString.isEmpty) {
      _hasMore = fetchedVariants.length == _itemsPerPage;
      if (_hasMore) {
        _currentPage++;
      }
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
      final newVariants = await _fetchVariants(
        branchId: branchId,
        page: _currentPage,
        searchString: '',
      );

      if (newVariants.isNotEmpty) {
        _allLoadedVariants.addAll(newVariants);
        if (!_isDisposed) {
          state = AsyncValue.data(_allLoadedVariants);
        }
      }
    } catch (e) {
      talker.error('Failed to load more variants: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Removes a variant from the state.
  void removeVariantById(String variantId) {
    _allLoadedVariants.removeWhere((v) => v.id == variantId);
    if (!_isDisposed) {
      state = AsyncValue.data(List.from(_allLoadedVariants));
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
