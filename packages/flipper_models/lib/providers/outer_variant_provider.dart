// flipper_models/providers/outer_variant_provider.dart

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:supabase_models/cache/cache_export.dart';

part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  // Internal state for pagination and loading
  int _currentPage = 0;
  List<Variant> _allLoadedVariants = [];
  int? _itemsPerPage;
  bool _hasMore = true;
  bool _isLoading = false;
  String _lastSearchString = '';
  bool _cacheInitialized = false;

  /// Remove a variant from the current state by its ID
  void removeVariantById(String variantId) {
    final currentList = state.value ?? [];
    final updatedList = currentList.where((v) => v.id != variantId).toList();
    _allLoadedVariants = updatedList;
    state = AsyncValue.data(updatedList);
  }

  @override
  FutureOr<List<Variant>> build(int branchId) async {
    final searchString = ref.watch(searchStringProvider);

    // Initialize itemsPerPage once per build cycle
    _itemsPerPage ??= ProxyService.box.itemPerPage() ?? 10;

    // Reset state when branchId changes or search string changes significantly
    final shouldReset = _shouldResetState(searchString);
    if (shouldReset) {
      _resetPaginationState();
      _lastSearchString = searchString;
    }

    // Initialize cache manager once
    if (!_cacheInitialized) {
      await _initializeCacheManager();
      _cacheInitialized = true;
    }

    // If search string is empty, load initial data
    if (searchString.isEmpty) {
      return await _loadInitialVariants(branchId);
    }

    // Handle search with optimizations
    return await _handleSearch(branchId, searchString);
  }

  /// Determine if we should reset the pagination state
  bool _shouldResetState(String newSearchString) {
    // Reset if:
    // 1. Search string changed significantly (not just a continuation)
    // 2. This is the first build
    if (_lastSearchString.isEmpty) return true;

    // If search string is empty, reset
    if (newSearchString.isEmpty && _lastSearchString.isNotEmpty) return true;

    // If new search is completely different, reset
    if (newSearchString.isNotEmpty &&
        _lastSearchString.isNotEmpty &&
        !newSearchString
            .toLowerCase()
            .contains(_lastSearchString.toLowerCase()) &&
        !_lastSearchString
            .toLowerCase()
            .contains(newSearchString.toLowerCase())) {
      return true;
    }

    return false;
  }

  /// Reset pagination state
  void _resetPaginationState() {
    _currentPage = 0;
    _allLoadedVariants = [];
    _hasMore = true;
    _isLoading = false;
  }

  /// Load initial variants (when search is empty)
  Future<List<Variant>> _loadInitialVariants(int branchId) async {
    if (_allLoadedVariants.isNotEmpty && _lastSearchString.isEmpty) {
      return _allLoadedVariants; // Return cached data
    }

    final variants = await _fetchAndProcessVariants(
      branchId: branchId,
      page: _currentPage,
      searchString: '',
    );

    _allLoadedVariants = variants;
    return _allLoadedVariants;
  }

  /// Handle search with state-based optimization
  Future<List<Variant>> _handleSearch(int branchId, String searchString) async {
    final lowerCaseSearchString = searchString.toLowerCase();

    // First, check if we can find exact matches in current state
    // Use state.value instead of _allLoadedVariants to check current provider state
    final currentVariants = state.value ?? _allLoadedVariants;
    if (currentVariants.isNotEmpty) {
      final exactMatch =
          _findExactMatchInState(lowerCaseSearchString, currentVariants);
      if (exactMatch != null) {
        talker.info(
            'Exact match found in state: ${exactMatch.productName ?? exactMatch.name}');
        return [exactMatch];
      }

      // If no exact match but we have partial matches in state, check if we need to search further
      final partialMatches =
          _findPartialMatchesInState(lowerCaseSearchString, currentVariants);
      if (partialMatches.isNotEmpty &&
          _isSearchStringRefinement(searchString)) {
        return partialMatches;
      }
    }

    // No suitable matches in state, fetch from database
    talker.info('No suitable match found in state, proceeding to DB search.');
    final variants = await _fetchAndProcessVariants(
      branchId: branchId,
      page: 0, // Reset to first page for search
      searchString: searchString,
    );

    _allLoadedVariants = variants;
    return variants;
  }

  /// Find exact match in current state
  Variant? _findExactMatchInState(
      String lowerCaseSearchString, List<Variant> variants) {
    return variants.firstWhereOrNull((v) =>
        (v.productName?.toLowerCase().contains(lowerCaseSearchString) ==
            true) ||
        (v.name.toLowerCase().contains(lowerCaseSearchString) == true) ||
        (v.bcd?.toLowerCase() == lowerCaseSearchString));
  }

  /// Find partial matches in current state
  List<Variant> _findPartialMatchesInState(
      String lowerCaseSearchString, List<Variant> variants) {
    return variants
        .where((v) =>
            (v.productName?.toLowerCase().contains(lowerCaseSearchString) ==
                true) ||
            (v.name.toLowerCase().contains(lowerCaseSearchString) == true) ||
            (v.bcd?.toLowerCase().contains(lowerCaseSearchString) == true))
        .toList();
  }

  /// Check if current search is a refinement of previous search
  bool _isSearchStringRefinement(String currentSearch) {
    return _lastSearchString.isNotEmpty &&
        currentSearch.toLowerCase().contains(_lastSearchString.toLowerCase());
  }

  /// Initialize the cache manager (called once)
  Future<void> _initializeCacheManager() async {
    try {
      await CacheManager().initialize();
    } catch (e) {
      // Log error but don't fail the entire operation
      talker.error('Failed to initialize cache manager: $e');
    }
  }

  /// Save Stock objects to cache
  Future<void> _saveStocksToCache(List<Variant> variants) async {
    if (variants.isEmpty) return;

    try {
      final variantsWithStock = variants.where((v) => v.stock != null).toList();
      if (variantsWithStock.isNotEmpty) {
        await CacheManager().saveStocksForVariants(variantsWithStock);
      }
    } catch (e) {
      talker.error('Failed to save stocks to cache: $e');
    }
  }

  /// Get tax type codes based on VAT setting
  List<String> _getTaxTypeCodes() {
    final isVatEnabled = ProxyService.box.vatEnabled();
    return isVatEnabled ? ['A', 'B', 'C'] : ['D'];
  }

  /// Centralized method to fetch variants with optimized error handling
  Future<List<Variant>> _fetchAndProcessVariants({
    required int branchId,
    required int page,
    required String searchString,
  }) async {
    if (!_hasMore && page > 0) {
      talker.info('No more variants to fetch for page $page.');
      return [];
    }

    if (_isLoading) {
      talker.info('Already loading, skipping duplicate request.');
      return [];
    }

    _isLoading = true;

    try {
      final taxTyCds = _getTaxTypeCodes();
      final currentScanMode = ref.read(scanningModeProvider);

      // Try local first
      List<Variant> fetchedVariants = await _fetchVariantsWithStrategy(
        branchId: branchId,
        page: page,
        searchString: searchString,
        taxTyCds: taxTyCds,
        scanMode: currentScanMode,
        fetchRemote: false,
      );

      // Fallback to remote only if local is empty AND we have a search string
      if (fetchedVariants.isEmpty && searchString.isNotEmpty) {
        talker.info('Local search empty for "$searchString", trying remote...');
        fetchedVariants = await _fetchVariantsWithStrategy(
          branchId: branchId,
          page: page,
          searchString: searchString,
          taxTyCds: taxTyCds,
          scanMode: currentScanMode,
          fetchRemote: true,
        );
      }

      // Update pagination state
      _hasMore = fetchedVariants.length == (_itemsPerPage ?? 10);
      if (fetchedVariants.isNotEmpty) {
        _currentPage++;
      }

      // Save to cache asynchronously (don't wait for it)
      if (fetchedVariants.isNotEmpty) {
        unawaited(_saveStocksToCache(fetchedVariants));
      }

      return fetchedVariants;
    } on TimeoutException catch (e) {
      talker.error('Timeout: Variants loading took too long');
      rethrow;
    } catch (error) {
      talker.error('Error loading variants: $error');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  /// Fetch variants with specific strategy
  Future<List<Variant>> _fetchVariantsWithStrategy({
    required int branchId,
    required int page,
    required String searchString,
    required List<String> taxTyCds,
    required bool scanMode,
    required bool fetchRemote,
  }) async {
    return await ProxyService.strategy.variants(
      name: searchString.toLowerCase(),
      fetchRemote: fetchRemote,
      branchId: branchId,
      page: page,
      itemsPerPage: _itemsPerPage ?? 10,
      taxTyCds: taxTyCds,
      scanMode: scanMode,
    );
  }

  /// Load more variants with improved error handling
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) {
      talker.info('loadMore: Currently loading or no more items. Skipping.');
      return;
    }

    // Don't show loading state for loadMore to avoid flickering
    try {
      final newVariants = await _fetchAndProcessVariants(
        branchId: branchId,
        page: _currentPage,
        searchString: ref.read(searchStringProvider),
      );

      if (newVariants.isNotEmpty) {
        _allLoadedVariants = [..._allLoadedVariants, ...newVariants];
        state = AsyncValue.data(_allLoadedVariants);
      }
    } catch (e, st) {
      // Revert page increment on error
      if (_currentPage > 0) {
        _currentPage--;
      }

      // Don't override the current state with error for loadMore
      // Just log the error and let user retry
      talker.error('Failed to load more variants: $e');
      rethrow;
    }
  }

  /// Get current branchId from the provider argument
  int get branchId {
    // This assumes the branchId is passed as the argument to the provider
    // You might need to adjust this based on your actual implementation
    return ref.read(outerVariantsProvider(1).notifier)._getBranchId();
  }

  int _getBranchId() {
    // Return the branchId that was passed to the provider
    // This is a workaround since we can't directly access the argument
    // You might want to store this in a class variable instead
    return 1; // Replace with actual logic to get branchId
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
