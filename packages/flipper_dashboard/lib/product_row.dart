import 'package:cached_network_image/cached_network_image.dart';
import 'package:flipper_login/colors.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

import 'package:go_router/go_router.dart';

class ProductRow extends StatelessWidget {
  const ProductRow({
    Key? key,
    required this.color,
    required this.name,
    required this.hasImage,
    this.imageUrl,
    required this.stocks,
    required this.addToMenu,
    required this.product,
    required this.edit,
    required this.enableNfc,
    required this.model,
    required this.delete,
  }) : super(key: key);
  final String color;
  final String name;
  final bool hasImage;
  final String? imageUrl;
  final Product product;
  final Function delete;
  final Function addToMenu;
  final Function edit;
  final Function enableNfc;
  final ProductViewModel model;
  final List<Stock?> stocks;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('slidable-${product.id!}'),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push(Routes.sell, extra: product);
        },
        onLongPress: () {
          GoRouter.of(context).push(Routes.sell, extra: product);
        },
        child: Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            leading: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: 58,
              child: !hasImage
                  ? TextDrawable(
                      backgroundColor: HexColor(color),
                      text: name,
                      isTappable: true,
                      onTap: null,
                      boxShape: BoxShape.rectangle,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
            title: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              stocks.isNotEmpty
                  ? 'In stock ' + stocks[0]!.currentStock.toString()
                  : 'In stock 0.0',
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Container(
              width: 80,
              child: stocks.isEmpty
                  ? const Text(
                      ' Prices',
                      style: TextStyle(color: Colors.black),
                    )
                  : product.variants.isNotEmpty && product.variants.length > 1
                      ? const Text(
                          ' Prices',
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          'RWF ' + stocks.first!.retailPrice.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
            ),
          ),
        ),
      ),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: ScrollMotion(
          key: Key('dismissable-${product.id!}'),
        ),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) {
              delete(product.id!);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {
              edit(product.id!);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              enableNfc(product);
            },
            backgroundColor: product.nfcEnabled != null && product.nfcEnabled!
                ? Colors.blue
                : Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.nfc,
            label: 'NFC',
          )
        ],
      ),
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: ScrollMotion(
          key: Key('dismissable-${product.id!}'),
        ),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) {
              delete(product.id!);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) {
              edit(product.id!);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          )
        ],
      ),
    );
  }
}
