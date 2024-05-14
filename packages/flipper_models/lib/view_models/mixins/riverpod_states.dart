import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/realm_model_export.dart' as cat;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '_transaction.dart';

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

final stocValueProvider =
    StreamProvider.autoDispose.family<double, int>((ref, branchId) {
  return ProxyService.realm.stockValue(branchId: branchId);
});

final soldStockValueProvider =
    StreamProvider.autoDispose.family<double, int>((ref, branchId) {
  return ProxyService.realm.soldStockValue(branchId: branchId);
});

final stockByVariantIdProvider =
    StreamProvider.autoDispose.family<double, int>((ref, variantId) {
  return ProxyService.realm.getStockStream(variantId: variantId);
});

final variantsProvider = FutureProvider.autoDispose
    .family<List<Variant>, int?>((ref, productId) async {
  // Fetch the list of variants from a remote service.
  final variants = await ProxyService.realm.variants(
      branchId: ProxyService.box.getBranchId()!, productId: productId ?? 0);

  return variants;
});

final pendingTransactionProvider = FutureProvider.autoDispose
    .family<AsyncValue<ITransaction>, String>((ref, mode) async {
  try {
    ITransaction pendingTransaction =
        await ProxyService.realm.manageTransaction(transactionType: mode);
    return AsyncData(pendingTransaction);
  } catch (error) {
    return AsyncError(error, StackTrace.current);
  }
});
final talker = TalkerFlutter.init();

final transactionItemsProvider = StateNotifierProvider.autoDispose
    .family<TransactionItemsNotifier, AsyncValue<List<TransactionItem>>, int?>(
  (ref, currentTransaction) {
    return TransactionItemsNotifier(
        currentTransaction: currentTransaction ?? 0);
  },
);

class TransactionItemsNotifier
    extends StateNotifier<AsyncValue<List<TransactionItem>>> {
  TransactionItemsNotifier({required int currentTransaction})
      : super(AsyncLoading()) {
    loadItems(currentTransaction: currentTransaction);
  }

  Future<List<TransactionItem>> loadItems(
      {required int currentTransaction}) async {
    try {
      talker.info("Loading transactionId ${currentTransaction}");
      state = AsyncLoading();

      // Await the future and store the result in a local variable
      final items = await ProxyService.realm.transactionItems(
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
      final transaction = await ProxyService.realm
          .manageTransaction(transactionType: TransactionType.custom);
      ProxyService.realm.realm!.write(() {
        transaction.subTotal = totalPayable;
      });
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
  final scanMode = ref.watch(scanningModeProvider);
  final searchString = ref.watch(searchStringProvider);
  productsNotifier.loadVariants(
    scanMode: scanMode,
    searchString: searchString,
  );

  return productsNotifier;
});

class OuterVariantsNotifier extends StateNotifier<AsyncValue<List<Variant>>>
    with TransactionMixin {
  int branchId;

  OuterVariantsNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadVariants(
      {required bool scanMode, required String searchString}) async {
    try {
      final allVariants = await ProxyService.realm.variants(
        branchId: ProxyService.box.getBranchId()!,
      );

      // Apply search if searchString is not empty
      final filteredVariants = searchString.isNotEmpty
          ? allVariants
              .where((variant) => variant.name!
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
  final scanMode = ref.watch(scanningModeProvider);
  if (!scanMode) {
    productsNotifier.loadProducts(
        searchString: searchString, scanMode: scanMode);
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
    required bool scanMode,
  }) async {
    try {
      List<Product> products =
          await ProxyService.realm.productsFuture(branchId: branchId);

      // Fetch additional products beyond the initial 20 items
      if (searchString.isNotEmpty) {
        List<Product?> additionalProducts =
            await ProxyService.realm.getProductByName(name: searchString);

        // Filter out null products and cast non-null products to Product type
        products.addAll(additionalProducts
            .where((product) => product != null)
            .map((product) => product as Product));
      }

      // Apply search filter to the merged list
      List<Product> matchingProducts = products
          .where((product) =>
              product.name!.toLowerCase().contains(searchString.toLowerCase()))
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

  void deleteProduct({required int productId}) {
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
          await ProxyService.realm.customers(branchId: branchId);

      if (searchString.isNotEmpty) {
        customers = customers
            .where((customer) => customer.custNm!
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
          .where((customer) => customer.custNm!
              .toLowerCase()
              .contains(searchString.toLowerCase()))
          .toList();
    }
    return customers;
  }
}

final variantsFutureProvider = FutureProvider.autoDispose
    .family<AsyncValue<List<Variant>>, int>((ref, productId) async {
  final data =
      await ProxyService.realm.getVariantByProductId(productId: productId);
  return AsyncData(data);
});

final ordersStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  int branchId = ProxyService.box.getBranchId() ?? 0;
  return ProxyService.realm.orders(branchId: branchId);
});

final categoryStreamProvider =
    StreamProvider.autoDispose<List<cat.Category>>((ref) {
  final category = ProxyService.realm.categoryStream();

  // Return the stream
  return category;
});

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.realm
      .transactionsStream(branchId: ProxyService.box.getBranchId());

  // Return the stream
  return transactionsStream;
});

final unitsProvider =
    FutureProvider.autoDispose<AsyncValue<List<IUnit>>>((ref) async {
  try {
    final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits = await ProxyService.realm.units(branchId: branchId);

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
  final transactions = ProxyService.realm
      .transactionList(startDate: startDate, endDate: endDate);

  return transactions.handleError((error) {
    // If an error occurs in the stream, emit the error so that the UI can display it
    return [];
  });
});

final variantStreamProvider =
    StreamProvider.autoDispose.family<List<Variant>, int>((ref, id) {
  return ProxyService.realm
      .getVariantByProductIdStream(productId: id)
      .distinct((prev, next) =>
          prev.map((e) => e.retailPrice).join() ==
          next.map((e) => e.retailPrice).join())
      .handleError((error) => []);
});

final transactionItemsStreamProvider = StreamProvider.autoDispose
    .family<List<TransactionItem>, int?>((ref, transactionId) {
  return ProxyService.realm.transactionItemsStreams(
    transactionId: transactionId ?? 0,
    doneWithTransaction: false,
    active: true,
  );
});

final currentTransactionsByIdStream =
    StreamProvider.autoDispose.family<List<ITransaction>, int>((ref, id) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.realm
      .transactionStreamById(id: id, filterType: FilterType.TRANSACTION);

  // Return the stream
  return transactionsStream;
});

final selectImportItemsProvider = FutureProvider.autoDispose
    .family<RwApiResponse, int?>((ref, productId) async {
  // Fetch the list of variants from a remote service.
  final response = await ProxyService.realm.selectImportItems(
      tin: 999909695, bhfId: "00", lastReqDt: "20210331000000");

  return response;
});
