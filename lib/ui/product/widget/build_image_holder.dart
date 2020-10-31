import 'dart:io';



import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/product/add/add_product_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

import 'build_close_button.dart';

class BuildImageHolder extends StatefulWidget {
  const BuildImageHolder({Key key,@required this.model,}) : super(key: key);
  //final CommonViewModel vm;
  final AddProductViewmodel model;


  @override
  _BuildImageHolderState createState() => _BuildImageHolderState();
}

class _BuildImageHolderState extends State<BuildImageHolder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FlipperNavigationService _navigationService = ProxyService.nav;
        _navigationService.navigateTo(Routing.editItemTitle);
      },
      child: !widget.model.product.hasPicture
          ? Container(
              height: 80,
              width: 80,

              color: widget.model.currentColor != null
                  ? HexColor(widget.model.currentColor.name)
                  : HexColor('#ee5253'),
            )
          : widget.model.product.isImageLocal
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(widget.model.product.picture),
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
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
                    BuildCloseButton()
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        widget.model.product.picture,
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
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