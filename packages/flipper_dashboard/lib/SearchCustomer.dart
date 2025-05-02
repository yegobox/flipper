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
  final bool compact;

  const CustomDropdownButton({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.label,
    this.icon,
    this.compact = false,
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
        padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 8 : 12,
            vertical: widget.compact ? 6 : 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(widget.icon,
                  size: widget.compact ? 14 : 16, color: Colors.black54),
            if (widget.icon != null) SizedBox(width: widget.compact ? 2 : 4),
            Flexible(
              child: Text(
                widget.selectedItem,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: widget.compact ? 12 : 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: widget.compact ? 2 : 4),
            Icon(Icons.arrow_drop_down, size: widget.compact ? 16 : 20),
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
  final List<String> _customerTypes = [
    'Shop',
    'Walk-in',
    'Take Away',
    'Delivery'
  ];
  final List<String> _saleTypes = [
    'Agent Sale',
    'Outgoing Sale',
    'Incoming Return'
  ];
  String _selectedCustomerType = 'Walk-in';
  String _selectedSaleType = 'Outgoing- Sale';
  List<Customer> _searchResults = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeSearchBox();
    // Initialize with default values
    _selectedCustomerType = 'Walk-in';
    _selectedSaleType = 'Outgoing- Sale';
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
        ProxyService.box.writeString(
            key: 'currentSaleCustomerPhoneNumber',
            value: customer.first.telNo!);
        ProxyService.box
            .writeString(key: 'customerName', value: customer.first.custNm!);
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

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileWidth = screenWidth < 600;

    // Set mobile-specific defaults if on mobile
    if (isMobileWidth) {
      if (_selectedCustomerType == 'Walk-in') {
        _selectedCustomerType = 'Shop';
      }
      if (_selectedSaleType == 'Outgoing- Sale') {
        _selectedSaleType = 'Agent Sale';
        // Update the stockInOutType value for Agent Sale
        ProxyService.box.writeString(key: 'stockInOutType', value: "11");
      }
    } else {
      // Ensure desktop defaults are maintained
      if (_selectedCustomerType == 'Shop' &&
          !_customerTypes.contains('Walk-in')) {
        _selectedCustomerType = 'Walk-in';
      }
      if (_selectedSaleType == 'Agent Sale' &&
          !_saleTypes.contains('Outgoing- Sale')) {
        _selectedSaleType = 'Outgoing- Sale';
        // Update the stockInOutType value for Outgoing Sale
        ProxyService.box.writeString(key: 'stockInOutType', value: "11");
      }
    }

    return attachedCustomerFuture.when(
      data: (attachedCustomer) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobileWidth
                  ? _buildMobileLayout(attachedCustomer)
                  : _buildDesktopLayout(attachedCustomer),
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

  Widget _buildMobileLayout(Customer? attachedCustomer) {
    return Column(
      children: [
        TextFormField(
          readOnly: attachedCustomer != null,
          controller: _searchController,
          onChanged: _performSearch,
          decoration: InputDecoration(
            hintText: 'Search Customer',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: attachedCustomer != null
                ? IconButton(
                    icon: const Icon(
                      FluentIcons.person_delete_20_regular,
                      color: Colors.red,
                    ),
                    onPressed: _removeCustomer,
                  )
                : IconButton(
                    onPressed: () {
                      locator<RouterService>().navigateTo(CustomersRoute());
                    },
                    icon: const Icon(
                      FluentIcons.person_add_16_regular,
                      color: Colors.blue,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: CustomDropdownButton(
                items: _customerTypes,
                selectedItem: _selectedCustomerType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCustomerType = newValue;
                  });
                },
                label: 'Customer Type',
                icon: Icons.person,
                compact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomDropdownButton(
                items: _saleTypes,
                selectedItem: _selectedSaleType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSaleType = newValue;
                    if (newValue == "Outgoing Sale") {
                      ProxyService.box
                          .writeString(key: 'stockInOutType', value: "11");
                    } else if (newValue == "Incoming Return") {
                      ProxyService.box
                          .writeString(key: 'stockInOutType', value: "03");
                    }
                  });
                },
                label: 'Sale Type',
                icon: Icons.shopping_cart,
                compact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(Customer? attachedCustomer) {
    return TextFormField(
      readOnly: attachedCustomer != null,
      controller: _searchController,
      onChanged: _performSearch,
      decoration: InputDecoration(
        hintText: 'Search Customer',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            CustomDropdownButton(
              items: _saleTypes,
              selectedItem: _selectedSaleType,
              onChanged: (newValue) {
                setState(() {
                  _selectedSaleType = newValue;
                  if (newValue == "Outgoing Sale") {
                    ProxyService.box
                        .writeString(key: 'stockInOutType', value: "11");
                  } else if (newValue == "Incoming Return") {
                    ProxyService.box
                        .writeString(key: 'stockInOutType', value: "03");
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
                      locator<RouterService>().navigateTo(CustomersRoute());
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
    );
  }
}
