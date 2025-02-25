// ignore_for_file: unused_result

import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/flipperWatch.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flipper_models/providers/transactions_provider.dart';

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

  RowItem({
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
    with Refresh, CoreMiscellaneous {
  final _routerService = locator<RouterService>();
  // Constants for consistent sizing
  static const double borderRadius = 8.0;
  static const double contentPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedItemIdProvider);
    final isSelected = selectedItem == widget.variant?.id ||
        widget.product?.id == selectedItem;

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, c) {
        return Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withAlpha((0.05 * 255).toInt())
                : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2.0)
                : Border.all(color: Colors.grey.withAlpha((0.1 * 255).toInt())),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).toInt()),
                blurRadius: 4.0,
                spreadRadius: 0.5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: () async {
                if (isSelected) {
                  ref.read(selectedItemIdProvider.notifier).state =
                      NO_SELECTION;
                } else {
                  final flipperWatch? w = kDebugMode
                      ? flipperWatch("onAddingItemToQuickSell")
                      : null;
                  w?.start();
                  await onTapItem(model: model, isOrdering: widget.isOrdering);
                  w?.log("Item Added to Quick Sell");
                }
              },
              onLongPress: () {
                final itemId = widget.variant?.id ?? widget.product?.id;
                if (itemId != null) {
                  if (selectedItem == itemId) {
                    ref.read(selectedItemIdProvider.notifier).state =
                        NO_SELECTION;
                  } else {
                    ref.read(selectedItemIdProvider.notifier).state = itemId;
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(contentPadding),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Use a Stack to overlay the colored container and image
                      Expanded(
                        child: Hero(
                          tag: widget.variant?.id ??
                              widget.product?.id ??
                              'product_image',
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadius - 4),
                            child: AspectRatio(
                              aspectRatio:
                                  1.0, // Square aspect ratio for consistency
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Colored Container (takes the whole space when no image)
                                  if (widget.imageUrl?.isEmpty ?? true)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: HexColor(widget.color.isEmpty
                                            ? "#FF0000"
                                            : widget.color),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            widget.productName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Image (overlayed on top of the colored container when present)
                                  if (widget.imageUrl?.isNotEmpty == true)
                                    _buildImage(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      _buildProductDetails(isComposite: widget.isComposite),
                      // Add row for actions when selected
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () {
                                  if (widget.variant != null) {
                                    widget.delete(
                                        widget.variant?.productId, 'product');
                                  } else if (widget.product != null) {
                                    widget.delete(
                                        widget.product?.id, 'product');
                                  }
                                },
                              ),
                              const SizedBox(width: 16.0),
                              _buildActionButton(
                                icon: Icons.edit,
                                color: Colors.blue,
                                onPressed: () {
                                  if (widget.variant != null) {
                                    widget.edit(
                                        widget.variant?.productId, 'product');
                                  } else if (widget.product != null) {
                                    widget.edit(widget.product?.id, 'product');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return (widget.forceRemoteUrl)
        ? FutureBuilder<String>(
            future: preSignedUrl(
                branchId: widget.variant!.branchId!,
                imageInS3: widget.imageUrl!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return _buildImageErrorPlaceholder();
              } else {
                return Image.network(
                  snapshot.data!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageErrorPlaceholder();
                  },
                );
              }
            },
          )
        : FutureBuilder<String?>(
            future: getImageFilePath(imageFileName: widget.imageUrl!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Image.file(
                  File(snapshot.data!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImageErrorPlaceholder();
                  },
                );
              } else {
                return _buildImageErrorPlaceholder();
              }
            },
          );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 32,
              color: Colors.grey[500],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails({required bool isComposite}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.productName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4.0),

        // Variant name if different from product name
        if (widget.variantName != widget.productName &&
            widget.variantName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.variantName,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Stock information
        if (!isComposite && widget.stock != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Text(
                  "Stock: ",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  "${widget.stock}",
                  style: TextStyle(
                    color:
                        widget.stock < 10 ? Colors.orange[700] : Colors.black87,
                    fontSize: 14.0,
                    fontWeight:
                        widget.stock < 10 ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

        // Price information
        if (widget.variant?.retailPrice != null &&
            widget.variant?.retailPrice != 0)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: _buildPrices(),
          ),
      ],
    );
  }

  Widget _buildPrices() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        (widget.variant?.retailPrice ?? 0).toRwf(),
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Rest of the methods remain unchanged
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

  Future<void> onTapItem({
    required CoreViewModel model,
    required bool isOrdering,
  }) async {
    try {
      final flipperWatch? w = kDebugMode ? flipperWatch("callApiWatch") : null;
      w?.start();
      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;

      // Update isOrdering flag
      ProxyService.box.writeBool(key: 'isOrdering', value: isOrdering);

      // Manage transaction
      final pendingTransaction =
          ref.watch(pendingTransactionStreamProvider(isExpense: isOrdering));

      // Fetch product details
      final product = await ProxyService.strategy.getProduct(
        businessId: businessId,
        id: widget.variant!.productId!,
        branchId: branchId,
      );

      if (product != null && product.isComposite == true) {
        // Handle composite product
        final composites =
            await ProxyService.strategy.composites(productId: product.id);

        for (final composite in composites) {
          final variant =
              await ProxyService.strategy.getVariant(id: composite.variantId!);
          if (variant != null) {
            await model.saveTransaction(
              variation: variant,
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
        await model.saveTransaction(
          variation: widget.variant!,
          amountTotal: widget.variant?.retailPrice ?? 0,
          customItem: false,
          currentStock: widget.variant!.stock?.currentStock ?? 0,
          pendingTransaction: pendingTransaction.value!,
          partOfComposite: false,
        );
      }
      w?.log("TapOnItemAndSaveTransaction");
      // Ensure transaction items are refreshed immediately
      refreshTransactionItems(transactionId: pendingTransaction.value!.id);
    } catch (e, s) {
      talker.warning("Error while clicking: $e");
      talker.error(s);
      rethrow;
    }
  }

  Future<void> onRowClick(BuildContext context) async {
    if (widget.addFavoriteMode != null && widget.addFavoriteMode == true) {
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
}
