import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_transaction.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// typedef ChatRef = void Function();
// // Define a StreamProvider that takes a ChatRef as a parameter
// final productsProvider =
//     StreamProvider.family<List<Product>, String?>((ref, prodIndex) {
//   return ProxyService.isar.productStreams(prodIndex: prodIndex);
// });
final productProvider = StateNotifierProvider<ProductNotifier, Product?>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<Product?> {
  ProductNotifier() : super(null);

  void emitProduct({required Product value}) {
    state = value;
  }
}

final customerSearchStringProvider =
    StateNotifierProvider.autoDispose<CustomerSearchStringNotifier, String>(
        (ref) {
  return CustomerSearchStringNotifier();
});

class CustomerSearchStringNotifier extends StateNotifier<String> {
  CustomerSearchStringNotifier() : super("");

  void emitString({required String value}) {
    state = value;
  }
}

final searchStringProvider =
    StateNotifierProvider.autoDispose<SearchStringNotifier, String>((ref) {
  return SearchStringNotifier();
});

class SearchStringNotifier extends StateNotifier<String> {
  SearchStringNotifier() : super("");

  void emitString({required String value}) {
    state = value;
  }
}

enum SellingMode {
  forOrdering,
  forHere,
  forSelling,
  // Add other modes as needed
}

// Change the argument type to SellingMode
final sellingModeProvider =
    StateNotifierProvider.autoDispose<SellingModeNotifier, SellingMode>((ref) {
  return SellingModeNotifier();
});

class SellingModeNotifier extends StateNotifier<SellingMode> {
  // Declare an optional named parameter with a default value
  SellingModeNotifier({SellingMode mode = SellingMode.forSelling})
      : super(mode);

  SellingMode setSellingMode(SellingMode mode) {
    state = mode;
    return state;
  }
}

final variantsProvider = FutureProvider.autoDispose
    .family<List<Variant>, String?>((ref, productId) async {
  // Fetch the list of variants from a remote service.
  final variants = await ProxyService.isar.variants(
      branchId: ProxyService.box.getBranchId()!, productId: productId ?? "");

  return variants;
});

final pendingTransactionProvider = FutureProvider.autoDispose
    .family<AsyncValue<ITransaction>, String>((ref, mode) async {
  try {
    ITransaction pendingTransaction =
        await ProxyService.isar.manageTransaction(transactionType: mode);
    return AsyncData(pendingTransaction);
  } catch (error) {
    return AsyncError(error, StackTrace.current);
  }
});

final transactionItemsProvider = StateNotifierProvider.autoDispose.family<
    TransactionItemsNotifier, AsyncValue<List<TransactionItem>>, String?>(
  (ref, currentTransaction) {
    return TransactionItemsNotifier(
        currentTransaction: currentTransaction ?? "0");
  },
);

class TransactionItemsNotifier
    extends StateNotifier<AsyncValue<List<TransactionItem>>> {
  TransactionItemsNotifier({required String currentTransaction})
      : super(AsyncLoading()) {
    loadItems(currentTransaction: currentTransaction);
  }

  Future<List<TransactionItem>> loadItems(
      {required String currentTransaction}) async {
    try {
      state = AsyncLoading();

      // Await the future and store the result in a local variable
      final items = await ProxyService.isar.transactionItems(
          transactionId: currentTransaction,
          doneWithTransaction: false,
          active: true);
      state = AsyncData(items);

      return items;
    } catch (error) {
      state = AsyncError(error, StackTrace.current);

      throw error;
    }
  }

  /// Keep pending transaction with updated subtotal
  Future<void> updatePendingTransaction() async {
    try {
      // Await the future and store the result in a local variable
      final transaction = await ProxyService.isar
          .manageTransaction(transactionType: TransactionType.custom);

      transaction.subTotal = totalPayable;
      await ProxyService.isar.update(data: transaction);
    } catch (error) {
      // Handle error
    }
  }

  int get counts {
    return state.maybeWhen(
      data: (items) {
        return items.length;
      },
      orElse: () => 0,
    );
  }

  double get totalPayable {
    return state.maybeWhen(
      data: (items) {
        return items.fold(0, (a, b) => a + (b.price * b.qty));
      },
      orElse: () => 0.0,
    );
  }
}

final outerVariantsProvider = StateNotifierProvider.autoDispose
    .family<OuterVariantsNotifier, AsyncValue<List<Variant>>, int>(
        (ref, branchId) {
  final productsNotifier = OuterVariantsNotifier(branchId);
  final scannMode = ref.watch(scanningModeProvider);
  final searchString = ref.watch(searchStringProvider);
  if (scannMode) {
    productsNotifier.loadVariants(
      scannMode: scannMode,
      searchString: searchString,
    );
  }

  return productsNotifier;
});

class OuterVariantsNotifier extends StateNotifier<AsyncValue<List<Variant>>>
    with TransactionMixin {
  int branchId;
  OuterVariantsNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadVariants(
      {required bool scannMode, required String searchString}) async {
    try {
      final allVariants = await ProxyService.isar.variants(
        branchId: ProxyService.box.getBranchId()!,
      );

      // Apply search if searchString is not empty
      final filteredVariants = searchString.isNotEmpty
          ? allVariants
              .where((variant) => variant.name
                  .toLowerCase()
                  .contains(searchString.toLowerCase()))
              .toList()
          : allVariants;

      // If there's a match, save the transaction for the first matched variant

      // Update the state with the filtered list of variants.
      state = AsyncValue.data(filteredVariants);
    } catch (error) {
      // Handle errors if needed
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final productsProvider = StateNotifierProvider.autoDispose
    .family<ProductsNotifier, AsyncValue<List<Product>>, int>((ref, branchId) {
  final productsNotifier = ProductsNotifier(branchId, ref);
  final searchString = ref.watch(searchStringProvider);
  final scannMode = ref.watch(scanningModeProvider);
  if (!scannMode) {
    productsNotifier.loadProducts(
        searchString: searchString, scannMode: scannMode);
  }
  return productsNotifier;
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>>
    with TransactionMixin {
  final int branchId;
  final StateNotifierProviderRef<ProductsNotifier, AsyncValue<List<Product>>>
      ref;
  ProductsNotifier(this.branchId, this.ref) : super(AsyncLoading());
  void expanded(Product? product) {
    if (product == null) {
      return;
    }

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

  Future<void> loadProducts(
      {required String searchString, required bool scannMode}) async {
    try {
      List<Product> products =
          await ProxyService.isar.productsFuture(branchId: branchId);
      // if (scannMode) {
      //TODO:work on auto-expanding the product row when a search is match
      /// search variant using name
      // Variant? variant = await ProxyService.isar.variant(name: searchString);
      // if (variant != null) {
      // log(variant.name);
      // log(variant.productId);
      // Product? associatedProduct =
      //     await ProxyService.isar.getProduct(id: variant.productId);
      // if (associatedProduct != null) {
      //   for (Product product in products) {
      //     log(product.name.toLowerCase());
      //     log(product.id.toLowerCase());
      //     log(associatedProduct.name.toLowerCase());
      //     if (product.name.toLowerCase() ==
      //         associatedProduct.name.toLowerCase()) {
      /// if the product is found, call expanded with the product
      // products = products
      //     .where((product) => product.name
      //         .toLowerCase()
      //         .contains(associatedProduct.name))
      //     .toList();
      // print('Before calling expanded with associatedProduct:');
      // expanded(associatedProduct);
      // ref
      //     .read(productsProvider(ProxyService.box.getBranchId()!)
      //         .notifier)
      //     .expanded(associatedProduct);
      // saveTransaction(
      //     variationId: variant.id,
      //     amountTotal: variant.retailPrice,
      //     customItem: false);

      //         print('After calling expanded');
      //       }
      //     }
      //   }
      // }
      // } else {
      if (searchString.isNotEmpty) {
        products = products
            .where((product) =>
                product.name.toLowerCase().contains(searchString.toLowerCase()))
            .toList();
        // }
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
}

// scanning
final scanningModeProvider =
    StateNotifierProvider.autoDispose<ScanningModeNotifier, bool>((ref) {
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

  List<Customer> filterCustomers(
    List<Customer> customers,
    String searchString,
  ) {
    if (searchString.isNotEmpty) {
      return customers
          .where((customer) =>
              customer.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();
    }
    return customers;
  }
}

final customersProvider = StateNotifierProvider.autoDispose
    .family<CustomersNotifier, AsyncValue<List<Customer>>, int>(
        (ref, branchId) {
  final customersNotifier = CustomersNotifier(branchId);
  final searchString = ref.watch(searchStringProvider);
  customersNotifier.loadCustomers(searchString: searchString);

  return customersNotifier;
});

final ordersStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  int branchId = ProxyService.box.getBranchId() ?? 0;
  return ProxyService.isar.orders(branchId: branchId);
});
