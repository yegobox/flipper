import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProductButtons extends StatelessWidget {
  const AddProductButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w, right: 18.w),
      child: Container(
        width: double.infinity,
        child: Form(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40.h,
                  child: BoxButton(
                    onTap: () {
                      ProxyService.nav.navigateTo(Routes.product);
                    },
                    title: 'Add Product',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40.h,
                  child: BoxButton.outline(
                    onTap: () {
                      ProxyService.nav.back();
                    },
                    title: 'Dismiss',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
