import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flipper/utils/HexColor.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({Key key}) : super(key: key);

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
        body: Padding(
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        color: Colors.blue,
                        height: 50.0,
                        width: 50.0,
                        child: const Center(
                          child: Text(
                            'MR',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text('Muragijimana Richard',overflow: TextOverflow.ellipsis,),
                            const Text('0783054874|muragijimanarichard@gmail.com',overflow: TextOverflow.ellipsis,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
