import 'dart:async';
import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/product_sort_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_dashboard/widgets/variant_shimmer_placeholder.dart';
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
  // Pagination state
  int _currentPage = 0;
  Timer? _debounce;
  Timer? _branchSwitchTimer;
  int _lastCheckedBranchSwitchTimestamp = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialProducts();

    // Set up a timer to periodically check for branch switches (less frequent)
    _branchSwitchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
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

      // Instead of invalidating providers, just refresh the data
      try {
        // Use the provider's refresh method instead of invalidation
        ref.read(outerVariantsProvider(branchId).notifier).refresh();

        // Force reload initial products
        _loadInitialProducts();

        // Explicitly refresh the UI
        if (mounted) {
          setState(() {
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
      } catch (e) {
        print('Error refreshing providers: $e');
      }
    }
  }

  void _loadInitialProducts() {
    ref.read(
        outerVariantsProvider(ProxyService.box.getBranchId() ?? 0).notifier);
  }

  void _goToPage(int page) async {
    final branchId = ProxyService.box.getBranchId() ?? 0;
    final notifier = ref.read(outerVariantsProvider(branchId).notifier);
    setState(() {
      _currentPage = page;
    });
    // Ensure page data is loaded
    await notifier.fetchPage(page);
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
        Expanded(
          child: _buildVariantList(context, model),
        ),
      ],
    );
  }

  Widget _buildVariantList(BuildContext context, ProductViewModel model) {
    return Consumer(
      builder: (context, ref, _) {
        final branchId = ProxyService.box.getBranchId() ?? 0;
        // If the search string changed, reset our local page to the first page
        // so that search results always start from page 0.
        final currentSearch = ref.watch(searchStringProvider);
        if (currentSearch.isNotEmpty && _currentPage != 0) {
          // Use setState to trigger UI update
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentPage = 0);
          });
        }

        return ref.watch(outerVariantsProvider(branchId)).when(
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
              loading: () => Column(
                children: List.generate(
                  5,
                  (index) => const VariantShimmerPlaceholder(),
                ),
              ),
            );
      },
    );
  }

  Widget _buildVariantsGrid(BuildContext context, ProductViewModel model,
      {required List<Variant> variants}) {
    // Debug display will be shown below after we obtain pagination helpers
    final showProductList = ref.watch(showProductsList);

    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    // Pagination helpers from provider
    final branchId = ProxyService.box.getBranchId() ?? 0;
    final notifier = ref.read(outerVariantsProvider(branchId).notifier);
    final ipp = notifier.itemsPerPage;

    // Use the provided (already filtered) variants for display and counts.
    final loadedCount = variants.length;
    final estimatedTotalPages = notifier.estimatedTotalPages();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox.shrink(),
        const SizedBox(height: 16),
        // Top summary row similar to attached screenshot
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Showing X–Y of Z results
              Builder(builder: (context) {
                final start = loadedCount == 0 ? 0 : (_currentPage * ipp) + 1;
                final total = notifier.totalCount ?? loadedCount;
                final end = ((_currentPage + 1) * ipp) > total
                    ? total
                    : ((_currentPage + 1) * ipp);
                final totalText = total.toString();
                return Text(
                  'Showing $start–$end of $totalText results',
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }),
              // Sorting dropdown
              _buildSortingDropdown(context),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Flexible container that takes up remaining space
        Expanded(
          // Only apply sorting when not searching to avoid interfering with auto-add
          child: _buildMainContentSection(
              context,
              model,
              _shouldApplySorting(ref)
                  ? _sortVariants(variants, ref)
                  : variants,
              showProductList,
              startDate,
              endDate,
              ref),
        ),

        // Bottom pagination controls
        if (estimatedTotalPages > 0)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Previous button
                IconButton(
                  icon: const Icon(FluentIcons.chevron_left_20_regular),
                  onPressed: _currentPage > 0
                      ? () => _goToPage(_currentPage - 1)
                      : null,
                ),
                // Page numbers (show up to 5 pages centered around current)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        estimatedTotalPages,
                        (index) {
                          // limit displayed page buttons to reasonable number
                          if (estimatedTotalPages > 10) {
                            final low = (_currentPage - 2)
                                .clamp(0, estimatedTotalPages - 1);
                            final high = (_currentPage + 2)
                                .clamp(0, estimatedTotalPages - 1);
                            if (index < low || index > high) {
                              // show ellipsis instead of the button
                              return const SizedBox.shrink();
                            }
                          }
                          final page = index;
                          final isCurrent = page == _currentPage;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: InkWell(
                              onTap: () => _goToPage(page),
                              child: Container(
                                width: 40,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                child: Text(
                                  '${page + 1}',
                                  style: TextStyle(
                                      color: isCurrent
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ),
                            ),
                          );
                        },
                      ).where((w) => w != const SizedBox.shrink()).toList(),
                    ),
                  ),
                ),
                // Next button
                IconButton(
                  icon: const Icon(FluentIcons.chevron_right_20_regular),
                  onPressed: _currentPage < (estimatedTotalPages - 1)
                      ? () => _goToPage(_currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
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
        // Add itemExtent for better performance with uniform item heights
        // itemExtent: 120.0, // Adjust based on your actual item height
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
        // Add cacheExtent for smoother scrolling
        cacheExtent: 500.0,
      );
    } else {
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 2.0,
          // Add childAspectRatio for consistent item sizing
          childAspectRatio: 1.0,
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
        // Add cacheExtent for smoother scrolling
        cacheExtent: 1000.0,
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

  Widget _buildSortingDropdown(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final currentSort = ref.watch(productSortProvider);
        return PopupMenuButton<ProductSortOption>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentSort.label),
                const SizedBox(width: 8),
                Icon(FluentIcons.chevron_down_20_regular,
                    size: 16, color: Theme.of(context).colorScheme.onSurface)
              ],
            ),
          ),
          onSelected: (ProductSortOption option) {
            ref.read(productSortProvider.notifier).state = option;
          },
          itemBuilder: (BuildContext context) {
            return ProductSortOption.values.map((ProductSortOption option) {
              return PopupMenuItem<ProductSortOption>(
                value: option,
                child: Row(
                  children: [
                    if (option == currentSort)
                      Icon(FluentIcons.checkmark_20_filled,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Text(option.label),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  bool _shouldApplySorting(WidgetRef ref) {
    final currentSearch = ref.watch(searchStringProvider);
    // Don't apply sorting when actively searching to preserve auto-add functionality
    return currentSearch.isEmpty;
  }

  List<Variant> _sortVariants(List<Variant> variants, WidgetRef ref) {
    final sortOption = ref.watch(productSortProvider);

    // Return original list if no sorting needed
    if (sortOption == ProductSortOption.latest) {
      return variants;
    }

    // Create a copy only when sorting is needed
    final sortedVariants = List<Variant>.from(variants);

    switch (sortOption) {
      case ProductSortOption.defaultSorting:
        return variants; // Already handled above
      case ProductSortOption.popularity:
        sortedVariants.sort((a, b) => (b.qty ?? 0).compareTo(a.qty ?? 0));
        break;
      case ProductSortOption.averageRating:
        // Assuming rating is stored in a field, adjust as needed
        sortedVariants.sort(
            (a, b) => 0); // Placeholder - implement based on your rating field
        break;
      case ProductSortOption.latest:
        sortedVariants.sort((a, b) => (b.lastTouched ?? DateTime(0))
            .compareTo(a.lastTouched ?? DateTime(0)));
        break;
      case ProductSortOption.priceLowToHigh:
        sortedVariants
            .sort((a, b) => (a.retailPrice ?? 0).compareTo(b.retailPrice ?? 0));
        break;
      case ProductSortOption.priceHighToLow:
        sortedVariants
            .sort((a, b) => (b.retailPrice ?? 0).compareTo(a.retailPrice ?? 0));
        break;
      case ProductSortOption.eventDateOldToNew:
        sortedVariants.sort((a, b) => (a.lastTouched ?? DateTime(0))
            .compareTo(b.lastTouched ?? DateTime(0)));
        break;
      case ProductSortOption.eventDateNewToOld:
        sortedVariants.sort((a, b) => (b.lastTouched ?? DateTime(0))
            .compareTo(a.lastTouched ?? DateTime(0)));
        break;
    }

    return sortedVariants;
  }
}
