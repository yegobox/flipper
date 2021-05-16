import 'package:flipper/routes.router.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flutter/material.dart';
import 'close_button.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/product.dart';

class ImagePlaceHolderView extends StatelessWidget {
  const ImagePlaceHolderView(
      {Key? key, required this.product, required this.currentColor})
      : super(key: key);
  final Product product;
  final String currentColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProxyService.nav.navigateTo(Routes.colors);
      },
      child: product.imageUrl == null
          ? Container(
              height: 80,
              width: 80,
              color: HexColor(currentColor),
            )
          : Stack(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    product.imageUrl!,
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
            ),
    );
  }
}
