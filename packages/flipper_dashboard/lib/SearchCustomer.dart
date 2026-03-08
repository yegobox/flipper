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

  // Layer link used to anchor the floating results below the search field
  final LayerLink _layerLink = LayerLink();

  String _selectedCustomerType = 'Walk-in';
  String _selectedSaleType = 'Outgoing- Sale';
  List<Customer> _searchResults = [];
  Timer? _debounceTimer;
  String? _selectedCustomerId;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _initializeSearchBox();
    _selectedCustomerType = 'Walk-in';
    _selectedSaleType = 'Outgoing- Sale';
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
    _removeOverlay();
    super.dispose();
  }

  // ─── Overlay management ────────────────────────────────────────────────────

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(ITransaction? transaction) {
    _removeOverlay();
    if (_searchResults.isEmpty) return;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // Transparent barrier – tapping outside dismisses the dropdown
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
              child: const SizedBox.expand(),
            ),
          ),
          _FloatingResults(
            layerLink: _layerLink,
            results: _searchResults,
            selectedId: _selectedCustomerId,
            onSelect: (customer) {
              if (transaction == null) return;
              setState(() => _selectedCustomerId = customer.id);
              _addCustomerToTransaction(customer, transaction);
              _removeOverlay();
            },
          ),
        ],
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  // ─── Initialisation ────────────────────────────────────────────────────────

  Future<void> _initializeSearchBox() async {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );

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

    final existingCustomerName = ProxyService.box.customerName();
    if (existingCustomerName != null) {
      _searchController.text = existingCustomerName;
    } else {
      _searchController.clear();
      Future(() {
        ref.read(customerPhoneNumberProvider.notifier).state = null;
      });
    }
  }

  // ─── Customer actions ──────────────────────────────────────────────────────

  Future<void> _removeCustomer() async {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );
    ProxyService.box.remove(key: 'customerTin');
    if (transaction.value?.id != null) {
      final oldCustomerId = transaction.value!.customerId;
      await ProxyService.strategy.removeCustomerFromTransaction(
        transaction: transaction.value!,
      );
      if (oldCustomerId != null) {
        ref.invalidate(attachedCustomerProvider(oldCustomerId));
      }
      ref.refresh(pendingTransactionStreamProvider(isExpense: false));
      setState(() => _searchController.clear());
      ref.read(customerPhoneNumberProvider.notifier).state = null;
    }
  }

  void _performSearch(String searchKey, ITransaction? transaction) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      if (searchKey.isEmpty) {
        setState(() => _searchResults = []);
        _removeOverlay();
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
        setState(() => _searchResults = customers);
        _showOverlay(transaction);
      } catch (e) {
        talker.warning('Error searching customers: $e');
        setState(() => _searchResults = []);
        _removeOverlay();
      }
    });
  }

  Future<void> _saveTransactionMetadata() async {
    final transaction = ref.read(
      pendingTransactionStreamProvider(isExpense: false),
    );
    if (transaction.value?.id != null) {
      try {
        await ProxyService.strategy.updateTransaction(
          transactionId: transaction.value!.id,
          customerType: _selectedCustomerType,
        );
        final stockInOutType = _selectedSaleType == 'Agent Sale' ? '11' : '11';
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
      await ProxyService.box.writeString(
        key: 'customerName',
        value: customer.custNm!,
      );
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: customer.telNo ?? '',
      );
      if (customer.custTin != null && customer.custTin!.isNotEmpty) {
        unawaited(
          ProxyService.box.writeString(
            key: 'customerTin',
            value: customer.custTin!,
          ),
        );
      }
      ref.read(customerPhoneNumberProvider.notifier).state = customer.telNo;
      ref.invalidate(attachedCustomerProvider(customer.id));
      await _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Success',
        description: 'Customer ${customer.custNm} added to the sale!',
        data: {'status': InfoDialogStatus.success},
      );
      ref.refresh(pendingTransactionStreamProvider(isExpense: false));
      setState(() {
        _searchResults = [];
        _searchController.clear();
        _selectedCustomerId = null;
      });
    } catch (e, s) {
      talker.warning('Error adding customer to transaction: $s');
      showToast(context, '$e', color: Colors.red);
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

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

    final attachedCustomer = attachedCustomerAsync.maybeWhen(
      data: (customer) => customer,
      orElse: () => null,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _buildSearchLayout(
        attachedCustomer,
        isMobileWidth,
        transaction.value,
      ),
    );
  }

  // ─── Layouts ───────────────────────────────────────────────────────────────

  Widget _buildSearchLayout(
    Customer? attachedCustomer,
    bool isMobileWidth,
    ITransaction? transaction,
  ) {
    if (isMobileWidth) {
      return _buildCompactLayout(attachedCustomer, transaction);
    } else {
      return _buildExpandedLayout(attachedCustomer, transaction);
    }
  }

  Widget _buildCompactLayout(
    Customer? attachedCustomer,
    ITransaction? transaction,
  ) {
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
                  setState(() => _selectedCustomerType = value);
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
                  setState(() => _selectedSaleType = value);
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
        _buildSearchField(attachedCustomer, transaction),
      ],
    );
  }

  Widget _buildExpandedLayout(
    Customer? attachedCustomer,
    ITransaction? transaction,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: _buildSearchField(attachedCustomer, transaction),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: CustomDropdownButton(
            items: ['Walk-in', 'Shop'],
            selectedItem: _selectedCustomerType,
            onChanged: (value) {
              setState(() => _selectedCustomerType = value);
              _saveTransactionMetadata();
            },
            label: 'Customer Type',
            icon: FluentIcons.person_16_regular,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomDropdownButton(
            items: ['Outgoing- Sale', 'Agent Sale'],
            selectedItem: _selectedSaleType,
            onChanged: (value) {
              setState(() => _selectedSaleType = value);
              _saveTransactionMetadata();
            },
            label: 'Sale Type',
            icon: FluentIcons.arrow_swap_16_regular,
          ),
        ),
      ],
    );
  }

  /// The search text field wrapped in a [CompositedTransformTarget] so the
  /// floating results overlay can be anchored directly below it at any
  /// screen resolution.
  Widget _buildSearchField(
    Customer? attachedCustomer,
    ITransaction? transaction,
  ) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        readOnly: attachedCustomer != null,
        controller: _searchController,
        onChanged: (v) => _performSearch(v, transaction),
        onTap: () {
          // Re-show overlay if results already exist (e.g. user tapped away)
          if (_searchResults.isNotEmpty) _showOverlay(transaction);
        },
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
    );
  }
}

// ─── Floating results overlay ──────────────────────────────────────────────

/// Renders a floating card directly below the search field using
/// [CompositedTransformFollower], regardless of where the widget sits
/// inside the widget tree or what screen size/resolution is in use.
class _FloatingResults extends StatelessWidget {
  final LayerLink layerLink;
  final List<Customer> results;
  final String? selectedId;
  final ValueChanged<Customer> onSelect;

  const _FloatingResults({
    required this.layerLink,
    required this.results,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Measure available height so the list never overflows the screen.
    final screenHeight = MediaQuery.of(context).size.height;
    final maxListHeight = screenHeight * 0.4;

    return Positioned(
      // Required for OverlayEntry – actual position is driven by the follower.
      top: 0,
      left: 0,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        // Place the top-left of the follower at the bottom-left of the target.
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
        offset: const Offset(0, 4),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 280,
              maxWidth: 480,
              maxHeight: maxListHeight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final customer = results[index];
                  final isSelected = selectedId == customer.id;
                  return InkWell(
                    onTap: () => onSelect(customer),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // Avatar circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kcPrimaryColor.withAlpha(20),
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
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.custNm ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                if ((customer.custTin?.isNotEmpty ?? false) ||
                                    (customer.telNo?.isNotEmpty ?? false)) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      if (customer.custTin?.isNotEmpty ??
                                          false) ...[
                                        Icon(
                                          FluentIcons.document_text_16_regular,
                                          size: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.custTin!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (customer.telNo?.isNotEmpty ??
                                          false) ...[
                                        Icon(
                                          FluentIcons.phone_16_regular,
                                          size: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.telNo!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isSelected
                                ? const Icon(
                                    FluentIcons.checkmark_circle_24_filled,
                                    key: ValueKey('checked'),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
