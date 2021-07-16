import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:flipper_models/view_models/stock_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/product.dart';

class ProductRow extends StatelessWidget {
  const ProductRow(
      {Key? key,
      required this.color,
      required this.name,
      required this.hasImage,
      this.imageUrl,
      required this.product,
      required this.delete})
      : super(key: key);
  final String color;
  final String name;
  final bool hasImage;
  final String? imageUrl;
  final Product product;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: GestureDetector(
        onTap: () {
          ProxyService.nav.navigateTo(Routes.sell,
              arguments: SellArguments(product: product));
        },
        onLongPress: () {
          ProxyService.nav.navigateTo(Routes.sell,
              arguments: SellArguments(product: product));
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
                  : Image.network(
                      imageUrl ?? '',
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          child: child,
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
            ),
            title: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: ViewModelBuilder<StockViewModel>.reactive(
              viewModelBuilder: () => StockViewModel(),
              onModelReady: (StockViewModel stockModel) =>
                  stockModel.loadStockByProductId(productId: product.id),
              builder: (context, stockModel, child) {
                return stockModel.stocks.isEmpty
                    ? const Text(
                        ' Prices',
                        style: TextStyle(color: Colors.black),
                      )
                    : stockModel.stocks.length > 1
                        ? const Text(
                            ' Prices',
                            style: TextStyle(color: Colors.black),
                          )
                        : Text(
                            'RWF ' +
                                stockModel.stocks[0].retailPrice
                                    .toInt()
                                    .toString(),
                            style: const TextStyle(color: Colors.black),
                          );
              },
            ),
          ),
          Container(
            height: 0.5.h,
            color: Colors.black26,
          ),
        ]),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            delete(product.id);
          },
        ),
      ],
      actionPane: SlidableDrawerActionPane(),
    );
  }
}
