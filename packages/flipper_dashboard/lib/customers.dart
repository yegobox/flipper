// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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

  // Color scheme constants - Microsoft Fluent inspired
  final Color primaryColor = const Color(0xFF0078D4); // Microsoft blue
  final Color secondaryColor = const Color(0xFF106EBE);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF323130);
  final Color textSecondaryColor = const Color(0xFF605E5C);
  final Color accentColor = const Color(0xFF0078D4);
  final Color deleteColor = const Color(0xFFD83B01); // Microsoft red
  final Color successColor = const Color(0xFF107C10);
  final double maxHeight = 680;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: cardColor,
            title: Text(
              'Add Customer',
              style: TextStyle(
                color: textPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 22),
              onPressed: () {
                // ref.refresh(customersProvider);
                ///TODO: this is supposed to make SearchCustomer refresh but for somereason it is not,debug this further
                ref.refresh(pendingTransactionStreamProvider(isExpense: false));
                _routerService.pop();
              },
            ),
            actions: [
              // Help button
              IconButton(
                icon: Icon(Icons.help_outline, color: primaryColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Customer Management Help'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHelpItem(Icons.search,
                                'Search for customers by name or phone number'),
                            _buildHelpItem(
                                Icons.swipe, 'Swipe left to delete a customer'),
                            _buildHelpItem(Icons.swipe_right,
                                'Swipe right to add/remove from sale'),
                            _buildHelpItem(Icons.add_circle_outline,
                                'Add a new customer using the button below'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close',
                              style: TextStyle(color: primaryColor)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              _buildResultStats(), // New: shows number of results
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

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14, color: textSecondaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStats() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: displayedCustomers.isEmpty
            ? Text(
                'No customers found',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
              )
            : Text(
                '${displayedCustomers.length} ${displayedCustomers.length == 1 ? 'customer' : 'customers'} found',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondaryColor,
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: FocusScope(
          child: Focus(
            onFocusChange: (hasFocus) => setState(() {}),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: FocusScope.of(context).hasFocus
                      ? primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 16, color: textPrimaryColor),
                decoration: InputDecoration(
                  hintText: 'Search customers by name or phone number',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Icon(Icons.search, color: primaryColor, size: 24),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: deleteColor, size: 22),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged("");
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 16),
      physics: AlwaysScrollableScrollPhysics(), // Makes empty lists scrollable
      itemCount: displayedCustomers.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayedCustomers.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                strokeWidth: 3,
              ),
            ),
          );
        }
        final customer = displayedCustomers[index];
        return _buildCustomerCard(customer, model, transaction);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No customers found',
              style: TextStyle(
                color: textPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try different search terms or add a new customer'
                  : 'Add a customer to get started',
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondaryColor),
            ),
            SizedBox(height: 24),
            _searchController.text.isNotEmpty
                ? ElevatedButton.icon(
                    onPressed: () {
                      // Quick add: open add customer modal with search text
                      showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        showDragHandle: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.0)),
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
                    icon: Icon(Icons.add_circle_outline),
                    label:
                        Text('Add "${_searchController.text}" as new customer'),
                    style: ElevatedButton.styleFrom(
                      // primary: primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      // Open add customer modal
                      showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        showDragHandle: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.0)),
                        ),
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AddCustomer(
                                  transactionId: ref
                                      .watch(pendingTransactionStreamProvider(
                                          isExpense: false))
                                      .value!
                                      .id,
                                  searchedKey: '',
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Add New Customer'),
                    style: ElevatedButton.styleFrom(
                      // primary: primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(
      Customer customer, CoreViewModel model, ITransaction transaction) {
    // Get first letter of customer name safely
    String nameInitial =
        (customer.custNm != null && customer.custNm!.isNotEmpty)
            ? customer.custNm![0].toUpperCase()
            : '?';

    // Generate a consistent color based on the customer name
    Color avatarColor = _getAvatarColor(customer.custNm ?? '');

    // Check if this customer is selected in the current transaction
    bool isSelected = transaction.customerId == customer.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        key: Key('customer-${customer.id}'),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Customer'),
                    content: Text(
                        'Are you sure you want to delete ${customer.custNm}?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Delete',
                            style: TextStyle(color: deleteColor)),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await model.deleteCustomer(
                              customer.id, (message) => toast(message));
                          ref
                              .refresh(customersProvider.notifier)
                              .loadCustomers(searchString: '');
                        },
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: deleteColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              // borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (_) {
                // Show edit customer form
                showModalBottomSheet(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  showDragHandle: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: AddCustomer(
                        transactionId: transaction.id,
                        searchedKey: customer.custNm ?? '',
                        // isEdit: true,
                        // customer: customer,
                      ),
                    );
                  },
                );
              },
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
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

                // Show elegant toast instead of alert
                showSimpleNotification(
                  Text(
                    "Customer added to sale",
                    style: TextStyle(color: Colors.white),
                  ),
                  background: successColor,
                  duration: Duration(seconds: 2),
                  slideDismissDirection: DismissDirection.up,
                );
              },
              backgroundColor: successColor,
              foregroundColor: Colors.white,
              icon: Icons.add,
              label: 'Add',
            ),
            SlidableAction(
              onPressed: (_) async {
                await model.removeFromSale(transaction: transaction);
                model.getTransactionById();

                // Show elegant toast instead of alert
                showSimpleNotification(
                  Text(
                    "Customer removed from sale",
                    style: TextStyle(color: Colors.white),
                  ),
                  background: Colors.orange,
                  duration: Duration(seconds: 2),
                  slideDismissDirection: DismissDirection.up,
                );
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.remove,
              label: 'Remove',
              // borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: Card(
          elevation: 1,
          color: isSelected ? Color(0xFFEDF6FB) : cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.transparent,
              width: isSelected ? 1.5 : 0,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              model.assignToSale(
                  customerId: customer.id, transactionId: transaction.id);
              model.getTransactionById();

              // Show elegant toast instead of alert dialog
              showSimpleNotification(
                Text(
                  "Customer added to sale",
                  style: TextStyle(color: Colors.white),
                ),
                background: successColor,
                duration: Duration(seconds: 2),
                slideDismissDirection: DismissDirection.up,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: avatarColor,
                    child: Text(
                      nameInitial,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.custNm ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (customer.telNo != null &&
                            customer.telNo!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.phone,
                                    size: 14, color: textSecondaryColor),
                                SizedBox(width: 4),
                                Text(
                                  customer.telNo!,
                                  style: TextStyle(color: textSecondaryColor),
                                ),
                              ],
                            ),
                          ),
                        if (customer.custTin != null &&
                            customer.custTin!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.receipt,
                                    size: 14, color: textSecondaryColor),
                                SizedBox(width: 4),
                                Text(
                                  "TIN: ${customer.custTin!}",
                                  style: TextStyle(color: textSecondaryColor),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: successColor,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    // Generate consistent colors based on name
    final List<Color> colors = [
      Color(0xFF0078D4), // Blue
      Color(0xFF107C10), // Green
      Color(0xFFD83B01), // Red
      Color(0xFF5C2D91), // Purple
      Color(0xFF008575), // Teal
      Color(0xFFE3008C), // Magenta
      Color(0xFF00B7C3), // Cyan
      Color(0xFFFFB900), // Yellow
    ];

    if (name.isEmpty) return colors[0];

    // Simple hash function
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }

    return colors[hash.abs() % colors.length];
  }

  Widget _buildAddButton(
      BuildContext context,
      CoreViewModel model,
      AsyncValue<List<Customer>> customersRef,
      String searchKeyword,
      String id) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add_circle_outline),
        label: Text(_getButtonText(customersRef, searchKeyword)),
        style: ElevatedButton.styleFrom(
          // primary: primaryColor,
          // onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
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

    // If search is empty, just say "Add New Customer"
    if (searchKeyword.isEmpty) {
      return 'Add New Customer';
    }

    return isCustomerListEmpty
        ? 'Add Customer "$searchKeyword"'
        : 'Add "$searchKeyword" to Sale';
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

    if (filteredCustomers.isEmpty || searchKeyword.isEmpty) {
      showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: maxHeight),
        showDragHandle: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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

      // Show elegant toast instead of alert dialog
      showSimpleNotification(
        Text(
          "Customer added to sale",
          style: TextStyle(color: Colors.white),
        ),
        background: successColor,
        duration: Duration(seconds: 2),
        slideDismissDirection: DismissDirection.up,
      );
    }
  }
}
