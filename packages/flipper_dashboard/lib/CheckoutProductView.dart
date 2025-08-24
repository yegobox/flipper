// ignore_for_file: unused_result

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_dashboard/bottomSheet.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'dart:io';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutProductView extends StatefulHookConsumerWidget {
  const CheckoutProductView({
    required this.widget,
    required this.tabController,
    required this.textEditController,
    required this.model,
    Key? key,
  }) : super(key: key);

  final CoreViewModel model;
  final CheckOut widget;
  final TabController tabController;
  final TextEditingController textEditController;

  @override
  _CheckoutProductViewState createState() => _CheckoutProductViewState();
}

class _CheckoutProductViewState extends ConsumerState<CheckoutProductView>
    with
        TextEditingControllersMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver,
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
    super.dispose();
  }

  String getCartText({required String transactionId}) {
    // Get the latest count with a fresh watch to ensure reactivity
    final itemsAsync =
        ref.watch(transactionItemsStreamProvider(transactionId: transactionId));

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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Loyverse-style Header
              _buildFlipperseHeader(),

              // Main Action Buttons
              _buildActionButtons(),

              // Search/Filter Bar
              _buildSearchFilterBar(),

              // ProductView takes remaining space
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    return ref
                        .watch(outerVariantsProvider(
                            ProxyService.box.getBranchId() ?? 0))
                        .when(
                          data: (variants) {
                            if (variants.isEmpty) {
                              return _buildEmptyItemsView(context);
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ProductView.normalMode(),
                            );
                          },
                          error: (error, stackTrace) =>
                              _buildErrorView(context, error),
                          loading: () => _buildLoadingView(),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlipperseHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Modern Back Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          const Spacer(),

          // Action Icons
          Row(
            children: [
              // Add Customer Icon
              IconButton(
                icon: const Icon(
                  FluentIcons.person_add_16_regular,
                  color: Colors.blue,
                  size: 20,
                ),
                onPressed: () {
                  locator<RouterService>().navigateTo(CustomersRoute());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer(
      builder: (context, ref, _) {
        final transactionAsyncValue =
            ref.watch(pendingTransactionStreamProvider(isExpense: false));

        return transactionAsyncValue.when(
          data: (transaction) {
            final cartText = getCartText(transactionId: transaction.id);
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // OPEN TICKETS Button - Shows bottom sheet like old implementation
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        handleTicketNavigation(transaction);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759), // Green like Loyverse
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Tickets',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tickets Button - Handles complete transaction like old implementation
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showPreviewCartBottomSheet(transaction);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759), // Green like Loyverse
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            cartText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          loading: () => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'OPEN TICKETS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'CHARGE RWF 0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'OPEN TICKETS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'CHARGE RWF 0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPreviewCartBottomSheet(ITransaction transaction) {
    // Show bottom sheet like in old implementation
    if (Platform.isAndroid || Platform.isIOS) {
      BottomSheets.showBottom(
        context: context,
        ref: ref,
        transactionId: transaction.id,
        onCharge: (transactionId, total) async {
          await _handleCompleteTransaction(transaction);
          Navigator.of(context).pop();
        },
        doneDelete: () {
          ref.refresh(transactionItemsStreamProvider(
              branchId: ProxyService.box.branchIdString()!,
              transactionId: transaction.id));
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> _handleCompleteTransaction(ITransaction transaction) async {
    // This should call the same complete transaction logic as the old implementation
    // For now, we'll trigger the cart preview to show the payment flow
    ref.read(oldImplementationOfRiverpod.previewingCart.notifier).state = true;
  }

  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SearchField(
        controller: searchController,
        showAddButton: true,
        showDatePicker: false,
        showIncomingButton: false,
        showOrderButton: true,
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
                  outerVariantsProvider(ProxyService.box.getBranchId() ?? 0)),
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
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
