import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'close_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/product.dart';

class ColorAndImagePlaceHolder extends StatelessWidget {
  const ColorAndImagePlaceHolder(
      {Key? key, required this.product, required this.currentColor})
      : super(key: key);
  final Product? product;
  final String currentColor;
  Future<Product?> getProduct() async {
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProxyService.nav.navigateTo(Routes.colors);
      },
      child: FutureBuilder<Product?>(
          future: getProduct(),
          builder: (context, product) {
            //if for the case of adding a discount the product will be null
            if (product.data == null)
              return Container(
                height: 80,
                width: 80,
                color: HexColor('#cccccc'),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      left: 31,
                      top: 24,
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      FeatherIcons.tag,
                      size: 70.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            // the case of adding a product when product is not null but no image attached to it.
            if (product.data!.imageUrl == null)
              return Container(
                height: 80,
                width: 80,
                color: HexColor(currentColor),
              );
            return Stack(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    product.data!.imageUrl!,
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
                    height: 80,
                    width: 80,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const BuildCloseButton()
              ],
            );
          }),
    );
  }
}
