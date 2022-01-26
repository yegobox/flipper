import 'package:flipper_routing/routes.router.dart';
import 'package:flipper/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'close_button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ColorAndImagePlaceHolder extends StatelessWidget {
  const ColorAndImagePlaceHolder(
      {Key? key, required this.product, required this.currentColor})
      : super(key: key);
  final ProductSync? product;
  final String currentColor;
  Future<ProductSync?> getProduct() async {
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProxyService.nav.navigateTo(Routes.colors);
      },
      child: FutureBuilder<ProductSync?>(
        future: getProduct(),
        builder: (context, product) {
          //if for the case of adding a discount the product will be null
          if (product.data == null) {
            return Container(
              height: 100,
              width: 100,
              color: HexColor('#cccccc'),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const Positioned(
                    left: 31,
                    top: 40,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(50 / 360),
                      child: Text(
                        'RWF',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    FeatherIcons.tag,
                    size: 80.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          }
          // the case of adding a product when product is not null but no image attached to it.
          if (product.data!.imageUrl == null) {
            return Container(
              height: 80,
              width: 80,
              color: HexColor(currentColor),
            );
          }
          return Stack(
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: product.data!.imageUrl!,
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const BuildCloseButton()
            ],
          );
        },
      ),
    );
  }
}
