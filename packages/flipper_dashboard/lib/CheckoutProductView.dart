// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/HandleScannWhileSelling.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_dashboard/QuickSellingMobile.dart';
import 'package:flipper_dashboard/widgets/reset_transaction_button.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_scanner/scanner_view.dart';
import 'package:flipper_dashboard/checkout_scanner_actions.dart';

class CheckoutProductView extends StatefulHookConsumerWidget {
  const CheckoutProductView({
    required this.widget,
    required this.tabController,
    required this.textEditController,
    required this.model,
    required this.onCompleteTransaction,
    Key? key,
  }) : super(key: key);

  final CoreViewModel model;
  final CheckOut widget;
  final TabController tabController;
  final TextEditingController textEditController;
  final Future<bool> Function(
    ITransaction transaction,
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  ])
  onCompleteTransaction;

  @override
  _CheckoutProductViewState createState() => _CheckoutProductViewState();
}

class _CheckoutProductViewState extends ConsumerState<CheckoutProductView>
    with
        TextEditingControllersMixin,
        TickerProviderStateMixin,
        TransactionMixinOld,
        PreviewCartMixin {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    searchController.dispose();
    discountController.dispose();
    receivedAmountController.dispose();
    customerPhoneNumberController.dispose();
    paymentTypeController.dispose();
    // Call super.dispose() last to ensure proper cleanup order
    // This allows mixins to clean up their resources before the widget is disposed
    super.dispose();
  }

  String getCartText({required String transactionId}) {
    // Get the latest count with a fresh watch to ensure reactivity
    final itemsAsync = ref.watch(
      transactionItemsStreamProvider(
        transactionId: transactionId,
        branchId: ProxyService.box.branchIdString()!,
      ),
    );

    // Get the count from the async value
    final count = itemsAsync.when(
      data: (items) => items.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return count > 0 ? 'Preview Cart ($count)' : 'Preview Cart';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final transactionAsyncValue = ref.watch(
                pendingTransactionStreamProvider(isExpense: false),
              );

              final txn = transactionAsyncValue.asData?.value;

              final itemsAsync = txn == null
                  ? const AsyncValue<List<TransactionItem>>.data([])
                  : ref.watch(
                      transactionItemsStreamProvider(
                        transactionId: txn.id,
                        branchId: ProxyService.box.branchIdString()!,
                      ),
                    );

              return Column(
                children: [
                  _buildTopBar(context, ref, txn),
                  _buildSaleSummary(txn, itemsAsync),
                  _buildTicketsItemsRow(txn, itemsAsync),
                  _buildSearchAndScanRow(),
                  Expanded(
                    child: ref
                        .watch(
                          outerVariantsProvider(
                            ProxyService.box.getBranchId() ?? "",
                          ),
                        )
                        .when(
                          data: (variants) {
                            if (variants.isEmpty) {
                              return _buildEmptyItemsView(context);
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: ProductView.normalMode(),
                            );
                          },
                          error: (error, stackTrace) =>
                              _buildErrorView(context, error),
                          loading: () => _buildLoadingView(),
                        ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    WidgetRef ref,
    ITransaction? transaction,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final phone = ref.watch(customerPhoneNumberProvider);
    final name = transaction?.customerName?.trim();
    final subtitle = _customerSubtitle(
      name: name,
      phone: phone,
      createdAt: transaction?.createdAt,
    );

    final status = (transaction?.status ?? 'PENDING').toUpperCase();
    final statusStyle = _statusStyle(status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: scheme.outline.withValues(alpha: 0.15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF0078D4),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusStyle.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.bgColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: statusStyle.borderColor,
                            ),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: statusStyle.textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    locator<RouterService>().navigateTo(CustomersRoute()),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0078D4),
                    fontSize: 13,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(customerPhoneNumberProvider.notifier).state = null;
                  ProxyService.box.writeString(
                    key: 'currentSaleCustomerPhoneNumber',
                    value: '',
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _customerSubtitle({
    required String? name,
    required String? phone,
    required DateTime? createdAt,
  }) {
    final who = (name != null && name.isNotEmpty)
        ? name
        : (phone != null && phone.isNotEmpty)
            ? phone
            : 'No customer';
    final time = createdAt != null
        ? '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'
        : '—';
    return '$who · Walk-in · $time';
  }

  ({Color dotColor, Color bgColor, Color borderColor, Color textColor})
  _statusStyle(String status) {
    switch (status) {
      case 'OPEN':
        return (
          dotColor: Colors.green.shade600,
          bgColor: Colors.green.withValues(alpha: 0.12),
          borderColor: Colors.green.withValues(alpha: 0.25),
          textColor: Colors.green.shade800,
        );
      case 'COMPLETED':
        return (
          dotColor: Colors.blue.shade600,
          bgColor: Colors.blue.withValues(alpha: 0.1),
          borderColor: Colors.blue.withValues(alpha: 0.22),
          textColor: Colors.blue.shade800,
        );
      default:
        return (
          dotColor: Colors.amber.shade800,
          bgColor: Colors.amber.withValues(alpha: 0.14),
          borderColor: Colors.amber.withValues(alpha: 0.35),
          textColor: Colors.orange.shade900,
        );
    }
  }

  ({int itemRows, double subtotal, double tax, double total}) _computeSaleMoney(
    ITransaction? transaction,
    AsyncValue<List<TransactionItem>> itemsAsync,
  ) {
    final items = itemsAsync.asData?.value ?? const <TransactionItem>[];
    final active = items.where((i) => i.active != false).toList();
    var lineSub = 0.0;
    var lineTax = 0.0;
    for (final it in active) {
      lineSub += (it.price * it.qty).toDouble();
      lineTax += (it.taxAmt ?? 0).toDouble();
    }
    final t = transaction;
    final sub = (t?.subTotal != null && t!.subTotal! > 0) ? t.subTotal! : lineSub;
    final taxVal = (t?.taxAmount != null && (t!.taxAmount ?? 0) > 0)
        ? t.taxAmount!.toDouble()
        : lineTax;
    final total = sub + taxVal;
    return (
      itemRows: active.length,
      subtotal: sub,
      tax: taxVal,
      total: total,
    );
  }

  Widget _buildSaleSummary(
    ITransaction? transaction,
    AsyncValue<List<TransactionItem>> itemsAsync,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final sym = ProxyService.box.defaultCurrency();
    final m = _computeSaleMoney(transaction, itemsAsync);
    final itemText =
        '${m.itemRows} item${m.itemRows == 1 ? '' : 's'}';

    Widget moneyCol(String label, String amount, {required Color amountColor}) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: amountColor,
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.12)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Reserve label line height so columns align with subtotal/tax/total.
                    const SizedBox(height: 15),
                    const SizedBox(height: 2),
                    Text(
                      itemText,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              moneyCol(
                'subtotal',
                m.subtotal.toCurrencyFormatted(symbol: sym),
                amountColor: scheme.onSurface,
              ),
              moneyCol(
                'tax',
                m.tax.toCurrencyFormatted(symbol: sym),
                amountColor: scheme.onSurface,
              ),
              moneyCol(
                'total',
                m.total.toCurrencyFormatted(symbol: sym),
                amountColor: const Color(0xFF1B7F3A),
              ),
              const ResetTransactionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsItemsRow(
    ITransaction? transaction,
    AsyncValue<List<TransactionItem>> itemsAsync,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final items = itemsAsync.asData?.value ?? const <TransactionItem>[];
    final count = items.where((i) => i.active != false).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: transaction == null
                  ? null
                  : () => handleTicketNavigation(transaction),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.arrow_left_20_regular, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Tickets',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: transaction == null ? null : () => _showPreviewCartBottomSheet(transaction),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.onPrimary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPreviewCartBottomSheet(ITransaction transaction) {
    // Show bottom sheet like in old implementation
    print("Transaction isLoan: ${transaction.isLoan}");
    QuickSellingMobile.showBottom(
      context: context,
      ref: ref,
      transaction: transaction,
      onCharge:
          (
            transactionId,
            total,
            onPaymentConfirmed,
            onPaymentFailed, [
            bool immediateCompletion = false,
          ]) async {
            return await widget.onCompleteTransaction(
              transaction,
              immediateCompletion,
              onPaymentConfirmed,
              onPaymentFailed,
            );
          },
      doneDelete: () {
        ref.refresh(
          transactionItemsStreamProvider(
            branchId: ProxyService.box.branchIdString()!,
            transactionId: transaction.id,
          ),
        );
      },
    );
  }

  Widget _buildSearchAndScanRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _CheckoutPosProductSearch(controller: searchController),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannView(
                      intent: 'selling',
                      scannerActions: CheckoutScannerActions(context, ref),
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0078D4),
                side: const BorderSide(color: Color(0xFFD1D1D6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.scan_camera_16_filled, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Scan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyItemsView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 180.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.box_20_regular,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Items not available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, Object error) {
    // Show error in the standardized snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomSnackBarUtil(
        context,
        'Error loading items: ${error.toString()}',
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 5),
      );
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.error_circle_20_regular,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading Items',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.refresh(
                outerVariantsProvider(ProxyService.box.getBranchId() ?? ""),
              ),
              icon: const Icon(FluentIcons.arrow_sync_20_filled),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator(), SizedBox(height: 16)],
        ),
      ),
    );
  }
}

/// Mobile checkout product search: POS-style field only (no orders / mail /
/// add-product strip). Uses the same debounced [processDebouncedValue] path
/// as [SearchField] so product filtering and scan-to-add stay consistent.
class _CheckoutPosProductSearch extends StatefulHookConsumerWidget {
  const _CheckoutPosProductSearch({required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<_CheckoutPosProductSearch> createState() =>
      _CheckoutPosProductSearchState();
}

class _CheckoutPosProductSearchState extends ConsumerState<_CheckoutPosProductSearch>
    with HandleScannWhileSelling<_CheckoutPosProductSearch> {
  final _textSubject = BehaviorSubject<String>();
  final _model = CoreViewModel();
  StreamSubscription<String>? _debounceSub;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onControllerChanged);
    _debounceSub = _textSubject
        .debounceTime(const Duration(milliseconds: 400))
        .listen(_onDebounced);
    _textSubject.add(widget.controller.text);
  }

  void _onControllerChanged() {
    final text = widget.controller.text;
    if (mounted) {
      setState(() {
        hasText = text.isNotEmpty;
      });
    }
    _textSubject.add(text);
  }

  Future<void> _onDebounced(String value) async {
    if (!mounted) return;
    if (ref.read(searchStringProvider) == value) return;
    if (_isSearching) return;
    setState(() => _isSearching = true);
    try {
      await processDebouncedValue(value, _model, widget.controller);
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _clearSearch() {
    if (!ref.read(toggleProvider)) {
      ref.read(searchStringProvider.notifier).emitString(value: '');
    }
    widget.controller.clear();
    if (mounted) {
      setState(() => hasText = false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _debounceSub?.cancel();
    if (!_textSubject.isClosed) {
      _textSubject.close();
    }
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: widget.controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE8E8ED),
        hintText: 'Search products...',
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: scheme.primary.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        prefixIcon: _isSearching
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.primary,
                  ),
                ),
              )
            : Icon(
                FluentIcons.search_24_regular,
                color: scheme.onSurfaceVariant,
              ),
        suffixIcon: hasText
            ? IconButton(
                onPressed: _clearSearch,
                icon: Icon(
                  FluentIcons.dismiss_24_regular,
                  color: scheme.onSurfaceVariant,
                ),
                tooltip: 'Clear',
              )
            : null,
      ),
    );
  }
}
