// ignore_for_file: unused_result

import 'package:demo_ui_components/demo_ui_components.dart';
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
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
  void _showDropdown() {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: ModalSheetTopBarTitle(widget.label),
          pageTitle: ModalSheetTitle(widget.label),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((String value) {
                final isSelected = value == widget.selectedItem;
                return ListTile(
                  title: Text(
                    value,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    widget.onChanged(value);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
  String? _selectedCustomerId;

  @override
  void initState() {
    super.initState();
    _initializeSearchBox();
    // Initialize with default values
    _selectedCustomerType = 'Walk-in';
    _selectedSaleType = 'Outgoing- Sale';
    // Save default values to transaction after a short delay to ensure transaction is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _saveTransactionMetadata();
      }
    });
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
      // Store the old customer ID before removal
      final oldCustomerId = transaction.value!.customerId;

      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );

      // Invalidate the old customer provider to clear cache
      if (oldCustomerId != null) {
        ref.invalidate(attachedCustomerProvider(oldCustomerId));
      }

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

  /// Save customer type and sale type to the pending transaction
  Future<void> _saveTransactionMetadata() async {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );

    if (transaction.value?.id != null) {
      try {
        // Save customer type to transaction
        await ProxyService.strategy.updateTransaction(
          transactionId: transaction.value!.id,
          customerType: _selectedCustomerType,
        );

        // Save sale type (stockInOutType) to box for reference, defaulting to all 11 for now
        final stockInOutType = _selectedSaleType == 'Agent Sale' ? "11" : "11";
        await ProxyService.box.writeString(
          key: 'stockInOutType',
          value: stockInOutType,
        );

        talker.info(
          'Transaction metadata updated: customerType=$_selectedCustomerType, saleType=$_selectedSaleType',
        );
      } catch (e) {
        talker.warning('Error saving transaction metadata: $e');
      }
    }
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

      // Invalidate the attached customer provider to force refresh
      ref.invalidate(attachedCustomerProvider(customer.id));

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
        _selectedCustomerId = null;
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
          _buildSearchLayout(attachedCustomer, isMobileWidth),
          const SizedBox(height: 16.0),
          if (_searchResults.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final customer = _searchResults[index];
                final isSelected = _selectedCustomerId == customer.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      final transactionValue = transaction.value;
                      if (transactionValue == null) return;
                      setState(() {
                        _selectedCustomerId = customer.id;
                      });
                      _addCustomerToTransaction(customer, transactionValue);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? kcPrimaryColor.withAlpha(15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? kcPrimaryColor
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isSelected
                                ? Icon(
                                    FluentIcons.checkmark_circle_24_filled,
                                    key: const ValueKey('checked'),
                                    color: kcPrimaryColor,
                                  )
                                : Icon(
                                    FluentIcons.add_circle_24_regular,
                                    key: const ValueKey('add'),
                                    color: kcPrimaryColor.withAlpha(80),
                                  ),
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

  Widget _buildSearchLayout(Customer? attachedCustomer, bool isMobileWidth) {
    if (isMobileWidth) {
      return _buildCompactLayout(attachedCustomer);
    } else {
      return _buildExpandedLayout(attachedCustomer);
    }
  }

  Widget _buildCompactLayout(Customer? attachedCustomer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropdownButton(
                items: ['Walk-in', 'Shop'],
                selectedItem: _selectedCustomerType,
                onChanged: (value) {
                  setState(() {
                    _selectedCustomerType = value;
                  });
                  _saveTransactionMetadata();
                },
                label: 'Customer Type',
                icon: FluentIcons.person_16_regular,
                compact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomDropdownButton(
                items: ['Outgoing- Sale', 'Agent Sale'],
                selectedItem: _selectedSaleType,
                onChanged: (value) {
                  setState(() {
                    _selectedSaleType = value;
                  });
                  _saveTransactionMetadata();
                },
                label: 'Sale Type',
                icon: FluentIcons.arrow_swap_16_regular,
                compact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSearchField(attachedCustomer),
      ],
    );
  }

  Widget _buildExpandedLayout(Customer? attachedCustomer) {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildSearchField(attachedCustomer)),
        const SizedBox(width: 12),
        CustomDropdownButton(
          items: ['Walk-in', 'Shop'],
          selectedItem: _selectedCustomerType,
          onChanged: (value) {
            setState(() {
              _selectedCustomerType = value;
            });
            _saveTransactionMetadata();
          },
          label: 'Customer Type',
          icon: FluentIcons.person_16_regular,
        ),
        const SizedBox(width: 8),
        CustomDropdownButton(
          items: ['Outgoing- Sale', 'Agent Sale'],
          selectedItem: _selectedSaleType,
          onChanged: (value) {
            setState(() {
              _selectedSaleType = value;
            });
            _saveTransactionMetadata();
          },
          label: 'Sale Type',
          icon: FluentIcons.arrow_swap_16_regular,
        ),
      ],
    );
  }

  Widget _buildSearchField(Customer? attachedCustomer) {
    return TextFormField(
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
    );
  }
}
