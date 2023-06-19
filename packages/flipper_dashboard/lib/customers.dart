import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'add_customer.dart';
import 'customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class Customers extends StatelessWidget {
  Customers({Key? key, required this.orderId}) : super(key: key);
  final int orderId;
  final TextEditingController _seach = TextEditingController();
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                title: 'Add customer',
                showActionButton: false,
                onActionButtonClicked: () async {
                  _routerService.pop();
                },
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 50,
              ),
              body: Column(
                children: [
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: BoxInputField(
                      controller: _seach,
                      trailing: const Icon(Icons.clear_outlined),
                      placeholder: 'Search for a customer',
                      onChanged: (value) {
                        model.setSearch(value);
                      },
                    ),
                  ),
                  verticalSpaceSmall,
                  StreamBuilder<Customer?>(
                      stream: ProxyService.isar.getCustomer(
                        key: model.searchCustomerkey,
                      ),
                      builder: (context, snapshot) {
                        return snapshot.data != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 18),
                                child: Slidable(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await model.assignToSale(
                                        customerId: snapshot.data!.id,
                                        orderId: orderId,
                                      );
                                      model.app.setCustomer(snapshot.data!);
                                      model.getOrderById();
                                      _routerService.pop();
                                    },
                                    onLongPress: () {},
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                        leading: SizedBox(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: 58,
                                            child: TextDrawable(
                                              backgroundColor: Colors.red,
                                              text: snapshot.data!.name,
                                              isTappable: true,
                                              onTap: null,
                                              boxShape: BoxShape.rectangle,
                                            )),
                                        title: Text(
                                          snapshot.data!.phone,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        height: 0.5,
                                        color: Colors.black26,
                                      ),
                                    ]),
                                  ),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(
                                      key: Key('dismissable-100'),
                                    ),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) {
                                          model.deleteCustomer(
                                              snapshot.data!.id, (message) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(message),
                                              ),
                                            );
                                          });
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(
                                        key: Key('dismissable-100')),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) {
                                          model.deleteCustomer(
                                              snapshot.data!.id, (message) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(message),
                                              ),
                                            );
                                          });
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }),
                  verticalSpaceSmall,
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                    child: BoxButton(
                      title: model.searchCustomerkey.isNotEmpty
                          ? 'Create Customer ' '"' +
                              model.searchCustomerkey +
                              '"'
                          : 'Add Customer',
                      onTap: () {
                        _showModalBottomSheet(
                            context, orderId, model.searchCustomerkey);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showModalBottomSheet(BuildContext context, int orderId, searchedKey) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: AddCustomer(
            orderId: orderId,
            searchedKey: searchedKey,
          ),
        );
      },
    );
  }
}
