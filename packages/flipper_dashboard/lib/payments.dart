import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class Payments extends StatelessWidget {
  Payments({Key? key, required this.order}) : super(key: key);

  final Order order;
  final _routerService = locator<RouterService>();
  // TODO: remove duePay get it's value from stream
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                onActionButtonClicked: () {
                  _routerService.pop();
                },
                rightActionButtonName: 'Split payment',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: StreamBuilder<List<OrderItem>>(
                        stream: ProxyService.isar.orderItemsStream(),
                        builder: (context, snapshot) {
                          final orderItems = snapshot.data ?? [];

                          // Calculate the sum of all orderItems' prices for due
                          final duePay = orderItems.fold<double>(
                              0, (sum, orderItem) => sum + orderItem.price);

                          return Column(
                            children: [
                              const SizedBox(height: 40),
                              model.kOrder != null
                                  ? Text(
                                      'FRw ' +
                                          NumberFormat('#,###').format(duePay),
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text('0.00'),
                              const SizedBox(height: 40),
                              const Text(
                                'Select Payment type Below',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 60.0,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _routerService.navigateTo(CollectCashViewRoute(
                                  order: order, paymentType: "cash"));
                            },
                            child: ListTile(
                              leading: Text(
                                'Cash',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: TextButton(
                                  onPressed: null,
                                  style: primaryButtonStyle.copyWith(
                                      shape: MaterialStateProperty.resolveWith<
                                          OutlinedBorder>(
                                        (states) => RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      textStyle:
                                          MaterialStatePropertyAll<TextStyle>(
                                              TextStyle(color: Colors.white)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff006AFE)),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
                                            return Colors.blue
                                                .withOpacity(0.04);
                                          }
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed)) {
                                            return Colors.blue
                                                .withOpacity(0.12);
                                          }
                                          return null;
                                        },
                                      )),
                                  child: Text(
                                    "Pay",
                                    style: primaryTextStyle.copyWith(
                                        color: Colors.white),
                                  )),
                            ),
                          ),
                          ProxyService.remoteConfig.isSpennPaymentAvailable()
                              ? GestureDetector(
                                  onTap: () {
                                    _routerService.navigateTo(
                                        CollectCashViewRoute(
                                            order: order,
                                            paymentType: "spenn"));
                                  },
                                  child: const ListTile(
                                    leading: Text(
                                      'SPENN',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.pink,
                                      size: 24.0,
                                      semanticLabel: 'SPENN',
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          model.updatePayable();
        },
        viewModelBuilder: () => HomeViewModel());
  }
}
