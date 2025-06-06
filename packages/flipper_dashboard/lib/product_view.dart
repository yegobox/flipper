import 'dart:async';
import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/widgets/custom_segmented_button.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  Timer? _branchSwitchTimer;
  int _lastCheckedBranchSwitchTimestamp = 0;

  ViewMode _selectedStatus = ViewMode.products;
  //TODO: when is agent get this value to handle all cases where you might not be eligible to see stock.
  bool _isStockButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialProducts();

    // Set up a timer to periodically check for branch switches
    _branchSwitchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkForBranchSwitch();
    });
  }

  void _scrollListener() {
    // Debounce scroll to avoid rapid DB queries
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _loadMoreVariants();
      });
    }
  }

  void _loadMoreVariants() {
    ref.read(
        outerVariantsProvider(ProxyService.box.getBranchId() ?? 0).notifier);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _branchSwitchTimer?.cancel();
    super.dispose();
  }

  void _checkForBranchSwitch() {
    // Check if the branch_switched flag is set
    final branchSwitched =
        ProxyService.box.readBool(key: 'branch_switched') ?? false;
    final lastSwitchTimestamp =
        ProxyService.box.readInt(key: 'last_branch_switch_timestamp') ?? 0;
    final activeBranchId =
        ProxyService.box.readInt(key: 'active_branch_id') ?? 0;

    // Only refresh if the branch was switched and we haven't processed this switch yet
    if (branchSwitched &&
        lastSwitchTimestamp > _lastCheckedBranchSwitchTimestamp) {
      _lastCheckedBranchSwitchTimestamp = lastSwitchTimestamp;

      // Reset the flag
      ProxyService.box.writeBool(key: 'branch_switched', value: false);

      // Refresh the variants for the new branch
      _refreshVariantsForCurrentBranch(activeBranchId);
    }
  }

  void _refreshVariantsForCurrentBranch([int? specificBranchId]) {
    final branchId = specificBranchId ?? ProxyService.box.getBranchId() ?? 0;
    if (branchId > 0) {
      print('Refreshing variants for branch ID: $branchId');

      // Force clear the provider cache for this branch
      try {
        // Invalidate and refresh the variant providers
        ref.invalidate(outerVariantsProvider(branchId));
        ref.invalidate(productsProvider(branchId));

        // Use the searchStringProvider to trigger a refresh
        // First emit "search" to trigger the refresh
        ref.read(searchStringProvider.notifier).emitString(value: "search");
        // Then clear it to reset the search state
        ref.read(searchStringProvider.notifier).emitString(value: "");

        // Force reload initial products with a small delay to ensure state is updated
        Future.delayed(const Duration(milliseconds: 100), () {
          _loadInitialProducts();

          // Explicitly refresh the UI
          if (mounted) {
            setState(() {
              // Trigger a rebuild with the new branch data
              print('Rebuilding ProductView with new branch data');
              // Show a snackbar to notify the user
              if (context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                showCustomSnackBarUtil(
                  context,
                  'Products refreshed for new branch',
                  duration: const Duration(seconds: 2),
                );
              }
            });
          }
        });
      } catch (e) {
        print('Error refreshing providers: $e');
      }
    }
  }

  void _loadInitialProducts() {
    ref.read(productsProvider(ProxyService.box.getBranchId() ?? 0).notifier);
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

  Widget _buildMainContent(BuildContext context, ProductViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Add padding around the segmented button for better visual appearance
        if (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildSegmentedButton(context, ref),
          ),
        // Expanded to make the variant list fill the remaining space
        Expanded(
          child: _buildVariantList(context, model),
        ),
      ],
    );
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _buildVariantsGrid(context, model, variants: variants);
              },
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 180),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => ref.refresh(outerVariantsProvider(
                            ProxyService.box.getBranchId() ?? 0)),
                        icon: const Icon(FluentIcons.arrow_sync_20_filled),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(
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
              ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        // Flexible container that takes up remaining space
        Expanded(
          child: _buildMainContentSection(context, model, variants,
              showProductList, startDate, endDate, ref),
        ),
      ],
    );
  }

  Widget _buildSegmentedButton(BuildContext context, WidgetRef ref) {
    return CustomSegmentedButton<ViewMode>(
      segments: <ButtonSegment<ViewMode>>[
        ButtonSegment<ViewMode>(
          value: ViewMode.products,
          label: Text('Products'),
          icon: Icon(Icons.inventory),
        ),
        ButtonSegment<ViewMode>(
          value: ViewMode.stocks,
          label: Text('Stock'),
          icon: Icon(Icons.check_circle_outline),
          enabled:
              _isStockButtonEnabled, // Conditionally enable/disable the stock segment
        ),
      ],
      selected: <ViewMode>{_selectedStatus},
      onSelectionChanged: (Set<ViewMode> newSelection) {
        if (newSelection.first == ViewMode.stocks && !_isStockButtonEnabled) {
          return; // Do nothing if the stock segment is disabled
        }
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
    // Check if the current platform is mobile
    final bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    // Use ListView for mobile platforms and GridView for desktop platforms
    if (isMobile) {
      return ListView.builder(
        controller: _scrollController,
        itemCount: variants.length,
        itemBuilder: (context, index) {
          return buildVariantRow(
            forceRemoteUrl: false,
            context: context,
            model: model,
            variant: variants[index],
            isOrdering: false,
            forceListView: true,
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
      );
    } else {
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
            forceListView: false, // Explicitly set to false for desktop
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
      );
    }
  }

  Widget _buildStockView(
      BuildContext context,
      ProductViewModel model,
      List<Variant> variants,
      DateTime? startDate,
      DateTime? endDate,
      WidgetRef ref) {
    final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();
    return variants.isEmpty
        ? const Center(child: Text("No stock data available"))
        : DataView(
            workBookKey: workBookKey,
            onTapRowShowRefundModal: false,
            onTapRowShowRecountModal: true,
            showDetailed: false,
            startDate: startDate ?? DateTime.now().toUtc(),
            endDate: endDate ?? DateTime.now().toUtc(),
            variants: variants,
            rowsPerPage: ref.read(rowsPerPageProvider),
            showDetailedReport: true,
          );
  }
}
