import 'dart:io';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final coreViewModelProvider = ChangeNotifierProvider((ref) => CoreViewModel());
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

final customersStreamProvider = StreamProvider.autoDispose
    .family<List<Customer>, ({int? branchId, String? id})>((ref, params) {
  final (:branchId, :id) = params;
  return ProxyService.strategy.customersStream(branchId: branchId ?? 0, id: id);
});

final customerProvider = FutureProvider.autoDispose
    .family<Customer?, ({String? id})>((ref, params) async {
  final (:id) = params;
  return (await ProxyService.strategy
          .customers(id: id, branchId: ProxyService.box.getBranchId()!))
      .firstOrNull;
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

final initialStockProvider =
    StreamProvider.autoDispose.family<double, int>((ref, branchId) {
  return ProxyService.strategy.totalSales(branchId: branchId);
});

final paginatedVariantsProvider = StateNotifierProvider.family<
    PaginatedVariantsNotifier,
    AsyncValue<List<Variant>>,
    String>((ref, productId) {
  return PaginatedVariantsNotifier(productId);
});

class PaginatedVariantsNotifier
    extends StateNotifier<AsyncValue<List<Variant>>> {
  final String productId;
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

  Future<List<Variant>> fetchVariants(String productId) async {
    final branchId = ProxyService.box.getBranchId()!;
    return await ProxyService.strategy
        .variants(branchId: branchId, productId: productId);
  }
}

final matchedProductProvider = Provider.autoDispose<Product?>((ref) {
  final productsState =
      ref.watch(productsProvider(ProxyService.box.getBranchId() ?? 0));
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
  int branchId = ProxyService.box.getBranchId() ?? 0;
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
          await ProxyService.strategy.customers(branchId: branchId);

      if (searchString.isNotEmpty) {
        customers = customers
            .where((customer) => customer.custNm!
                .toLowerCase()
                .contains(searchString.toLowerCase()))
            .toList();
      }

      state = AsyncData(customers);
    } catch (error) {
      //state = AsyncError(error, StackTrace.current);
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
    .family<AsyncValue<List<Variant>>, String>((ref, productId) async {
  final data = await ProxyService.strategy.variants(
      productId: productId, branchId: ProxyService.box.getBranchId()!);
  return AsyncData(data);
});

final unitsProvider =
    FutureProvider.autoDispose<AsyncValue<List<IUnit>>>((ref) async {
  try {
    // Use the unityOfQuantity constants from RRADEFAULTS
    final units = RRADEFAULTS.unityOfQuantity.map((unitStr) {
      final parts = unitStr.split(':');
      return IUnit(
        id: parts[1], // Use the number part as ID
        name: parts[3], // Use the long description as name
        code: parts[0], // Use the code
        description: parts[3], // Use the long description
      );
    }).toList();

    return AsyncData(units);
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

// final transactionListProvider =
//     StreamProvider.autoDispose.family<List<ITransaction>, bool>((ref, forceRealData) {
//   final dateRange = ref.watch(dateRangeProvider);
//   final startDate = dateRange.startDate;
//   final endDate = dateRange.endDate;

//   // Check if startDate or endDate is null, and return an empty list stream if either is null
//   if (startDate == null || endDate == null) {
//     return Stream.value([]);
//   }

//   try {
//     final stream = ProxyService.strategy.transactionsStream(
//       startDate: startDate,
//       endDate: endDate,
//       removeAdjustmentTransactions: true,
//       branchId: ProxyService.box.getBranchId(),
//       isCashOut: false,
//       status: COMPLETE,
//       forceRealData: forceRealData,
//     );

//     // Use `switchMap` to handle potential changes in dateRangeProvider
//     return stream.switchMap((transactions) {
//       // Log the received data to the console
//       // talker.info("Transaction Data: $transactions");

//       // Handle null or empty transactions if needed
//       return Stream.value(transactions);
//     });
//   } catch (e, stackTrace) {
//     // Return an error stream if something goes wrong
//     talker.info("Error loading transactions: $e");
//     return Stream.error(e, stackTrace);
//   }
// });

final currentTransactionsByIdStream =
    StreamProvider.autoDispose.family<List<ITransaction>, String>((ref, id) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the IsarStream of transactions
  final transactionsStream = ProxyService.strategy.transactionsStream(
      id: id,
      filterType: FilterType.TRANSACTION,
      forceRealData: true,
      removeAdjustmentTransactions: true);

  // Return the stream
  return transactionsStream;
});

final selectImportItemsProvider = FutureProvider.autoDispose
    .family<List<Variant>, int?>((ref, productId) async {
  // Fetch the list of variants from a remote service.
  final response = await ProxyService.strategy.selectImportItems(
      tin: 999909695, bhfId: (await ProxyService.box.bhfId()) ?? "00");

  return response;
});

final ordersStreamProvider =
    StreamProvider.autoDispose<List<ITransaction>>((ref) {
  int branchId = ProxyService.box.getBranchId() ?? 0;
  return ProxyService.strategy.transactionsStream(
      branchId: branchId,
      removeAdjustmentTransactions: true,
      forceRealData: true);
});

final universalProductsNames =
    FutureProvider.autoDispose<AsyncValue<List<UnversalProduct>>>((ref) async {
  try {
    // final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits =
        await ProxyService.strategy.universalProductNames(branchId: 1);

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

// final isLoadingProvider = StateProvider<bool>((ref) => false);
// Define the provider
final loadingProvider =
    StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

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
final rowsPerPageProvider = StateProvider<int>((ref) => 20);

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

const String NO_SELECTION = "-1";

final selectedItemIdProvider = StateProvider<String?>((ref) => NO_SELECTION);

final tenantProvider = FutureProvider<Tenant?>((ref) async {
  final userId = ProxyService.box.getUserId();
  return await ProxyService.strategy
      .tenant(userId: userId, fetchRemote: !Platform.isWindows);
});

/// check if a user has either, admin,read,write on a given feature
// StateNotifierProvider
// Provider to get the list of user accesses

final businessesProvider = FutureProvider<List<Business>>((ref) async {
  return await ProxyService.strategy
      .businesses(userId: ProxyService.box.getUserId()!);
});

// Define a provider for the selected branch
final selectedBranchProvider = AutoDisposeStateProvider<Branch?>((ref) => null);
// Provider to check if a user has access to a specific feature
/// A provider that determines if a user has access to a specific feature based on their permissions.
/// This provider implements a hierarchical access control system where certain elevated permissions
/// (like ticket access) can restrict access to other features.

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

final variantsProvider = FutureProvider.autoDispose
    .family<List<Variant>, ({int branchId})>((ref, params) async {
  final (:branchId) = params;

  return await ProxyService.strategy.variants(branchId: branchId);
});


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
          Payment(amount: 0.0, method: 'CASH'),
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
      {required String transactionId}) {
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

class StringState extends StateNotifier<String?> {
  StringState(String? initialValue) : super(initialValue);

  void updateString(String newString) {
    state = newString;
  }
}

final stringProvider = StateNotifierProvider<StringState, String?>((ref) {
  return StringState(null);
});

final showProductsList = AutoDisposeStateProvider<bool>((ref) => true);
List<ProviderBase> allProviders = [
  unsavedProductProvider,
  sellingModeProvider,
  matchedProductProvider,
  scanningModeProvider,
  receivingOrdersModeProvider,
  customersProvider,
  ordersStreamProvider,
  unitsProvider,
  buttonIndexProvider,
  dateRangeProvider,
];
