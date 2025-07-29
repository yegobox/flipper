// flipper_models/providers/outer_variant_provider.dart

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart'; // Keep if used elsewhere, but not directly for this logic
import 'dart:async';
import 'package:supabase_models/cache/cache_export.dart';
part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  /// Remove a variant from the current state by its ID
  void removeVariantById(String variantId) {
    final currentList = state.value ?? [];
    final updatedList = currentList.where((v) => v.id != variantId).toList();
    state = AsyncValue.data(updatedList);
  }

  // Internal state for pagination and loading
  int _currentPage = 0;
  List<Variant> _allLoadedVariants = []; // Holds all variants loaded so far
  final int _itemsPerPage =
      ProxyService.box.itemPerPage() ?? 10; // Sensible default
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  FutureOr<List<Variant>> build(int branchId) async {
    final searchString = ref.watch(searchStringProvider);

    // Reset state only on initial build or when branchId changes
    _currentPage = 0;
    _allLoadedVariants = []; // Clear variants on new build/search
    _hasMore = true;
    _isLoading = false;

    // Initialize cache manager if needed (can be moved out of build for performance if it's truly a one-time thing)
    await _initializeCacheManager();

    // Load initial variants based on current search string and pagination
    final variants = await _fetchAndProcessVariants(
      branchId: branchId,
      page: _currentPage, // Always start from page 0 for a new build/search
      searchString: searchString,
    );

    _allLoadedVariants = variants; // Set the initial list
    return _allLoadedVariants;
  }

  /// Initialize the cache manager
  Future<void> _initializeCacheManager() async {
    try {
      // Assuming CacheManager() returns a singleton or is managed by GetIt already
      await CacheManager().initialize();
      // talker.info('Cache manager initialized successfully');
    } catch (e) {
      // talker.info('Failed to initialize cache manager: $e');
    }
  }

  /// Save Stock objects to cache
  Future<void> _saveStocksToCache(List<Variant> variants) async {
    try {
      final variantsWithStock = variants.where((v) => v.stock != null).toList();

      if (variantsWithStock.isNotEmpty) {
        // talker.info('Saving ${variantsWithStock.length} stocks to cache');
        await CacheManager().saveStocksForVariants(
            variantsWithStock); // Pass only variants with stock
        // talker.info('Stocks saved to cache successfully');
      }
    } catch (e) {
      // talker.info('Failed to save stocks to cache: $e');
    }
  }

  /// Centralized method to fetch variants, handle local/remote fallback, and process them.
  /// This method only *fetches* data and updates internal pagination state,
  /// but doesn't directly set the `state` of the provider.
  Future<List<Variant>> _fetchAndProcessVariants({
    required int branchId,
    required int page,
    required String searchString,
  }) async {
    if (!_hasMore) {
      // No more to load globally
      talker.info('No more variants to fetch.');
      return [];
    }

    _isLoading = true; // Set loading state internally

    List<Variant> fetchedVariants = [];
    try {
      final isVatEnabled = ProxyService.box.vatEnabled();
      final List<String> taxTyCds = isVatEnabled ? ['A', 'B', 'C'] : ['D'];
      talker.info("taxTyCds: $taxTyCds");

      // Attempt local fetch first
      fetchedVariants = await ProxyService.strategy.variants(
        name: searchString,
        fetchRemote: false,
        branchId: branchId,
        page: page,
        itemsPerPage: _itemsPerPage,
        taxTyCds: taxTyCds,
      );

      // If no variants found locally AND a search string is active, try remote.
      // Do not fallback to remote if searchString is empty (i.e., initial load)
      // unless that's your explicit design. The test implies fallback on search.
      if (fetchedVariants.isEmpty && searchString.isNotEmpty) {
        talker.info('Local search empty for "$searchString", trying remote...');
        fetchedVariants = await ProxyService.strategy.variants(
          name: searchString,
          fetchRemote: true,
          branchId: branchId,
          page: page,
          itemsPerPage: _itemsPerPage,
          taxTyCds: taxTyCds,
        );
      }

      // Save stock to cache for the retrieved variants.
      if (fetchedVariants.isNotEmpty) {
        await _saveStocksToCache(fetchedVariants);
      }

      // Update pagination logic. This applies to the *source* of the data.
      _hasMore = fetchedVariants.length == _itemsPerPage;
      _currentPage++; // Increment page for the *next* fetch

      return fetchedVariants;
    } on TimeoutException {
      talker.info('Timeout: Variants loading took too long');
      rethrow; // Let the caller (build or loadMore) handle the error state
    } catch (error, stackTrace) {
      talker.info('Error loading variants: $error');
      rethrow; // Let the caller handle the error state
    } finally {
      _isLoading = false; // Reset loading state
    }
  }

  // loadMore should only increment the page and then fetch using the common method
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) {
      talker.info('loadMore: Currently loading or no more items. Skipping.');
      return;
    }

    state = AsyncValue.loading(); // Indicate loading new page
    try {
      final newVariants = await _fetchAndProcessVariants(
        branchId: branchId, 
        page:
            _currentPage, // Use the _currentPage which was already incremented in _fetchAndProcessVariants
        searchString: ref.read(searchStringProvider),
      );

      // Append new variants to the existing list, then update the provider's state
      _allLoadedVariants = [..._allLoadedVariants, ...newVariants];
      state = AsyncValue.data(_allLoadedVariants);
    } catch (e, st) {
      // If loadMore fails, decrement page as it didn't complete successfully
      _currentPage--;
      state = AsyncValue.error(e, st);
    }
  }
}

// Keep your Products provider as is if it's not part of the problem.
@riverpod
class Products extends _$Products {
  @override
  FutureOr<List<Product>> build(int branchId) async {
    final searchString = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);

    if (!scanMode) {
      await loadProducts(searchString: searchString, scanMode: scanMode);
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
        Product? additionalProduct = await ProxyService.strategy.getProduct(
          name: searchString,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
        );

        if (additionalProduct != null) {
          products.add(additionalProduct);
        }
      }

      List<Product> matchingProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();

      state = AsyncData(matchingProducts);

      if (matchingProducts.isNotEmpty) {
        _expandProduct(matchingProducts.first);
      } else {
        state = AsyncData(products);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void _expandProduct(Product product) {
    state.whenData((currentData) {
      final updatedProducts = currentData.map((p) {
        if (p.id == product.id && !p.searchMatch!) {
          p.searchMatch = true;
        } else {
          p.searchMatch = false;
        }
        return p;
      }).toList();

      final equality = ListEquality();
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
