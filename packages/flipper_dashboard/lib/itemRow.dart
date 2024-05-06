import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_dashboard/text_drawable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

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
  11: 'twelvth',
  12: 'thirteenth',
  13: 'fourteenth',
  14: 'fifteenth',
  15: 'sixteenth'
};
typedef void DeleteProductFunction(int? id, String type);
typedef void DeleteVariantFunction(int? id, String type);

class RowItem extends StatefulHookConsumerWidget {
  final String color;
  final String name;
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
  RowItem({
    Key? key,
    required this.color,
    required this.name,
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
    return Column(
      children: [
        SizedBox(
          height: 0.5,
        ),
        Slidable(
          key: Key('slidable-${widget.product?.id ?? widget.variant?.id}'),
          child: InkWell(
            onTap: () {
              onRowClick(context);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        "${widget.stock}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                _buildPrices(),
              ],
            ),
          ),
          startActionPane: _buildStartActionPane(),

          /// when add to menu is given then we have one swiping option therefore
          /// disable the bellow swipe
          endActionPane:
              widget.addToMenu == null ? null : _buildEndActionPane(),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 58,
      child: widget.imageUrl?.isEmpty ?? true
          ? TextDrawable(
              backgroundColor:
                  HexColor(widget.color.isEmpty ? "#FF0000" : widget.color),
              text: widget.name,
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
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }

  Widget _buildPrices() {
    return Container(
      width: 80,
      child: StreamBuilder<List<Variant>>(
        stream: ProxyService.realm.getVariantByProductIdStream(
          productId: widget.product?.id ?? widget.variant?.productId ?? 0,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final variants = snapshot.data ?? [];
          final nonZeroPrice = variants
              .firstWhere(
                (variant) => variant.retailPrice != 0,
              )
              .retailPrice;

          return Text(
            'RWF ${NumberFormat('#,###').format(nonZeroPrice)}',
            style: const TextStyle(color: Colors.black),
          );
        },
      ),
    );
  }

  // Widget _buildPrices() {
  //   return Container(
  //     width: 80,
  //     child: FutureBuilder<List<Variant>>(
  //       future: ProxyService.isar.getVariantByProductId(
  //         productId: widget.product?.id,
  //       ),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return SizedBox.shrink();
  //         }

  //         final variants = snapshot.data ?? [];

  //         double firstNonZeroRetailPrice = 0;

  //         for (var variant in variants) {
  //           if (variant.retailPrice != 0) {
  //             firstNonZeroRetailPrice = variant.retailPrice;
  //             break;
  //           }
  //         }

  //         return Text(
  //           'RWF ${NumberFormat('#,###').format(firstNonZeroRetailPrice)}',
  //           style: const TextStyle(color: Colors.black),
  //         );
  //       },
  //     ),
  //   );
  // }

  ActionPane _buildStartActionPane() {
    return ActionPane(
      motion: ScrollMotion(
        key: Key('dismissable-${widget.product?.id ?? widget.variant?.id}'),
      ),
      children: [
        SlidableAction(
          onPressed: (_) {
            if (widget.addToMenu == null) {
              if (widget.product?.id == null) {
                widget.deleteVariant(widget.variant?.id!, 'variant');
              } else {
                widget.deleteProduct(widget.product?.id!, 'product');
              }
            } else {
              widget.addToMenu!(widget.product ?? widget.variant);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: widget.addToMenu == null
              ? FluentIcons.delete_20_regular
              : FluentIcons.cart_24_regular,
          label: '',
        ),
        if (widget.variant == null)
          SlidableAction(
            onPressed: (_) {
              widget.edit(widget.product?.id ?? widget.variant?.id);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: FluentIcons.edit_24_regular,
            label: '',
          ),
        if (widget.variant == null)
          SlidableAction(
            onPressed: (_) {
              widget.enableNfc(widget.product);
            },
            backgroundColor:
                widget.product?.nfcEnabled == true ? Colors.blue : Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.nfc,
            label: '',
          ),
      ],
    );
  }

  ActionPane _buildEndActionPane() {
    return ActionPane(
      motion: ScrollMotion(
        key: Key('dismissable-${widget.product?.id ?? widget.variant?.id}'),
      ),
      children: [
        SlidableAction(
          onPressed: (_) {
            widget.edit(widget.product?.id ?? widget.variant?.id);
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: FluentIcons.edit_24_regular,
          label: '',
        ),
      ],
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
              'You are about to add ${widget.name} to your $position favorite position.\n\nDo you approve?',
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
