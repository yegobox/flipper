import 'package:flipper/routes.logger.dart';
import 'package:flipper/routes.router.dart';
import 'package:flipper_dashboard/loader.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'add_customer.dart';
import 'customappbar.dart';
import 'package:flipper_models/customer.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

class Customers extends StatelessWidget {
  Customers({Key? key, required this.orderId}) : super(key: key);
  final int orderId;
  final TextEditingController _seach = TextEditingController();
  final log = getLogger('Customers');
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        viewModelBuilder: () => BusinessHomeViewModel(),
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  ProxyService.nav.back();
                },
                title: 'Add Customer to Sale',
                showActionButton: false,
                onPressedCallback: () async {
                  ProxyService.nav.back();
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
                      trailing: Icon(Icons.clear_outlined),
                      placeholder: 'Search for a customer',
                      onChanged: (value) {
                        model.setSearch(value);
                      },
                    ),
                  ),
                  verticalSpaceSmall,
                  StreamBuilder<Customer?>(
                      stream: ProxyService.api.getCustomer(
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
                                      log.i(snapshot.data!.id);
                                      await model.assignToSale(
                                        customerId: snapshot.data!.id,
                                        orderId: orderId,
                                      );

                                      /// this update a model when the Order has the customerId in it then will show related data accordingly!
                                      model.getOrderById();
                                      ProxyService.nav.popUntil(
                                          ModalRoute.withName(
                                              Routes.afterSale));
                                    },
                                    onLongPress: () {},
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                        // leading: callImageBox(context, product),
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
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {},
                                    ),
                                  ],
                                  actionPane: SlidableDrawerActionPane(),
                                ),
                              )
                            : SizedBox.shrink();
                      }),
                  verticalSpaceSmall,
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
                    child: BoxButton(
                      title: model.searchCustomerkey.isNotEmpty
                          ? 'Create Customer ' +
                              '"' +
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: AddCustomer(
              orderId: orderId,
              searchedKey: searchedKey,
            ),
          ),
        );
      },
    );
  }
}
