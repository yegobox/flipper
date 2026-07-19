import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/add_new_customer_button.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'add_customer.dart';

class Customers extends StatefulHookConsumerWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  CustomersState createState() => CustomersState();
}

class CustomersState extends ConsumerState<Customers> {
  final TextEditingController _searchController = TextEditingController();
  final _routerService = locator<RouterService>();
  bool _openingCustomerForm = false;
  /// Customer id currently being attached/removed — drives per-row spinner.
  String? _saleActionCustomerId;
  /// Desktop side panel (add / edit) — null when closed.
  _CustomerFormPanel? _formPanel;

  static const double _desktopContentMaxWidth = 720;
  static const double _desktopFormPanelWidth = 420;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(customerSearchStringProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(customerSearchStringProvider.notifier).emitString(value: value);
  }

  bool _isWideLayout(BuildContext context) {
    return MediaQuery.sizeOf(context).width >=
        PosLayoutBreakpoints.mobileLayoutMaxWidth;
  }

  @override
  Widget build(BuildContext context) {
    final searchKeyword = ref.watch(customerSearchStringProvider);
    final customersRef = ref.watch(customersProvider);
    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(isExpense: false),
    );
    final isWide = _isWideLayout(context);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: PosTokens.posBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: PosTokens.surface,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Customers',
              style: TextStyle(
                color: PosTokens.ink1,
                fontWeight: FontWeight.w700,
                fontSize: isWide ? 22 : 20,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: PosTokens.blue,
                size: 20,
              ),
              // Do not invalidate pendingTransactionStream here — that tears
              // down the Capella observer and can spawn a new empty cart,
              // dropping the customer just attached on this screen.
              onPressed: () => _routerService.pop(),
            ),
            actions: [
              IconButton(
                tooltip: 'Help',
                icon: const Icon(Icons.help_outline, color: PosTokens.blue),
                onPressed: () => _showHelpDialog(context, isWide),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: PosTokens.line),
            ),
          ),
          body: transactionAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (transaction) {
              return customersRef.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (allCustomers) {
                  final filteredCustomers = ref
                      .read(customersProvider.notifier)
                      .filterCustomers(allCustomers, searchKeyword);

                  final listPane = Column(
                    children: [
                      _buildSearchBar(isWide),
                      _buildAddButton(
                        context,
                        model,
                        customersRef,
                        searchKeyword,
                        transaction,
                        isWide,
                      ),
                      _buildResultStats(filteredCustomers, isWide),
                      Expanded(
                        child: _buildCustomerList(
                          model,
                          transaction,
                          filteredCustomers,
                          isWide,
                        ),
                      ),
                    ],
                  );

                  if (!isWide) return listPane;

                  final panel = _formPanel;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: panel != null
                                  ? double.infinity
                                  : _desktopContentMaxWidth,
                            ),
                            child: listPane,
                          ),
                        ),
                      ),
                      if (panel != null)
                        SizedBox(
                          width: _desktopFormPanelWidth,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: PosTokens.surface,
                              border: Border(
                                left: BorderSide(color: PosTokens.line),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  offset: Offset(-4, 0),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: AddCustomer(
                              key: ValueKey(
                                'panel-${panel.customer?.id ?? 'new'}-'
                                '${panel.searchedKey}',
                              ),
                              transactionId: panel.transactionId,
                              searchedKey: panel.searchedKey,
                              customer: panel.customer,
                              showSheetHandle: false,
                              panelMode: true,
                              onDismissed: _closeFormPanel,
                              onCompleted: (message) {
                                _closeFormPanel();
                                _showCustomersToast(
                                  message,
                                  backgroundColor: Colors.green[600],
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _closeFormPanel() {
    if (!mounted) return;
    setState(() {
      _formPanel = null;
      _openingCustomerForm = false;
    });
  }

  void _showHelpDialog(BuildContext context, bool isWide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer management'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                Icons.search_rounded,
                'Search customers by name or phone number',
              ),
              _buildHelpItem(
                Icons.edit_outlined,
                'Use Edit on a customer row to update their details',
              ),
              _buildHelpItem(
                Icons.touch_app_outlined,
                'Tap a customer to attach them to the current sale',
              ),
              if (!isWide)
                _buildHelpItem(
                  Icons.swipe_rounded,
                  'On phone, swipe a row for quick delete, edit, add, or remove',
                ),
              _buildHelpItem(
                Icons.person_add_outlined,
                'Add a new customer with the button below the search field',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Close',
              style: TextStyle(color: PosTokens.blue),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: PosTokens.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: PosTokens.ink2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStats(List<Customer> customers, bool isWide) {
    final horizontal = isWide ? 20.0 : 16.0;
    return Padding(
      padding: EdgeInsets.only(left: horizontal, right: horizontal, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: customers.isEmpty
            ? const Text(
                'No customers found',
                style: TextStyle(
                  fontSize: 14,
                  color: PosTokens.ink3,
                  fontStyle: FontStyle.italic,
                ),
              )
            : Text(
                '${customers.length} ${customers.length == 1 ? 'customer' : 'customers'} found',
                style: const TextStyle(fontSize: 14, color: PosTokens.ink3),
              ),
      ),
    );
  }

  Widget _buildSearchBar(bool isWide) {
    final horizontal = isWide ? 20.0 : 16.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 15, color: PosTokens.ink1),
        decoration: InputDecoration(
          hintText: 'Search customers by name or phone',
          hintStyle: const TextStyle(color: PosTokens.ink4, fontSize: 15),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: PosTokens.blue,
            size: 22,
          ),
          filled: true,
          fillColor: PosTokens.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            borderSide: const BorderSide(color: PosTokens.lineStrong),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            borderSide: const BorderSide(color: PosTokens.blue, width: 1.5),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: PosTokens.ink3,
                    size: 20,
                  ),
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildCustomerList(
    CoreViewModel model,
    ITransaction transaction,
    List<Customer> displayedCustomers,
    bool isWide,
  ) {
    if (displayedCustomers.isEmpty) {
      return _buildEmptyState(transaction, isWide);
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        isWide ? 20 : 16,
        0,
        isWide ? 20 : 16,
        24,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: displayedCustomers.length,
      itemBuilder: (context, index) {
        final customer = displayedCustomers[index];
        return _buildCustomerCard(customer, model, transaction, isWide);
      },
    );
  }

  Widget _buildEmptyState(ITransaction transaction, bool isWide) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: PosTokens.ink4),
            const SizedBox(height: 16),
            const Text(
              'No customers found',
              style: TextStyle(
                color: PosTokens.ink1,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try different search terms or add a new customer'
                  : 'Add a customer to get started',
              textAlign: TextAlign.center,
              style: const TextStyle(color: PosTokens.ink3),
            ),
            const SizedBox(height: 24),
            AddNewCustomerButton(
              label: _searchController.text.isNotEmpty
                  ? 'Add "${_searchController.text}" as new customer'
                  : 'Add new customer',
              isLoading: _openingCustomerForm,
              onPressed: _openingCustomerForm
                  ? null
                  : () => _openCustomerForm(
                        context,
                        transactionId: transaction.id,
                        searchedKey: _searchController.text,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(
    Customer customer,
    CoreViewModel model,
    ITransaction transaction,
    bool isWide,
  ) {
    final nameInitial =
        (customer.custNm != null && customer.custNm!.isNotEmpty)
        ? customer.custNm![0].toUpperCase()
        : '?';

    final avatarColor = _getAvatarColor(customer.custNm ?? '');
    final isSelected = transaction.customerId == customer.id;
    final isSaleActionBusy = _saleActionCustomerId == customer.id;
    final isEditingInPanel = _formPanel?.customer?.id == customer.id;

    final card = Material(
      color: isEditingInPanel
          ? const Color(0xFFFFF8EF)
          : isSelected
          ? PosTokens.blueTint
          : PosTokens.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        side: BorderSide(
          color: isEditingInPanel
              ? PosTokens.warnAmber
              : isSelected
              ? PosTokens.blue
              : PosTokens.line,
          width: (isSelected || isEditingInPanel) ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        onTap: isSaleActionBusy || isSelected
            ? null
            : () => _attachCustomer(customer, transaction, model: model),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 16 : 14,
            vertical: isWide ? 14 : 12,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: isWide ? 24 : 22,
                backgroundColor: avatarColor,
                child: Text(
                  nameInitial,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isWide ? 18 : 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.custNm ?? 'No Name',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: PosTokens.ink1,
                      ),
                    ),
                    if (customer.telNo != null && customer.telNo!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: PosTokens.ink3,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                customer.telNo!,
                                style: const TextStyle(color: PosTokens.ink2),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (customer.custTin != null &&
                        customer.custTin!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: 14,
                              color: PosTokens.ink3,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'TIN: ${customer.custTin!}',
                                style: const TextStyle(color: PosTokens.ink2),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: PosTokens.gain.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: PosTokens.gain,
                    size: 18,
                  ),
                ),
              ],
              const SizedBox(width: 4),
              if (isWide)
                _buildDesktopActions(
                  customer,
                  model,
                  transaction,
                  isSelected,
                  isSaleActionBusy,
                )
              else
                _buildMobileOverflowMenu(
                  customer,
                  model,
                  transaction,
                  isSelected,
                  isSaleActionBusy,
                ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: isWide
          ? card
          : Slidable(
              key: Key('customer-${customer.id}'),
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      if (isSaleActionBusy) return;
                      _confirmDeleteCustomer(customer, model);
                    },
                    backgroundColor: PosTokens.loss,
                    foregroundColor: Colors.white,
                    icon: Icons.delete_outline,
                    label: 'Delete',
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      if (isSaleActionBusy) return;
                      _openCustomerForm(
                        context,
                        transactionId: transaction.id,
                        searchedKey: customer.custNm ?? '',
                        customer: customer,
                      );
                    },
                    backgroundColor: PosTokens.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  if (!isSelected)
                    SlidableAction(
                      onPressed: (_) {
                        if (isSaleActionBusy) return;
                        _attachCustomer(customer, transaction, model: model);
                      },
                      backgroundColor: PosTokens.gain,
                      foregroundColor: Colors.white,
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Add',
                    ),
                  if (isSelected)
                    SlidableAction(
                      onPressed: (_) {
                        if (isSaleActionBusy) return;
                        _removeCustomerFromSale(
                          customer,
                          transaction,
                          model: model,
                        );
                      },
                      backgroundColor: PosTokens.warnAmber,
                      foregroundColor: Colors.white,
                      icon: Icons.person_remove_outlined,
                      label: 'Remove',
                    ),
                ],
              ),
              child: card,
            ),
    );
  }

  Widget _buildDesktopActions(
    Customer customer,
    CoreViewModel model,
    ITransaction transaction,
    bool isSelected,
    bool isSaleActionBusy,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Edit customer',
          onPressed: isSaleActionBusy
              ? null
              : () => _openCustomerForm(
                    context,
                    transactionId: transaction.id,
                    searchedKey: customer.custNm ?? '',
                    customer: customer,
                  ),
          icon: const Icon(Icons.edit_outlined, size: 20),
          color: PosTokens.ink2,
        ),
        if (isSaleActionBusy)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: PosTokens.blue,
              ),
            ),
          )
        else
          IconButton(
            tooltip: isSelected ? 'Remove from sale' : 'Add to sale',
            onPressed: () {
              if (isSelected) {
                _removeCustomerFromSale(
                  customer,
                  transaction,
                  model: model,
                );
              } else {
                _attachCustomer(customer, transaction, model: model);
              }
            },
            icon: Icon(
              isSelected
                  ? Icons.person_remove_outlined
                  : Icons.person_add_alt_1_outlined,
              size: 20,
            ),
            color: isSelected ? PosTokens.warnAmber : PosTokens.gain,
          ),
        IconButton(
          tooltip: 'Delete customer',
          onPressed: isSaleActionBusy
              ? null
              : () => _confirmDeleteCustomer(customer, model),
          icon: const Icon(Icons.delete_outline, size: 20),
          color: PosTokens.loss,
        ),
      ],
    );
  }

  Widget _buildMobileOverflowMenu(
    Customer customer,
    CoreViewModel model,
    ITransaction transaction,
    bool isSelected,
    bool isSaleActionBusy,
  ) {
    if (isSaleActionBusy) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: PosTokens.blue,
          ),
        ),
      );
    }

    return PopupMenuButton<_CustomerAction>(
      tooltip: 'Customer actions',
      icon: const Icon(Icons.more_vert_rounded, color: PosTokens.ink3),
      onSelected: (action) {
        switch (action) {
          case _CustomerAction.edit:
            _openCustomerForm(
              context,
              transactionId: transaction.id,
              searchedKey: customer.custNm ?? '',
              customer: customer,
            );
          case _CustomerAction.attach:
            _attachCustomer(customer, transaction, model: model);
          case _CustomerAction.remove:
            _removeCustomerFromSale(customer, transaction, model: model);
          case _CustomerAction.delete:
            _confirmDeleteCustomer(customer, model);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _CustomerAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined, color: PosTokens.blue),
            title: Text('Edit'),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: isSelected
              ? _CustomerAction.remove
              : _CustomerAction.attach,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isSelected
                  ? Icons.person_remove_outlined
                  : Icons.person_add_alt_1_outlined,
              color: isSelected ? PosTokens.warnAmber : PosTokens.gain,
            ),
            title: Text(isSelected ? 'Remove from sale' : 'Add to sale'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: _CustomerAction.delete,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: PosTokens.loss),
            title: Text('Delete'),
            dense: true,
          ),
        ),
      ],
    );
  }

  Future<void> _attachCustomer(
    Customer customer,
    ITransaction transaction, {
    CoreViewModel? model,
  }) async {
    if (_saleActionCustomerId != null) return;

    // Always attach to the live pending cart (same source as SearchCustomer /
    // checkout), not a possibly stale list-row snapshot.
    final livePending = ref
        .read(pendingTransactionStreamProvider(isExpense: false))
        .asData
        ?.value;
    final target = livePending ?? transaction;
    if (target.customerId == customer.id) {
      _routerService.pop();
      return;
    }

    setState(() => _saleActionCustomerId = customer.id);
    await WidgetsBinding.instance.endOfFrame;

    try {
      talker.info(
        'Customers.attach customer=${customer.id} txn=${target.id} '
        '(listTxn=${transaction.id})',
      );

      // Mirror SearchCustomer attach, but clear stale name/TIN when the new
      // customer lacks them so a prior sale's session values cannot linger.
      final customerNameController = ref.read(customerNameControllerProvider);
      final name = customer.custNm?.trim() ?? '';
      if (name.isNotEmpty) {
        customerNameController.text = name;
      } else {
        customerNameController.clear();
      }

      await ProxyService.getStrategy(Strategy.capella)
          .assignCustomerToTransaction(
        customer: customer,
        transaction: target,
      );

      if (name.isNotEmpty) {
        await ProxyService.box.writeString(key: 'customerName', value: name);
      } else {
        await ProxyService.box.writeString(key: 'customerName', value: '');
      }
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: customer.telNo ?? '',
      );
      final tin = customer.custTin?.trim() ?? '';
      if (tin.isNotEmpty) {
        await ProxyService.box.writeString(key: 'customerTin', value: tin);
      } else {
        await ProxyService.box.remove(key: 'customerTin');
      }

      ref.read(customerPhoneNumberProvider.notifier).state = customer.telNo;
      ref.invalidate(attachedCustomerProvider(customer.id));
      ref.invalidate(transactionByIdProvider(target.id));

      if (!mounted) return;
      _showCustomersToast(
        'Customer ${customer.custNm ?? ''} added to sale',
        backgroundColor: PosTokens.gain,
      );
      // Return to checkout so the red "customer attached" control is visible.
      _routerService.pop();
    } catch (e, s) {
      talker.warning('Customers.attach failed: $e\n$s');
      _showCustomersToast(
        e.toString().isNotEmpty ? e.toString() : 'Failed to add customer to sale',
        backgroundColor: PosTokens.loss,
      );
    } finally {
      if (mounted) setState(() => _saleActionCustomerId = null);
    }
  }

  void _showCustomersToast(
    String message, {
    Color? backgroundColor,
  }) {
    if (!mounted) return;
    // Use this State's context (Customers Scaffold), not the root navigator —
    // Customers is a CustomPage above the dashboard, so root snackbars sit behind it.
    showCustomSnackBarUtil(
      context,
      message,
      backgroundColor: backgroundColor,
    );
  }

  Future<void> _removeCustomerFromSale(
    Customer customer,
    ITransaction transaction, {
    CoreViewModel? model,
  }) async {
    if (_saleActionCustomerId != null) return;

    final livePending = ref
        .read(pendingTransactionStreamProvider(isExpense: false))
        .asData
        ?.value;
    final target = livePending ?? transaction;

    setState(() => _saleActionCustomerId = customer.id);
    await WidgetsBinding.instance.endOfFrame;

    try {
      final oldCustomerId = target.customerId;
      await ProxyService.getStrategy(Strategy.capella)
          .removeCustomerFromTransaction(transaction: target);

      await ProxyService.box.remove(key: 'customerName');
      await ProxyService.box.remove(key: 'currentSaleCustomerPhoneNumber');
      await ProxyService.box.remove(key: 'customerTin');
      ref.read(customerNameControllerProvider).clear();

      ref.read(customerPhoneNumberProvider.notifier).state = null;
      if (oldCustomerId != null) {
        ref.invalidate(attachedCustomerProvider(oldCustomerId));
      }
      ref.invalidate(transactionByIdProvider(target.id));
      _showCustomersToast(
        'Customer removed from sale',
        backgroundColor: PosTokens.warnAmber,
      );
    } catch (e, s) {
      talker.warning('Customers.remove failed: $e\n$s');
      _showCustomersToast(
        e.toString().isNotEmpty
            ? e.toString()
            : 'Failed to remove customer from sale',
        backgroundColor: PosTokens.loss,
      );
    } finally {
      if (mounted) setState(() => _saleActionCustomerId = null);
    }
  }

  Future<void> _confirmDeleteCustomer(
    Customer customer,
    CoreViewModel model,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierColor: PosTokens.ink1.withValues(alpha: 0.58),
      builder: (dialogContext) =>
          _DeleteCustomerDialog(customer: customer),
    );
    if (confirmed != true || !mounted) return;

    final livePending = ref
        .read(pendingTransactionStreamProvider(isExpense: false))
        .asData
        ?.value;
    // Detach cart only when this customer is the one on the sale.
    if (livePending?.customerId == customer.id) {
      await _removeCustomerFromSale(
        customer,
        livePending!,
        model: model,
      );
    }
    // Delete the record without CoreViewModel.deleteCustomer, which
    // clears any attached cart customer regardless of id match.
    // Route through Capella (same store the list observes) so the Ditto
    // customersStream observer fires and the row disappears on its own.
    await ProxyService.getStrategy(Strategy.capella).flipperDelete(
      id: customer.id,
      endPoint: 'customer',
      flipperHttpClient: ProxyService.http,
    );
    if (!mounted) return;
    _showCustomersToast(
      'Customer deleted',
      backgroundColor: PosTokens.blue,
    );
    ref.invalidate(customersProvider);
    ref.invalidate(attachedCustomerProvider(customer.id));
  }

  Future<void> _openCustomerForm(
    BuildContext context, {
    required String transactionId,
    String searchedKey = '',
    Customer? customer,
  }) async {
    if (_openingCustomerForm && _formPanel == null) return;

    final isWide = _isWideLayout(context);

    // Desktop: side-by-side panel so the list stays visible while editing.
    if (isWide) {
      setState(() {
        _openingCustomerForm = false;
        _formPanel = _CustomerFormPanel(
          transactionId: transactionId,
          searchedKey: searchedKey,
          customer: customer,
        );
      });
      return;
    }

    if (_openingCustomerForm) return;
    setState(() => _openingCustomerForm = true);
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;

    try {
      final message = await showModalBottomSheet<String>(
        context: context,
        useRootNavigator: true,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: PosTokens.surface,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MposTokens.sheetRadius),
          ),
        ),
        builder: (sheetContext) => AddCustomer(
          transactionId: transactionId,
          searchedKey: searchedKey,
          customer: customer,
          showSheetHandle: true,
        ),
      );

      if (message != null && message.isNotEmpty) {
        _showCustomersToast(
          message,
          backgroundColor: Colors.green[600],
        );
      }
    } catch (e) {
      _showCustomersToast(
        'Could not open customer form: $e',
        backgroundColor: PosTokens.loss,
      );
    } finally {
      if (mounted) setState(() => _openingCustomerForm = false);
    }
  }

  Color _getAvatarColor(String name) {
    const colors = [
      PosTokens.blue,
      PosTokens.gain,
      PosTokens.loss,
      Color(0xFF5C2D91),
      Color(0xFF008575),
      Color(0xFFE3008C),
      Color(0xFF00B7C3),
      Color(0xFFFFB900),
    ];
    if (name.isEmpty) return colors[0];
    var hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  Widget _buildAddButton(
    BuildContext context,
    CoreViewModel model,
    AsyncValue<List<Customer>> customersRef,
    String searchKeyword,
    ITransaction transaction,
    bool isWide,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWide ? 20 : 16,
        0,
        isWide ? 20 : 16,
        12,
      ),
      child: AddNewCustomerButton(
        label: _getButtonText(customersRef, searchKeyword),
        isLoading: _openingCustomerForm,
        onPressed: _openingCustomerForm
            ? null
            : () => _handleButtonPress(
                  context,
                  model,
                  customersRef,
                  searchKeyword,
                  transaction,
                ),
      ),
    );
  }

  String _getButtonText(
    AsyncValue<List<Customer>> customersRef,
    String searchKeyword,
  ) {
    final customers = customersRef.asData?.value ?? [];
    final isCustomerListEmpty = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword)
        .isEmpty;

    if (searchKeyword.isEmpty) {
      return 'Add new customer';
    }

    return isCustomerListEmpty
        ? 'Add customer "$searchKeyword"'
        : 'Add "$searchKeyword" to sale';
  }

  Future<void> _handleButtonPress(
    BuildContext context,
    CoreViewModel model,
    AsyncValue<List<Customer>> customersRef,
    String searchKeyword,
    ITransaction transaction,
  ) async {
    final customers = customersRef.asData?.value ?? [];
    final filteredCustomers = ref
        .read(customersProvider.notifier)
        .filterCustomers(customers, searchKeyword);

    if (filteredCustomers.isEmpty || searchKeyword.isEmpty) {
      await _openCustomerForm(
        context,
        transactionId: transaction.id,
        searchedKey: searchKeyword,
      );
    } else {
      final customer = filteredCustomers.first;
      await _attachCustomer(customer, transaction, model: model);
    }
  }
}

enum _CustomerAction { edit, attach, remove, delete }

class _CustomerFormPanel {
  const _CustomerFormPanel({
    required this.transactionId,
    this.searchedKey = '',
    this.customer,
  });

  final String transactionId;
  final String searchedKey;
  final Customer? customer;
}

/// Confirm delete — same chrome as ticket delete ([_DeleteTicketDialog]).
class _DeleteCustomerDialog extends StatelessWidget {
  const _DeleteCustomerDialog({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final name = (customer.custNm ?? 'this customer').trim();
    final phone = (customer.telNo ?? '').trim();
    final tin = (customer.custTin ?? '').trim();
    final media = MediaQuery.sizeOf(context);
    final maxWidth = media.width < 460 ? media.width - 48 : 420.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: PosTokens.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: PosTokens.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33103240),
                offset: Offset(0, 24),
                blurRadius: 48,
                spreadRadius: -18,
              ),
              BoxShadow(
                color: Color(0x14103240),
                offset: Offset(0, 8),
                blurRadius: 18,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: PosTokens.lossTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: PosTokens.lossInk,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delete customer?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: PosTokens.ink1,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Remove $name from your customer list. This cannot be undone.',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.35,
                              color: PosTokens.ink2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (phone.isNotEmpty || tin.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: PosTokens.surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: PosTokens.line),
                    ),
                    child: Column(
                      children: [
                        _DeleteCustomerDetailRow(label: 'Name', value: name),
                        if (phone.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _DeleteCustomerDetailRow(label: 'Phone', value: phone),
                        ],
                        if (tin.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _DeleteCustomerDetailRow(label: 'TIN', value: tin),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: PosTokens.warnTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: Color(0xFFC2410C),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This action cannot be undone.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PosTokens.ink1,
                          side: const BorderSide(color: PosTokens.lineStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(Icons.delete_outline, size: 19),
                        label: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: PosTokens.loss,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteCustomerDetailRow extends StatelessWidget {
  const _DeleteCustomerDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: PosTokens.ink3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PosTokens.ink1,
            ),
          ),
        ),
      ],
    );
  }
}
