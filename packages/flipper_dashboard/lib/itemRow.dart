import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
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

  const RowItem({
    Key? key,
    required this.color,
    required this.productName,
    required this.variantName,
    required this.stock,
    required this.forceRemoteUrl,
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

  // Constants for consistent styling
  static const double cardBorderRadius = 12.0;
  static const double imageBorderRadius = 10.0;
  static const double contentPadding = 12.0;
  static const int animationDuration = 200;

  // Image loading state management
  Future<String>? _cachedRemoteUrlFuture;
  Future<String?>? _cachedLocalPathFuture;
  String? _imageUrl;
  int? _branchId;
  final _lock = Lock();

  @override
  void initState() {
    super.initState();
    _initImageCache();
  }

  void _initImageCache() {
    if (widget.imageUrl != null) {
      _imageUrl = widget.imageUrl;
      if (widget.forceRemoteUrl && widget.variant?.branchId != null) {
        _branchId = widget.variant!.branchId!;
        _cachedRemoteUrlFuture = _lock.synchronized(
            () => preSignedUrl(branchId: _branchId!, imageInS3: _imageUrl!));
      } else {
        _cachedLocalPathFuture = _lock
            .synchronized(() => getImageFilePath(imageFileName: _imageUrl!));
      }
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
                ? colorScheme.primaryContainer.withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : Colors.grey.withOpacity(0.12),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.04),
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
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 80, // Fixed minimum height
                        maxHeight: 220, // Add maximum height constraint
                      ),
                      child:
                          _buildItemContent(isSelected, textTheme, colorScheme),
                    ),
                  ),

                  // Overlay action buttons when selected
                  if (isSelected)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _buildFloatingActionButtons(colorScheme),
                    ),
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
    return SingleChildScrollView(
      // Add SingleChildScrollView to handle any potential overflow
      physics: const NeverScrollableScrollPhysics(), // Disable actual scrolling
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section - Fixed height to prevent overflow
          AspectRatio(
            aspectRatio: 16 / 10, // Slightly taller image
            child: _buildProductImageSection(isSelected),
          ),

          const SizedBox(height: 6), // Reduced spacing

          // Product Info Section - Handle varying content
          _buildProductInfoSection(textTheme),

          // Action Buttons (only when selected)
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 4), // Reduced top padding
              child: _buildActionButtonsSection(colorScheme),
            ),
        ],
      ),
    );
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
              color: Colors.black.withOpacity(0.05),
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
                          color: Colors.black.withOpacity(0.2),
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

  Widget _buildProductInfoSection(TextTheme textTheme) {
    // Get appropriate display names with safe fallbacks
    final String displayProductName =
        widget.productName.isNotEmpty ? widget.productName : "Unnamed Product";

    final String displayVariantName =
        widget.variantName.isNotEmpty ? widget.variantName : "Default Variant";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product name - Ensure it fits with ellipsis
        Text(
          displayProductName.length > 20
              ? '${displayProductName.substring(0, 20)}...'
              : displayProductName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Product variant (if different from name)
        if (displayVariantName != displayProductName)
          Text(
            displayVariantName.length > 12
                ? '${displayVariantName.substring(0, 12)}...'
                : displayVariantName,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        const SizedBox(height: 8),

        // Price and stock info - Using Wrap to handle overflow gracefully
        _buildPriceAndStockInfo(textTheme),
      ],
    );
  }

  Widget _buildPriceAndStockInfo(TextTheme textTheme) {
    // List of indicators to show
    final List<Widget> indicators = [];

    // Price tag
    if (widget.variant?.retailPrice != null &&
        widget.variant?.retailPrice != 0) {
      indicators.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            (widget.variant?.retailPrice ?? 0).toRwf(),
            style: textTheme.labelSmall?.copyWith(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Stock indicator
    if (!widget.isComposite && widget.stock != 0) {
      indicators.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: widget.stock < 10
                ? Colors.orange.withOpacity(0.12)
                : Colors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 10,
                color:
                    widget.stock < 10 ? Colors.orange[700] : Colors.green[700],
              ),
              const SizedBox(width: 2),
              Text(
                "${widget.stock}",
                style: textTheme.labelSmall?.copyWith(
                  color: widget.stock < 10
                      ? Colors.orange[700]
                      : Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Responsive layout for stock/price indicators
    final isMobile = MediaQuery.of(context).size.shortestSide < 600;
    if (isMobile) {
      // On mobile, stack vertically for visibility and reduce font size/padding
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: indicators
            .map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 11),
                    child: w,
                  ),
                ))
            .toList(),
      );
    } else {
      // On desktop/tablet, use the original Wrap
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: indicators,
      );
    }
  }

  Widget _buildActionButtonsSection(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Delete button
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'Delete',
            color: colorScheme.error,
            onPressed: () {
              if (widget.variant != null) {
                widget.delete(widget.variant?.productId, 'product');
              } else if (widget.product != null) {
                widget.delete(widget.product?.id, 'product');
              }
            },
          ),

          const SizedBox(width: 8),

          // Edit button
          _buildActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit',
            color: colorScheme.primary,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6), // Reduced radius
      child: InkWell(
        borderRadius: BorderRadius.circular(6), // Reduced radius
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4), // Reduced padding
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 12), // Smaller icon
              const SizedBox(width: 3), // Reduced spacing
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10, // Smaller font
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon-only button for even more compact display
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            color: color,
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageUrl == null) {
      return _buildImageErrorPlaceholder();
    }

    return (widget.forceRemoteUrl)
        ? FutureBuilder<String>(
            key: ValueKey('remote-${widget.variant?.id}-${widget.imageUrl}'),
            future: _cachedRemoteUrlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildImageLoadingIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return _buildImageErrorPlaceholder();
              } else {
                return CachedNetworkImage(
                  key: ValueKey('cached-${snapshot.data}'),
                  imageUrl: snapshot.data!,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  memCacheHeight: 300,
                  placeholder: (context, url) => _buildImageLoadingIndicator(),
                  errorWidget: (context, url, error) =>
                      _buildImageErrorPlaceholder(),
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
      showCustomSnackBar(context, 'Adding item to cart...',
          backgroundColor: Colors.black);

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
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        /// because item of tax type D are not supposed to have stock so it can be sold without stock.
        if (widget.variant?.taxTyCd != "D" &&
            widget.variant?.stock?.currentStock == null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          toast("You do not have enough stock");
          return;
        }
        if (widget.variant?.taxTyCd != "D" &&
            (widget.variant?.stock?.currentStock ?? 0) <= 0) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
            amountTotal: widget.variant?.retailPrice ?? 0,
            customItem: false,
            currentStock: widget.variant!.stock?.currentStock ?? 0,
            pendingTransaction: pendingTransaction.value!,
            partOfComposite: false,
          );
        }
      });

      // Hide the loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      talker.warning("Error while clicking: $e");
      talker.error(s);
      toast("Failed to add item to cart");
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
        color: Colors.white.withOpacity(0.9),
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
            onPressed: () {
              if (widget.variant != null) {
                widget.delete(widget.variant?.productId, 'product');
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
