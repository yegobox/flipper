import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_display/number_display.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'customappbar.dart';
import 'package:google_ui/google_ui.dart';
import 'package:go_router/go_router.dart';

class AfterSale extends StatefulWidget {
  const AfterSale(
      {Key? key,
      required this.totalOrderAmount,
      required this.order,
      this.receiptType = ReceiptType.ns})
      : super(key: key);
  final double totalOrderAmount;
  final Order order;
  final String? receiptType;

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
            top: false,
            child: Scaffold(
              appBar: CustomAppBar(
                useTransparentButton: false,
                onPop: () {
                  model.currentOrder();
                  GoRouter.of(context).push(Routes.home);
                },
                title: '',
                closeButton: CLOSEBUTTON.BUTTON,
                disableButton: false,
                showActionButton: true,
                onPressedCallback: () async {
                  await model.getOrderById();
                  GoRouter.of(context).push(
                      Routes.customers + '/' + widget.order.id.toString());
                },
                leftActionButtonName:
                    model.app.customer != null ? 'New Sale' : 'New Sale',
                rightActionButtonName: 'Add Customer',
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
                          const SizedBox(height: 40),
                          Text(
                            'FRw' +
                                display(model.keypad.cashReceived -
                                        widget.totalOrderAmount)
                                    .toString() +
                                ' Change',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Out of FRw ' +
                                model.keypad.cashReceived.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 18,
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
                      child: StreamBuilder<Customer?>(
                          stream: ProxyService.isarApi.getCustomerByOrderId(
                              id: model.kOrder == null ? 0 : model.kOrder!.id),
                          builder: (context, snapshot) {
                            return snapshot.data == null
                                ? Column(
                                    children: [
                                      const Text(
                                          'How would you like your receipt?'),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: GOutlinedButton(
                                            'Email Receipt',
                                            onPressed: () async {
                                              if (await ProxyService.isarApi
                                                  .isTaxEnabled()) {
                                                if (model.receiptReady) {
                                                  Business? business =
                                                      await ProxyService.isarApi
                                                          .getBusiness();
                                                  List<OrderItem> items =
                                                      await ProxyService.isarApi
                                                          .orderItems(
                                                    orderId: widget.order.id,
                                                  );
                                                  model.printReceipt(
                                                      items: items,
                                                      business: business!,
                                                      oorder: widget.order,
                                                      receiptType:
                                                          widget.receiptType!);
                                                } else {
                                                  //show scaffold message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      content: Text(
                                                          "We are generating receipt wait a few seconds and try again"),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
                                        child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: GOutlinedButton(
                                            'No Receipt',
                                            onPressed: () {
                                              // refresh orders
                                              model.currentOrder();
                                              GoRouter.of(context)
                                                  .push(Routes.home);
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
                                                  .isReceiptOnEmail() ||
                                              kDebugMode
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18, right: 18),
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
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, right: 18),
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
                        child: Row(
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.globe),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: null,
                            ),
                            Text(
                              'English',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        onModelReady: (model) async {
          model.getOrderById();
          // generate rra receipt
          if (await ProxyService.isarApi.isTaxEnabled()) {
            Business? business = await ProxyService.isarApi.getBusiness();
            List<OrderItem> items =
                await ProxyService.isarApi.orderItems(orderId: widget.order.id);

            model.generateRRAReceipt(
                items: items,
                business: business!,
                order: widget.order,
                receiptType: widget.receiptType,
                callback: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content:
                        Text("EBM V2 server is down, please try again later"),
                  ));
                });
          }
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
