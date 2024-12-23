import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/realm_model_export.dart' as cat;
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '_transaction.dart';
import 'package:http/http.dart' as http;

final unsavedProductProvider =
    StateNotifierProvider<ProductNotifier, Product?>((ref) {
  return ProductNotifier();
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
    try {
      final url =
          await ProxyService.box.getServerUrl() ?? "https://example.com";
      final response = await http.get(Uri.parse(url));

      print('Connectivity check!: ${response.statusCode == 200}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  });
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
  // forHere,
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
  return ProxyService.strategy.stockValue(branchId: branchId);
});

final soldStockValueProvider =
    StreamProvider.autoDispose.family<double, int>((ref, branchId) {
  return ProxyService.strategy.soldStockValue(branchId: branchId);
});
final initialStockProvider =
    StreamProvider.autoDispose.family<double, int>((ref, branchId) {
  return ProxyService.strategy.soldStockValue(branchId: branchId);
});
final transactionItemsStreamProvider = StreamProvider.autoDispose
    .family<List<TransactionItem>, int?>((ref, transactionId) {
  return ProxyService.strategy.transactionItemsStreams(
    branchId: ProxyService.box.getBranchId()!,
    transactionId: transactionId ?? 0,
    doneWithTransaction: false,
    active: true,
  );
});

final transactionItemProvider = Provider.autoDispose
    .family<List<TransactionItem>, ({int branchId, int transactionId})>(
        (ref, params) {
  final (:branchId, :transactionId) = params;

  return ProxyService.strategy.transactionItemsFuture(
    transactionId: transactionId,
    doneWithTransaction: false,
    active: true,
  );
});

final stockByVariantIdProvider =
    StreamProvider.autoDispose.family<double, int>((ref, variantId) {
  int branchId = ProxyService.box.getBranchId()!;
  return ProxyService.strategy
      .getStockStream(variantId: variantId, branchId: branchId);
});

final paginatedVariantsProvider = StateNotifierProvider.family<
    PaginatedVariantsNotifier,
    AsyncValue<List<Variant>>,
    int>((ref, productId) {
  return PaginatedVariantsNotifier(productId);
});

class PaginatedVariantsNotifier
    extends StateNotifier<AsyncValue<List<Variant>>> {
  final int productId;
  int _page = 1;
  static const int _pageSize = 4;
  bool _hasMore = true;
  List<Variant> _allVariants = [];

  PaginatedVariantsNotifier(this.productId)
      : super(const AsyncValue.loading()) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();
    try {
      if (_allVariants.isEmpty) {
        _allVariants = await fetchVariants(productId);
      }

      final startIndex = (_page - 1) * _pageSize;
      final endIndex = startIndex + _pageSize;
      final newVariants = _allVariants.sublist(
        startIndex,
        endIndex.clamp(0, _allVariants.length),
      );

      if (newVariants.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        final currentList = state.value ?? [];
        final updatedList = [...currentList, ...newVariants];
        state = AsyncValue.data(updatedList);
      }

      if (endIndex >= _allVariants.length) {
        _hasMore = false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<List<Variant>> fetchVariants(int productId) async {
    final branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.strategy
        .variants(branchId: branchId, productId: productId);
  }
}

final pendingTransactionProviderNonStream = FutureProvider.autoDispose
    .family<ITransaction, ({String mode, bool isExpense})>(
  (ref, params) async {
    final (:mode, :isExpense) = params;

    // Access ProxyService to get the branch ID
    final branchId = ProxyService.box.getBranchId()!;

    // Return the result of manageTransaction directly
    return await ProxyService.strategy.manageTransaction(
      transactionType: mode,
      isExpense: isExpense,
      branchId: branchId,
    );
  },
);
final pendingTransactionProvider = StreamProvider.autoDispose
    .family<ITransaction, ({String mode, bool isExpense})>(
  (ref, params) {
    final (:mode, :isExpense) = params;
    // Access ProxyService to get the branch ID
    final branchId = ProxyService.box.getBranchId()!;

    // Return a stream from the manageTransaction method
    return ProxyService.strategy.manageTransactionStream(
      transactionType: mode,
      isExpense: isExpense,
      branchId: branchId,
    );
  },
);

final freshtransactionItemsProviderByIdProvider =
    StateNotifierProvider.autoDispose.family<TransactionItemsNotifier,
        AsyncValue<List<TransactionItem>>, ({int transactionId})>(
  (ref, params) {
    final (:transactionId) = params;

    return TransactionItemsNotifier(
      transactionId: transactionId,
    );
  },
);

final transactionItemsProvider = StateNotifierProvider.autoDispose.family<
    TransactionItemsNotifier,
    AsyncValue<List<TransactionItem>>,
    ({bool isExpense})>(
  (ref, params) {
    final (:isExpense) = params;
    final transaction = ref.watch(pendingTransactionProviderNonStream((isExpense
        ? (mode: TransactionType.cashOut, isExpense: true)
        : (mode: TransactionType.sale, isExpense: false))));

    return TransactionItemsNotifier(
      transactionId: transaction.value?.id,
    );
  },
);

class TransactionItemsNotifier
    extends StateNotifier<AsyncValue<List<TransactionItem>>> {
  final int? transactionId;

  TransactionItemsNotifier({required this.transactionId})
      : super(const AsyncValue.loading()) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    await loadItems(currentTransaction: transactionId ?? 0);
  }

  Future<List<TransactionItem>> loadItems(
      {required int currentTransaction}) async {
    try {
      talker.info("Loading transactionId $currentTransaction");
      state = const AsyncValue.loading();

      final items = ProxyService.strategy.transactionItems(
          branchId: ProxyService.box.getBranchId()!,
          transactionId: currentTransaction,
          doneWithTransaction: false,
          active: true);
      state = AsyncValue.data(items);

      return items;
    } catch (error, stackTrace) {
      talker.error("Error loading transaction items: $error");
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updatePendingTransaction() async {
    try {
      final branchId = ProxyService.box.getBranchId()!;
      final stream = ProxyService.strategy.manageTransactionStream(
        branchId: branchId,
        transactionType: TransactionType.sale,
        isExpense: false,
      );

      // Listen to the stream and process the transaction
      await for (final transaction in stream) {
        // Assuming realm.write is synchronous, process the transaction here

        ProxyService.strategy.updateTransaction(
          transaction: transaction,
          subTotal: totalPayable,
        );
        // Optionally break the loop if only one transaction needs to be updated
        break;
      }
    } catch (error) {
      talker.error("Error updating pending transaction: $error");
    }
  }

  int get counts {
    return state.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );
  }

  double get totalPayable {
    return state.maybeWhen(
      data: (items) => items.fold(0, (a, b) => a + (b.price * b.qty)),
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
        searchOnly: searchString.isNotEmpty);
    return productsNotifier;
  },
);

///The code will now first try to filter the variants based on the search string in the name field.
/// If no match is found in name, it will then search in the productName field.
/// This ensures that the filter prioritizes searching by name and only searches by productName if no matching name is found.
/// With this modification, the OuterVariantsNotifier will filter variants as you intended, giving priority to filtering by name first and then falling back to productName if necessary.
class OuterVariantsNotifier extends StateNotifier<AsyncValue<List<Variant>>>
    with TransactionMixin {
  int branchId;
  int _currentPage = 0;
  final int _itemsPerPage = ProxyService.box.itemPerPage()!;
  bool _hasMore = true;
  bool _isLoading = false;

  OuterVariantsNotifier(this.branchId) : super(AsyncLoading());

  Future<void> loadVariants({
    required bool scanMode,
    required String searchString,
    bool searchOnly = false,
  }) async {
    if (_isLoading || (!_hasMore && !searchOnly)) return;

    _isLoading = true;
    try {
      List<Variant> variants;

      if (searchOnly) {
        // Fetch all variants for search purposes
        variants = await ProxyService.strategy.variants(branchId: branchId);
      } else {
        // Fetch paginated variants
        variants = await ProxyService.strategy.variants(
          branchId: branchId,
          page: _currentPage,
          itemsPerPage: _itemsPerPage,
        );
      }

      // Apply search if searchString is not empty
      final filteredVariants = searchString.isNotEmpty
          ? variants
              // match the variant name
              .where((variant) =>
                  variant.name!
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  // match the productName
                  variant.productName!
                      .toLowerCase()
                      .contains(searchString.toLowerCase()) ||
                  (variant.bcd != null &&
                      variant.bcd!.contains(searchString.toLowerCase())))
              .toList()
          : variants;

      // Update pagination info if not searching
      if (!searchOnly) {
        _currentPage++;
        _hasMore = filteredVariants.length == _itemsPerPage;
      }

      _isLoading = false;

      final currentState = state.value ?? [];
      state = AsyncValue.data([...currentState, ...filteredVariants]);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      _isLoading = false;
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
          if (p.id == product.id && !p.searchMatch!) {
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
          await ProxyService.strategy.productsFuture(branchId: branchId);

      // Fetch additional products beyond the initial 20 items
      if (searchString.isNotEmpty) {
        Product? additionalProducts = await ProxyService.strategy.getProduct(
            name: searchString, branchId: ProxyService.box.getBranchId()!);

        // Filter out null products and cast non-null products to Product type
        products.addAll([additionalProducts!]);
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
      } else {
        state = AsyncData(products);
      }
    } catch (error) {
      if (mounted) state = AsyncError(error, StackTrace.current);
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
      // await any ongoing database persistance
      List<Customer> customers =
          ProxyService.strategy.customers(branchId: branchId);

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
  final data = await ProxyService.strategy.variants(
      productId: productId, branchId: ProxyService.box.getBranchId()!);
  return AsyncData(data);
});

final categoryStreamProvider =
    StreamProvider.autoDispose<List<cat.Category>>((ref) {
  final category = ProxyService.strategy.categoryStream();

  // Return the stream
  return category;
});

final unitsProvider =
    FutureProvider.autoDispose<AsyncValue<List<IUnit>>>((ref) async {
  try {
    final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits = await ProxyService.strategy.units(branchId: branchId);

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
    StateNotifierProvider<DateRangeNotifier, Map<String, DateTime>>(
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

final transactionItemListProvider =
    StreamProvider.autoDispose<List<TransactionItem>>((ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange['startDate'];
  final endDate = dateRange['endDate'];
  final isPluReport = ref.watch(toggleBooleanValueProvider);

  // Use keepAlive to prevent the provider from being disposed immediately
  ref.keepAlive();

  if (startDate == null || endDate == null) {
    return Stream.value([]);
  }

  return ProxyService.strategy
      .transactionItemList(
    startDate: startDate,
    endDate: endDate,
    isPluReport: isPluReport,
  )
      .map((transactions) {
    // talker.info("Transaction Item Data: $transactions");
    return transactions;
  }).handleError((e, stackTrace) {
    talker.error("Error loading transaction items: $e");
    talker.error(stackTrace);
    throw e;
  });
});

final transactionListProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  final dateRange = ref.watch(dateRangeProvider);
  final startDate = dateRange['startDate'];
  final endDate = dateRange['endDate'];

  // Check if startDate or endDate is null, and return an empty list stream if either is null
  if (startDate == null || endDate == null) {
    return Stream.value([]);
  }

  try {
    final stream = ProxyService.strategy.transactionList(
      startDate: startDate,
      endDate: endDate,
    );

    // Use `switchMap` to handle potential changes in dateRangeProvider
    return stream.switchMap((transactions) {
      // Log the received data to the console
      // talker.info("Transaction Data: $transactions");

      // Handle null or empty transactions if needed
      return Stream.value(transactions);
    });
  } catch (e, stackTrace) {
    // Return an error stream if something goes wrong
    talker.info("Error loading transactions: $e");
    return Stream.error(e, stackTrace);
  }
});

final currentTransactionsByIdStream =
    StreamProvider.autoDispose.family<List<ITransaction>, int>((ref, id) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.strategy
      .transactionStreamById(id: id, filterType: FilterType.TRANSACTION);

  // Return the stream
  return transactionsStream;
});

final selectImportItemsProvider = FutureProvider.autoDispose
    .family<RwApiResponse, int?>((ref, productId) async {
  // Fetch the list of variants from a remote service.
  final response = await ProxyService.strategy.selectImportItems(
      tin: 999909695,
      bhfId: (await ProxyService.box.bhfId()) ?? "00",
      lastReqDt: "20210331000000");

  return response;
});

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.strategy
      .transactionsStream(branchId: ProxyService.box.getBranchId());

  // Return the stream
  return transactionsStream;
});

final ordersStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  int branchId = ProxyService.box.getBranchId() ?? 0;
  return ProxyService.strategy.orders(branchId: branchId);
});
final variantStreamProvider =
    StreamProvider.autoDispose.family<List<Variant>, int>((ref, id) {
  return ProxyService.strategy
      .getVariantByProductIdStream(productId: id)
      .distinct((prev, next) =>
          prev.map((e) => e.retailPrice).join() ==
          next.map((e) => e.retailPrice).join())
      .handleError((error) => []);
});

final universalProductsNames =
    FutureProvider.autoDispose<AsyncValue<List<UnversalProduct>>>((ref) async {
  try {
    final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits =
        await ProxyService.strategy.universalProductNames(branchId: branchId);

    return AsyncData(existingUnits);
  } catch (error) {
    // Return AsyncError with error and stack trace
    return AsyncError(error, StackTrace.current);
  }
});

final skuProvider =
    StreamProvider.autoDispose.family<SKU?, int>((ref, branchId) {
  return ProxyService.strategy
      .sku(branchId: branchId, businessId: ProxyService.box.getBusinessId()!);
});

final keypadProvider = StateNotifierProvider<KeypadNotifier, String>((ref) {
  return KeypadNotifier();
});

class KeypadNotifier extends StateNotifier<String> {
  KeypadNotifier() : super("0.00");

  void addKey(String key) {
    if (key == 'C') {
      state = 'C';
    } else if (state == 'C') {
      state = key;
    } else {
      state = state == "0.00" ? key : "$state$key";
    }
  }

  void pop() {
    if (state == 'C') {
      state = "0.00";
    } else if (state.length > 2) {
      state = state.substring(0, state.length - 1);
    } else {
      state = "0.00";
    }
  }

  void reset() {
    state = "0.00";
  }

  String get value => state == 'C' ? '' : state;
}

// State provider for managing loading state

class LoadingState {
  final bool isLoading;
  final String? error;

  const LoadingState({
    this.isLoading = false,
    this.error,
  });

  LoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Create a notifier to handle loading state changes
class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const LoadingState());

  void startLoading() {
    state = state.copyWith(isLoading: true, error: null);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }

  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error);
  }
}

// Define the provider
final loadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

final toggleProvider = StateProvider<bool>((ref) => false);
final previewingCart = StateProvider<bool>((ref) => false);

final refreshProvider = Provider((ref) {
  return CombinedNotifier(ref);
});

class CombinedNotifier {
  final Ref ref;

  CombinedNotifier(this.ref);

  void performActions({required String productName, required bool scanMode}) {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      throw Exception('Branch ID is null!');
    }

    ref.read(searchStringProvider.notifier).emitString(value: "search");
    ref.read(searchStringProvider.notifier).emitString(value: "");

    ref.read(productsProvider(branchId).notifier).loadProducts(
          searchString: productName,
          scanMode: scanMode,
        );
  }
}

// final notificationStreamProvider = StreamProvider<List<AppNotification>>((ref) {
//   return ProxyService.strategy
//       .notificationStream(identifier: ProxyService.box.getBranchId() ?? 0);
// });

final reportsProvider =
    StreamProvider.autoDispose.family<List<Report>, int>((ref, branchId) {
  return ProxyService.strategy.reports(branchId: branchId).map((reports) {
    talker.warning(reports);
    return reports;
  });
});
// TODO: hardcoding 2000 items is not ideal, I need to find permanent solution.
final rowsPerPageProvider = StateProvider<int>((ref) => 2000);

class PluReportToggleNotifier extends StateNotifier<bool> {
  PluReportToggleNotifier() : super(false); // Default to ZReport

  void toggleReport() {
    state = !state;
  }
}

final toggleBooleanValueProvider =
    StateNotifierProvider<PluReportToggleNotifier, bool>((ref) {
  return PluReportToggleNotifier();
});

final isProcessingProvider = StateNotifierProvider<IsProcessingNotifier, bool>(
  (ref) => IsProcessingNotifier(),
);

class IsProcessingNotifier extends StateNotifier<bool> {
  IsProcessingNotifier() : super(false);

  void startProcessing() {
    state = true;
  }

  void stopProcessing() {
    state = false;
  }

  void toggleProcessing() {
    state = !state;
  }
}

const int NO_SELECTION = -1;

final selectedItemIdProvider = StateProvider<int?>((ref) => NO_SELECTION);

final tenantProvider = Provider<Tenant?>((ref) {
  final userId = ProxyService.box.getUserId();
  return ProxyService.strategy.tenant(userId: userId);
});

/// check if a user has either, admin,read,write on a given feature
// StateNotifierProvider
// Provider to get the list of user accesses
final userAccessesProvider = FutureProvider<List<Access>>((ref) async {
  final userId = ProxyService.box.getUserId()!;
  return await ProxyService.strategy.access(userId: userId);
});

final businessesProvider = FutureProvider<List<Business>>((ref) async {
  return await ProxyService.strategy
      .businesses(userId: ProxyService.box.getUserId()!);
});

// Define a provider for the selected branch
final selectedBranchProvider = AutoDisposeStateProvider<Branch?>((ref) => null);
// Provider to check if a user has access to a specific feature
final featureAccessProvider = Provider.family<bool, String>((ref, featureName) {
  final accesses = ref.watch(userAccessesProvider);
  final now = DateTime.now();

  // Check if the elevated permission (e.g., "ticket") is active
  final hasElevatedPermission = accesses.value?.any((access) =>
      access.featureName == AppFeature.Tickets &&
      access.status == 'active' &&
      (access.expiresAt == null || access.expiresAt!.isAfter(now)));

  // If the elevated permission is active, return false for other permissions
  if (hasElevatedPermission! && featureName != AppFeature.Tickets) {
    return false;
  }

  // Normal permission check for the requested feature
  return accesses.value!.any((access) =>
      access.featureName == featureName &&
      access.status == 'active' &&
      (access.expiresAt == null || access.expiresAt!.isAfter(now)));
});

final featureAccessLevelProvider =
    Provider.family<bool, String>((ref, accessLevel) {
  final accesses = ref.watch(userAccessesProvider);
  final now = DateTime.now();
  // Normal permission check for the requested feature
  return accesses.value!.any((access) =>
      access.accessLevel == accessLevel &&
      (access.expiresAt == null || access.expiresAt!.isAfter(now)));
});

class BusinessSelectionState {
  final bool isLoading;
  final Business? selectedBusiness;

  BusinessSelectionState({
    required this.isLoading,
    this.selectedBusiness,
  });

  BusinessSelectionState copyWith({
    bool? isLoading,
    Business? selectedBusiness,
  }) {
    return BusinessSelectionState(
      isLoading: isLoading ?? this.isLoading,
      selectedBusiness: selectedBusiness ?? this.selectedBusiness,
    );
  }
}

class BusinessSelectionNotifier extends StateNotifier<BusinessSelectionState> {
  BusinessSelectionNotifier() : super(BusinessSelectionState(isLoading: false));

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setSelectedBusiness(Business business) {
    state = state.copyWith(selectedBusiness: business);
  }
}

final businessSelectionProvider =
    StateNotifierProvider<BusinessSelectionNotifier, BusinessSelectionState>(
  (ref) => BusinessSelectionNotifier(),
);

class BranchSelectionState {
  final bool isLoading;
  final Branch? selectedBranch;

  BranchSelectionState({
    required this.isLoading,
    this.selectedBranch,
  });

  BranchSelectionState copyWith({
    bool? isLoading,
    Branch? selectedBranch,
  }) {
    return BranchSelectionState(
      isLoading: isLoading ?? this.isLoading,
      selectedBranch: selectedBranch ?? this.selectedBranch,
    );
  }
}

final statusTextProvider = StreamProvider<String?>((ref) {
  return Stream.periodic(const Duration(milliseconds: 100), (_) {
    return ProxyService.status.statusText.value;
  }).distinct();
});

final statusColorProvider = StreamProvider<Color?>((ref) {
  return Stream.periodic(const Duration(milliseconds: 100), (_) {
    return ProxyService.status.statusColor.value;
  }).distinct();
});

class BranchSelectionNotifier extends StateNotifier<BranchSelectionState> {
  BranchSelectionNotifier() : super(BranchSelectionState(isLoading: false));

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setSelectedBranch(Branch branch) {
    state = state.copyWith(selectedBranch: branch);
  }
}

final branchSelectionProvider =
    StateNotifierProvider<BranchSelectionNotifier, BranchSelectionState>(
  (ref) => BranchSelectionNotifier(),
);

final stockRequestsProvider = StreamProvider.autoDispose
    .family<List<StockRequest>, ({String filter})>((ref, params) {
  final branchId = ProxyService.box.getBranchId();
  final (:filter) = params;
  if (branchId == null) {
    return Stream.empty();
  }
  return ProxyService.strategy
      .requestsStream(branchId: branchId, filter: filter);
});

final stocksProvider =
    Provider.autoDispose.family<List<Stock>, ({int branchId})>((ref, params) {
  final (:branchId) = params;

  return ProxyService.strategy.stocks(branchId: branchId);
});

final branchesProvider = FutureProvider.autoDispose
    .family<List<Branch>, ({bool? includeSelf})>((ref, params) async {
  final (:includeSelf) = params;
  final businessId = ProxyService.box.getBusinessId();

  // Awaiting the asynchronous call
  final branches = await ProxyService.strategy
      .branches(businessId: businessId!, includeSelf: includeSelf);

  return branches;
});

class StringState extends StateNotifier<String> {
  StringState(String initialValue) : super(initialValue);

  void updateString(String newString) {
    state = newString;
  }
}

class Payment {
  double amount;
  String method;
  TextEditingController controller;
  final String id;

  Payment({
    required this.amount,
    required this.method,
    String? id,
  })  : controller = TextEditingController(text: amount.toString()),
        id = id ?? UniqueKey().toString();
}

class PaymentMethodsNotifier extends StateNotifier<List<Payment>> {
  PaymentMethodsNotifier()
      : super([
          Payment(amount: 0.0, method: 'Cash'),
        ]);

  // Method to add a payment method
  void addPaymentMethod(Payment method) {
    try {
      final existingIndex = state.indexWhere(
          (existingMethod) => existingMethod.method == method.method);
      if (existingIndex != -1) {
        state[existingIndex] = method;
      } else {
        state = [...state, method];
      }
    } catch (e) {}
  }

  void updatePaymentMethod(int index, Payment payment,
      {required int transactionId}) {
    final updatedList = List<Payment>.from(state);
    updatedList[index] = payment;
    state = updatedList;

    talker.warning("Payment Lenght:${state.length}");

    ProxyService.strategy.savePaymentType(
        amount: payment.amount,
        singlePaymentOnly: state.length == 1,
        paymentMethod: payment.method,
        transactionId: transactionId);
  }

  // Method to remove a payment method
  void removePaymentMethod(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }

  // Method to update payment methods
  void setPaymentMethods(List<Payment> methods) {
    state = methods;
  }
}

final paymentMethodsProvider =
    StateNotifierProvider<PaymentMethodsNotifier, List<Payment>>(
  (ref) => PaymentMethodsNotifier(), // No need to pass initial list here
);
final stringProvider = StateNotifierProvider<StringState, String>((ref) {
  return StringState(RequestStatus.pending);
});

final showProductsList = AutoDisposeStateProvider<bool>((ref) => true);
List<ProviderBase> allProviders = [
  unsavedProductProvider,
  customerSearchStringProvider,
  searchStringProvider,
  sellingModeProvider,
  matchedProductProvider,
  scanningModeProvider,
  receivingOrdersModeProvider,
  customersProvider,
  ordersStreamProvider,
  categoryStreamProvider,
  transactionsStreamProvider,
  unitsProvider,
  buttonIndexProvider,
  dateRangeProvider,
  transactionListProvider,
];
