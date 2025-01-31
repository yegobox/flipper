import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  int _currentPage = 0;
  final int _itemsPerPage = ProxyService.box.itemPerPage()!;
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
    if (_isLoading || !_hasMore) return [];

    _isLoading = true;

    try {
      final searchString = ref.watch(searchStringProvider);

      // Fetch variants from the API
      final variants = await ProxyService.strategy.variants(
        branchId: branchId,
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
      );

      // Apply search filtering
      final filteredVariants = searchString.isNotEmpty
          ? variants
              .where((variant) =>
                  variant.name
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  variant.productName!
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  (variant.bcd != null &&
                      variant.bcd!.contains(searchString.toLowerCase())))
              .toList()
          : variants;

      // Update pagination state
      _currentPage++;
      _hasMore = filteredVariants.length == _itemsPerPage;

      // Return the filtered variants
      return filteredVariants;
    } catch (error) {
      // Handle errors
      throw error;
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
