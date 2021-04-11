import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_models/view_models/customer_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddCustomerView extends StatelessWidget {
  const AddCustomerView({Key key}) : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CustomerViewModel(),
        builder: (BuildContext context, CustomerViewModel model, Widget child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  ProxyService.nav.pop();
                },
                title: 'Create New Customer',
                disableButton: true,
                showActionButton: false,
                onPressedCallback: () async {
                  // await model.handleCreateItem();
                  ProxyService.nav.pop();
                },
                rightActionButtonName: 'Save',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: Form(
                key: _formKey,
                child: Padding(

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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name required';
                              }
                              return null;
                            },
                            onChanged: (String name) async {
                              model.setName(name: name);
                            },
                            decoration: InputDecoration(
                              hintText: 'Name',
                              fillColor: Theme.of(context)
                                  .copyWith(canvasColor: Colors.white)
                                  .canvasColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor('#D0D7E3')),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: Container(
                          width: double.infinity,
                          child: TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number required';
                              }
                              return null;
                            },
                            onChanged: (String phone) async {
                              model.setPhoneNumber(phone: phone);
                            },
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              fillColor: Theme.of(context)
                                  .copyWith(canvasColor: Colors.white)
                                  .canvasColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor('#D0D7E3')),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                            onChanged: (String email) async {
                              model.setEmail(email: email);
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              fillColor: Theme.of(context)
                                  .copyWith(canvasColor: Colors.white)
                                  .canvasColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor('#D0D7E3')),
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
                              if (_formKey.currentState.validate()) {
                                model.createCustomer();
                                ProxyService.nav.pop();
                              }
                            },
                            buttonName: 'Add',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
