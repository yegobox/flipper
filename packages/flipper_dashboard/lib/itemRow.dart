// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flipper_dashboard/text_drawable.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final DeleteProductFunction deleteProduct;
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

  RowItem({
    Key? key,
    required this.color,
    required this.productName,
    required this.variantName,
    required this.stock,
    this.addToMenu = _defaultFunction,
    this.deleteProduct = _defaultFunction,
    this.deleteVariant = _defaultFunction,
    this.edit = _defaultFunction,
    this.enableNfc = _defaultFunction,
    required this.model,
    this.imageUrl,
    this.variant,
    this.product,
    this.addFavoriteMode,
    this.favIndex,
  }) : super(key: key);

  static _defaultFunction(int? id, String type) {
    print("no function provided for the action");
  }

  @override
  _RowItemState createState() => _RowItemState();
}

class _RowItemState extends ConsumerState<RowItem> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    final variantStream = ref.watch(variantStreamProvider(
        widget.product?.id ?? widget.variant?.productId ?? 0));

    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, c) {
          return InkWell(
            onTap: () async {
              /// directly add this to cart
              Stock? stock = await ProxyService.realm
                  .stockByVariantId(variantId: widget.variant?.id ?? 0);
              final pendingTransaction =
                  ref.watch(pendingTransactionProvider(TransactionType.sale));

              await model.saveTransaction(
                variation: widget.variant!,
                amountTotal: widget.variant?.retailPrice ?? 0,
                customItem: false,
                currentStock: stock!.currentStock,
                pendingTransaction: pendingTransaction.value!.value!,
              );
              ref.refresh(transactionItemsProvider(
                  pendingTransaction.value?.value?.id));
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  _buildImage(),
                  Text(
                    widget.variantName.length > 10
                        ? widget.variantName.substring(0, 10)
                        : widget.variantName,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.productName,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Stock: ${widget.stock}",
                    style: const TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                  _buildPrices(variantStream),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildImage() {
    return SizedBox(
      width: 130,
      child: widget.imageUrl?.isEmpty ?? true
          ? TextDrawable(
              backgroundColor:
                  HexColor(widget.color.isEmpty ? "#FF0000" : widget.color),
              text: widget.productName,
              isTappable: true,
              onTap: null,
              boxShape: BoxShape.rectangle,
            )
          : CachedNetworkImage(
              imageUrl: widget.imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                  width: 20,
                  height: 20,
                  child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
      // copy variant.name to clipboard, handy tool when want to copy name for some use.
      if (widget.variant != null) {
        await Clipboard.setData(ClipboardData(text: widget.variant!.name!));
      }
      if (widget.variant == null) {
        _routerService.navigateTo(SellRoute(product: widget.product!));
      }
    }
  }
}
