import 'package:flipper/helpers/utils.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:localize/localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class ProductRow extends StatelessWidget {
  const ProductRow(
      {Key? key,
      required this.color,
      required this.name,
      required this.hasImage,
      this.imageUrl,
      required this.stocks,
      required this.addToMenu,
      required this.product,
      required this.edit,
      required this.model,
      required this.delete})
      : super(key: key);
  final String color;
  final String name;
  final bool hasImage;
  final String? imageUrl;
  final ProductSync product;
  final Function delete;
  final Function addToMenu;
  final Function edit;
  final ProductViewModel model;
  final List<StockSync> stocks;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).go(Routes.sell + "/${product.id}");
        },
        onLongPress: () {
          GoRouter.of(context).go(Routes.sell + "/${product.id}");
        },
        child: Column(children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
            leading: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 58.w,
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
                      )),
            title: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: stocks.isEmpty
                ? const Text(
                    ' Prices',
                    style: TextStyle(color: Colors.black),
                  )
                : stocks.length > 1
                    ? const Text(
                        ' Prices',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'RWF ' + stocks[0].retailPrice.toInt().toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
          ),
          Container(
            height: 0.5.h,
            color: Colors.black26,
          ),
        ]),
      ),
      actions: [
        IconSlideAction(
          caption: FLocalization.of(context).addTomenu,
          color: Colors.white,
          icon: Icons.menu,
          onTap: () {
            addToMenu(product.id);
          },
        ),
      ],
      secondaryActions: <Widget>[
        if (ProxyService.remoteConfig.isMenuAvailable())
          IconSlideAction(
            caption: FLocalization.of(context).addTomenu,
            color: Colors.white,
            icon: Icons.menu,
            onTap: () {
              addToMenu(product.id);
            },
          ),
        IconSlideAction(
          caption: FLocalization.of(context).edit,
          color: Colors.white,
          icon: Icons.edit,
          onTap: () {
            edit(product.id);
          },
        ),
        IconSlideAction(
          caption: FLocalization.of(context).delete,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            delete(product.id);
          },
        ),
      ],
      actionPane: const SlidableDrawerActionPane(),
    );
  }
}
