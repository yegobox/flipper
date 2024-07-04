// ignore_for_file: unused_result

import 'dart:io';
import 'package:collection/collection.dart';
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
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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
  final Function? addToMenu;
  final String variantName;
  final bool isComposite;

  RowItem({
    Key? key,
    required this.color,
    required this.productName,
    required this.variantName,
    required this.stock,
    this.addToMenu = _defaultFunction,
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
  }) : super(key: key);

  static _defaultFunction(int? id, String type) {
    print("no function provided for the action");
  }

  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends ConsumerState<RowItem> {
  final _routerService = locator<RouterService>();
  bool _showButtons = false;

  @override
  Widget build(BuildContext context) {
    final variantStream = ref.watch(variantStreamProvider(
        widget.product?.id ?? widget.variant?.productId ?? 0));

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, c) {
        return InkWell(
          onTap: () async {
            final pendingTransaction =
                ref.watch(pendingTransactionProvider(TransactionType.sale));

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
                Stock? stock = ProxyService.realm
                    .stockByVariantId(variantId: composite.variantId!);
                Variant? variant =
                    ProxyService.realm.getVariantById(id: composite.variantId!);
                model.saveTransaction(
                  variation: variant!,
                  amountTotal: variant.retailPrice,
                  customItem: false,
                  currentStock: stock!.currentStock,
                  pendingTransaction: pendingTransaction.value!,
                  partOfComposite: true,
                );
              }

              await Future.delayed(Duration(microseconds: 1000));
              ref.refresh(
                  transactionItemsProvider(pendingTransaction.value?.id));

              await Future.delayed(Duration(microseconds: 200));
              ref.refresh(
                  transactionItemsProvider(pendingTransaction.value?.id));
            } else {
              Stock? stock = ProxyService.realm
                  .stockByVariantId(variantId: widget.variant?.id ?? 0);

              model.saveTransaction(
                variation: widget.variant!,
                amountTotal: widget.variant?.retailPrice ?? 0,
                customItem: false,
                currentStock: stock!.currentStock,
                pendingTransaction: pendingTransaction.value!,
                partOfComposite: false,
              );

              await Future.delayed(Duration(microseconds: 1000));
              ref.refresh(
                  transactionItemsProvider(pendingTransaction.value?.id));

              await Future.delayed(Duration(microseconds: 200));
              ref.refresh(
                  transactionItemsProvider(pendingTransaction.value?.id));
            }
          },
          onLongPress: () {
            setState(() {
              _showButtons = !_showButtons;
            });
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _showButtons ? Colors.grey[300] : Colors.white,
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
                    _buildProductDetails(variantStream,
                        isComposite: widget.isComposite),
                  ],
                ),
              ),
              if (_showButtons)
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
              if (_showButtons)
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

  Future<String?> getImageFilePath({required String imageFileName}) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final imageFilePath = '${appSupportDir.path}/${imageFileName}';
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

  Widget _buildProductDetails(AsyncValue<List<Variant>> variantStream,
      {required bool isComposite}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name: ${widget.productName}",
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.0),
        Text(
          "Stock: ${isComposite ? '-' : widget.stock}",
          style: const TextStyle(color: Colors.black, fontSize: 14.0),
        ),
        SizedBox(height: 4.0),
        _buildPrices(variantStream),
      ],
    );
  }

  Widget _buildPrices(AsyncValue<List<Variant>> variantStream) {
    return Container(
      width: 80,
      child: variantStream.when(
        data: (variants) {
          final nonZeroPrice =
              variants.firstWhereOrNull((variant) => variant.retailPrice != 0);

          return Text(
            'RWF ${NumberFormat('#,###').format(nonZeroPrice?.retailPrice ?? 0)}',
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
            overflow: TextOverflow.ellipsis,
          );
        },
        error: (error, stackTrace) => const SizedBox.shrink(),
        loading: () => Text("loading.."),
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
