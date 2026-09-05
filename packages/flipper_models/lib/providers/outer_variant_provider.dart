// flipper_models/providers/outer_variant_provider.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync/utils/pos_catalog_tax_ty_cds.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'outer_variant_provider.g.dart';

@riverpod
class OuterVariants extends _$OuterVariants {
  /// In-memory pages `[firstCachedPage … lastCachedPage]`; oldest dropped when
  /// count exceeds [_maxCachedPages] so scroll "load more" cannot grow without bound.
  final Map<int, List<Variant>> _pageCache = {};
  int _firstCachedPage = 0;
  int _lastCachedPage = -1;

  static const int _maxCachedPages = 10;

  String _currentSearch = '';
  int _searchGeneration = 0;

  /// Non-null while the user is driving the explicit page bar: state then shows
  /// exactly that page instead of every cached page flattened together.
  int? _viewPage;

  /// Bumped whenever the page cache is thrown away (build/search/refresh) so an
  /// in-flight page fetch or prefetch cannot land on top of newer data.
  int _cacheGeneration = 0;

  /// Bumped on every page-bar tap; only the newest tap is allowed to paint.
  int _pageRequestGeneration = 0;

  /// Fetches in flight per page (taps + prefetch), so a double tap or a tap
  /// racing its own prefetch shares one query instead of issuing two.
  final Map<int, Future<PagedVariants>> _inFlightPages = {};
  int? _totalCount;
  int? _itemsPerPage;
  bool _isVatEnabled = false;

  List<Variant> _flattenContiguousPages() {
    if (_pageCache.isEmpty) return [];
    final keys = _pageCache.keys.toList()..sort();
    final out = <Variant>[];
    for (final k in keys) {
      out.addAll(_pageCache[k]!);
    }
    return out;
  }

  /// What the UI should show right now: a single page in page-bar mode, the
  /// whole contiguous cache in scroll ("load more") mode.
  List<Variant> _currentView() {
    final page = _viewPage;
    if (page != null) {
      return List<Variant>.from(_pageCache[page] ?? const <Variant>[]);
    }
    return _flattenContiguousPages();
  }

  /// Drops the pages furthest from [anchor] so jumping around the page bar keeps
  /// the neighbourhood the user is actually browsing hot.
  void _evictPagesFarFrom(int anchor) {
    while (_pageCache.length > _maxCachedPages) {
      final farthest = _pageCache.keys.reduce(
        (a, b) => (a - anchor).abs() >= (b - anchor).abs() ? a : b,
      );
      _pageCache.remove(farthest);
      talker.info(
        'OuterVariants: evicted page $farthest from cache '
        '(max $_maxCachedPages pages in memory)',
      );
    }
  }

  void _repackFromFlatList(List<Variant> flat) {
    _pageCache.clear();
    final ipp = _itemsPerPage;
    if (ipp == null || ipp <= 0 || flat.isEmpty) {
      _firstCachedPage = 0;
      _lastCachedPage = -1;
      return;
    }
    for (var i = 0; i < flat.length; i += ipp) {
      final pageIdx = i ~/ ipp;
      _pageCache[pageIdx] = flat.sublist(i, math.min(i + ipp, flat.length));
    }
    _firstCachedPage = _pageCache.keys.reduce(math.min);
    _lastCachedPage = _pageCache.keys.reduce(math.max);
  }

  void _syncBoundsFromCache() {
    if (_pageCache.isEmpty) {
      _firstCachedPage = 0;
      _lastCachedPage = -1;
    } else {
      _firstCachedPage = _pageCache.keys.reduce(math.min);
      _lastCachedPage = _pageCache.keys.reduce(math.max);
    }
  }

  @override
  FutureOr<List<Variant>> build(String branchId) async {
    ref.keepAlive();

    // Initialize itemsPerPage once. Use a smaller default for better performance
    final int _defaultPageSize = 15; // Reduced from 20 for better performance
    const int _maxPageSize = 50; // Reduced max from 100
    final int? prefIpp = ProxyService.box.itemPerPage();
    _itemsPerPage ??=
        (prefIpp != null && prefIpp > 0 && prefIpp <= _maxPageSize)
        ? prefIpp
        : _defaultPageSize;
    talker.info(
      'OuterVariants: itemsPerPage=${_itemsPerPage ?? 'null'} '
      '(pref=${prefIpp ?? 'null'}, default=$_defaultPageSize, max=$_maxPageSize)',
    );

    // VAT regime MUST follow the branch this provider is displaying, not the
    // ambient getBranchId(). ebmVatEnabledProvider reads getBranchId() and is
    // keepAlive, so after a branch switch the catalog would keep the previous
    // branch's tax-code set — filtering out items (e.g. cross-VAT transfers)
    // that are correctly coded for THIS branch. Resolve VAT for [branchId].
    _isVatEnabled = await _resolveBranchVatEnabled(branchId);

    _currentSearch = ref.read(searchStringProvider);

    ref.listen(searchStringProvider, (previous, next) {
      if (next == _currentSearch) return;
      unawaited(_applySearchQuery(next));
    });

    const int fetchPageIndex = 0;

    // First page + no search: Ditto may still be pulling from the mesh after
    // app start. A single empty success would cache forever unless we retry.
    final PagedVariants paged;
    if (fetchPageIndex == 0 && _currentSearch.isEmpty && branchId.isNotEmpty) {
      paged = await _fetchVariantsWithColdStartGrace(branchId);
    } else {
      paged = await _fetchVariants(branchId, fetchPageIndex, _currentSearch);
    }
    _totalCount = paged.totalCount;

    _resetPageCache();
    _pageCache[0] = List<Variant>.from(paged.variants);
    _firstCachedPage = 0;
    _lastCachedPage = 0;

    return _flattenContiguousPages();
  }

  /// VAT status for the branch being displayed (local-first; one remote retry
  /// only if the branch has no local EBM row yet). Keeps the catalog's tax-code
  /// filter aligned with [branchId] rather than the ambient current branch.
  Future<bool> _resolveBranchVatEnabled(String branchId) async {
    if (branchId.isEmpty) return false;
    try {
      var ebm =
          await ProxyService.strategy.ebm(branchId: branchId, fetchRemote: false);
      ebm ??=
          await ProxyService.strategy.ebm(branchId: branchId, fetchRemote: true);
      return ebm?.vatEnabled ?? false;
    } catch (e) {
      talker.warning('OuterVariants: VAT lookup failed for $branchId: $e');
      return false;
    }
  }

  /// Search updates without re-running [build] (keeps current grid visible).
  Future<void> _applySearchQuery(String searchString) async {
    final generation = ++_searchGeneration;
    _currentSearch = searchString;
    _resetPageCache();
    _firstCachedPage = 0;
    _lastCachedPage = -1;

    try {
      final paged = await _fetchVariants(branchId, 0, searchString);
      if (generation != _searchGeneration) return;

      _totalCount = paged.totalCount;
      _pageCache[0] = List<Variant>.from(paged.variants);
      _firstCachedPage = 0;
      _lastCachedPage = 0;
      state = AsyncValue.data(_currentView());
    } catch (error, stackTrace) {
      if (generation != _searchGeneration) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Extra backoff after an empty first fetch so products appear on cold start
  /// without requiring the user to search or navigate away.
  Future<PagedVariants> _fetchVariantsWithColdStartGrace(
    String branchId,
  ) async {
    var paged = await _fetchVariants(branchId, 0, '', fetchRemote: true);
    if (paged.variants.isNotEmpty) return paged;

    const delays = <Duration>[
      Duration(milliseconds: 400),
      Duration(milliseconds: 900),
      Duration(milliseconds: 1500),
    ];
    for (final d in delays) {
      talker.info(
        'OuterVariants: first load empty, retry after ${d.inMilliseconds}ms '
        '(Ditto / cloud sync)',
      );
      await Future.delayed(d);
      paged = await _fetchVariants(branchId, 0, '', fetchRemote: true);
      if (paged.variants.isNotEmpty) break;
    }
    return paged;
  }

  Future<PagedVariants> _fetchVariants(
    String branchId,
    int page,
    String searchString, {
    bool fetchRemote = false,
    bool countTotal = true,
  }) async {
    talker.info(
      'OuterVariants: _fetchVariants called (page=$page, itemsPerPage=${_itemsPerPage ?? 'null'}, searchString="$searchString")',
    );

    final taxTyCds = posCatalogTaxTyCds(vatEnabled: _isVatEnabled);
    final currentScanMode = ref.read(scanningModeProvider);
    talker.info(
      'OuterVariants: query branchId=$branchId vatEnabled=$_isVatEnabled '
      'taxTyCds=$taxTyCds search="$searchString"',
    );

    final paged = await ProxyService.getStrategy(Strategy.capella).variants(
      name: searchString.toLowerCase(),
      fetchRemote: fetchRemote,
      branchId: branchId,
      page: page,
      itemsPerPage: _itemsPerPage!,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
      countTotal: countTotal,
    );

    talker.info(
      'OuterVariants: _fetchVariants returned ${paged.variants.length} items (totalCount=${paged.totalCount ?? 'null'})',
    );

    return paged;
  }

  /// Loads the next page of variants for pagination.
  Future<void> loadMore() async {
    // Scrolling past the end is a request for a continuous list, so leave
    // page-bar mode rather than appending a page nobody is looking at.
    _leavePagedMode();
    if (_totalCount == null ||
        (_lastCachedPage + 1) * _itemsPerPage! >= _totalCount!) {
      return;
    }

    final nextPage = _lastCachedPage + 1;
    final paged = await _fetchVariants(branchId, nextPage, _currentSearch);
    _pageCache[nextPage] = List<Variant>.from(paged.variants);
    _lastCachedPage = nextPage;

    while (_pageCache.length > _maxCachedPages) {
      final first = _pageCache.keys.reduce(math.min);
      _pageCache.remove(first);
      talker.info(
        'OuterVariants: evicted page $first from cache '
        '(max $_maxCachedPages pages in memory)',
      );
    }
    _syncBoundsFromCache();

    state = AsyncValue.data(_currentView());
  }

  /// Method to be called when VAT settings change to force a full refresh.
  Future<void> resetForVatChange() async {
    // Refresh VAT status from EBM
    _isVatEnabled = await getVatEnabledFromEbm();
    ref.invalidateSelf();
  }

  /// Method to force a full refresh of variants (e.g., after adding new products).
  ///
  /// Deliberately a plain local read, not [_fetchVariantsWithColdStartGrace]:
  /// every caller runs this straight after a local write, so the rows are
  /// already in the local store. The grace path passes `fetchRemote: true` and,
  /// on an empty result, sleeps through its own 400/900/1500ms backoff *and*
  /// `variants()`'s inner 2s/3.5s/5s backoff — up to ~34s of retry loops on a
  /// machine still busy finishing the save. Cold start is still covered by
  /// [build], which callers reach via `ref.invalidate`.
  ///
  /// Takes a search generation so an in-flight [_applySearchQuery] cannot land
  /// on top of this refresh (or vice versa) and resurrect stale filtered rows.
  Future<void> refresh() async {
    final generation = ++_searchGeneration;
    final paged = await _fetchVariants(branchId, 0, '');
    if (generation != _searchGeneration) return;
    _currentSearch = '';
    _totalCount = paged.totalCount;
    _resetPageCache();
    _pageCache[0] = List<Variant>.from(paged.variants);
    _firstCachedPage = 0;
    _lastCachedPage = 0;
    state = AsyncValue.data(_currentView());
  }

  /// Switches back to the continuous ("load more") view, keeping the cached
  /// pages that sit in one unbroken run around the page being shown so the
  /// flattened list has no holes in it.
  void _leavePagedMode() {
    final anchor = _viewPage;
    if (anchor == null) return;
    _viewPage = null;

    // Only pages *after* the anchor are kept: prepending earlier pages would
    // shove the list the user is looking at down the screen.
    final low = anchor;
    var high = anchor;
    while (_pageCache.containsKey(high + 1)) {
      high++;
    }
    _pageCache.removeWhere((page, _) => page < low || page > high);
    _syncBoundsFromCache();
  }

  /// Clears every cached page and leaves page-bar mode, invalidating any fetch
  /// or prefetch still in flight.
  void _resetPageCache() {
    _pageCache.clear();
    _inFlightPages.clear();
    _viewPage = null;
    _cacheGeneration++;
  }

  /// Add newly created variants to the provider without full reload.
  void addVariants(List<Variant> newVariants) {
    if (newVariants.isEmpty || state.value == null) return;

    // Get IDs of new/updated variants
    final newVariantIds = newVariants.map((v) => v.id).toSet();

    final existingFlat = _pageCache.isEmpty
        ? List<Variant>.from(state.value!)
        : _flattenContiguousPages();

    // Filter out existing variants that match the new IDs to prevent duplicates
    final filteredExisting = existingFlat
        .where((v) => !newVariantIds.contains(v.id))
        .toList();

    // Prepend the new/updated variants to the list
    var newList = [...newVariants, ...filteredExisting];
    final ipp = _itemsPerPage ?? 15;
    final maxItems = _maxCachedPages * ipp;
    if (newList.length > maxItems) {
      newList = newList.sublist(0, maxItems);
    }
    _repackFromFlatList(newList);
    // The repack renumbers pages from 0 and the new rows sit at the top, so a
    // page-bar view has to follow them back to the first page.
    if (_viewPage != null) _viewPage = 0;
    state = AsyncValue.data(_currentView());
  }

  /// Removes a variant from the state.
  void removeVariantById(String variantId) {
    if (state.value == null) return;
    if (_pageCache.isEmpty) {
      final newList = state.value!.where((v) => v.id != variantId).toList();
      if (newList.isEmpty) {
        _firstCachedPage = 0;
        _lastCachedPage = -1;
        state = AsyncValue.data([]);
        return;
      }
      _repackFromFlatList(newList);
      state = AsyncValue.data(_currentView());
      return;
    }
    final keys = _pageCache.keys.toList();
    for (final k in keys) {
      final chunk = _pageCache[k];
      if (chunk == null) continue;
      _pageCache[k] = chunk.where((v) => v.id != variantId).toList();
      if (_pageCache[k]!.isEmpty) {
        _pageCache.remove(k);
      }
    }
    _syncBoundsFromCache();
    state = AsyncValue.data(_currentView());
  }

  /// Saves stock data to cache.

  /// Switches the visible page. A page still in [_pageCache] swaps in
  /// synchronously — no query, no await — so re-visiting a page the user has
  /// already seen is instant; only a cold page hits the store.
  Future<void> fetchPage(int page) async {
    if (page < 0) return;
    final requestGeneration = ++_pageRequestGeneration;
    final cacheGeneration = _cacheGeneration;

    if (_pageCache.containsKey(page)) {
      _viewPage = page;
      _syncBoundsFromCache();
      state = AsyncValue.data(_currentView());
      return;
    }

    final PagedVariants paged;
    try {
      paged = await _fetchPageOnce(
        page,
        // The total only changes when the filter changes, and that path clears
        // the cache — so skip the COUNT(*) scan on every page hop.
        countTotal: _totalCount == null,
      );
    } catch (e) {
      talker.warning('OuterVariants: page $page fetch failed: $e');
      return;
    }
    if (cacheGeneration != _cacheGeneration) return;

    _pageCache[page] = List<Variant>.from(paged.variants);
    // A newer tap already won: keep the page for later, but do not paint it.
    if (requestGeneration != _pageRequestGeneration) {
      _evictPagesFarFrom(_viewPage ?? page);
      _syncBoundsFromCache();
      return;
    }
    if (paged.totalCount != null) _totalCount = paged.totalCount;
    _viewPage = page;
    _evictPagesFarFrom(page);
    _syncBoundsFromCache();
    state = AsyncValue.data(_currentView());
  }

  /// Warms a page in the background without touching what is on screen, so the
  /// next/previous tap resolves from cache.
  Future<void> prefetchPage(int page) async {
    if (page < 0) return;
    if (_pageCache.containsKey(page) || _inFlightPages.containsKey(page))
      return;
    final total = _totalCount;
    if (total != null && page * itemsPerPage >= total) return;

    final cacheGeneration = _cacheGeneration;
    try {
      final paged = await _fetchPageOnce(page, countTotal: false);
      if (cacheGeneration != _cacheGeneration) return;
      if (paged.variants.isEmpty) return;
      _pageCache[page] = List<Variant>.from(paged.variants);
      _evictPagesFarFrom(_viewPage ?? page);
      _syncBoundsFromCache();
      // Deliberately no state emission: prefetching must not repaint the grid.
    } catch (e) {
      talker.warning('OuterVariants: prefetch of page $page failed: $e');
    }
  }

  /// One query per page at a time; callers arriving while it is running join it.
  Future<PagedVariants> _fetchPageOnce(int page, {required bool countTotal}) {
    final existing = _inFlightPages[page];
    if (existing != null) return existing;
    final future = _fetchVariants(
      branchId,
      page,
      _currentSearch,
      countTotal: countTotal,
    );
    _inFlightPages[page] = future;
    return future.whenComplete(() {
      if (identical(_inFlightPages[page], future)) _inFlightPages.remove(page);
    });
  }

  /// Whether [page] can be shown without a round trip.
  bool hasPageCached(int page) => _pageCache.containsKey(page);

  /// The page the page-bar is currently showing, or null in scroll mode.
  int? get viewPage => _viewPage;

  /// Return items for a given page (sliced from the locally cached variants).
  List<Variant> getPageItems(int page) {
    return List<Variant>.from(_pageCache[page] ?? const <Variant>[]);
  }

  int get itemsPerPage => _itemsPerPage ?? 10;

  int get loadedCount => state.value?.length ?? 0;

  int? get totalCount => _totalCount;

  /// Highest page index currently present in the page cache (0-based).
  int get currentPage => _lastCachedPage;

  /// Lowest page index currently held in memory (after evictions, can be > 0).
  int get firstCachedPage => _firstCachedPage;

  bool get hasMorePages =>
      _totalCount == null ||
      (_lastCachedPage + 1) * _itemsPerPage! < _totalCount!;

  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  /// Returns an estimate of total pages based on loaded items and whether
  /// there are more pages available. This is an estimate because the provider
  /// does not currently have access to the absolute total count from remote.
  int estimatedTotalPages() {
    if (_totalCount != null) {
      return (_totalCount! / itemsPerPage).ceil();
    }
    return 1;
  }

  /// Fetches all variants for the branch, bypassing pagination.
  /// Useful for data export (e.g., Excel).
  Future<List<Variant>> futureFetchAllVariants() async {
    final taxTyCds = posCatalogTaxTyCds(vatEnabled: _isVatEnabled);
    final currentScanMode = ref.read(scanningModeProvider);

    final paged = await ProxyService.getStrategy(Strategy.capella).variants(
      branchId: branchId,
      taxTyCds: taxTyCds,
      scanMode: currentScanMode,
      fetchRemote: true, // Ensure we have latest data for export
    );

    return List<Variant>.from(paged.variants);
  }
}

// Products provider remains the same but with minor optimizations
@riverpod
class Products extends _$Products {
  bool _initialLoadComplete = false;

  @override
  FutureOr<List<Product>> build(String branchId) async {
    final searchString = ref.watch(searchStringProvider);
    final scanMode = ref.watch(scanningModeProvider);

    if (!scanMode && !_initialLoadComplete) {
      await loadProducts(searchString: searchString, scanMode: scanMode);
      _initialLoadComplete = true;
    }

    return state.value ?? [];
  }

  Future<void> loadProducts({
    required String searchString,
    required bool scanMode,
  }) async {
    try {
      List<Product> products = await ProxyService.strategy.productsFuture(
        branchId: branchId,
      );

      if (searchString.isNotEmpty) {
        final additionalProduct = await ProxyService.strategy.getProduct(
          name: searchString.toLowerCase(),
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
        );

        if (additionalProduct != null) {
          products = [...products, additionalProduct];
        }
      }

      final matchingProducts = products
          .where(
            (product) =>
                product.name.toLowerCase().contains(searchString.toLowerCase()),
          )
          .toList();

      state = AsyncData(matchingProducts);

      if (matchingProducts.isNotEmpty) {
        _expandProduct(matchingProducts.first);
      } else if (searchString.isEmpty) {
        state = AsyncData(products);
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void _expandProduct(Product product) {
    state.whenData((currentData) {
      final updatedProducts = currentData.map((p) {
        p.searchMatch = p.id == product.id;
        return p;
      }).toList();

      const equality = ListEquality();
      if (!equality.equals(currentData, updatedProducts)) {
        state = AsyncData(updatedProducts);
      }
    });
  }

  void addProducts({required List<Product> products}) {
    final currentData = state.value ?? const <Product>[];
    state = AsyncData(mergeProductsById(currentData, products));
  }

  void deleteProduct(int productId) {
    state.whenData((currentData) {
      final updatedProducts = currentData
          .where((product) => product.id != productId)
          .toList();
      state = AsyncData(updatedProducts);
    });
  }
}

List<Product> mergeProductsById(
  List<Product> currentProducts,
  List<Product> incomingProducts,
) {
  final merged = <Product>[...currentProducts];
  for (final incoming in incomingProducts) {
    final existingIndex = merged.indexWhere(
      (product) => product.id == incoming.id,
    );
    if (existingIndex == -1) {
      merged.add(incoming);
    } else {
      merged[existingIndex] = incoming;
    }
  }
  return merged;
}
