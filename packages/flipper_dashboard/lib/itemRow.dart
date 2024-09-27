// ignore_for_file: unused_result

import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path/path.dart' as path;

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

typedef void DeleteProductFunction(int? id, String type);
typedef void DeleteVariantFunction(int? id, String type);

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
  final int? favIndex;
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

  static _defaultFunction(int? id, String type) {
    print("no function provided for the action");
  }

  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends ConsumerState<RowItem> with Refresh {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedItemIdProvider);
    final isSelected = selectedItem == widget.variant?.id ||
        widget.product?.id == selectedItem;

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, c) {
        return InkWell(
          onTap: () async {
            if (isSelected) {
              ref.read(selectedItemIdProvider.notifier).state = NO_SELECTION;
            } else {
              await onTapItem(model: model, isOrdering: widget.isOrdering);
            }
          },
          onLongPress: () {
            final itemId = widget.variant?.id ?? widget.product?.id;
            if (itemId != null) {
              if (selectedItem == itemId) {
                /// set it to 1 as 1 is not a valid id this will unselect item
                ref.read(selectedItemIdProvider.notifier).state = NO_SELECTION;
              } else {
                ref.read(selectedItemIdProvider.notifier).state = itemId;
              }
            }
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: _buildImage(),
                    ),
                    SizedBox(height: 8.0),
                    _buildProductDetails(isComposite: widget.isComposite),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  left: 8.0,
                  bottom: 8.0,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      if (widget.variant != null) {
                        widget.delete(widget.variant?.productId, 'product');
                      } else if (widget.product != null) {
                        widget.delete(widget.product?.id, 'product');
                      }
                    },
                  ),
                ),
              if (isSelected)
                Positioned(
                  right: 8.0,
                  bottom: 8.0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      if (widget.variant != null) {
                        widget.edit(widget.variant?.productId, 'product');
                      } else if (widget.product != null) {
                        widget.edit(widget.product?.id, 'product');
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onTapItem(
      {required CoreViewModel model, required isOrdering}) async {
    try {
      ITransaction? pendingTransaction = null;
      final branchId = ProxyService.box.getBranchId()!;
      if (isOrdering) {
        /// update is ordering to true
        ProxyService.box.writeBool(key: 'isOrdering', value: true);
        pendingTransaction = ProxyService.realm.manageTransaction(
          transactionType: TransactionType.sale,
          isExpense: true,
          branchId: branchId,
        );
      } else {
        /// update is ordering to true
        ProxyService.box.writeBool(key: 'isOrdering', value: false);
        pendingTransaction = ProxyService.realm.manageTransaction(
          transactionType: TransactionType.sale,
          isExpense: false,
          branchId: branchId,
        );
      }

      /// first check if this item is a composite
      Product? product =
          ProxyService.realm.getProduct(id: widget.variant!.productId!);
      if (product != null &&
          product.isComposite != null &&
          product.isComposite!) {
        /// get items of this composite
        List<Composite> composites =
            ProxyService.realm.composites(productId: product.id!);
        for (Composite composite in composites) {
          /// find a stock for a given variant
          Variant? variant =
              ProxyService.realm.getVariantById(id: composite.variantId!);
          model.saveTransaction(
            variation: variant!,
            amountTotal: variant.retailPrice,
            customItem: false,
            currentStock: variant.stock!.currentStock,
            pendingTransaction: pendingTransaction,
            partOfComposite: true,
            compositePrice: composite.actualPrice,
          );
          refreshTransactionItems(transactionId: pendingTransaction.id!);
        }

        await Future.delayed(Duration(microseconds: 1000));
        ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
      } else {
        double stockQty = 0;
        if (!widget.isOrdering) {
          Stock? stock = ProxyService.realm.stockByVariantId(
              variantId: widget.variant?.id ?? 0,
              branchId: ProxyService.box.getBranchId()!);
          stockQty = stock?.currentStock ?? 0.0;
        }

        model.saveTransaction(
          variation: widget.variant!,
          amountTotal: widget.variant?.retailPrice ?? 0,
          customItem: false,
          currentStock: stockQty,
          pendingTransaction: pendingTransaction,
          partOfComposite: false,
        );

        refreshTransactionItems(transactionId: pendingTransaction.id!);
      }
    } catch (e, s) {
      talker.warning("Error while clicking ${e}");
      talker.error(s);
      rethrow;
    }
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    Directory appSupportDir;
    if (Platform.isAndroid) {
      // Try to get external storage, fall back to internal if not available
      appSupportDir = await getApplicationCacheDirectory();
    } else {
      appSupportDir = await getApplicationCacheDirectory();
    }

    final imageFilePath = path.join(appSupportDir.path, imageFileName);
    final file = File(imageFilePath);

    if (await file.exists()) {
      return imageFilePath;
    } else {
      return null;
    }
  }

  Widget _buildImage() {
    if (widget.imageUrl?.isEmpty ?? true) {
      return Container(
        width: double.infinity,
        color: HexColor(widget.color.isEmpty ? "#FF0000" : widget.color),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productName,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      if (widget.forceRemoteUrl) {
        // get preSigned URL
        return FutureBuilder<String>(
          future: preSignedUrl(
              branchId: widget.variant!.branchId!, imageInS3: widget.imageUrl!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Image.asset(
                  package: 'flipper_dashboard',
                  'assets/default_placeholder.png'); // Replace with your default image path
            } else {
              return Image.network(snapshot.data!);
            }
          },
        );
      } else {
        return FutureBuilder<String?>(
          future: getImageFilePath(imageFileName: widget.imageUrl!),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final imageFilePath = snapshot.data!;

              return Image.file(
                File(imageFilePath),
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 130,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container(
                width: double.infinity,
                height: 130,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[500],
                  ),
                ),
              );
            }
          },
        );
      }
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

  Widget _buildProductDetails({required bool isComposite}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name: ${widget.productName}",
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
        Visibility(
            visible: (!isComposite && widget.stock != 0),
            child: SizedBox(height: 4.0)),
        Visibility(
          visible: (!isComposite && widget.stock != 0), // Use && here
          child: Text(
            "Stock: ${isComposite ? '-' : widget.stock}",
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
          ),
        ),
        Visibility(
            visible: widget.variant?.retailPrice != 0,
            child: SizedBox(height: 4.0)),
        Visibility(
            visible: widget.variant?.retailPrice != 0, child: _buildPrices()),
      ],
    );
  }

  Widget _buildPrices() {
    return Container(
      width: 80,
      child: Text(
        (widget.variant?.retailPrice ?? 0).toRwf(),
        style: const TextStyle(color: Colors.black, fontSize: 14.0),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> onRowClick(BuildContext context) async {
    if (widget.addFavoriteMode != null && widget.addFavoriteMode == true) {
      String? position = positionString[widget.favIndex!];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Favorite'),
            content: Text(
              'You are about to add ${widget.productName} to your $position favorite position.\n\nDo you approve?',
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text(
                  'Yes',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: primaryButtonStyle,
                onPressed: () => {
                  widget.model.addFavorite(
                    favIndex: widget.favIndex!,
                    productId: widget.product!.id!,
                  ),
                  widget.model.rebuildUi(),
                  Navigator.of(context).pop(),
                  Navigator.of(context).pop(),
                },
              ),
              OutlinedButton(
                child: Text(
                  'No',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: primaryButtonStyle,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      if (widget.variant != null) {
        // Copy variant.name to clipboard, handy tool when want to copy name for some use.
        // await Clipboard.setData(ClipboardData(text: widget.variant!.name!));
      }
      if (widget.variant == null) {
        _routerService.navigateTo(SellRoute(product: widget.product!));
      }
    }
  }
}
