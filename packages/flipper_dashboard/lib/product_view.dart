import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

enum ViewMode { products, stocks }

class ProductView extends StatefulHookConsumerWidget {
  final String? favIndex;
  final List<String> existingFavs;

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
    ref.read(
        outerVariantsProvider(ProxyService.box.getBranchId() ?? 0).notifier);
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
        return _buildMainContent(context, model);
      },
    );
  }

  void _loadInitialProducts() {
    ref.read(productsProvider(ProxyService.box.getBranchId() ?? 0).notifier);
  }

  Widget _buildMainContent(BuildContext context, ProductViewModel model) {
    return _buildVariantList(context, model);
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        return ref
            .watch(outerVariantsProvider(ProxyService.box.getBranchId() ?? 0))
            .when(
              data: (variants) {
                if (variants.isEmpty) {
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
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ));
                }

                return _buildVariantsGrid(context, model, variants: variants);
              },
              error: (_, __) => const SizedBox.shrink(),
              loading: () => Center(child: const Text('Loading')),
            );
      },
    );
  }

  Widget _buildVariantsGrid(BuildContext context, ProductViewModel model,
      {required List<Variant> variants}) {
    final showProductList = ref.watch(showProductsList);

    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    return Stack(
      children: [
        Column(
          children: [
            _buildSegmentedButton(context, ref),
            const SizedBox(
              height: 30,
            ),
            _buildMainContentSection(context, model, variants, showProductList,
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
              showDetailedReport: true,
            ),
          );
  }
}
