import 'dart:io';

import 'package:flipper/home/products/widget/build_close_button.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';

class BuildImageHolder extends StatefulWidget {
  const BuildImageHolder({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  _BuildImageHolderState createState() => _BuildImageHolderState();
}

class _BuildImageHolderState extends State<BuildImageHolder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FlipperNavigationService _navigationService = ProxyService.nav;
        _navigationService.navigateTo(Routing.editItemTitle,
            arguments: EditItemTitleArguments(productId: widget.vm.tmpItem.id));
      },
      child: !widget.vm.tmpItem.hasPicture
          ? Container(
              height: 80,
              width: 80,
              color: widget.vm.currentColor != null
                  ? HexColor(widget.vm.currentColor.hexCode)
                  : HexColor('#ee5253'),
            )
          : widget.vm.tmpItem.isImageLocal
              ? Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.file(
                        File(widget.vm.tmpItem.picture),
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
                    BuildCloseButton(vm:widget.vm)
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        widget.vm.tmpItem.picture,
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
                    BuildCloseButton(vm:widget.vm)
                  ],
                ),
    );
  }
}