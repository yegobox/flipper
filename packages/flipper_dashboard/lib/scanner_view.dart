import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pubnub/pubnub.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannView extends StatefulHookConsumerWidget {
  const ScannView({
    Key? key,
    this.intent = 'selling',
    this.useLatestImplementation = false,
  }) : super(key: key);

  final String intent;
  final bool useLatestImplementation;

  @override
  ScannViewState createState() => ScannViewState();
}

class ScannViewState extends ConsumerState<ScannView> {
  MobileScannerController? controller;
  bool isFlashOn = false;
  final _routerService = locator<RouterService>();

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              _buildScanner(context, model),
              _buildGuideBox(context), // Add this line
              _buildCloseButton(context),
              _buildFlashButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuideBox(BuildContext context) {
    return Center(
      child: Container(
        width: 250, // Set the width of the guide box
        height: 250, // Set the height of the guide box
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - (40 - 0.5 * 80) - 340,
      left: MediaQuery.of(context).size.width / 2 - 40,
      child: IconButton(
        iconSize: 80,
        onPressed: () => _routerService.pop(),
        icon: const CircleAvatar(
          backgroundColor: Color(0xff006AFE),
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFlashButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
                controller?.toggleTorch();
              });
            },
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.yellow : Colors.white,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              _routerService.pop();
            },
            icon: Icon(
              Icons.keyboard_return,
              color: isFlashOn ? Colors.yellow : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner(BuildContext context, CoreViewModel model) {
    return MobileScanner(
      onDetectError: (error, stackTrace) => print(error),
      controller: controller,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          performIntent(barcode, model);
        }
      },
    );
  }

  void scanToLogin({required String? result}) {
    log(result ?? "", name: 'login');
    if (result != null && result.contains('-')) {
      final split = result.split('-');
      if (split.length > 1 && split[0] == 'login') {
        _publishLoginDetails(split[1]);
      }
    }
  }

  Future<void> _publishLoginDetails(String channel) async {
    int userId = ProxyService.box.getUserId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    String phone = ProxyService.box.getUserPhone()!;
    String uid = ProxyService.box.uid();
    String defaultApp = ProxyService.box.getDefaultApp();

    PublishResult result = await ProxyService.event.publish(loginDetails: {
      'channel': channel,
      'userId': userId,
      'businessId': businessId,
      'branchId': branchId,
      'phone': phone,
      'defaultApp': defaultApp,
      'uid': uid,
      'deviceName': Platform.operatingSystem,
      'deviceVersion': Platform.operatingSystemVersion,
      'linkingCode': randomNumber().toString(),
    });
    if (!result.isError) {
      HapticFeedback.lightImpact();
      showToast(context, 'Login success');
      _routerService.back();
    } else {
      showToast(context, 'Login failed');
      _routerService.back();
    }
  }

  Future<void> performIntent(Barcode barcode, CoreViewModel model) async {
    if (widget.intent == BARCODE) {
      model.productService.setBarcode(barcode.rawValue);
    }
    scanToLogin(result: barcode.rawValue);
    // if (widget.intent == ATTENDANCE) {
    //   bool isCheckInDone =
    //       await ProxyService.strategy.checkIn(checkInCode: barcode.rawValue);
    //   if (isCheckInDone) {
    //     showSimpleNotification(
    //       const Text('Check In Successful'),
    //       background: Colors.green,
    //       position: NotificationPosition.bottom,
    //     );
    //     _routerService.pop();
    //   }
    // }

    navigate(barcode.rawValue, model);
  }

  void navigate(String? code, CoreViewModel model) async {
    if (widget.intent == BARCODE) {
      _routerService.pop();
      return;
    }
    if (widget.intent == SELLING) {
      Product? product =
          await model.productService.getProductByBarCode(code: code);
      if (product != null) {
        _routerService.navigateTo(SellRoute(product: product));
        return;
      }
      showSimpleNotification(
        const Text("Product not found"),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
      _routerService.pop();
      return;
    }
    if (widget.intent == ATTENDANCE) {
      return;
    }
    if (widget.intent == LOGIN) {
      return;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
