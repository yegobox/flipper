// import 'dart:developer';

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

final productsProvider = StateNotifierProviderFamily<ProductsNotifier,
    AsyncValue<List<Product>>, int>((ref, branchId) {
  return ProductsNotifier(branchId);
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final int branchId;

  ProductsNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadProducts() async {
    try {
      final List<Product> products =
          await ProxyService.isar.productsFuture(branchId: branchId);
      state = AsyncData(products);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void addProducts({required List<Product> products}) {
    final currentData = state.value ?? [];
    state = AsyncData([...currentData, ...products]);
  }

  void deleteProduct({required String productId}) {
    state.when(
      data: (currentData) {
        try {
          final updatedProducts =
              currentData.where((product) => product.id != productId).toList();

          state = AsyncData(updatedProducts);
        } catch (error) {
          state = AsyncError(error, StackTrace.current);
        }
      },
      loading: () {
        // State is already loading, no need to modify it
      },
      error: (error, stackTrace) {
        // Handle the error state if needed
      },
    );
  }
}

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

final searchStringProvider =
    StateNotifierProvider<SearchStringNotifier, String>((ref) {
  return SearchStringNotifier();
});

class SearchStringNotifier extends StateNotifier<String> {
  SearchStringNotifier() : super("");

  void emitString({required String value}) {
    state = value;
  }
}
