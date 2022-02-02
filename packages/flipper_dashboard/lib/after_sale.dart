import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'customappbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AfterSale extends StatefulWidget {
  const AfterSale({Key? key, required this.totalOrderAmount}) : super(key: key);
  final double totalOrderAmount;

  @override
  _AfterSaleState createState() => _AfterSaleState();
}

class _AfterSaleState extends State<AfterSale> {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final log = getLogger('AfterSale');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                useTransparentButton: true,
                onPop: () {
                  // refresh orders
                  model.currentOrder();
                  GoRouter.of(context).pushNamed(Routes.home);
                },
                title: '',
                closeButton: CLOSEBUTTON.BUTTON,
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () async {
                  await model.getOrderById();
                  log.i(model.kOrder!.id);
                  GoRouter.of(context)
                      .go(Routes.customers + '/' + model.kOrder!.id.toString());
                },
                leftActionButtonName:
                    model.kOrder != null && model.kOrder!.customerId != null
                        ? 'Remove Customer'
                        : 'New Sale',
                rightActionButtonName: 'Add Customer',
                // icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          Text(
                            'FRw' +
                                display(model.keypad.cashReceived -
                                        widget.totalOrderAmount)
                                    .toString() +
                                ' Change',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Out of FRw ' +
                                model.keypad.cashReceived.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      right: 0,
                      left: 0,
                      child: StreamBuilder<CustomerSync?>(
                          stream: ProxyService.api.getCustomerByOrderId(
                              id: model.kOrder == null ? 0 : model.kOrder!.id),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                          'How would you like your receipt?'),
                                      const SizedBox(height: 10),
                                      ProxyService.remoteConfig
                                                  .isEmailReceiptAvailable() ||
                                              kDebugMode
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 18.w, right: 18.w),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: BoxButton.outline(
                                                  title: 'Email',
                                                  onTap: () {},
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      SizedBox(height: 20.h),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.w, right: 18.w),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: BoxButton.outline(
                                            title: 'No Receipt',
                                            onTap: () {
                                              // refresh orders
                                              model.currentOrder();
                                              GoRouter.of(context)
                                                  .pushNamed(Routes.home);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                          'How would you like your receipt?'),
                                      const SizedBox(height: 10),
                                      ProxyService.remoteConfig
                                                  .isEmailReceiptAvailable() ||
                                              kDebugMode
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 18.w, right: 18.w),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: BoxButton.outline(
                                                  title: 'Email(' +
                                                      snapshot.data!.email +
                                                      ')',
                                                  onTap: () {},
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      SizedBox(height: 2.h),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.w, right: 18.w),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: BoxButton.outline(
                                            title: 'No Receipt',
                                            onTap: () {
                                              // refresh orders
                                              model.currentOrder();
                                              GoRouter.of(context)
                                                  .pushNamed(Routes.home);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                    ),
                    Positioned(
                        bottom: 0,
                        // center:
                        child: Row(
                          children: const [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.globe),
                              onPressed: null,
                            ),
                            Text('English')
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (model) {
          model.getOrderById();
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
