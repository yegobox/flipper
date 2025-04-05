// ignore_for_file: unused_result

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'dart:async';

class CustomDropdownButton extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onChanged;
  final String label;
  final IconData? icon;

  const CustomDropdownButton({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.label,
    this.icon,
  }) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  final GlobalKey _dropdownKey = GlobalKey();

  void _showDropdown() {
    final RenderBox renderBox =
        _dropdownKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((String value) {
                return ListTile(
                  title: Text(value),
                  onTap: () {
                    widget.onChanged(value);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _dropdownKey,
      onTap: _showDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(widget.icon, size: 16, color: Colors.black54),
            if (widget.icon != null) const SizedBox(width: 4),
            Text(
              widget.selectedItem,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}

class SearchInputWithDropdown extends ConsumerStatefulWidget {
  const SearchInputWithDropdown({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchInputWithDropdown> createState() =>
      _SearchInputWithDropdownState();
}

class _SearchInputWithDropdownState
    extends ConsumerState<SearchInputWithDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _customerTypes = ['Walk-in', 'Take Away', 'Delivery'];
  final List<String> _saleTypes = ['Outgoing Sale', 'Incoming Return'];
  String _selectedCustomerType = 'Walk-in';
  String _selectedSaleType = 'Outgoing- Sale';
  List<Customer> _searchResults = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSearchBox();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeSearchBox() async {
    final transaction =
        ref.read(pendingTransactionStreamProvider(isExpense: false));

    if (transaction.value?.customerId != null) {
      final customer = await ProxyService.strategy.customers(
        id: transaction.value!.customerId,
        branchId: ProxyService.box.getBranchId()!,
      );
      if (customer.isNotEmpty) {
        _searchController.text = customer.first.custNm!;
      }
    } else {
      _searchController.clear();
    }
  }

  Future<void> _removeCustomer() async {
    final transaction = ref.read(pendingTransactionStreamProvider(
      isExpense: false,
    ));

    if (transaction.value?.id != null) {
      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );

      ref.refresh(pendingTransactionStreamProvider(
        isExpense: false,
      ));

      setState(() {
        _searchController.clear();
      });
    }
  }

  void _performSearch(String searchKey) {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Set a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (searchKey.isEmpty) {
        setState(() {
          _searchResults = [];
        });
        return;
      }

      try {
        final customers = await ProxyService.strategy.customers(
          key: searchKey,
          branchId: ProxyService.box.getBranchId()!,
        );

        setState(() {
          _searchResults = customers;
        });
      } catch (e) {
        talker.warning('Error searching customers: $e');
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  void _addCustomerToTransaction(
      Customer customer, ITransaction transaction) async {
    try {
      await ProxyService.strategy.assignCustomerToTransaction(
        customerId: customer.id,
        transactionId: transaction.id,
      );

      // Show success alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: Text('Customer ${customer.custNm} added to the sale!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Refresh the transaction
                ref.refresh(pendingTransactionStreamProvider(
                  isExpense: false,
                ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Clear search results
      setState(() {
        _searchResults = [];
        _searchController.clear();
      });
    } catch (e, s) {
      talker.warning('Error adding customer to transaction: $s');
      // show
      // Show error dialog
      showToast(context, '$e', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(pendingTransactionStreamProvider(
      isExpense: false,
    ));

    final attachedCustomerFuture = ref.watch(
      customerProvider((id: transaction.value?.customerId ?? '')),
    );

    return attachedCustomerFuture.when(
      data: (attachedCustomer) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: attachedCustomer != null,
                controller: _searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search Customer',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Customer Type Dropdown
                      CustomDropdownButton(
                        items: _customerTypes,
                        selectedItem: _selectedCustomerType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCustomerType = newValue;
                          });
                        },
                        label: 'Customer Type',
                        icon: Icons.person,
                      ),
                      const SizedBox(width: 8),
                      // Sale Type Dropdown
                      CustomDropdownButton(
                        items: _saleTypes,
                        selectedItem: _selectedSaleType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSaleType = newValue;
                            if (newValue == "Outgoing Sale") {
                              ProxyService.box.writeString(
                                  key: 'stockInOutType', value: "11");
                            } else if (newValue == "Incoming Return") {
                              /// TODO: The retrieved transaction should be marked as pending,
                              /// making it the new active transaction, while the
                              /// previously active one is parked. Then, after confirming the return,
                              /// Final Logic Summary
                              // ✅ Step 1: User enters receipt number.
                              // ✅ Step 2: Retrieve transaction & items.
                              // ✅ Step 3: Park the old transaction and activate the retrieved one (this make it to be current pending transaction).
                              // ✅ Step 4: User confirms return → Save the return. (The Actions button has become Confirm Return)
                              // ✅ Step 5: Restore the old pending transaction and update UI. we restore the old pending transaction.
                              /// Flow->
                              /// show the modal, for a user to give receipt number
                              /// query the transaction item, using this given receipt number
                              /// first retrieve this transaction using ProxyService.strategy.getTransaction(sarNo: 'given receiptnumber',branchId: ProxyService.box.getBranchId()!)
                              /// then
                              ///
                              /// retrieve the items using the above transaction using ProxyService.strategy.transactionItems(transactionId: retrievedTransactionId)
                              /// mark the item as not done with transaction
                              /// mark the current pending transaction as parked and save its id temporarily
                              /// then mark the transaction that has retrieved these item as pending (this make it the active one)
                              /// change action button from Pay-> confirm return
                              /// When we are deaking with return only 1 button show and it does not involves payment, it just complete transaction
                              ///
                              /// finally save a return.
                              ProxyService.box.writeString(
                                  key: 'stockInOutType', value: "03");
                            }
                          });
                        },
                        label: 'Sale Type',
                        icon: Icons.shopping_cart,
                      ),
                      attachedCustomer != null
                          ? IconButton(
                              icon: const Icon(
                                FluentIcons.person_delete_20_regular,
                                color: Colors.red,
                              ),
                              onPressed: _removeCustomer,
                            )
                          : IconButton(
                              onPressed: () {
                                locator<RouterService>()
                                    .navigateTo(CustomersRoute());
                              },
                              icon: const Icon(
                                FluentIcons.person_add_16_regular,
                                color: Colors.blue,
                              ),
                            ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16.0),
              if (_searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final customer = _searchResults[index];
                    return GestureDetector(
                      onTap: () => _addCustomerToTransaction(
                          customer, transaction.value!),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(customer.custNm ?? 'Unknown'),
                          subtitle: Text(customer.custTin ?? 'No TIN'),
                          trailing: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
