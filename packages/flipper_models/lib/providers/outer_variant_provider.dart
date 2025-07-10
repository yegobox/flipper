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
    if (_isLoading || !_hasMore) return [];

    _isLoading = true;

    try {
      final searchString = ref.watch(searchStringProvider);
      final isVatEnabled = ProxyService.box.vatEnabled();

      // Determine the tax codes to filter by at the database level.
      final List<String> taxTyCds = isVatEnabled ? ['A', 'B', 'C'] : ['D'];

      // First, try to fetch variants locally with the tax filter.
      List<Variant> variants = await ProxyService.strategy.variants(
        name: searchString,
        fetchRemote: false, // Start with local
        branchId: branchId,
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
        taxTyCds: taxTyCds,
      );

      // If no variants were found locally, try fetching from remote.
      if (variants.isEmpty) {
        try {
          variants = await ProxyService.strategy.variants(
            name: searchString,
            fetchRemote: true, // Fetch remote as a fallback
            branchId: branchId,
            page: _currentPage,
            itemsPerPage: _itemsPerPage,
            taxTyCds: taxTyCds, // Apply the same tax filter to the remote query
          );
        } catch (e) {
          print('Remote variant fetch failed: $e');
        }
      }

      // Save stock to cache for the retrieved variants.
      if (variants.isNotEmpty) {
        _saveStocksToCache(variants);
      }

      // Update pagination state.
      _currentPage++;
      _hasMore = variants.length == _itemsPerPage;

      return variants;
    } on TimeoutException {
      print('Timeout: Variants loading took too long');
      state = AsyncValue.error(
          'Timeout: Variants loading took too long', StackTrace.current);
      return [];
    } catch (error, stackTrace) {
      print('Error loading variants: $error');
      state = AsyncValue.error(error, stackTrace);
      return [];
    } finally {
      _isLoading = false;
    }
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
