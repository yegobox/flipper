import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/providers/pos_cart_add_service.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:flipper_dashboard/widgets/pos_catalog_grid_card.dart';

Map<int, String> positionString = {
  0: 'first',
  1: 'second',
  2: 'third',
  3: 'fourth',
  4: 'fifth',
  5: 'sixth',
  6: 'seventh',
  7: 'eighth',
  8: 'ninth',
  9: 'tenth',
  10: 'eleventh',
  11: 'twelfth',
  12: 'thirteenth',
  13: 'fourteenth',
  14: 'fifteenth',
  15: 'sixteenth',
};

typedef void DeleteProductFunction(String? id, String type);
typedef void DeleteVariantFunction(String? id, String type);

class RowItem extends StatefulHookConsumerWidget {
  final String color;
  final String productName;
  final String? imageUrl;
  final DeleteProductFunction delete;
  final DeleteVariantFunction deleteVariant;
  final Function edit;
  final Function enableNfc;
  final ProductViewModel model;
  final double stock;
  final Variant? variant;
  final Product? product;
  final bool? addFavoriteMode;
  final String? favIndex;
  final String variantName;
  final bool isComposite;
  final bool isOrdering;
  final bool forceRemoteUrl;
  final bool forceListView;
  /// Desktop POS catalog grid — uses [PosCatalogGridCard] (handoff layout).
  final bool usePosCatalogTile;

  const RowItem({
    Key? key,
    required this.color,
    required this.productName,
    required this.variantName,
    required this.stock,
    required this.forceRemoteUrl,
    required this.forceListView,
    this.usePosCatalogTile = false,
    this.delete = _defaultFunction,
    this.deleteVariant = _defaultFunction,
    this.edit = _defaultFunction,
    this.enableNfc = _defaultFunction,
    required this.model,
    this.imageUrl,
    this.variant,
    this.product,
    this.addFavoriteMode,
    this.favIndex,
    required this.isComposite,
    required this.isOrdering,
  }) : super(key: key);

  static _defaultFunction(String? id, String type) {
    print("no function provided for the action");
  }

  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends ConsumerState<RowItem>
    with Refresh, CoreMiscellaneous, SnackBarMixin {
  final _routerService = locator<RouterService>();

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return text.substring(0, maxLength) + '...';
  }

  // Constants for consistent styling
  static const double cardBorderRadius = PosTokens.radiusMd;
  static const double imageBorderRadius = PosTokens.radiusMd;
  static const double contentPadding = 12.0;

  double get _lowStockThreshold =>
      widget.variant?.stock?.lowStock ?? 10.0;

  // Image loading state management
  Future<String>? _cachedRemoteUrlFuture;
  Future<String?>? _cachedLocalImageFuture;
  String? _branchId;
  Widget? _cachedImageWidget;
  static final Map<String, Future<void>> _assetDownloadCache = {};

  @override
  void initState() {
    super.initState();
    _initImageCache();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initImageCache() {
    try {
      // Objects live under `public/branch-{id}/…` for the branch that owned the
      // upload. Prefer the variant's branch so rows match S3 even when the
      // session branch id differs or is not ready yet.
      _branchId = widget.variant?.branchId ?? ProxyService.box.getBranchId();
    } catch (e) {
      talker.error('Error initializing image cache: $e');
    }
  }

  @override
  void didUpdateWidget(RowItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageUrl != oldWidget.imageUrl ||
        (widget.variant?.branchId != oldWidget.variant?.branchId)) {
      _branchId = widget.variant?.branchId;

      // Clear cached futures and widget when image URL changes
      _cachedRemoteUrlFuture = null;
      _cachedLocalImageFuture = null;
      _cachedImageWidget = null;

      // Reinitialize cache
      _initImageCache();
    }
  }

  void _handleProductTap({
    required bool isMultiSelectActive,
    required String? itemId,
  }) {
    if (isMultiSelectActive) {
      if (itemId != null) {
        ref.read(selectedItemIdsProvider.notifier).toggleSelection(itemId);
      }
      return;
    }
    final flipperWatch? w =
        kDebugMode ? flipperWatch('onAddingItemToQuickSell') : null;
    w?.start();
    _onAddToCartWithOptimistic();
    w?.log('Item Added to Quick Sell');
  }

  Widget _buildDesktopPosGridCard({
    required BuildContext context,
    required WidgetRef ref,
    required bool isSelected,
    required bool isMultiSelectActive,
    required String? itemId,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    final variantId = widget.variant?.id;
    final inCartQty = (variantId != null && variantId.isNotEmpty)
        ? ref.watch(posCartQtyForVariantProvider(variantId))
        : 0;

    final stockAsync = ref.watch(
      stockByVariantProvider(widget.variant?.stockId ?? ''),
    );
    final stockRaw = stockAsync.value?.currentStock ?? widget.stock;
    final stockValue = stockRaw is int ? stockRaw : stockRaw.floor();
    final visual = posStockVisual(
      currentStock: stockValue,
      lowStockThreshold: _lowStockThreshold,
    );
    final isOut = visual == PosStockVisual.out;

    final price = widget.variant?.retailPrice ?? 0;
    final currency = ProxyService.box.defaultCurrency();

    final bcd = widget.variant?.bcd;
    final bcdLabel =
        bcd != null && bcd.isNotEmpty ? 'BCD: $bcd' : null;

    final hasImage = widget.imageUrl?.isNotEmpty == true;

    return PosCatalogGridCard(
      key: Key('pos-catalog-tap-${variantId ?? itemId ?? ''}'),
      productName: widget.productName.isNotEmpty
          ? widget.productName
          : 'Unnamed Product',
      bcdLabel: bcdLabel,
      currencySymbol: currency,
      priceAmount: price,
      stockVisual: visual,
      stockLabel: posStockLabel(visual, stockValue),
      inCartQty: inCartQty,
      showSelectionBorder: isMultiSelectActive && isSelected,
      isOutOfStock: isOut,
      thumb: posCatalogThumb(
        name: widget.productName,
        hasImage: hasImage,
        image: hasImage
            ? ClipRRect(
                child: SizedBox.expand(child: _buildImage()),
              )
            : null,
        isOutOfStock: isOut,
      ),
      onTap: isOut
          ? null
          : () => _handleProductTap(
              isMultiSelectActive: isMultiSelectActive,
              itemId: itemId,
            ),
      onLongPress: () {
        if (itemId != null && !widget.isOrdering) {
          ref.read(selectedItemIdsProvider.notifier).toggleSelection(itemId);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemIds = ref.watch(selectedItemIdsProvider);
    final itemId = widget.variant?.id ?? widget.product?.id;
    final isSelected = selectedItemIds.contains(itemId);
    final isMultiSelectActive = selectedItemIds.isNotEmpty;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Check if we should use list view mode
    final deviceType = DeviceType.getDeviceType(context);
    final bool useListView =
        deviceType == 'Phone' ||
        (widget.forceListView &&
            deviceType !=
                'Desktop'); // Use list view on phones or when forced (except on desktop)

    final bool isCompactPosList =
        widget.forceListView &&
        !widget.isOrdering &&
        MediaQuery.sizeOf(context).width < 600;

    final bool renderPosCatalogTile = widget.usePosCatalogTile;

    if (isCompactPosList) {
      return _buildMposCatalogProductCard(
        context: context,
        ref: ref,
        textTheme: textTheme,
        colorScheme: colorScheme,
      );
    }
    if (renderPosCatalogTile) {
      return _buildDesktopPosGridCard(
        context: context,
        ref: ref,
        isSelected: isSelected,
        isMultiSelectActive: isMultiSelectActive,
        itemId: itemId,
        textTheme: textTheme,
        colorScheme: colorScheme,
      );
    }

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, c) {
        final listChild = useListView
            ? _buildListItemContent(isSelected, textTheme, colorScheme)
            : _buildItemContent(isSelected, textTheme, colorScheme);

        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.25)
                : Colors.white,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : Colors.grey.withValues(alpha: 0.12),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: PosTokens.shadow1,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(cardBorderRadius),
              onTap: () => _handleProductTap(
                isMultiSelectActive: isMultiSelectActive,
                itemId: itemId,
              ),
              onLongPress: () {
                if (itemId != null && !widget.isOrdering) {
                  ref
                      .read(selectedItemIdsProvider.notifier)
                      .toggleSelection(itemId);
                }
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(contentPadding - 4),
                    child: listChild,
                  ),
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  if (isSelected &&
                      selectedItemIds.length == 1 &&
                      !widget.isOrdering)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _buildFloatingActionButtons(colorScheme),
                    ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemContent(
    bool isSelected,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available height for content
        final double maxHeight = constraints.maxHeight;

        // Allocate space for image and info sections
        // Reserve at least 75px for product info to prevent overflow because some names are long
        // and we display 4 rows of text.
        final double maxInfoHeight =
            75.0; // Increased height for info section from 50.0
        final double availableForImage =
            maxHeight - maxInfoHeight - 4; // 4px for spacing

        // Cap image height to prevent overflow and maintain a balanced look
        final double imageHeight = math.min(
          availableForImage,
          maxHeight * 0.55, // Cap at 55% of available height
        );

        return Column(
          mainAxisSize: MainAxisSize.min, // Important to prevent overflow
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section with explicit constraints
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: _buildProductImageSection(isSelected),
            ),

            const SizedBox(height: 2), // Minimal spacing
            // Product Info Section with fixed maximum height
            Container(
              constraints: BoxConstraints(maxHeight: maxInfoHeight),
              // Use SingleChildScrollView to prevent RenderFlex overflow if text is too large
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: _buildCompactProductInfo(textTheme),
              ),
            ),
          ],
        );
      },
    );
  }

  // New compact product info section specifically designed to avoid overflow
  Widget _buildCompactProductInfo(TextTheme textTheme) {
    // Get appropriate display names with safe fallbacks
    final String displayProductName = _truncateString(
      widget.productName.isNotEmpty ? widget.productName : "Unnamed Product",
      20,
    );

    final String displayVariantName = _truncateString(
      widget.variantName.isNotEmpty ? widget.variantName : "Default Variant",
      20,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name with strict constraints
        Text(
          displayProductName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 13, // Increased from 11
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Only show variant if different and there's enough space
        if (displayVariantName != displayProductName)
          Text(
            displayVariantName,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 11, // Increased from 9
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Barcode display
        if (widget.variant?.bcd != null && widget.variant!.bcd!.isNotEmpty)
          Text(
            'BCD: ${widget.variant!.bcd}',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 11, // Increased from 9
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Price tag - simplified to avoid overflow
        if (widget.variant?.retailPrice != null &&
            widget.variant?.retailPrice != 0)
          Text(
            (widget.variant?.retailPrice ?? 0).toCurrencyFormatted(
              symbol: ProxyService.box.defaultCurrency(),
            ),
            style: textTheme.labelSmall?.copyWith(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Stock display with live updates from Riverpod
        RepaintBoundary(
          child: Consumer(
            builder: (context, ref, child) {
              final stockAsync = ref.watch(
                stockByVariantProvider(widget.variant?.stockId ?? ''),
              );
              final stockValue = stockAsync.value?.currentStock ?? 0;

              return Text(
                '$stockValue in stock',
                style: textTheme.bodySmall?.copyWith(
                  color: stockValue > 0 ? Colors.green[700] : Colors.red[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItemContent(
    bool isSelected,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    // POS compact list row (matches the new mobile POS design).
    //
    // Do NOT gate on [DeviceType] == 'Phone': diagonal-based classification
    // labels many real phones as 'Phablet', which would incorrectly fall back
    // to the legacy list row (no +/- controls). Keep this in sync with
    // [ProductView] mobile layout (< 600 width) + forced list from POS.
    final bool isCompactPosList =
        widget.forceListView &&
        !widget.isOrdering &&
        MediaQuery.sizeOf(context).width < 600;
    if (isCompactPosList) {
      return _buildPosMobileListRow(textTheme, colorScheme);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for product info
        final double maxWidth = constraints.maxWidth;
        final double imageWidth = 95; // Fixed image width
        final double spacing = 8; // Reduced spacing
        final double availableForInfo = maxWidth - imageWidth - spacing;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image - Fixed size for list view
            SizedBox(
              width: imageWidth,
              height: 95,
              child: _buildProductImageSection(isSelected),
            ),

            SizedBox(width: spacing),

            // Product Info - Constrained width
            Container(
              width: availableForInfo,
              constraints: BoxConstraints(maxHeight: 95), // Match image height
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name
                    Text(
                      _truncateString(
                        widget.productName.isNotEmpty
                            ? widget.productName
                            : "Unnamed Product",
                        20,
                      ),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 12, // Smaller font size
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2), // Reduced spacing
                    // Variant name (if different from product name)
                    if (widget.variantName != widget.productName &&
                        widget.variantName.isNotEmpty)
                      Text(
                        _truncateString(widget.variantName, 20),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10, // Smaller font size
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 2),

                    // Barcode display
                    if (widget.variant?.bcd != null &&
                        widget.variant!.bcd!.isNotEmpty) ...[
                      Text(
                        'BCD: ${widget.variant!.bcd}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Price tag - simplified to avoid overflow
                    if (widget.variant?.retailPrice != null &&
                        widget.variant?.retailPrice != 0)
                      Text(
                        (widget.variant?.retailPrice ?? 0).toCurrencyFormatted(
                          symbol: ProxyService.box.defaultCurrency(),
                        ),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    // Stock display with live updates from Riverpod
                    RepaintBoundary(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final stockAsync = ref.watch(
                            stockByVariantProvider(
                              widget.variant?.stockId ?? '',
                            ),
                          );
                          final stockValue =
                              stockAsync.value?.currentStock ?? 0;

                          return Text(
                            '$stockValue in stock',
                            style: textTheme.bodySmall?.copyWith(
                              color: stockValue > 0
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _isMposCatalogRow =>
      widget.forceListView &&
      !widget.isOrdering &&
      MediaQuery.sizeOf(context).width < 600;

  Widget _buildMposCatalogProductCard({
    required BuildContext context,
    required WidgetRef ref,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PosTokens.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildPosMobileListRow(textTheme, colorScheme),
    );
  }

  Widget _buildPosMobileListRow(TextTheme textTheme, ColorScheme colorScheme) {
    // Match non-compact rows: when variant label differs from product title,
    // lead with variant name so POS/search rows match what was saved per SKU.
    final productTitle = widget.productName.trim();
    final variantTitle = widget.variantName.trim();
    final hasDistinctVariant =
        variantTitle.isNotEmpty && variantTitle != productTitle;
    final String primaryLine = hasDistinctVariant
        ? variantTitle
        : (productTitle.isNotEmpty
              ? productTitle
              : (widget.variant?.productName?.trim().isNotEmpty == true
                    ? widget.variant!.productName!.trim()
                    : variantTitle));
    final String? productSubtitle =
        hasDistinctVariant && productTitle.isNotEmpty ? productTitle : null;

    final num retailPrice = widget.variant?.retailPrice ?? 0;
    final String priceText = retailPrice.toCurrencyFormatted(
      symbol: ProxyService.box.defaultCurrency(),
    );

    final tileColor = widget.color.isEmpty
        ? posTileColorForName(primaryLine)
        : HexColor(widget.color);
    final abbrText = posTileAbbr(primaryLine);

    final thumbSize = _isMposCatalogRow ? 50.0 : 44.0;
    final thumbRadius = _isMposCatalogRow ? 13.0 : 10.0;

    final Widget leading = widget.imageUrl?.isNotEmpty == true
        ? SizedBox(
            width: thumbSize,
            height: thumbSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(thumbRadius),
              child: _buildImage(),
            ),
          )
        : Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(thumbRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              abbrText.isEmpty ? 'PRD' : abbrText,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: _isMposCatalogRow ? 15 : 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );

    final codeLine = widget.variant?.bcd?.trim().isNotEmpty == true
        ? widget.variant!.bcd!.trim()
        : (productSubtitle ?? '');

    return SizedBox(
      height: _isMposCatalogRow ? 72 : 68,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,

          const SizedBox(width: 12),

          // Middle: name + barcode
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryLine.isNotEmpty ? primaryLine : 'Unnamed',
                  style: TextStyle(
                    fontSize: _isMposCatalogRow ? 15 : 14,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                    letterSpacing: -0.01,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!_isMposCatalogRow && productSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    productSubtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (codeLine.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    codeLine,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PosTokens.ink3,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceText,
                style: TextStyle(
                  fontSize: _isMposCatalogRow ? 14.5 : 14,
                  fontWeight: FontWeight.w800,
                  color: PosTokens.ink1,
                  fontFamily: _isMposCatalogRow ? 'monospace' : null,
                ),
              ),
              const SizedBox(height: 6),
              RepaintBoundary(
                child: Consumer(
                  builder: (context, ref, _) {
                    final stockAsync = ref.watch(
                      stockByVariantProvider(widget.variant?.stockId ?? ''),
                    );
                    final stockRaw = stockAsync.value?.currentStock ?? 0;
                    final stockValue = stockRaw is int
                        ? stockRaw
                        : stockRaw.floor();

                    final threshold = _lowStockThreshold;
                    final visual = posStockVisual(
                      currentStock: stockValue,
                      lowStockThreshold: threshold,
                    );
                    final Color bg = visual == PosStockVisual.out
                        ? PosTokens.lossTint
                        : (visual == PosStockVisual.low
                              ? PosTokens.warnTint
                              : PosTokens.gain.withValues(alpha: 0.14));
                    final Color fg = posStockTextColor(visual);
                    final label = visual == PosStockVisual.out
                        ? 'Out of stock'
                        : '$stockValue left';

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: fg,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          _buildCartQtyControl(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCartQtyControl(TextTheme textTheme, ColorScheme colorScheme) {
    final v = widget.variant;
    if (v == null) {
      return const SizedBox.shrink();
    }

    return Consumer(
      builder: (context, ref, _) {
        final txnId = ref.watch(
          posCartPendingTransactionIdProvider(widget.isOrdering),
        );
        if (txnId == null || txnId.isEmpty) {
          return _buildPlusOnlyButton(textTheme, colorScheme);
        }

        final displayQty = ref.watch(posCartQtyForVariantProvider(v.id));

        if (displayQty <= 0) {
          return _buildPlusOnlyButton(textTheme, colorScheme);
        }

        return _buildStepper(
          textTheme: textTheme,
          colorScheme: colorScheme,
          qty: displayQty,
          decrementEnabled: displayQty > 0,
          onDecrement: () async {
            _decrementVariantFromCart(
              transactionId: txnId,
              variantId: v.id,
            );
          },
          onIncrement: _onAddToCartWithOptimistic,
        );
      },
    );
  }

  Widget _buildPlusOnlyButton(TextTheme textTheme, ColorScheme colorScheme) {
    if (_isMposCatalogRow) {
      return Consumer(
        builder: (context, ref, _) {
          final stockAsync = ref.watch(
            stockByVariantProvider(widget.variant?.stockId ?? ''),
          );
          final stockRaw = stockAsync.value?.currentStock ?? 0;
          final stockValue = stockRaw is int ? stockRaw : stockRaw.floor();
          final enabled = stockValue > 0;

          return Material(
            color: enabled ? PosTokens.blue : const Color(0xFFE8E8ED),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: enabled ? _onAddToCartWithOptimistic : null,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.add_rounded,
                  color: enabled ? Colors.white : const Color(0xFFAEAEB2),
                  size: 22,
                ),
              ),
            ),
          );
        },
      );
    }

    return SizedBox(
      width: 38,
      height: 32,
      child: OutlinedButton(
        onPressed: _onAddToCartWithOptimistic,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.22)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: colorScheme.onSurface,
        ),
        child: const Icon(Icons.add, size: 18),
      ),
    );
  }

  Widget _buildStepper({
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required num qty,
    required bool decrementEnabled,
    required Future<void> Function() onDecrement,
    required VoidCallback onIncrement,
  }) {
    if (_isMposCatalogRow) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: PosTokens.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _mposQtyTap(
              icon: Icons.remove_rounded,
              onTap: decrementEnabled ? () async => onDecrement() : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                qty.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            _mposQtyTap(icon: Icons.add_rounded, onTap: onIncrement),
          ],
        ),
      );
    }

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: decrementEnabled ? () async => onDecrement() : null,
              icon: const Icon(Icons.remove, size: 18),
              color: decrementEnabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withValues(alpha: 0.35),
              tooltip: 'Decrease quantity',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              qty.toString(),
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onIncrement,
              icon: const Icon(Icons.add, size: 18),
              color: colorScheme.onSurface,
              tooltip: 'Increase quantity',
            ),
          ),
        ],
      ),
    );
  }

  Widget _mposQtyTap({required IconData icon, VoidCallback? onTap}) {
    return SizedBox(
      width: 36,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _decrementVariantFromCart({
    required String transactionId,
    required String variantId,
  }) {
    final matching = ref
        .read(posCartDisplayItemsProvider)
        .where((it) => it.active != false && it.variantId == variantId)
        .toList();
    final persisted = matching
        .where((it) => !OptimisticCartIds.isOptimistic(it.id))
        .toList();
    if (persisted.isNotEmpty) {
      unawaited(
        _decrementOne(transactionId: transactionId, matchingItems: persisted),
      );
      return;
    }

    final txnForOpt = transactionId.isNotEmpty
        ? transactionId
        : (ref.read(posCartMergeTxnIdProvider(widget.isOrdering)));
    if (txnForOpt.isEmpty) return;

    ref.read(optimisticCartProvider.notifier).rollbackPending(
          transactionId: txnForOpt,
          variantId: variantId,
        );
    ref.read(optimisticOrderCountProvider.notifier).decrement();
  }

  Future<void> _decrementOne({
    required String transactionId,
    required List<TransactionItem> matchingItems,
  }) async {
    if (matchingItems.isEmpty) return;

    // Prefer decrementing an item with qty > 1; otherwise delete one row
    // (handles the case where the same variant exists as multiple qty=1 rows).
    matchingItems.sort((a, b) {
      final aq = a.qty;
      final bq = b.qty;
      return bq.compareTo(aq);
    });

    final item = matchingItems.first;
    final currentQty = item.qty;

    try {
      if (currentQty > 1) {
        await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
          qty: (currentQty - 1).toDouble(),
          transactionItemId: item.id,
          ignoreForReport: false,
        );
      } else {
        await ProxyService.getStrategy(Strategy.capella).deleteItemFromCart(
          transactionItemId: item,
          transactionId: transactionId,
        );
      }
    } catch (e) {
      // Keep UI resilient; errors are surfaced via existing global handlers/logging.
      talker.error('Failed to decrement item: $e');
    }
  }

  Widget _buildProductImageSection(bool isSelected) {
    return Hero(
      tag:
          widget.variant?.id ??
          widget.product?.id ??
          'product_image_${widget.product?.id}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(imageBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageBorderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Product color background
              if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: widget.color.isEmpty
                        ? posTileColorForName(widget.productName)
                        : HexColor(widget.color),
                    borderRadius: BorderRadius.circular(imageBorderRadius),
                  ),
                  child: Center(
                    child: Text(
                      widget.variantName.isNotEmpty
                          ? (widget.variantName.length > 3
                                ? widget.variantName.substring(0, 3)
                                : widget.variantName)
                          : (widget.productName.length > 3
                                ? widget.productName.substring(0, 3)
                                : widget.productName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Product image
              if (widget.imageUrl?.isNotEmpty == true) _buildImage(),

              // Selection indicator overlay
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Removed unused methods _buildProductInfoSection and _buildPriceAndStockInfo
  // to fix lint warnings and prevent potential regression issues

  Widget _buildImage() {
    final imageUrl = widget.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImageErrorPlaceholder();
    }

    _cachedLocalImageFuture ??= _resolveLocalImagePath(imageUrl);
    return FutureBuilder<String?>(
      key: ValueKey('local-${widget.variant?.id}-$imageUrl'),
      future: _cachedLocalImageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildImageLoadingIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            File(snapshot.data!),
            key: ValueKey('file-${snapshot.data}'),
            fit: BoxFit.cover,
            cacheWidth: 300,
            cacheHeight: 300,
            errorBuilder: (context, error, stackTrace) {
              // If local file fails, try remote URL
              return _buildRemoteImageFallback();
            },
          );
        }
        return _buildRemoteImageFallback();
      },
    );
  }

  Widget _buildRemoteImageFallback() {
    if (_branchId == null) {
      return _buildImageErrorPlaceholder();
    }

    // Return cached widget if available
    if (_cachedImageWidget != null) {
      return _cachedImageWidget!;
    }

    _cachedRemoteUrlFuture ??= preSignedUrl(
      imageInS3: widget.imageUrl!,
      branchId: _branchId!,
    );

    return FutureBuilder<String>(
      key: ValueKey('remote-${widget.imageUrl}-${_branchId}'),
      future: _cachedRemoteUrlFuture,
      builder: (context, remoteSnapshot) {
        if (remoteSnapshot.connectionState == ConnectionState.waiting) {
          return _buildImageLoadingIndicator();
        } else if (remoteSnapshot.hasError) {
          talker.error('Error loading remote image: ${remoteSnapshot.error}');
          return _buildImageErrorPlaceholder();
        } else if (remoteSnapshot.hasData) {
          // Cache the widget to prevent rebuilds
          _cachedImageWidget ??= RepaintBoundary(
            child: CachedNetworkImage(
              useOldImageOnUrlChange: true,
              key: ValueKey('cached-${remoteSnapshot.data}'),
              imageUrl: remoteSnapshot.data!,
              fit: BoxFit.cover,
              memCacheWidth: 300,
              memCacheHeight: 300,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (context, url) => _buildImageLoadingIndicator(),
              errorWidget: (context, url, error) {
                talker.error('CachedNetworkImage error: $error');
                return _buildImageErrorPlaceholder();
              },
            ),
          );
          return _cachedImageWidget!;
        } else {
          return _buildImageErrorPlaceholder();
        }
      },
    );
  }

  Widget _buildImageLoadingIndicator() {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 24,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 2),
          Text(
            'No Image',
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// One hop: optimistic cart + background Ditto ([posCartAddServiceProvider]).
  void _onAddToCartWithOptimistic() {
    final v = widget.variant;
    if (v == null) return;
    ref.read(posCartAddServiceProvider).tapAdd(
      context: context,
      variant: v,
      isOrdering: widget.isOrdering,
      product: widget.product,
      isComposite: widget.isComposite,
    );
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    Directory appSupportDir = await getApplicationSupportDirectory();

    final imageFilePath = '${appSupportDir.path}/$imageFileName';
    final file = File(imageFilePath);

    if (await file.exists()) {
      return imageFilePath;
    } else {
      return null;
    }
  }

  Future<String?> _resolveLocalImagePath(String assetName) async {
    final localPath = await getImageFilePath(imageFileName: assetName);
    if (localPath != null) return localPath;
    return _tryLoadFromAssetPath(assetName);
  }

  // Try to load an image from the asset's localPath in the database
  Future<String?> _tryLoadFromAssetPath(String assetName) async {
    try {
      // Look up the asset in the database
      final asset = await ProxyService.strategy.getAsset(assetName: assetName);

      // If the asset exists and has a local path, return it
      if (asset != null &&
          asset.localPath != null &&
          asset.localPath!.isNotEmpty) {
        final file = File(asset.localPath!);
        if (await file.exists()) {
          return asset.localPath!;
        }
      }

      // Lazy download from S3 if missing locally (new device). Share the same
      // in-flight download across all rows that render the same product image.
      try {
        final downloadKey = '${_branchId ?? ''}/$assetName';
        _assetDownloadCache[downloadKey] ??= _downloadAsset(assetName);
        try {
          await _assetDownloadCache[downloadKey];
        } catch (_) {
          _assetDownloadCache.remove(downloadKey);
          rethrow;
        }

        final downloaded = await getImageFilePath(imageFileName: assetName);
        if (downloaded != null) return downloaded;
      } catch (e) {
        // Best-effort; remote URL fallback will still work when online.
        talker.error('Error downloading asset from S3: $e');
      }
      return null;
    } catch (e) {
      talker.error('Error loading asset from local path: $e');
      return null;
    }
  }

  Future<void> _downloadAsset(String assetName) async {
    final branchId = _branchId;
    final stream = branchId == null || branchId.isEmpty
        ? await ProxyService.strategy.downloadAssetSave(
            assetName: assetName,
            subPath: 'branch',
          )
        : await ProxyService.strategy.downloadAsset(
            branchId: branchId,
            assetName: assetName,
            subPath: 'branch',
          );
    await for (final p in stream) {
      if (p >= 100) break;
    }
  }

  Future<String> preSignedUrl({
    required String imageInS3,
    required String branchId,
  }) async {
    try {
      final filePath = 'public/branch-$branchId/$imageInS3';
      talker.warning("GettingPreSignedURL:$filePath");

      final file = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(filePath),
        options: StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence:
                false, // Don't validate existence to avoid delays
            expiresIn: Duration(minutes: 30),
          ),
        ),
      ).result;

      final url = file.url.toString();
      talker.info('Generated presigned URL: $url');
      return url;
    } catch (e) {
      talker.error('Error generating presigned URL: $e');
      rethrow;
    }
  }

  Future<void> onRowClick(BuildContext context) async {
    if (widget.addFavoriteMode == true) {
      String? position = positionString[int.parse(widget.favIndex!)];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Favorite'),
            content: Text(
              'You are about to add ${widget.productName} to your $position favorite position.\n\nDo you approve?',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: const Text('Yes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => {
                  widget.model.addFavorite(
                    favIndex: widget.favIndex!,
                    productId: widget.product!.id,
                  ),
                  widget.model.rebuildUi(),
                  Navigator.of(context).pop(),
                  Navigator.of(context).pop(),
                },
              ),
            ],
          );
        },
      );
    } else {
      if (widget.variant == null) {
        _routerService.navigateTo(SellRoute(product: widget.product!));
      }
    }
  }

  Widget _buildFloatingActionButtons(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Delete button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: colorScheme.error,
              size: 20,
            ),
            tooltip: 'Delete',
            onPressed: () async {
              if (widget.variant != null) {
                final strategy = ProxyService.getStrategy(Strategy.capella);
                final stock = await strategy.getStockById(
                  id: widget.variant!.stockId!,
                );
                final businessId = ProxyService.box.getBusinessId();
                final branchId = ProxyService.box.getBranchId();

                final isEbmEnabled =
                    businessId != null &&
                    branchId != null &&
                    await ProxyService.strategy.isTaxEnabled(
                      businessId: businessId,
                      branchId: branchId,
                    );

                if ((stock.currentStock ?? 0) > 0 &&
                    isEbmEnabled &&
                    !kDebugMode) {
                  final dialogService = locator<DialogService>();
                  dialogService.showCustomDialog(
                    variant: DialogType.info,
                    title: 'Error',
                    description: 'Cannot delete a variant with stock.',
                    data: {'status': InfoDialogStatus.error},
                  );
                  return;
                }

                // PIN Verification
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

                widget.delete(widget.variant!.id, 'variant');
              }
            },
          ),

          // Edit button
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
            tooltip: 'Edit',
            onPressed: () async {
              // PIN Verification
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

              if (widget.variant != null) {
                widget.edit(widget.variant?.productId, 'product');
              } else if (widget.product != null) {
                widget.edit(widget.product?.id, 'product');
              }
            },
          ),
        ],
      ),
    );
  }
}
