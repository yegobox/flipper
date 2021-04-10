import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/g_customer.dart';
import 'package:flipper_models/view_models/customer_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({Key key}) : super(key: key);

  List<Widget> buildCustomerList({List<GCustomer> customers}) {
    final List<Widget> list = <Widget>[];
    for (GCustomer customer in customers) {
      list.add(Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Container(
              color: Colors.blue,
              height: 50.0,
              width: 50.0,
              child: Center(
                child: Text(
                  customer.name.substring(0, 2),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(customer.name),
            ),
          )
        ],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onPop: () {
            ProxyService.nav.pop();
          },
          title: 'Add Customer to Sale',
          disableButton: true,
          showActionButton: false,
          onPressedCallback: () async {
            ProxyService.nav.pop();
          },
          icon: Icons.close,
          multi: 3,
          bottomSpacer: 52,
        ),
        body: ViewModelBuilder.reactive(
          viewModelBuilder: () => CustomerViewModel(),
          builder:
              (BuildContext context, CustomerViewModel model, Widget child) {
            return Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.black),
                        // validator: Validators.isValid,
                        onChanged: (String name) async {
                          // model.setName(name: name);
                          // model.lock();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Name, Email, Phone',
                          fillColor: Theme.of(context)
                              .copyWith(canvasColor: Colors.white)
                              .canvasColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor('#D0D7E3')),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Container(
                      width: double.infinity,
                      child: FLipperButton(
                        disableButton: false,
                        onPressedCallback: () {
                          ProxyService.nav.navigateTo(Routing.addCustomerView);
                        },
                        buttonName: 'Create New Customer',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18.0, top: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('RECENTLY CREATED'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18.0, top: 20),
                    child: Column(
                        children: model.customers.isEmpty
                            ? [const CircularProgressIndicator()]
                            : buildCustomerList(customers: model.customers)),
                  )
                ],
              ),
            );
          },
          onModelReady: (CustomerViewModel model) {
            model.getCustomers();
          },
        ),
      ),
    );
  }
}
