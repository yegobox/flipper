// ignore_for_file: unused_result

import 'package:flipper_dashboard/custom_widgets.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'add_customer.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

class Customers extends StatefulHookConsumerWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  CustomersState createState() => CustomersState();
}

class CustomersState extends ConsumerState<Customers> {
  final TextEditingController _searchController = TextEditingController();
  final _routerService = locator<RouterService>();

  // --- Paging State ---
  final ScrollController _scrollController = ScrollController();
  List<Customer> displayedCustomers = [];
  bool isLoadingMore = false;
  bool hasMore = true;
  int pageSize = 30;
  String lastSearch = '';
  int currentPage = 0;

  bool _hasLoadedInitialCustomers = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // If scrolled near the bottom, try to load more
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMore) {
      _loadMoreCustomers();
    }
  }

  void _onSearchChanged(String value) {
    lastSearch = value;
    currentPage = 0;
    hasMore = true;
    displayedCustomers.clear();
    _hasLoadedInitialCustomers = false; // Reset flag so paging can re-init
    _loadInitialCustomers();
  }

  Future<void> _loadInitialCustomers() async {
    final customers = ref.read(customersProvider.notifier).filterCustomers(
          ref.read(customersProvider).asData?.value ?? [],
          lastSearch,
        );
    setState(() {
      displayedCustomers = customers.take(pageSize).toList();
      hasMore = customers.length > pageSize;
      currentPage = 1;
    });
  }

  Future<void> _loadMoreCustomers() async {
    if (isLoadingMore || !hasMore) return;
    setState(() {
      isLoadingMore = true;
    });
    await Future.delayed(Duration(milliseconds: 300)); // Simulate loading
    final customers = ref.read(customersProvider.notifier).filterCustomers(
          ref.read(customersProvider).asData?.value ?? [],
          lastSearch,
        );
    final nextPage =
        customers.skip(currentPage * pageSize).take(pageSize).toList();
    setState(() {
      displayedCustomers.addAll(nextPage);
      isLoadingMore = false;
      hasMore = customers.length > displayedCustomers.length;
      currentPage += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(customerSearchStringProvider);
    final customersRef = ref.watch(customersProvider);
    final transaction =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    // Listen for provider data becoming available and trigger initial load only once
    ref.listen<AsyncValue<List<Customer>>>(customersProvider, (previous, next) {
      if (next is AsyncData<List<Customer>> && !_hasLoadedInitialCustomers) {
        _hasLoadedInitialCustomers = true;
        _loadInitialCustomers();
      }
    });

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Add Customer',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                // ref.refresh(customersProvider);
                ///TODO: this is supposed to make SearchCustomer refresh but for somereason it is not,debug this further
                ref.refresh(pendingTransactionStreamProvider(isExpense: false));
                _routerService.pop();
              },
            ),
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildCustomerList(model, transaction.value!),
              ),
              _buildAddButton(context, model, customersRef, searchKeyword,
                  transaction.value!.id),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
        child: FocusScope(
          child: Focus(
            onFocusChange: (hasFocus) => setState(() {}),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  color: FocusScope.of(context).hasFocus
                      ? Colors.blue
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search for a customer',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Icon(Icons.search, color: Colors.blue, size: 26),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.redAccent, size: 22),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged("");
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                ),
                onChanged: (value) {
                  _onSearchChanged(value);
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerList(CoreViewModel model, ITransaction transaction) {
    if (displayedCustomers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text('No customers found',
                style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Quick add: open add customer modal with search text
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AddCustomer(
                        transactionId: ref
                            .watch(pendingTransactionStreamProvider(
                                isExpense: false))
                            .value!
                            .id,
                        searchedKey: _searchController.text,
                      ),
                    );
                  },
                );
              },
              child: Text('Add "${_searchController.text}" as new customer'),
            )
          ],
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedCustomers.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayedCustomers.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final customer = displayedCustomers[index];
        return _buildCustomerCard(customer, model, transaction);
      },
    );
  }

  Widget _buildCustomerCard(
      Customer customer, CoreViewModel model, ITransaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        key: Key('customer-${customer.id}'),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                await model.deleteCustomer(
                    customer.id, (message) => toast(message));
                ref
                    .refresh(customersProvider.notifier)
                    .loadCustomers(searchString: '');
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                model.assignToSale(
                    customerId: customer.id, transactionId: transaction.id);
                model.getTransactionById();
                toast("Customer added to sale");
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add,
              label: 'Add',
            ),
            SlidableAction(
              onPressed: (_) async {
                await model.removeFromSale(transaction: transaction);
                model.getTransactionById();
                toast("Customer removed from sale");
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.remove,
              label: 'Remove',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                customer.custNm!.substring(0, 1),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              '${customer.custNm!}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(customer.telNo ?? '',
                    style: TextStyle(color: Colors.grey[600])),
                Text(customer.custTin ?? '',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            onTap: () {
              model.assignToSale(
                  customerId: customer.id, transactionId: transaction.id);
              model.getTransactionById();
              showAlert(context,
                  onPressedOk: () {}, title: "Customer added to sale!");
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context,
      CoreViewModel model,
      AsyncValue<List<Customer>> customersRef,
      String searchKeyword,
      String id) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FlipperButton(
        color: Colors.blue,
        textColor: Colors.white,
        text: _getButtonText(customersRef, searchKeyword),
        onPressed: () =>
            _handleButtonPress(context, model, customersRef, searchKeyword, id),
      ),
    );
  }

  String _getButtonText(
      AsyncValue<List<Customer>> customersRef, String searchKeyword) {
    final customers = customersRef.asData?.value ?? [];
    final isCustomerListEmpty = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword)
        .isEmpty;
    return isCustomerListEmpty
        ? 'Add Customer $searchKeyword'
        : 'Add $searchKeyword to Sale';
  }

  Future<void> _handleButtonPress(
      BuildContext context,
      CoreViewModel model,
      AsyncValue<List<Customer>> customersRef,
      String searchKeyword,
      String id) async {
    final customers = customersRef.asData?.value ?? [];
    final filteredCustomers = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword);

    if (filteredCustomers.isEmpty) {
      showModalBottomSheet(
        showDragHandle: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AddCustomer(
              transactionId: id,
              searchedKey: searchKeyword,
            ),
          );
        },
      );
    } else {
      final customer = filteredCustomers.first;
      model.assignToSale(customerId: customer.id, transactionId: id);
      showAlert(context, onPressedOk: () {}, title: "Customer added to sale!");
    }
  }
}
