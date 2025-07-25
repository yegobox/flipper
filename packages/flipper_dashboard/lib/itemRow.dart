import 'dart:io';
import 'dart:math' as math;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/cache/cache_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_routing/app.dialogs.dart';

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
  15: 'sixteenth'
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

  const RowItem({
    Key? key,
    required this.color,
    required this.productName,
    required this.variantName,
    required this.stock,
    required this.forceRemoteUrl,
    required this.forceListView,
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
  static const double cardBorderRadius = 12.0;
  static const double imageBorderRadius = 10.0;
  static const double contentPadding = 12.0;
  static const int animationDuration = 200;

  // Image loading state management
  Future<String>? _cachedRemoteUrlFuture;
  Future<String?>? _cachedLocalPathFuture;
  // Cache for asset path lookup to prevent unnecessary reloading
  Future<String?>? _cachedAssetPathFuture;
  String? _imageUrl;
  int? _branchId;
  final _lock = Lock();

  @override
  void initState() {
    super.initState();
    _initImageCache();
  }

  void _initImageCache() {
    try {
      _imageUrl = widget.imageUrl;
      _branchId = ProxyService.box.getBranchId();

      if (_imageUrl != null && _imageUrl!.isNotEmpty && _branchId != null) {
        // Initialize image loading futures
        _cachedRemoteUrlFuture = preSignedUrl(
          imageInS3: _imageUrl!,
          branchId: _branchId!,
        );

        // Try to load from asset path
        if (!widget.forceRemoteUrl) {
          _cachedAssetPathFuture = _tryLoadFromAssetPath(_imageUrl!);
        }
      }
    } catch (e) {
      talker.error('Error initializing image cache: $e');
    }
  }

  /// Get a stream of stock updates for the current variant from cache
  /// This provides live updates when stock changes
  Stream<Stock?> _getStockStreamForVariant() {
    // Skip if variant is null or has no ID
    if (widget.variant == null || widget.variant!.id.isEmpty) {
      return Stream.value(null);
    }

    try {
      // Get a stream of stock updates from cache using variant ID
      return CacheManager().watchStockByVariantId(widget.variant!.id);
    } catch (e) {
      print('Error setting up stock stream from cache: $e');
      return Stream.value(null);
    }
  }

  @override
  void didUpdateWidget(RowItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl ||
        (widget.variant?.branchId != oldWidget.variant?.branchId)) {
      _imageUrl = widget.imageUrl;
      _branchId = widget.variant?.branchId;

      if (widget.imageUrl != null) {
        if (widget.forceRemoteUrl && widget.variant?.branchId != null) {
          _cachedRemoteUrlFuture = _lock.synchronized(
              () => preSignedUrl(branchId: _branchId!, imageInS3: _imageUrl!));
        } else {
          _cachedLocalPathFuture = _lock
              .synchronized(() => getImageFilePath(imageFileName: _imageUrl!));
        }

        // Update the asset path cache when the image URL changes
        _cachedAssetPathFuture =
            _lock.synchronized(() => _tryLoadFromAssetPath(_imageUrl!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedItemIdProvider);
    final isSelected = selectedItem == widget.variant?.id ||
        widget.product?.id == selectedItem;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Check if we should use list view mode
    final deviceType = DeviceType.getDeviceType(context);
    final bool useListView = deviceType == 'Phone' ||
        (widget.forceListView &&
            deviceType !=
                'Desktop'); // Use list view on phones or when forced (except on desktop)

    // Debug the selection state
    if (isSelected) {
      talker.debug(
          "Card is selected: ${widget.variant?.id ?? widget.product?.id}");
    }

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, c) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: animationDuration),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.12),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 8.0 : 4.0,
                spreadRadius: isSelected ? 1.0 : 0.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // Add clipBehavior to ensure no child overflows
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(cardBorderRadius),
              onTap: () async {
                if (isSelected && !widget.isOrdering) {
                  ref.read(selectedItemIdProvider.notifier).state =
                      NO_SELECTION;
                  return;
                }
                final flipperWatch? w =
                    kDebugMode ? flipperWatch("onAddingItemToQuickSell") : null;
                w?.start();
                await onTapItem(model: model, isOrdering: widget.isOrdering);
                w?.log("Item Added to Quick Sell");
              },
              onLongPress: () {
                final itemId = widget.variant?.id ?? widget.product?.id;
                if (itemId != null && !widget.isOrdering) {
                  if (selectedItem == itemId) {
                    ref.read(selectedItemIdProvider.notifier).state =
                        NO_SELECTION;
                  } else {
                    ref.read(selectedItemIdProvider.notifier).state = itemId;
                    // Show a toast to indicate selection
                    toast("Item selected for editing");
                  }
                }
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                        contentPadding - 4), // Further reduced padding
                    child: useListView
                        ? _buildListItemContent(
                            isSelected, textTheme, colorScheme)
                        : _buildItemContent(isSelected, textTheme, colorScheme),
                  ),

                  // Overlay action buttons when selected
                  if (isSelected)
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
      bool isSelected, TextTheme textTheme, ColorScheme colorScheme) {
    // Check if we're on desktop Windows
    final isDesktopWindows = Platform.isWindows;

    return LayoutBuilder(builder: (context, constraints) {
      // Calculate available height for content
      final double maxHeight = constraints.maxHeight;

      // Allocate space for image and info sections
      // Reserve at least 40px for product info to prevent overflow
      final double maxInfoHeight = 50.0; // Minimum height for info section
      final double availableForImage =
          maxHeight - maxInfoHeight - 4; // 4px for spacing

      // Cap image height to prevent overflow
      final double imageHeight = isDesktopWindows
          ? math.min(100, availableForImage) // More conservative on Windows
          : math.min(availableForImage,
              maxHeight * 0.55); // Cap at 55% of available height

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
            child: _buildCompactProductInfo(textTheme),
          ),
        ],
      );
    });
  }

  // New compact product info section specifically designed to avoid overflow
  Widget _buildCompactProductInfo(TextTheme textTheme) {
    // Get appropriate display names with safe fallbacks
    final String displayProductName = _truncateString(
        widget.productName.isNotEmpty ? widget.productName : "Unnamed Product",
        20);

    final String displayVariantName = _truncateString(
        widget.variantName.isNotEmpty ? widget.variantName : "Default Variant",
        20);

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
            fontSize: 11, // Smaller font size
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
              fontSize: 9, // Smaller font size
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Price tag - simplified to avoid overflow
        if (widget.variant?.retailPrice != null &&
            widget.variant?.retailPrice != 0)
          Text(
            (widget.variant?.retailPrice ?? 0).toCurrencyFormatted(
                symbol: ProxyService.box.defaultCurrency()),
            style: textTheme.labelSmall?.copyWith(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        // Stock display with live updates from cache
        StreamBuilder<Stock?>(
          // Use stream from cache for live updates
          stream: _getStockStreamForVariant(),
          builder: (context, snapshot) {
            // Always use cache data when available
            final stockValue = snapshot.data?.currentStock ?? 0;

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
      ],
    );
  }

  Widget _buildListItemContent(
      bool isSelected, TextTheme textTheme, ColorScheme colorScheme) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate available width for product info
      final double maxWidth = constraints.maxWidth;
      final double imageWidth = 70; // Fixed image width
      final double spacing = 8; // Reduced spacing
      final double availableForInfo = maxWidth - imageWidth - spacing;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image - Fixed size for list view
          SizedBox(
            width: imageWidth,
            height: 70,
            child: _buildProductImageSection(isSelected),
          ),

          SizedBox(width: spacing),

          // Product Info - Constrained width
          Container(
            width: availableForInfo,
            constraints: BoxConstraints(maxHeight: 70), // Match image height
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
                      20),
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

                const SizedBox(height: 4), // Reduced spacing

                // Price tag - simplified to avoid overflow
                if (widget.variant?.retailPrice != null &&
                    widget.variant?.retailPrice != 0)
                  Text(
                    (widget.variant?.retailPrice ?? 0).toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency()),
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                // Stock display
                if (widget.variant?.stock?.currentStock != null)
                  Text(
                    '${widget.variant?.stock?.currentStock ?? 0} in stock',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProductImageSection(bool isSelected) {
    return Hero(
      tag: widget.variant?.id ??
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
                    color: HexColor(
                        widget.color.isEmpty ? "#FF0000" : widget.color),
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
                        fontSize: 22.0,
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
    if (widget.imageUrl == null) {
      return _buildImageErrorPlaceholder();
    }

    // Ensure asset path future is initialized
    if (_cachedAssetPathFuture == null && widget.imageUrl != null) {
      _cachedAssetPathFuture =
          _lock.synchronized(() => _tryLoadFromAssetPath(widget.imageUrl!));
    }

    return (widget.forceRemoteUrl)
        ? FutureBuilder<String>(
            key: ValueKey('remote-${widget.variant?.id}-${widget.imageUrl}'),
            future: _cachedRemoteUrlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildImageLoadingIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                // Try to load from local storage if remote fails
                return FutureBuilder<String?>(
                  key: ValueKey('fallback-local-${widget.imageUrl}'),
                  future: _cachedAssetPathFuture!,
                  builder: (context, assetSnapshot) {
                    if (assetSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildImageLoadingIndicator();
                    } else if (assetSnapshot.hasData &&
                        assetSnapshot.data != null) {
                      return Image.file(
                        File(assetSnapshot.data!),
                        key: ValueKey('file-${assetSnapshot.data}'),
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        cacheHeight: 300,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImageErrorPlaceholder(),
                      );
                    } else {
                      return _buildImageErrorPlaceholder();
                    }
                  },
                );
              } else {
                return CachedNetworkImage(
                  key: ValueKey('cached-${snapshot.data}'),
                  imageUrl: snapshot.data!,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  memCacheHeight: 300,
                  placeholder: (context, url) => _buildImageLoadingIndicator(),
                  errorWidget: (context, url, error) {
                    // If network image fails, try local storage
                    return FutureBuilder<String?>(
                      key: ValueKey('error-local-${widget.imageUrl}'),
                      future: _cachedAssetPathFuture!,
                      builder: (context, assetSnapshot) {
                        if (assetSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildImageLoadingIndicator();
                        } else if (assetSnapshot.hasData &&
                            assetSnapshot.data != null) {
                          return Image.file(
                            File(assetSnapshot.data!),
                            key: ValueKey('file-${assetSnapshot.data}'),
                            fit: BoxFit.cover,
                            cacheWidth: 300,
                            cacheHeight: 300,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImageErrorPlaceholder(),
                          );
                        } else {
                          return _buildImageErrorPlaceholder();
                        }
                      },
                    );
                  },
                );
              }
            },
          )
        : FutureBuilder<String?>(
            key: ValueKey('local-${widget.variant?.id}-${widget.imageUrl}'),
            future: _cachedLocalPathFuture,
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
                  errorBuilder: (context, error, stackTrace) =>
                      _buildImageErrorPlaceholder(),
                );
              } else {
                // Try to load from asset's local path in database
                return FutureBuilder<String?>(
                  key: ValueKey('db-local-${widget.imageUrl}'),
                  future: _cachedAssetPathFuture!,
                  builder: (context, assetSnapshot) {
                    if (assetSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildImageLoadingIndicator();
                    } else if (assetSnapshot.hasData &&
                        assetSnapshot.data != null) {
                      return Image.file(
                        File(assetSnapshot.data!),
                        key: ValueKey('file-${assetSnapshot.data}'),
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        cacheHeight: 300,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImageErrorPlaceholder(),
                      );
                    } else {
                      return _buildImageErrorPlaceholder();
                    }
                  },
                );
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
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the methods remain the same
  Future<void> onTapItem({
    required CoreViewModel model,
    required bool isOrdering,
  }) async {
    try {
      // Show immediate visual feedback to indicate the item is being processed
      if (mounted) {
        showCustomSnackBar(context, 'Adding item to cart...',
            backgroundColor: Colors.black);
      }

      final flipperWatch? w = kDebugMode ? flipperWatch("callApiWatch") : null;
      w?.start();
      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      // Update isOrdering flag
      ProxyService.box.writeBool(key: 'isOrdering', value: isOrdering);

      // Manage transaction
      final pendingTransaction =
          ref.read(pendingTransactionStreamProvider(isExpense: isOrdering));

      if (pendingTransaction.value == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        toast("Error: No active transaction");
        return;
      }

      // Fetch product details
      final product = await ProxyService.strategy.getProduct(
        businessId: businessId,
        id: widget.variant!.productId!,
        branchId: branchId,
      );

      // Only check stock if we're not in ordering mode
      if (!isOrdering) {
        // Get the latest stock from cache
        Stock? cachedStock;
        if (widget.variant != null && widget.variant!.id.isNotEmpty) {
          cachedStock =
              await CacheManager().getStockByVariantId(widget.variant!.id);
        }

        // Use cached stock if available, otherwise fall back to variant.stock
        final currentStock =
            cachedStock?.currentStock ?? widget.variant?.stock?.currentStock;

        /// because item of tax type D are not supposed to have stock so it can be sold without stock.
        if (widget.variant?.taxTyCd != "D" &&

            /// itemTyCd is 3 it is a service
            currentStock == null &&
            widget.variant?.itemTyCd != "3") {
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          toast("You do not have enough stock");
          return;
        }
        if (widget.variant?.taxTyCd != "D" &&
            (currentStock ?? 0) <= 0 &&
            widget.variant?.itemTyCd != "3") {
          if (mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          toast("You do not have enough stock");
          return;
        }
      }

      // Use a lock to prevent multiple simultaneous operations
      final lock = Lock();
      await lock.synchronized(() async {
        if (product != null && product.isComposite == true) {
          // Handle composite product
          final composites =
              await ProxyService.strategy.composites(productId: product.id);

          for (final composite in composites) {
            final variant = await ProxyService.strategy
                .getVariant(id: composite.variantId!);
            if (variant != null) {
              await ProxyService.strategy.saveTransactionItem(
                variation: variant,
                doneWithTransaction: false,
                ignoreForReport: false,
                amountTotal: variant.retailPrice!,
                customItem: false,
                currentStock: variant.stock?.currentStock ?? 0,
                pendingTransaction: pendingTransaction.value!,
                partOfComposite: true,
                compositePrice: composite.actualPrice,
              );
            }
          }
        } else {
          // Handle non-composite product
          await ProxyService.strategy.saveTransactionItem(
            variation: widget.variant!,
            doneWithTransaction: false,
            ignoreForReport: false,
            amountTotal: widget.variant?.retailPrice ?? 0,
            customItem: false,
            currentStock: widget.variant!.stock?.currentStock ?? 0,
            pendingTransaction: pendingTransaction.value!,
            partOfComposite: false,
          );
        }
      });

      // Hide the loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Show success message
      // showCustomSnackBar(context, 'Item added to cart');

      // Force refresh the transaction items with a small delay to ensure DB operations complete
      await Future.delayed(Duration(milliseconds: 100));

      // Immediately refresh the transaction items
      await refreshTransactionItems(
          transactionId: pendingTransaction.value!.id);

      // Also explicitly invalidate the provider to force a refresh
      ref.invalidate(transactionItemsStreamProvider(
          transactionId: pendingTransaction.value!.id));

      w?.log("TapOnItemAndSaveTransaction");
    } catch (e, s) {
      // Hide the loading indicator if there was an error
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      talker.warning("Error while clicking: $e");
      talker.error(s);
      toast("Failed to add item to cart");

      GlobalErrorHandler.logError(
        s,
        type: "ITEM-ADD-EXCEPTION",
        context: {
          'resultCode': e,
          'businessId': ProxyService.box.getBusinessId(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      rethrow;
    }
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    Directory appSupportDir = await getSupportDir();

    final imageFilePath = path.join(appSupportDir.path, imageFileName);
    final file = File(imageFilePath);

    if (await file.exists()) {
      return imageFilePath;
    } else {
      return null;
    }
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
      return null;
    } catch (e) {
      talker.error('Error loading asset from local path: $e');
      return null;
    }
  }

  Future<String> preSignedUrl(
      {required String imageInS3, required int branchId}) async {
    final filePath = 'public/branch-$branchId/$imageInS3';
    talker.warning("GettingPreSignedURL:$filePath");
    final file = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(filePath),
        options: StorageGetUrlOptions(
            pluginOptions: S3GetUrlPluginOptions(
          validateObjectExistence: true,
          expiresIn: Duration(minutes: 30),
        ))).result;
    return file.url.toString();
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
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Delete button
          IconButton(
            icon:
                Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
            tooltip: 'Delete',
            onPressed: () async {
              if (widget.variant != null) {
                final stock = await CacheManager()
                    .getStockByVariantId(widget.variant!.id);
                if (stock != null && stock.currentStock != 0) {
                  final dialogService = locator<DialogService>();
                  dialogService.showCustomDialog(
                    variant: DialogType.info,
                    title: 'Error',
                    description: 'Cannot delete a variant with stock.',
                    data: {'status': InfoDialogStatus.error},
                  );
                  return;
                }
                widget.delete(widget.variant!.productId!, 'product');
              } else if (widget.product != null) {
                widget.delete(widget.product?.id, 'product');
              }
            },
          ),

          // Edit button
          IconButton(
            icon:
                Icon(Icons.edit_outlined, color: colorScheme.primary, size: 20),
            tooltip: 'Edit',
            onPressed: () {
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
