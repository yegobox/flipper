import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
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
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (didPop) return;
        // _handleWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Checkout'),
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Theme.of(context).canvasColor,
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
                              return _buildEmptyProductsView(context);
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

  Widget _buildEmptyProductsView(BuildContext context) {
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
              'Products not available',
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
              'Error loading products',
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
            Text('Loading products...'),
          ],
        ),
      ),
    );
  }
}
