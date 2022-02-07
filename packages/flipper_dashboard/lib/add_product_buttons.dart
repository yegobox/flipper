import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:go_router/go_router.dart';

final isAndroid = UniversalPlatform.isAndroid;
final isIos = UniversalPlatform.isIOS;

class AddProductButtons extends StatelessWidget {
  const AddProductButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: Form(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40,
                  child: BoxButton(
                    onTap: () {
                      GoRouter.of(context).push(Routes.product);
                    },
                    title: 'Add Product',
                  ),
                ),
              ),
              if (isIos ||
                  isAndroid ||
                  kDebugMode && ProxyService.remoteConfig.isDiscountAvailable())
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    color: Colors.white70,
                    width: double.infinity,
                    height: 40,
                    child: BoxButton(
                      onTap: () {
                        GoRouter.of(context).go(Routes.discount);
                      },
                      title: 'Add Discount',
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40,
                  child: BoxButton.outline(
                    onTap: () {
                      Navigator.maybePop(context);
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
