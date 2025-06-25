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
  /// Remove a variant from the current state by its ID
  void removeVariantById(String variantId) {
    final currentList = state.value ?? [];
    final updatedList = currentList.where((v) => v.id != variantId).toList();
    state = AsyncValue.data(updatedList);
  }
  int _currentPage = 0;
  final int _itemsPerPage = ProxyService.box.itemPerPage() ?? 1000;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  FutureOr<List<Variant>> build(int branchId, {fetchRemote = false}) async {
    // Reset state when the provider is rebuilt (e.g., branchId changes)
    _currentPage = 0;
    _hasMore = true;
    _isLoading = false;

    // Initialize cache manager if needed
    await _initializeCacheManager();

    // Load initial variants
    return await _loadVariants(branchId, fetchRemote: fetchRemote);
  }

  /// Initialize the cache manager
  Future<void> _initializeCacheManager() async {
    try {
      await CacheManager().initialize();
      print('Cache manager initialized successfully');
    } catch (e) {
      print('Failed to initialize cache manager: $e');
    }
  }

  /// Save Stock objects to cache
  Future<void> _saveStocksToCache(List<Variant> variants) async {
    try {
      // Filter variants with stock information
      final variantsWithStock = variants.where((v) => v.stock != null).toList();

      if (variantsWithStock.isNotEmpty) {
        print('Saving ${variantsWithStock.length} stocks to cache');

        // Save stocks to cache
        await CacheManager().saveStocksForVariants(variants);
        print('Stocks saved to cache successfully');
      }
    } catch (e) {
      print('Failed to save stocks to cache: $e');
    }
  }

  Future<List<Variant>> _loadVariants(int branchId,
      {bool fetchRemote = false}) async {
    // Early return if already loading or no more items to load
    if (_isLoading || !_hasMore) return [];

    _isLoading = true;
    print('Loading variants for branchId: $branchId, page: $_currentPage');

    try {
      final searchString = ref.watch(searchStringProvider);
      print('Search string: $searchString');

      // Get VAT enabled status
      final bool isVatEnabled = ProxyService.box.vatEnabled();
      print('VAT status - Enabled: $isVatEnabled');

      // First try to fetch variants locally
      List<Variant> variants = await ProxyService.strategy
          .variants(
            name: searchString,
            fetchRemote: fetchRemote, // First try locally
            branchId: branchId,
            page: _currentPage,
            itemsPerPage: _itemsPerPage,
          )
          .timeout(
              const Duration(seconds: 10)); // Add a timeout to prevent hanging

      // Filter variants based on VAT status
      variants = variants.where((variant) {
        if (isVatEnabled) {
          // When VAT is enabled, exclude items with taxTyCd == 'D'
          return variant.taxTyCd != 'D';
        } else {
          // When VAT is disabled, only include items with taxTyCd == 'D'
          return (variant.taxTyCd ?? '') == 'D';
        }
      }).toList();

      print('Filtered ${variants.length} variants based on VAT status');

      // If no variants found locally or very few, try to fetch from remote
      if (variants.isEmpty ||
          (variants.length < 5 && searchString.isNotEmpty)) {
        print('Few or no variants found locally, trying remote fetch');

        try {
          // Try to fetch from remote
          final remoteVariants = await ProxyService.strategy
              .variants(
                name: searchString,
                fetchRemote: true, 
                branchId: branchId,
                page: _currentPage,
                itemsPerPage: _itemsPerPage,
              )
              .timeout(
                  const Duration(seconds: 30)); // Longer timeout for remote

          // If we got results from remote, use those instead
          if (remoteVariants.isNotEmpty) {
            print('Found ${remoteVariants.length} variants from remote');
            variants = remoteVariants;

            // Save Stock objects to cache
            _saveStocksToCache(remoteVariants);
          }
        } catch (e) {
          // If remote fetch fails, continue with local results
          print('Remote fetch failed: $e');
        }
      }

      // If search string is empty, return all variants
      if (searchString.isEmpty) {
        _currentPage++;
        _hasMore = variants.length == _itemsPerPage;
        print('Loaded ${variants.length} variants (no search filter)');
        _saveStocksToCache(variants);
        return variants;
      }

      // Filter variants based on the search string
      final filteredVariants = variants.where((variant) {
        return variant.name
                .toLowerCase()
                .contains(searchString.toLowerCase()) ||
            (variant.productName != null &&
                variant.productName!
                    .toLowerCase()
                    .contains(searchString.toLowerCase())) ||
            (variant.bcd != null &&
                variant.bcd!
                    .toLowerCase()
                    .contains(searchString.toLowerCase()));
      }).toList();

      // also save stock in cache

      // If no matches, try fetching by barcode if the search string looks like a barcode
      if (filteredVariants.isEmpty && _isNumeric(searchString)) {
        print('No matches found, trying barcode search for: $searchString');
        try {
          final barcodeVariants = await ProxyService.strategy
              .variants(
                bcd: searchString,
                fetchRemote: true, // Always try remote for barcode search
                branchId: branchId,
              )
              .timeout(const Duration(seconds: 20));

          if (barcodeVariants.isNotEmpty) {
            print('Found ${barcodeVariants.length} variants by barcode');
            _currentPage++;
            _hasMore = barcodeVariants.length == _itemsPerPage;
            return barcodeVariants;
          }
        } catch (e) {
          print('Barcode search failed: $e');
        }
      }

      // If still no matches, return the unfiltered list
      if (filteredVariants.isEmpty) {
        print('No matches found for search string: $searchString');
        _currentPage++;
        _hasMore = variants.length == _itemsPerPage;
        return variants; // Return unfiltered list
      }

      // Update pagination state
      _currentPage++;
      _hasMore = filteredVariants.length == _itemsPerPage;

      print('Loaded ${filteredVariants.length} variants (filtered)');
      return filteredVariants;
    } on TimeoutException {
      print('Timeout: Variants loading took too long');
      state = AsyncValue.error(
          'Timeout: Variants loading took too long', StackTrace.current);
      return [];
    } catch (error, stackTrace) {
      print('Error loading variants: $error');
      print('Stack trace: $stackTrace');
      state = AsyncValue.error(error, stackTrace);
      return [];
    } finally {
      _isLoading = false;
    }
  }

  // Helper method to check if a string is numeric (likely a barcode)
  bool _isNumeric(String str) {
    if (str.isEmpty) return false;
    return double.tryParse(str) != null;
  }

  Future<void> loadMore(int branchId) async {
    if (_isLoading || !_hasMore) return;

    // Load more variants
    final newVariants = await _loadVariants(branchId);

    // Update the state with the new variants
    state = AsyncValue.data([...state.value ?? [], ...newVariants]);
  }
}

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
