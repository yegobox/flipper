import 'dart:io';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/rraConstants.dart';
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart'
    show ChangeNotifierProvider, StateProvider;
import 'package:http/http.dart' as http;

final coreViewModelProvider = ChangeNotifierProvider((ref) => CoreViewModel());
final unsavedProductProvider =
    NotifierProvider<ProductNotifier, Product?>(ProductNotifier.new);

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
    try {
      final url =
          await ProxyService.box.getServerUrl() ?? "https://turbo.yegobox.com/";
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
    .family<List<Customer>, ({String? branchId, String? id})>((ref, params) {
  final (:branchId, :id) = params;
  return ProxyService.strategy
      .customersStream(branchId: branchId ?? "", id: id);
});

final customerProvider = FutureProvider.autoDispose
    .family<Customer?, ({String? id})>((ref, params) async {
  final (:id) = params;
  String? branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) return null;
  return (await ProxyService.getStrategy(Strategy.capella)
          .customers(id: id, branchId: branchId))
      .firstOrNull;
});

/// Provider specifically for fetching a single attached customer by ID.
/// Returns null when no valid customerId is provided, preventing unnecessary
/// queries that would return all customers for the branch.
final attachedCustomerProvider = FutureProvider.autoDispose
    .family<Customer?, String?>((ref, customerId) async {
  // Return null immediately if customerId is null or empty
  if (customerId == null || customerId.isEmpty) {
    return null;
  }

  String? branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) return null;
  return (await ProxyService.getStrategy(Strategy.capella)
          .customers(id: customerId, branchId: branchId))
      .firstOrNull;
});

class ProductNotifier extends Notifier<Product?> {
  @override
  Product? build() => null;

  void emitProduct({required Product value}) {
    state = value;
  }
}

final customerSearchStringProvider =
    NotifierProvider<CustomerSearchStringNotifier, String>(
        CustomerSearchStringNotifier.new);

class CustomerSearchStringNotifier extends Notifier<String> {
  @override
  String build() => "";

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
    NotifierProvider<SellingModeNotifier, SellingMode>(SellingModeNotifier.new);

class SellingModeNotifier extends Notifier<SellingMode> {
  @override
  SellingMode build() => SellingMode.forSelling;

  SellingMode setSellingMode(SellingMode mode) {
    state = mode;
    return state;
  }
}

final initialStockProvider =
    StreamProvider.autoDispose.family<double, String>((ref, branchId) {
  return ProxyService.strategy.totalSales(branchId: branchId);
});

final paginatedVariantsProvider = NotifierProvider.family<
    PaginatedVariantsNotifier,
    AsyncValue<List<Variant>>,
    String>(PaginatedVariantsNotifier.new);

class PaginatedVariantsNotifier extends Notifier<AsyncValue<List<Variant>>> {
  final String productId;
  PaginatedVariantsNotifier(this.productId);
  int _page = 1;
  static const int _pageSize = 4;
  bool _hasMore = true;
  List<Variant> _allVariants = [];

  @override
  AsyncValue<List<Variant>> build() {
    futureLoad(productId);
    return const AsyncValue.loading();
  }

  Future<void> futureLoad(String productId) async {
    await loadMore();
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;

    if (state.value == null) {
      // ensure we show loading if not already (though build returned loading)
      state = const AsyncValue.loading();
    }

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
        // Should we set data if it was loading?
        if (state.isLoading) {
          state = const AsyncValue.data([]);
        }
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
    final paged = await ProxyService.strategy.variants(
        branchId: branchId,
        productId: productId,
        taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D']);
    return List<Variant>.from(paged.variants);
  }
}

final matchedProductProvider = Provider.autoDispose<Product?>((ref) {
  final productsState =
      ref.watch(productsProvider(ProxyService.box.getBranchId() ?? ""));
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

class ScanningModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggleScanningMode() {
    state = !state;
  }
}
// end scanning

// ordering
final receivingOrdersModeProvider =
    NotifierProvider<ReceiveOrderModeNotifier, bool>(
        ReceiveOrderModeNotifier.new);

class ReceiveOrderModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggleReceiveOrder() {
    state = !state;
  }
}
// end ordering

final customersProvider =
    NotifierProvider<CustomersNotifier, AsyncValue<List<Customer>>>(
        CustomersNotifier.new);

class CustomersNotifier extends Notifier<AsyncValue<List<Customer>>> {
  @override
  AsyncValue<List<Customer>> build() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      return const AsyncValue.data([]);
    }
    return ref.watch(customersStreamProvider((branchId: branchId, id: null)));
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
  final paged = await ProxyService.strategy.variants(
      taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D'],
      productId: productId,
      branchId: ProxyService.box.getBranchId()!);
  final data = List<Variant>.from(paged.variants);
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
    NotifierProvider<ButtonIndexNotifier, int>(ButtonIndexNotifier.new);

class ButtonIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final currentTransactionsByIdStream =
    StreamProvider.autoDispose.family<List<ITransaction>, String>((ref, id) {
  // Retrieve the transaction status from the provider container, if needed

  // Use ProxyService to get the  of transactions
  final transactionsStream = ProxyService.strategy.transactionsStream(
      id: id,
      filterType: FilterType.TRANSACTION,
      forceRealData: true,
      skipOriginalTransactionCheck: true,
      removeAdjustmentTransactions: true);

  // Return the stream
  return transactionsStream;
});

final transactionTotalPaidProvider = FutureProvider.autoDispose
    .family<double, String>((ref, transactionId) async {
  if (transactionId.isEmpty) return 0.0;
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return 0.0;

  try {
    final totalPaid = await ProxyService.getStrategy(Strategy.capella)
        .getTotalPaidForTransaction(
      transactionId: transactionId,
      branchId: branchId,
    );
    return totalPaid ?? 0.0;
  } catch (e) {
    talker.error('Error getting total paid for transaction: $e');
    return 0.0;
  }
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
  String branchId = ProxyService.box.getBranchId() ?? "";
  return ProxyService.strategy.transactionsStream(
      branchId: branchId,
      skipOriginalTransactionCheck: true,
      removeAdjustmentTransactions: true,
      forceRealData: true);
});

final universalProductsNames =
    FutureProvider.autoDispose<AsyncValue<List<UnversalProduct>>>((ref) async {
  try {
    // final branchId = ProxyService.box.getBranchId()!;

    // Check if units are already present in the database
    final existingUnits =
        await ProxyService.strategy.universalProductNames(branchId: "1");

    return AsyncData(existingUnits);
  } catch (error) {
    // Return AsyncError with error and stack trace
    return AsyncError(error, StackTrace.current);
  }
});

final skuProvider =
    StreamProvider.autoDispose.family<SKU?, String>((ref, branchId) {
  return ProxyService.strategy
      .sku(branchId: branchId, businessId: ProxyService.box.getBusinessId()!);
});

final keypadProvider =
    NotifierProvider<KeypadNotifier, String>(KeypadNotifier.new);

class KeypadNotifier extends Notifier<String> {
  @override
  String build() => "0.00";

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
    NotifierProvider<LoadingNotifier, LoadingState>(LoadingNotifier.new);

// Create a notifier to handle loading state changes
class LoadingNotifier extends Notifier<LoadingState> {
  @override
  LoadingState build() => const LoadingState();

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

    // Trigger search to force UI update
    ref.read(searchStringProvider.notifier).emitString(value: "search");
    ref.read(searchStringProvider.notifier).emitString(value: "");

    // Note: We don't call refresh() here because variants are already added
    // directly in the onCompleteCallback via addVariants() method.
    // Calling refresh() here would cause duplicates.

    // Reload products
    ref.read(productsProvider(branchId).notifier).loadProducts(
          searchString: productName,
          scanMode: scanMode,
        );
  }
}

final reportsProvider =
    StreamProvider.autoDispose.family<List<Report>, String>((ref, branchId) {
  return ProxyService.strategy.reports(branchId: branchId).map((reports) {
    talker.warning(reports);
    return reports;
  });
});
// TODO: hardcoding 2000 items is not ideal, I need to find permanent solution.
final rowsPerPageProvider = StateProvider<int>((ref) => 20);

final toggleBooleanValueProvider =
    NotifierProvider<PluReportToggleNotifier, bool>(
        PluReportToggleNotifier.new);

class PluReportToggleNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggleReport() {
    state = !state;
  }
}

final isProcessingProvider =
    NotifierProvider<IsProcessingNotifier, bool>(IsProcessingNotifier.new);

class IsProcessingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

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
  try {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return [];

    final userAccess = await ProxyService.ditto.getUserAccess(userId);
    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      return businessesJson
          .map((json) => Business.fromMap(Map<String, dynamic>.from(json)))
          .toList();
    }
    return [];
  } catch (e, stack) {
    // Log the error to our error service
    if (ProxyService.box.getUserLoggingEnabled() ?? false) {
      final logService = LogService();
      await logService.logException(
        e,
        stackTrace: stack,
        type: 'business_fetch',
        tags: {
          'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
          'method': 'businessesProvider',
        },
      );
    }

    // Re-throw the exception so the UI can handle it appropriately
    rethrow;
  }
});

// Define a provider for the selected branch
final selectedBranchProvider =
    StateProvider.autoDispose<Branch?>((ref) => null);
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

final businessSelectionProvider =
    NotifierProvider<BusinessSelectionNotifier, BusinessSelectionState>(
        BusinessSelectionNotifier.new);

class BusinessSelectionNotifier extends Notifier<BusinessSelectionState> {
  @override
  BusinessSelectionState build() => BusinessSelectionState(isLoading: false);

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setSelectedBusiness(Business business) {
    state = state.copyWith(selectedBusiness: business);
  }
}

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

final branchSelectionProvider =
    NotifierProvider<BranchSelectionNotifier, BranchSelectionState>(
        BranchSelectionNotifier.new);

class BranchSelectionNotifier extends Notifier<BranchSelectionState> {
  @override
  BranchSelectionState build() => BranchSelectionState(isLoading: false);

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setSelectedBranch(Branch branch) {
    state = state.copyWith(selectedBranch: branch);
  }
}

final variantsProvider = FutureProvider.autoDispose
    .family<List<Variant>, ({String branchId})>((ref, params) async {
  final (:branchId) = params;
  final paged = await ProxyService.strategy.variants(
      branchId: branchId,
      taxTyCds: ProxyService.box.vatEnabled() ? ['A', 'B', 'C'] : ['D']);
  return List<Variant>.from(paged.variants);
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
    TextEditingController? controller,
  })  : controller = controller ??
            TextEditingController(text: amount.toStringAsFixed(2)),
        id = id ?? UniqueKey().toString();

  void dispose() {
    controller.dispose();
  }
}

final paymentMethodsProvider =
    NotifierProvider<PaymentMethodsNotifier, List<Payment>>(
        PaymentMethodsNotifier.new);

class PaymentMethodsNotifier extends Notifier<List<Payment>> {
  final List<Payment>? initialPayments;
  PaymentMethodsNotifier([this.initialPayments]);

  @override
  List<Payment> build() {
    ref.onDispose(() {
      for (var payment in state) {
        payment.dispose();
      }
    });
    return initialPayments ?? [Payment(amount: 0.0, method: 'CASH')];
  }

  void _safeDispose(Payment payment) {
    final controller = payment.controller;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });
  }

  // Method to add a payment method
  void addPaymentMethod(Payment method) {
    try {
      final existingIndex = state.indexWhere(
          (existingMethod) => existingMethod.method == method.method);
      if (existingIndex != -1) {
        final oldPayment = state[existingIndex];
        // Only dispose if we are NOT reusing the same controller
        if (oldPayment.controller != method.controller) {
          _safeDispose(oldPayment);
        }
        final updatedList = List<Payment>.from(state);
        updatedList[existingIndex] = method;
        state = updatedList;
      } else {
        state = [...state, method];
      }
    } catch (e) {
      talker.error('Error adding payment method: $e');
    }
  }

  void updatePaymentMethod(int index, Payment payment,
      {String? transactionId}) {
    if (index >= 0 && index < state.length) {
      final oldPayment = state[index];
      // Only dispose if we are NOT reusing the same controller
      if (oldPayment.controller != payment.controller) {
        _safeDispose(oldPayment);
      }
    }
    final updatedList = List<Payment>.from(state);
    updatedList[index] = payment;
    state = updatedList;

    talker.warning("Payment Lenght:${state.length}");
  }

  void removePaymentMethod(int index) {
    if (index >= 0 && index < state.length) {
      _safeDispose(state[index]);
    }
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
  }

  void setPaymentMethods(List<Payment> methods) {
    // Collect controllers that are being kept
    final newControllers = methods.map((p) => p.controller).toSet();

    // Dispose only those that are NOT in the new list
    for (final oldPayment in state) {
      if (!newControllers.contains(oldPayment.controller)) {
        _safeDispose(oldPayment);
      }
    }
    state = methods;
  }
}

class StringState extends Notifier<String?> {
  StringState(this.initialValue);
  final String? initialValue;

  @override
  String? build() => initialValue;

  void updateString(String newString) {
    state = newString;
  }
}

final stringProvider = NotifierProvider<StringState, String?>(() {
  return StringState(null);
});

final orderStatusProvider =
    StateProvider<OrderStatus>((ref) => OrderStatus.pending);
final requestStatusProvider =
    StateProvider<String>((ref) => RequestStatus.pending);

final showProductsList = StateProvider.autoDispose<bool>((ref) => true);

// Stock stream provider for live stock updates
final stockByVariantProvider =
    StreamProvider.autoDispose.family<Stock?, String>((ref, stockId) {
  if (stockId.isEmpty) {
    return Stream.value(null);
  }

  try {
    return ProxyService.getStrategy(Strategy.capella)
        .watchStockByVariantId(stockId: stockId);
  } catch (e) {
    print('Error setting up stock stream from strategy: $e');
    return Stream.value(null);
  }
});

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
