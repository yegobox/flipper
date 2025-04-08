import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:async';
part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  int _currentPage = 0;
  final int _itemsPerPage = ProxyService.box.itemPerPage() ?? 1000;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  FutureOr<List<Variant>> build(int branchId) async {
    // Reset state when the provider is rebuilt (e.g., branchId changes)
    _currentPage = 0;
    _hasMore = true;
    _isLoading = false;

    // Load initial variants
    return await _loadVariants(branchId);
  }

  Future<List<Variant>> _loadVariants(int branchId) async {
    // Early return if already loading or no more items to load
    if (_isLoading || !_hasMore) return [];

    _isLoading = true;
    print('Loading variants for branchId: $branchId, page: $_currentPage');

    try {
      final searchString = ref.watch(searchStringProvider);
      print('Search string: $searchString');

      // Fetch variants from the API with a timeout
      final variants = await ProxyService.strategy
          .variants(
            branchId: branchId,
            page: _currentPage,
            itemsPerPage: _itemsPerPage,
          )
          .timeout(
              const Duration(seconds: 30)); // Add a timeout to prevent hanging

      // If search string is empty, return all variants
      if (searchString.isEmpty) {
        _currentPage++;
        _hasMore = variants.length == _itemsPerPage;
        print('Loaded ${variants.length} variants (no search filter)');
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

      // If no matches, return the unfiltered list
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
