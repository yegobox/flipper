import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_dashboard/widgets/custom_segmented_button.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_services/proxy.dart';

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

class _CheckoutProductViewState extends ConsumerState<CheckoutProductView> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  String _selectedSegment = 'Items';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        // _handleWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new,
                  size: 16, color: colorScheme.primary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
          elevation: 1.0,
          shadowColor: Colors.black12,
          backgroundColor: Theme.of(context).colorScheme.surface,
          actions: [
            IconButton(
              icon: const Icon(FluentIcons.more_vertical_20_regular),
              onPressed: () {
                // Show more options menu
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomSegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'Items',
                    label: Text('Items'),
                    icon: Icon(FluentIcons.box_20_regular, size: 18),
                  ),
                  ButtonSegment<String>(
                    value: 'cart',
                    label: Text('Cart'),
                    enabled: false,
                    icon: Icon(FluentIcons.cart_20_regular, size: 18),
                  ),
                  ButtonSegment<String>(
                    value: 'Pay',
                    label: Text('Pay'),
                    enabled: false,
                    icon: Icon(FluentIcons.payment_20_regular, size: 18),
                  ),
                ],
                selected: {_selectedSegment},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedSegment = newSelection.first;
                  });
                },
                selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                unselectedBackgroundColor: Colors.transparent,
                selectedForegroundColor:
                    Theme.of(context).colorScheme.onPrimary,
                unselectedForegroundColor:
                    Theme.of(context).colorScheme.onSurface,
                borderColor: Theme.of(context).colorScheme.primary,
                borderRadius: 8.0,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search field at the top
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SearchField(
                  controller: searchController,
                  showAddButton: true,
                  showDatePicker: false,
                  showIncomingButton: true,
                  showOrderButton: true,
                ),
              ),

              // ProductView takes remaining space
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    return ref
                        .watch(outerVariantsProvider(
                            ProxyService.box.getBranchId() ?? 0,
                            fetchRemote: true))
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
            Text('Loading Items...'),
          ],
        ),
      ),
    );
  }
}
