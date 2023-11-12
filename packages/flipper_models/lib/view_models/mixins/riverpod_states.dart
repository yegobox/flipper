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

  void expanded(Product product) {
    state.maybeWhen(
      data: (currentData) {
        final updatedProducts = currentData.map((p) {
          // Update the searchMatch property to true for the expanded product
          if (p.id == product.id) {
            p.searchMatch = !p.searchMatch;
          } else {
            // Set searchMatch to false for other products
            p.searchMatch = false;
          }
          return p;
        }).toList();
        state = AsyncData(updatedProducts);
      },
      orElse: () {},
    );
  }
}

final productsProvider = StateNotifierProviderFamily<ProductsNotifier,
    AsyncValue<List<Product>>, int>((ref, branchId) {
  final productsNotifier = ProductsNotifier(branchId);
  final searchString = ref.watch(searchStringProvider);
  productsNotifier.loadProducts(searchString: searchString);

  return productsNotifier;
});

final variantsProvider = StateNotifierProviderFamily<VariantsNotifier,
    AsyncValue<List<Variant>>, String?>((ref, productId) {
  final variantsNotifier = VariantsNotifier(productId);
  ref.onDispose(() => variantsNotifier.dispose());

  // Fetch and update the list of variants.
  variantsNotifier.variants();

  return variantsNotifier;
});

class VariantsNotifier extends StateNotifier<AsyncValue<List<Variant>>> {
  final String? productId;

  VariantsNotifier(this.productId) : super(AsyncLoading());

  Future<void> variants() async {
    // Fetch the list of variants from a remote service.
    final variants = await ProxyService.isar.variants(
        branchId: ProxyService.box.getBranchId()!, productId: productId ?? "");

    // Update the state with the list of variants.
    state = AsyncValue.data(variants);
  }

  @override
  void dispose() {
    // Dispose of any resources that were used to fetch and update the list of variants.
    super.dispose();
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

class CustomersNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final int branchId;

  CustomersNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadCustomers({required String searchString}) async {
    try {
      List<Customer> customers =
          await ProxyService.isar.customers(branchId: branchId);

      if (searchString.isNotEmpty) {
        customers = customers
            .where((customer) => customer.name
                .toLowerCase()
                .contains(searchString.toLowerCase()))
            .toList();
      }

      state = AsyncData(customers);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void addCustomers({required List<Customer> customers}) {
    final currentData = state.value ?? [];
    final List<Customer> updatedCustomers = [...currentData, ...customers];
    state = AsyncData(updatedCustomers);
  }

  void deleteCustomer({required String customerId}) {
    state.maybeWhen(
      data: (currentData) {
        final updatedCustomers =
            currentData.where((customer) => customer.id != customerId).toList();
        state = AsyncData(updatedCustomers);
      },
      orElse: () {},
    );
  }

  List<Customer?>? filterCustomers(
      List<Customer>? customers, String searchString) {
    if (customers == null) {
      return null;
    }

    if (searchString.isNotEmpty) {
      return customers
          .where((customer) =>
              customer.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    }

    return customers;
  }
}

final customersProvider = StateNotifierProviderFamily<CustomersNotifier,
    AsyncValue<List<Customer>>, int>((ref, branchId) {
  final customersNotifier = CustomersNotifier(branchId);
  final searchString = ref.watch(searchStringProvider);
  customersNotifier.loadCustomers(searchString: searchString);

  return customersNotifier;
});
