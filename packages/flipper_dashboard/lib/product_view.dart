import 'dart:async';
import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/product_sort_labels.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/product_sort_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_dashboard/widgets/variant_shimmer_placeholder.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_catalog_search_row.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';

enum ViewMode { products, stocks }

class ProductView extends StatefulHookConsumerWidget {
  final String? favIndex;
  final List<String> existingFavs;
  final TextEditingController? linkedSearchController;
  final bool suppressMobilePagination;

  ProductView.normalMode({
    Key? key,
    this.linkedSearchController,
    this.suppressMobilePagination = false,
  }) : favIndex = null,
       existingFavs = [],
       super(key: key);

  ProductView.favoriteMode({
    Key? key,
    required this.favIndex,
    required this.existingFavs,
  }) : linkedSearchController = null,
       suppressMobilePagination = false,
       super(key: key);

  @override
  ProductViewState createState() => ProductViewState();
}

class ProductViewState extends ConsumerState<ProductView> with Datamixer {
  final ScrollController _scrollController = ScrollController();
  // Pagination state
  int _currentPage = 0;

  /// True only while a page the cache does not hold is being fetched; cached
  /// pages switch synchronously and never raise this.
  bool _isPageLoading = false;

  /// Identifies the newest page tap so a slow earlier fetch cannot resurrect
  /// its spinner (or its prefetch) after the user has moved on.
  int _pageNavToken = 0;

  /// Page whose neighbours have already been warmed.
  int? _prefetchedAround;

  /// Whether the previous provider emission came from the page bar; leaving
  /// page-bar mode is not an eviction and must not move the scroll offset.
  bool _wasPagedMode = false;
  Timer? _debounce;
  Timer? _branchSwitchTimer;
  int _lastCheckedBranchSwitchTimestamp = 0;

  /// Track OuterVariants front-evictions to keep scroll position stable.
  ProviderSubscription<AsyncValue<List<Variant>>>? _outerVariantsSub;
  String? _listenedBranchId;
  int? _lastFirstCachedPage;

  /// Last-known layout metrics used for scroll compensation.
  bool? _lastIsMobileLayout;
  double? _lastPaneWidth;
  int? _lastGridCrossAxisCount;
  double? _lastGridMainAxisSpacing;
  double? _lastGridChildAspectRatio;

  static const double _estimatedMobileListItemExtent =
      132.0; // card + separator

  void _ensureOuterVariantsEvictionListener(String branchId) {
    if (branchId.isEmpty) return;
    if (_listenedBranchId == branchId && _outerVariantsSub != null) return;

    _outerVariantsSub?.close();
    _listenedBranchId = branchId;
    _lastFirstCachedPage = null;

    _outerVariantsSub = ref.listenManual<AsyncValue<List<Variant>>>(
      outerVariantsProvider(branchId),
      (prev, next) {
        final notifier = ref.read(outerVariantsProvider(branchId).notifier);

        // Page-bar mode renders one page at a time and starts it at the top,
        // so cache evictions there must not nudge the scroll offset.
        final viewPage = notifier.viewPage;
        if (viewPage == null && _wasPagedMode) {
          _wasPagedMode = false;
          _lastFirstCachedPage = notifier.firstCachedPage;
          return;
        }
        if (viewPage != null) {
          _wasPagedMode = true;
          _lastFirstCachedPage = notifier.firstCachedPage;
          if (viewPage != _currentPage && mounted) {
            // The provider moved the view itself (e.g. new products landed on
            // page 0); keep the page bar honest.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && notifier.viewPage == viewPage) {
                setState(() => _currentPage = viewPage);
              }
            });
          }
          return;
        }

        final first = notifier.firstCachedPage;
        final lastSeen = _lastFirstCachedPage;
        _lastFirstCachedPage = first;

        if (lastSeen == null) return;
        if (first <= lastSeen) return;

        if (!_scrollController.hasClients) return;
        final currentOffset = _scrollController.offset;
        if (currentOffset <= 0) return;

        final deltaPages = first - lastSeen;
        final removedItems = deltaPages * notifier.itemsPerPage;

        final isMobile = _lastIsMobileLayout;
        final paneWidth = _lastPaneWidth;
        final crossAxisCount = _lastGridCrossAxisCount;
        final mainAxisSpacing = _lastGridMainAxisSpacing;
        final childAspectRatio = _lastGridChildAspectRatio;

        double? removedPx;
        if (isMobile == true) {
          removedPx = removedItems * _estimatedMobileListItemExtent;
        } else if (paneWidth != null &&
            crossAxisCount != null &&
            crossAxisCount > 0 &&
            mainAxisSpacing != null &&
            childAspectRatio != null &&
            childAspectRatio > 0) {
          // Grid layout has predictable row height: tileWidth/aspectRatio.
          final tileWidth =
              (paneWidth - (mainAxisSpacing * (crossAxisCount - 1))) /
              crossAxisCount;
          final tileHeight = tileWidth / childAspectRatio;
          final removedRows = (removedItems / crossAxisCount).ceil();
          removedPx = removedRows * (tileHeight + mainAxisSpacing);
        }

        if (removedPx == null || removedPx <= 0) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_scrollController.hasClients) return;
          final newOffset = (currentOffset - removedPx!).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          );
          _scrollController.jumpTo(newOffset);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

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
    ref
        .read(
          outerVariantsProvider(ProxyService.box.getBranchId() ?? "").notifier,
        )
        .loadMore();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _branchSwitchTimer?.cancel();
    _outerVariantsSub?.close();
    super.dispose();
  }

  void _checkForBranchSwitch() {
    // Check if the branch_switched flag is set
    final branchSwitched =
        ProxyService.box.readBool(key: 'branch_switched') ?? false;
    final lastSwitchTimestamp =
        ProxyService.box.readInt(key: 'last_branch_switch_timestamp') ?? 0;
    final activeBranchId =
        ProxyService.box.readString(key: 'active_branch_id') ?? "";

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

  void _refreshVariantsForCurrentBranch([String? specificBranchId]) {
    final branchId = specificBranchId ?? ProxyService.box.getBranchId() ?? "";

    // Instead of invalidating providers, just refresh the data
    try {
      // Use the provider's refresh method instead of invalidation
      ref.invalidate(outerVariantsProvider(branchId));

      // Explicitly refresh the UI
      if (mounted) {
        setState(() {
          print('Rebuilding ProductView with new branch data');
          // Show a snackbar to notify the user
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            showCustomSnackBarUtil(
              context,
              context.flipperL10n.productsRefreshedForNewBranch,
              duration: const Duration(seconds: 2),
            );
          }
        });
      }
    } catch (e) {
      print('Error refreshing providers: $e');
    }
  }

  void _goToPage(int page) async {
    if (page == _currentPage && !_isPageLoading) return;
    final branchId = ProxyService.box.getBranchId() ?? "";
    final notifier = ref.read(outerVariantsProvider(branchId).notifier);
    final token = ++_pageNavToken;

    // Cached pages swap in on this frame — only a cold page shows progress.
    final isCached = notifier.hasPageCached(page);
    setState(() {
      _currentPage = page;
      _isPageLoading = !isCached;
    });
    _jumpListToTop();

    await notifier.fetchPage(page);
    if (!mounted || token != _pageNavToken) return;
    if (_isPageLoading) setState(() => _isPageLoading = false);
    _jumpListToTop();
    _prefetchNeighbours(notifier, page);
  }

  void _jumpListToTop() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset == 0) return;
    _scrollController.jumpTo(0);
  }

  /// Warms the pages on either side so the common next/previous tap is instant.
  void _prefetchNeighbours(OuterVariants notifier, int page) {
    if (_prefetchedAround == page) return;
    _prefetchedAround = page;
    unawaited(notifier.prefetchPage(page + 1));
    if (page > 0) unawaited(notifier.prefetchPage(page - 1));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return _buildMainContent(context, model);
      },
    );
  }

  Widget _buildMainContent(BuildContext context, ProductViewModel model) {
    final selectedIds = ref.watch(selectedItemIdsProvider);
    final isSelectionMode = selectedIds.isNotEmpty;
    final progress = ref.watch(bulkDeleteProgressProvider);
    final showProductList = ref.watch(showProductsList);

    return LayoutBuilder(
      builder: (context, constraints) {
        final paneWidth = constraints.maxWidth;
        final isMobileLayout =
            paneWidth < PosLayoutBreakpoints.mobileLayoutMaxWidth;

        final linked = widget.linkedSearchController;
        final showLinkedSearch = linked != null && showProductList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (progress > 0)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 2,
              ),
            if (isSelectionMode)
              _buildBulkSelectionBar(context, model, selectedIds),
            if (showLinkedSearch) ...[
              SizedBox(height: isMobileLayout ? 8 : 20),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobileLayout ? 16 : 22,
                  0,
                  isMobileLayout ? 16 : 22,
                  10,
                ),
                child: isMobileLayout
                    ? SearchFieldWidget(
                        controller: linked,
                        hintText: context.flipperL10n.searchProducts,
                        densePadding: true,
                        showNoticesButton: false,
                        showOrderButton: false,
                        showIncomingButton: false,
                      )
                    : PosCatalogSearchRow(
                        controller: linked,
                        hintText: context.flipperL10n.searchProducts,
                      ),
              ),
            ],
            Expanded(
              child: _buildVariantList(context, model, paneWidth: paneWidth),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulkSelectionBar(
    BuildContext context,
    ProductViewModel model,
    Set<String> selectedIds,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colorScheme.primaryContainer,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(selectedItemIdsProvider.notifier).clearSelection();
            },
            tooltip: context.flipperL10n.clearSelection,
          ),
          const SizedBox(width: 8),
          Text(
            context.flipperL10n.itemsSelected(selectedIds.length),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: Text(context.flipperL10n.delete),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () =>
                _showBulkDeleteConfirmation(context, model, selectedIds),
          ),
        ],
      ),
    );
  }

  Future<void> _showBulkDeleteConfirmation(
    BuildContext context,
    ProductViewModel model,
    Set<String> selectedIds,
  ) async {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();
    final isEbmEnabled =
        businessId != null &&
        branchId != null &&
        await ProxyService.strategy.isTaxEnabled(
          businessId: businessId,
          branchId: branchId,
        );

    if (isEbmEnabled && !kDebugMode) {
      for (final id in selectedIds) {
        final variant = await ProxyService.getStrategy(
          Strategy.capella,
        ).getVariant(id: id);
        if (variant != null && (variant.stock?.currentStock ?? 0) > 0) {
          final dialogService = locator<DialogService>();
          dialogService.showCustomDialog(
            variant: DialogType.info,
            title: context.flipperL10n.error,
            description: context.flipperL10n.cannotDeleteVariantWithStockRemaining,
            data: {'status': InfoDialogStatus.error},
          );
          return;
        }
      }
    }

    // Admin PIN Verification
    final settingsService = locator<SettingsService>();
    if (settingsService.isAdminPinEnabled) {
      final setting = await settingsService.settings();
      final confirmed = await showAdminPinDialog(
        context: context,
        mode: AdminPinMode.verify,
        expectedPin: setting?.adminPin,
      );
      if (confirmed != true) return;
    }

    final dialogService = locator<DialogService>();
    final response = await dialogService.showCustomDialog(
      variant: DialogType.info,
      title: context.flipperL10n.deleteMultipleItems,
      description: context.flipperL10n.deleteItemsConfirmation(selectedIds.length),
      data: {
        'status': InfoDialogStatus.warning,
        'mainButtonText': context.flipperL10n.delete,
      },
    );

    if (response?.confirmed == true) {
      final branchId = ProxyService.box.getBranchId() ?? "";
      final notifier = ref.read(outerVariantsProvider(branchId).notifier);

      // Reset and show progress
      ref.read(bulkDeleteProgressProvider.notifier).state = 0.01;

      await model.bulkDelete(
        ids: selectedIds,
        type: 'variant',
        onProgress: (p) {
          ref.read(bulkDeleteProgressProvider.notifier).state = p;
        },
      );

      // Manual optimization: remove items from state for immediate UI feedback
      for (final id in selectedIds) {
        notifier.removeVariantById(id);
      }

      ref.read(selectedItemIdsProvider.notifier).clearSelection();
      // Reset progress
      ref.read(bulkDeleteProgressProvider.notifier).state = 0.0;

      if (context.mounted) {
        showCustomSnackBarUtil(
          context,
          context.flipperL10n.deletedItemsCount(selectedIds.length),
        );
      }
    }
  }

  Widget _buildVariantList(
    BuildContext context,
    ProductViewModel model, {
    required double paneWidth,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        final branchId = ProxyService.box.getBranchId() ?? "";
        _ensureOuterVariantsEvictionListener(branchId);
        // If the search string changed, reset our local page to the first page
        // so that search results always start from page 0.
        final currentSearch = ref.watch(searchStringProvider);
        if (currentSearch.isNotEmpty && _currentPage != 0) {
          // Use setState to trigger UI update
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _pageNavToken++;
            _prefetchedAround = null;
            setState(() {
              _currentPage = 0;
              _isPageLoading = false;
            });
          });
        }

        return ref
            .watch(outerVariantsProvider(branchId))
            .when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              data: (variants) {
                if (variants.isEmpty) {
                  final hasBranch = branchId.isNotEmpty;
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
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
                            hasBranch
                                ? context.flipperL10n.noProductsYet
                                : context.flipperL10n.noBranchSelected,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          if (hasBranch) ...[
                            const SizedBox(height: 8),
                            Text(
                              context.flipperL10n.productsSyncingHint,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () => ref.invalidate(
                                outerVariantsProvider(branchId),
                              ),
                              icon: const Icon(
                                FluentIcons.arrow_sync_20_filled,
                              ),
                              label: Text(
                                context.flipperL10n.refreshProducts,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }
                return _buildVariantsGrid(
                  context,
                  model,
                  variants: variants,
                  paneWidth: paneWidth,
                );
              },
              error: (error, stackTrace) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
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
                        context.flipperL10n.errorLoadingProducts,
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
                          outerVariantsProvider(
                            ProxyService.box.getBranchId() ?? "",
                          ),
                        ),
                        icon: const Icon(FluentIcons.arrow_sync_20_filled),
                        label: Text(context.flipperL10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () {
                final hasBranch = branchId.isNotEmpty;
                final notifier = ref.read(outerVariantsProvider(branchId).notifier);
                final knownTotal = notifier.totalCount;

                // If there's no branch selected, show the empty/placeholder UI
                if (!hasBranch) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
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
                            context.flipperL10n.noBranchSelected,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // If we already know there are zero products for this branch,
                // show the empty-state immediately instead of shimmer.
                if (knownTotal != null && knownTotal == 0) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
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
                            context.flipperL10n.noProductsYet,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.flipperL10n.productsSyncingHint,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => ref.invalidate(
                              outerVariantsProvider(branchId),
                            ),
                            icon: const Icon(
                              FluentIcons.arrow_sync_20_filled,
                            ),
                            label: Text(
                              context.flipperL10n.refreshProducts,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Fallback: show a smaller shimmer set while loading
                return Column(
                  children: List.generate(
                    3,
                    (index) => const VariantShimmerPlaceholder(),
                  ),
                );
              },
            );
      },
    );
  }

  Widget _buildVariantsGrid(
    BuildContext context,
    ProductViewModel model, {
    required List<Variant> variants,
    required double paneWidth,
  }) {
    final showProductList = ref.watch(showProductsList);

    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    final branchId = ProxyService.box.getBranchId() ?? "";
    final notifier = ref.read(outerVariantsProvider(branchId).notifier);
    final ipp = notifier.itemsPerPage;

    final loadedCount = variants.length;
    final estimatedTotalPages = notifier.estimatedTotalPages();

    // Warm the neighbours of the first page too, so the first "next" tap is as
    // instant as the ones after it.
    if (_prefetchedAround == null && estimatedTotalPages > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _prefetchNeighbours(notifier, _currentPage);
      });
    }

    final isMobileLayout =
        paneWidth < PosLayoutBreakpoints.mobileLayoutMaxWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            isMobileLayout ? 16 : 22,
            isMobileLayout ? 12 : 16,
            isMobileLayout ? 16 : 22,
            isMobileLayout ? 10 : 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final total = notifier.totalCount ?? loadedCount;
                    final totalText = total.toString();
                    if (isMobileLayout) {
                      return Text(
                        context.flipperL10n.loadedOfProducts(
                          loadedCount.toString(),
                          totalText,
                        ),
                        style: const TextStyle(
                          color: PosTokens.ink3,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    final start = loadedCount == 0
                        ? 0
                        : (_currentPage * ipp) + 1;
                    final end = ((_currentPage + 1) * ipp) > total
                        ? total
                        : ((_currentPage + 1) * ipp);
                    return Text(
                      context.flipperL10n.showingRangeOfResults(
                        start.toString(),
                        end.toString(),
                        totalText,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              _buildSortingDropdown(context, compact: isMobileLayout),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: showProductList && !isMobileLayout
                    ? ColoredBox(
                        color: PosTokens.posBg,
                        child: _buildMainContentSection(
                          context,
                          model,
                          _shouldApplySorting(ref)
                              ? _sortVariants(variants, ref)
                              : variants,
                          showProductList,
                          startDate,
                          endDate,
                          ref,
                          paneWidth: paneWidth,
                        ),
                      )
                    : _buildMainContentSection(
                        context,
                        model,
                        _shouldApplySorting(ref)
                            ? _sortVariants(variants, ref)
                            : variants,
                        showProductList,
                        startDate,
                        endDate,
                        ref,
                        paneWidth: paneWidth,
                      ),
              ),
              // A cold page keeps the grid in place under a light veil rather
              // than emptying the pane, so switching pages never flashes.
              if (_isPageLoading)
                Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: PosTokens.posBg.withValues(alpha: 0.55),
                      child: const Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (estimatedTotalPages > 0 &&
            !(isMobileLayout && widget.suppressMobilePagination))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _paginationSideButton(
                        context: context,
                        icon: FluentIcons.chevron_left_20_regular,
                        onPressed: _currentPage > 0
                            ? () => _goToPage(_currentPage - 1)
                            : null,
                        usePosStyle: isMobileLayout,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                List.generate(estimatedTotalPages, (index) {
                                      if (estimatedTotalPages > 10) {
                                        final low = (_currentPage - 2).clamp(
                                          0,
                                          estimatedTotalPages - 1,
                                        );
                                        final high = (_currentPage + 2).clamp(
                                          0,
                                          estimatedTotalPages - 1,
                                        );
                                        if (index < low || index > high) {
                                          return const SizedBox.shrink();
                                        }
                                      }
                                      final page = index;
                                      final isCurrent = page == _currentPage;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Material(
                                          color: isMobileLayout
                                              ? (isCurrent
                                                    ? const Color(0xFFE8E8ED)
                                                    : Colors.white)
                                              : (isCurrent
                                                    ? PosTokens.blue
                                                    : PosTokens.surface),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            onTap: () => _goToPage(page),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: isMobileLayout
                                                      ? const Color(0xFFD1D1D6)
                                                      : (isCurrent
                                                            ? PosTokens.blue
                                                            : PosTokens.line),
                                                ),
                                              ),
                                              child: Text(
                                                '${page + 1}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: isMobileLayout
                                                      ? (isCurrent
                                                            ? Colors.black87
                                                            : const Color(
                                                                0xFF3C3C43,
                                                              ))
                                                      : (isCurrent
                                                            ? Colors.white
                                                            : PosTokens.ink2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                    .where((w) => w != const SizedBox.shrink())
                                    .toList(),
                          ),
                        ),
                      ),
                      _paginationSideButton(
                        context: context,
                        icon: FluentIcons.chevron_right_20_regular,
                        onPressed: _currentPage < (estimatedTotalPages - 1)
                            ? () => _goToPage(_currentPage + 1)
                            : null,
                        usePosStyle: isMobileLayout,
                      ),
                    ],
                  ),
                ),
                if (!isMobileLayout)
                  Text(
                    context.flipperL10n.pageOfPages(
                      (_currentPage + 1).toString(),
                      estimatedTotalPages.toString(),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
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
    WidgetRef ref, {
    required double paneWidth,
  }) {
    return showProductList
        ? _buildProductGrid(context, model, variants, paneWidth: paneWidth)
        : _buildStockView(context, model, variants, startDate, endDate, ref);
  }

  Widget _buildProductGrid(
    BuildContext context,
    ProductViewModel model,
    List<Variant> variants, {
    required double paneWidth,
  }) {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final stocksById = ref
            .watch(stocksForVisibleVariantsProvider(branchId))
            .asData
            ?.value ??
        const <String, Stock?>{};

    final bool isMobileLayout =
        paneWidth < PosLayoutBreakpoints.mobileLayoutMaxWidth;

    // Capture layout metrics used for scroll compensation when pages are evicted
    // from the front of the in-memory page cache.
    _lastIsMobileLayout = isMobileLayout;
    _lastPaneWidth = paneWidth;

    if (isMobileLayout) {
      _lastGridCrossAxisCount = null;
      _lastGridMainAxisSpacing = null;
      _lastGridChildAspectRatio = null;
      return ColoredBox(
        color: PosTokens.posBg,
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
          itemCount: variants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return buildVariantRow(
              forceRemoteUrl: false,
              context: context,
              model: model,
              variant: variants[index],
              isOrdering: false,
              forceListView: true,
              stocksById: stocksById,
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
          cacheExtent: 500.0,
        ),
      );
    }

    final crossAxisCount =
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(paneWidth);
    final spacing = PosLayoutBreakpoints.desktopGridSpacing(paneWidth);
    final aspectRatio = PosLayoutBreakpoints.desktopGridChildAspectRatioForPane(
      paneWidth,
    );

    _lastGridCrossAxisCount = crossAxisCount;
    _lastGridMainAxisSpacing = spacing;
    _lastGridChildAspectRatio = aspectRatio;

    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        return buildVariantRow(
          forceRemoteUrl: false,
          context: context,
          model: model,
          variant: variants[index],
          isOrdering: false,
          forceListView: false,
          usePosCatalogTile: true,
          stocksById: stocksById,
        );
      },
      physics: const AlwaysScrollableScrollPhysics(),
      cacheExtent: 1000.0,
    );
  }

  Widget _buildStockView(
    BuildContext context,
    ProductViewModel model,
    List<Variant> variants,
    DateTime? startDate,
    DateTime? endDate,
    WidgetRef ref,
  ) {
    final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();
    return variants.isEmpty
        ? Center(child: Text(context.flipperL10n.noStockDataAvailable))
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


  Widget _paginationSideButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool usePosStyle,
  }) {
    if (!usePosStyle) {
      return IconButton(icon: Icon(icon), onPressed: onPressed);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD1D1D6)),
            ),
            child: Icon(
              icon,
              size: 18,
              color: onPressed == null
                  ? const Color(0xFFC7C7CC)
                  : const Color(0xFF3C3C43),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortingDropdown(BuildContext context, {bool compact = false}) {
    return Consumer(
      builder: (context, ref, _) {
        final currentSort = ref.watch(productSortProvider);
        final l10n = context.flipperL10n;
        final label = compact
            ? currentSort.compactLabel(l10n)
            : currentSort.localizedLabel(l10n);
        return PopupMenuButton<ProductSortOption>(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 12,
              vertical: compact ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: compact ? Colors.white : null,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(compact ? 10 : 4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 13 : 14,
                  ),
                ),
                SizedBox(width: compact ? 4 : 8),
                Icon(
                  FluentIcons.chevron_down_20_regular,
                  size: compact ? 14 : 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
          onSelected: (ProductSortOption option) {
            ref.read(productSortProvider.notifier).set(option);
          },
          itemBuilder: (BuildContext context) {
            return ProductSortOption.values.map((ProductSortOption option) {
              return PopupMenuItem<ProductSortOption>(
                value: option,
                child: Row(
                  children: [
                    if (option == currentSort)
                      Icon(
                        FluentIcons.checkmark_20_filled,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        option.localizedLabel(context.flipperL10n),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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

  /// Effective on-hand stock for a variant: prefer the attached stock's
  /// current quantity, falling back to the display-only [Variant.qty].
  double _effectiveStock(Variant v) => v.stock?.currentStock ?? v.qty ?? 0;

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
          (a, b) => 0,
        ); // Placeholder - implement based on your rating field
        break;
      case ProductSortOption.latest:
        sortedVariants.sort(
          (a, b) => (b.lastTouched ?? DateTime(0)).compareTo(
            a.lastTouched ?? DateTime(0),
          ),
        );
        break;
      case ProductSortOption.priceLowToHigh:
        sortedVariants.sort(
          (a, b) => (a.retailPrice ?? 0).compareTo(b.retailPrice ?? 0),
        );
        break;
      case ProductSortOption.priceHighToLow:
        sortedVariants.sort(
          (a, b) => (b.retailPrice ?? 0).compareTo(a.retailPrice ?? 0),
        );
        break;
      case ProductSortOption.stockOut:
        // Surface out-of-stock (and lowest) items first by sorting on the
        // effective on-hand stock ascending.
        sortedVariants.sort(
          (a, b) => _effectiveStock(a).compareTo(_effectiveStock(b)),
        );
        break;
      case ProductSortOption.eventDateOldToNew:
        sortedVariants.sort(
          (a, b) => (a.lastTouched ?? DateTime(0)).compareTo(
            b.lastTouched ?? DateTime(0),
          ),
        );
        break;
      case ProductSortOption.eventDateNewToOld:
        sortedVariants.sort(
          (a, b) => (b.lastTouched ?? DateTime(0)).compareTo(
            a.lastTouched ?? DateTime(0),
          ),
        );
        break;
    }

    return sortedVariants;
  }
}
