import 'dart:developer';

import 'package:flutter/foundation.dart';
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

final stockByVariantIdProvider =
    StreamProvider.autoDispose.family<double, String>((ref, variantId) {
  return ProxyService.isar.getStockStream(variantId: variantId);
});

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

final matchedProductProvider = Provider.autoDispose<Product?>((ref) {
  final productsState =
      ref.watch(productsProvider(ProxyService.box.getBranchId()!));
  return productsState.maybeWhen(
    data: (products) {
      try {
        return products.firstWhere((product) => product.searchMatch == true);
      } catch (e) {
        return null; // Return null if no matching product is found
      }
    },
    orElse: () => null,
  );
});

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
          if (p.id == product.id && !p.searchMatch) {
            p.searchMatch = true;
          } else {
            // Set searchMatch to false for other products
            p.searchMatch = false;
          }
          return p;
        }).toList();

        // Check if the products list actually changed before updating the state
        if (!listEquals(currentData, updatedProducts)) {
          state = AsyncData(updatedProducts);
        }
      },
      orElse: () {},
    );
  }

  Future<void> loadProducts({
    required String searchString,
    required bool scannMode,
  }) async {
    try {
      List<Product> products =
          await ProxyService.isar.productsFuture(branchId: branchId);

      // Fetch additional products beyond the initial 20 items
      if (searchString.isNotEmpty) {
        List<Product?> additionalProducts =
            await ProxyService.isar.getProductByName(name: searchString);
        log(additionalProducts.toString());
        // Filter out null products and cast non-null products to Product type
        products.addAll(additionalProducts
            .where((product) => product != null)
            .map((product) => product as Product));
      }

      // Apply search filter to the merged list
      List<Product> matchingProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(searchString.toLowerCase()))
          .toList();

      state = AsyncData(matchingProducts);

      if (matchingProducts.isNotEmpty) {
        // If there's at least one matching product, expand the first one
        Product matchingProduct = matchingProducts.first;
        expanded(matchingProduct);
      }
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

final customersProvider = StateNotifierProvider.autoDispose<CustomersNotifier,
    AsyncValue<List<Customer>>>((ref) {
  int branchId = ProxyService.box.getBranchId()!;
  final customersNotifier = CustomersNotifier(branchId);
  final searchString = ref.watch(searchStringProvider);
  customersNotifier.loadCustomers(searchString: searchString);

  return customersNotifier;
});

class CustomersNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final int branchId;

  CustomersNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadCustomers({required String searchString}) async {
    try {
      await Future.delayed(
          Duration(seconds: 3)); // await any ongoing database persistance
      List<Customer> customers =
          await ProxyService.isar.customers(branchId: branchId);

      if (searchString.isNotEmpty) {
        customers = customers
            .where((customer) => customer.custNm
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
          .where((customer) => customer.custNm
              .toLowerCase()
              .contains(searchString.toLowerCase()))
          .toList();
    }
    return customers;
  }
}

final variantsFutureProvider = FutureProvider.autoDispose
    .family<AsyncValue<List<Variant>>, String>((ref, productId) async {
  final data =
      await ProxyService.isar.getVariantByProductId(productId: productId);
  return AsyncData(data);
});

final ordersStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  int branchId = ProxyService.box.getBranchId() ?? 0;
  return ProxyService.isar.orders(branchId: branchId);
});

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.isar.transactionsStream();

  // Return the stream
  return transactionsStream;
});

final unitsProvider =
    FutureProvider.autoDispose<AsyncValue<List<IUnit>>>((ref) async {
  try {
    final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits = await ProxyService.isar.units(branchId: branchId);

    return AsyncData(existingUnits);
  } catch (error) {
    // Return AsyncError with error and stack trace
    return AsyncError(error, StackTrace.current);
  }
});

// create riverpod to track the index of button clicked
final buttonIndexProvider =
    StateNotifierProvider.autoDispose<ButtonIndexNotifier, int>((ref) {
  return ButtonIndexNotifier();
});

class ButtonIndexNotifier extends StateNotifier<int> {
  ButtonIndexNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

//DateTime range provider
final dateRangeProvider =
    StateNotifierProvider.autoDispose<DateRangeNotifier, Map<String, DateTime>>(
  (ref) => DateRangeNotifier(),
);

class DateRangeNotifier extends StateNotifier<Map<String, DateTime>> {
  DateRangeNotifier() : super({});

  void setStartDate(DateTime startDate) {
    state = {...state, 'startDate': startDate};
  }

  void setEndDate(DateTime endDate) {
    state = {...state, 'endDate': endDate};
  }
}

final transactionListProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  final startDate = ref.read(dateRangeProvider)['startDate'];
  final endDate = ref.read(dateRangeProvider)['endDate'];

  // Check if startDate or endDate is null, and return an empty stream if either is null
  if (startDate == null || endDate == null) {
    return Stream.empty();
  }
  final transactions =
      ProxyService.isar.transactionList(startDate: startDate, endDate: endDate);

  return transactions.handleError((error) {
    // If an error occurs in the stream, emit the error so that the UI can display it
    return [];
  });
});
