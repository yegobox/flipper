import 'dart:io';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/views/shared/close_button.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'image_placeholder_viewmodel.dart';

class ImagePlaceHolderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImagePlaceholderViewModel>.reactive(
        builder: (BuildContext context, ImagePlaceholderViewModel model,
            Widget child) {
          return GestureDetector(
            onTap: () {
              final FlipperNavigationService _navigationService =
                  ProxyService.nav;
              _navigationService.navigateTo(Routing.editItemTitle);
            },
            child: !model.product.hasPicture
                ? Container(
                    height: 80,
                    width: 80,
                    color: model.currentColor != null
                        ? HexColor(model.currentColor.name)
                        : HexColor('#ee5253'),
                  )
                : model.product.isImageLocal
                    ? Stack(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: Image.file(
                              File(model.product.picture),
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
                      )
                    : Stack(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              model.product.picture,
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
        },
        viewModelBuilder: () => ImagePlaceholderViewModel());
  }
}
