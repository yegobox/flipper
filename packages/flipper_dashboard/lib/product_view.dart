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
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  ViewMode _selectedStatus = ViewMode.products;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreVariants();
    }
  }

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
        _loadInitialProducts();
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return _buildContent(context, model);
      },
    );
  }

  void _loadInitialProducts() {
    ref
        .read(productsProvider(ProxyService.box.getBranchId() ?? 0).notifier)
        .loadProducts(
            searchString: ref.read(searchStringProvider),
            scanMode: ref.read(scanningModeProvider));
  }

  Widget _buildContent(BuildContext context, ProductViewModel model) {
    final buttonIndex = ref.watch(buttonIndexProvider);

    if (buttonIndex == 1) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: TransactionList(showDetailedReport: true),
      );
    }

    return _buildVariantList(context, model);
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        return _buildVariantListContent(ref, model);
      },
    );
  }

  Widget _buildVariantListContent(WidgetRef ref, ProductViewModel model) {
    return ref
        .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
        .when(
          data: (variants) {
            if (variants.isEmpty) {
              return const Text('No Products available.');
            }
            return _buildVariantsGrid(context, model, variants: variants);
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator()),
        );
  }

  Widget _buildVariantsGrid(BuildContext context, ProductViewModel model,
      {required List<Variant> variants}) {
    final showProductList = ref.watch(showProductsList);

    // Fetching the stock items
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];

    return Stack(
      children: [
        Column(
          children: [
            _buildSegmentedButton(context, ref),
            const SizedBox(
              height: 30,
            ),
            _buildMainContent(context, model, variants, showProductList,
                startDate, endDate, ref),
          ],
        )
      ],
    );
  }

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
        _handleViewModeChange(ref, newSelection.first);
      },
    );
  }

  void _handleViewModeChange(WidgetRef ref, ViewMode newSelection) {
    if (newSelection == ViewMode.products) {
      ref.read(showProductsList.notifier).state = true;
    } else {
      ref.read(showProductsList.notifier).state = false;
    }
  }

  Widget _buildMainContent(
      BuildContext context,
      ProductViewModel model,
      List<Variant> variants,
      bool showProductList,
      DateTime? startDate,
      DateTime? endDate,
      WidgetRef ref) {
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
      itemCount: variants.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= variants.length) {
          return const Center(
              child: SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()));
        }

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
