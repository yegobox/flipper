// ignore_for_file: unused_result

import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/TransactionList.dart';

enum ViewMode { products, stocks }

class ProductView extends StatefulHookConsumerWidget {
  final int? favIndex;
  final List<int> existingFavs;

  ProductView.normalMode({Key? key})
      : favIndex = null,
        existingFavs = [],
        super(key: key);

  ProductView.favoriteMode({
    Key? key,
    required this.favIndex,
    required this.existingFavs,
  }) : super(key: key);

  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends ConsumerState<ProductView> with Datamixer {
  // Search and scroll controllers
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Current view mode, defaults to products
  ViewMode _selectedStatus = ViewMode.products;

  @override
  void initState() {
    super.initState();
    // Listener for infinite scrolling on the grid
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more variants when the user has scrolled to end of grid/list.
      _loadMoreVariants();
    }
  }

  // Loads more variants, triggered when user scrolls to end of variants list.
  void _loadMoreVariants() {
    ref
        .read(
            outerVariantsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
        .loadVariants(
          scanMode: ref.read(scanningModeProvider),
          searchString: ref.read(searchStringProvider),
        );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
        // Load the initial products when the view model is ready.
        _loadInitialProducts();
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        // Build the main UI content.
        return _buildMainContent(context, model);
      },
    );
  }

  // Loads initial products when the view is loaded.
  void _loadInitialProducts() {
    ref
        .read(productsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
        .loadProducts(
          searchString: ref.read(searchStringProvider),
          scanMode: ref.read(scanningModeProvider),
        );
  }

  Widget _buildMainContent(BuildContext context, ProductViewModel model) {
    // Check if the transaction tab is selected
    final buttonIndex = ref.watch(buttonIndexProvider);
    if (buttonIndex == 1) {
      // Show the transaction list if the correct button is selected.
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: TransactionList(showDetailedReport: true),
      );
    }
    // Otherwise build the product/stock list.
    return _buildVariantList(context, model);
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    // use a consumer to rebuild when the state changes.
    return Consumer(
      builder: (context, ref, _) {
        // Consume the variant data from the provider and load data.
        return ref
            .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
            .when(
              data: (variants) {
                if (variants.isEmpty) {
                  // Show message when no product/stock data is available.
                  return const Text('No Products available.');
                }
                // If there is data display it in a grid or stock view.
                return _buildVariantsGrid(context, model, variants: variants);
              },
              error: (_, __) => const SizedBox.shrink(),
              loading: () => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            );
      },
    );
  }

  Widget _buildVariantsGrid(BuildContext context, ProductViewModel model,
      {required List<Variant> variants}) {
    final showProductList = ref.watch(showProductsList);

    // Fetching the stock items, if any.
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];

    return Stack(
      children: [
        Column(
          children: [
            // Segmented button for choosing between products or stock.
            _buildSegmentedButton(context, ref),
            const SizedBox(
              height: 30,
            ),
            // Display the main content: either grid of products or the stock view.
            _buildMainContentSection(context, model, variants, showProductList,
                startDate, endDate, ref),
          ],
        )
      ],
    );
  }

  // Build the segmented button for selecting products or stocks view
  Widget _buildSegmentedButton(BuildContext context, WidgetRef ref) {
    return SegmentedButton<ViewMode>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.primary;
            }
            return Colors.white;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Theme.of(context).colorScheme.primary;
          },
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      segments: const <ButtonSegment<ViewMode>>[
        ButtonSegment<ViewMode>(
          value: ViewMode.products,
          label: Text('Products'),
          icon: Icon(Icons.inventory),
        ),
        ButtonSegment<ViewMode>(
          value: ViewMode.stocks,
          label: Text('Stock'),
          icon: Icon(Icons.check_circle_outline),
        ),
      ],
      selected: <ViewMode>{_selectedStatus},
      onSelectionChanged: (Set<ViewMode> newSelection) {
        setState(() {
          _selectedStatus = newSelection.first;
        });
        // Handle the view mode change (products or stock).
        _handleViewModeChange(ref, newSelection.first);
      },
    );
  }

  void _handleViewModeChange(WidgetRef ref, ViewMode newSelection) {
    // Change to products or stock view depending on the selection.
    ref.read(showProductsList.notifier).state =
        newSelection == ViewMode.products;
  }

  Widget _buildMainContentSection(
      BuildContext context,
      ProductViewModel model,
      List<Variant> variants,
      bool showProductList,
      DateTime? startDate,
      DateTime? endDate,
      WidgetRef ref) {
    // Render product grid if `showProductList` is true, otherwise the stock view.
    return showProductList
        ? _buildProductGrid(context, model, variants)
        : _buildStockView(context, model, variants, startDate, endDate, ref);
  }

  Widget _buildProductGrid(
      BuildContext context, ProductViewModel model, List<Variant> variants) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        return buildVariantRow(
          forceRemoteUrl: false,
          context: context,
          model: model,
          variant: variants[index],
          isOrdering: false,
        );
      },
      shrinkWrap: true,
    );
  }

  Widget _buildStockView(
      BuildContext context,
      ProductViewModel model,
      List<Variant> variants,
      DateTime? startDate,
      DateTime? endDate,
      WidgetRef ref) {
    return variants.isEmpty
        ? const Center(child: Text("No stock data available"))
        : SizedBox(
            height: 1200,
            child: DataView(
              onTapRowShowRefundModal: false,
              onTapRowShowRecountModal: true,
              showPluReport: false,
              startDate: startDate ?? DateTime.now(),
              endDate: endDate ?? DateTime.now(),
              variants: variants,
              rowsPerPage: ref.read(rowsPerPageProvider),

              /// for print to work we need to show detailed report
              showDetailedReport: true,
            ),
          );
  }
}
