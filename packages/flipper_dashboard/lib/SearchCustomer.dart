// ignore_for_file: unused_result

import 'package:flipper_models/SyncStrategy.dart';
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
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'dart:async';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';

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
          vertical: widget.compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Icon(
                widget.icon,
                size: widget.compact ? 14 : 16,
                color: Colors.black54,
              ),
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
  final _dialogService = locator<DialogService>();

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
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );

    // Reuse the central logic for initializing customer from transaction
    if (transaction.value != null) {
      final customer = await TransactionInitializationHelper.initializeCustomer(
        ref,
        transaction.value!,
      );

      if (customer != null) {
        _searchController.text = customer.custNm ?? '';
        return;
      }
    }

    // Fallback: Use snapshot data from box
    final existingCustomerName = ProxyService.box.customerName();

    if (existingCustomerName != null) {
      // Use the manually entered customer name
      _searchController.text = existingCustomerName;
    } else {
      _searchController.clear();
      // Clear the Riverpod provider when no customer is found
      Future(() {
        ref.read(customerPhoneNumberProvider.notifier).state = null;
      });
    }
  }

  Future<void> _removeCustomer() async {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );
    ProxyService.box.remove(key: 'customerTin');
    if (transaction.value?.id != null) {
      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );

      ref.refresh(pendingTransactionStreamProvider(isExpense: false));

      setState(() {
        _searchController.clear();
      });
      // Clear the Riverpod provider for customer phone number
      ref.read(customerPhoneNumberProvider.notifier).state = null;
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
        List<Customer> customers = [];
        String? branchId = ProxyService.box.getBranchId();
        if (branchId != null && branchId.isNotEmpty) {
          customers = await ProxyService.getStrategy(
            Strategy.capella,
          ).customers(key: searchKey, branchId: branchId);
        }

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
    Customer customer,
    ITransaction transaction,
  ) async {
    final customerNameController = ref.read(customerNameControllerProvider);
    try {
      customerNameController.text = customer.custNm!;
      await ProxyService.strategy.assignCustomerToTransaction(
        customer: customer,
        transaction: transaction,
      );

      // Save customer information to ProxyService.box for receipt generation
      await ProxyService.box.writeString(
        key: 'customerName',
        value: customer.custNm!,
      );
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: customer.telNo ?? '',
      );

      // Save customer's TIN for future use
      if (customer.custTin != null && customer.custTin!.isNotEmpty) {
        unawaited(
          ProxyService.box.writeString(
            key: 'customerTin',
            value: customer.custTin!,
          ),
        );
      }

      // Update the Riverpod provider for customer phone number
      ref.read(customerPhoneNumberProvider.notifier).state = customer.telNo;

      // Show success alert
      await _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Success',
        description: 'Customer ${customer.custNm} added to the sale!',
        data: {'status': InfoDialogStatus.success},
      );
      // Refresh the transaction
      ref.refresh(pendingTransactionStreamProvider(isExpense: false));

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
    final transaction = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );

    final attachedCustomerAsync = ref.watch(
      attachedCustomerProvider(transaction.value?.customerId),
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
      ProxyService.box.writeString(key: 'stockInOutType', value: "11");
    }

    // Extract the customer value, defaulting to null if loading or error
    final attachedCustomer = attachedCustomerAsync.maybeWhen(
      data: (customer) => customer,
      orElse: () => null,
    );

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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final customer = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () =>
                        _addCustomerToTransaction(customer, transaction.value!),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: kcPrimaryColor.withAlpha(10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                customer.custNm?.isNotEmpty == true
                                    ? customer.custNm![0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: kcPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          horizontalSpaceRegular,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.custNm ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (customer.custTin?.isNotEmpty ??
                                        false) ...[
                                      Icon(
                                        FluentIcons.document_text_16_regular,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        customer.custTin ?? "",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                    ],
                                    if (customer.telNo?.isNotEmpty ??
                                        false) ...[
                                      Icon(
                                        FluentIcons.phone_16_regular,
                                        size: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        customer.telNo ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            FluentIcons.add_circle_24_regular,
                            color: kcPrimaryColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
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
