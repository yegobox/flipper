import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// typedef ChatRef = void Function();
// // Define a StreamProvider that takes a ChatRef as a parameter
// final productsProvider =
//     StreamProvider.family<List<Product>, String?>((ref, prodIndex) {
//   return ProxyService.isar.productStreams(prodIndex: prodIndex);
// });
final searchStringProvider =
    StateNotifierProvider<SearchStringNotifier, String>((ref) {
  return SearchStringNotifier();
});

class SearchStringNotifier extends StateNotifier<String> {
  SearchStringNotifier() : super("");

  void emitString({required String value}) {
    log(value, name: 'emitted search');
    state = value;
  }
}

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final int branchId;

  ProductsNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadProducts({required String searchString}) async {
    try {
      List<Product> products =
          await ProxyService.isar.productsFuture(branchId: branchId);

      if (searchString.isNotEmpty) {
        products = products
            .where((product) =>
                product.name.toLowerCase().contains(searchString.toLowerCase()))
            .toList();
      }

      state = AsyncData(products);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void addProducts({required List<Product> products}) {
    final currentData = state.value ?? [];
    final List<Product> updatedProducts = [...currentData, ...products];
    state = AsyncData(updatedProducts);
  }

  void deleteProduct({required String productId}) {
    state.maybeWhen(
      data: (currentData) {
        final updatedProducts =
            currentData.where((product) => product.id != productId).toList();
        state = AsyncData(updatedProducts);
      },
      orElse: () {},
    );
  }

  List<Product> filterProducts(List<Product> products, String searchString) {
    if (searchString.isNotEmpty) {
      return products
          .where((product) =>
              product.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    }
    return products;
  }
}

final productsProvider = StateNotifierProviderFamily<ProductsNotifier,
    AsyncValue<List<Product>>, int>((ref, branchId) {
  final productsNotifier = ProductsNotifier(branchId);
  final searchString = ref.watch(searchStringProvider);
  productsNotifier.loadProducts(searchString: searchString);

  return productsNotifier;
});

// scanning
final scanningModeProvider =
    StateNotifierProvider<ScanningModeNotifier, bool>((ref) {
  return ScanningModeNotifier();
});

class ScanningModeNotifier extends StateNotifier<bool> {
  ScanningModeNotifier() : super(false);

  void toggleScanningMode() {
    state = !state;
  }
}
// end scanning

// ordering
final receivingOrdersModeProvider =
    StateNotifierProvider<ReceiveOrderModeNotifier, bool>((ref) {
  return ReceiveOrderModeNotifier();
});

class ReceiveOrderModeNotifier extends StateNotifier<bool> {
  ReceiveOrderModeNotifier() : super(false);

  void toggleReceiveOrder() {
    state = !state;
  }
}
// end ordering


