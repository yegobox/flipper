import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';

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
                  child: GElevatedButton(
                    'Add Product',
                    onPressed: () {
                      GoRouter.of(context).push(Routes.product);
                    },
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
                    child: GElevatedButton(
                      'Add Discount',
                      onPressed: () {
                        GoRouter.of(context).go(Routes.discount);
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  color: Colors.white70,
                  width: double.infinity,
                  height: 40,
                  child: GOutlinedButton(
                    'Dismiss',
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
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
