import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

class AddCustomerView extends StatelessWidget {
  const AddCustomerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          onPop: () {
            ProxyService.nav.pop();
          },
          title: 'Create New Customer',
          disableButton: true,
          showActionButton: true,
          onPressedCallback: () async {
            // await model.handleCreateItem();
            ProxyService.nav.pop();
          },
          rightActionButtonName: 'Save',
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
                      hintText: 'First Name',
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
                      hintText: 'Last Name',
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
                      hintText: 'Phone Number',
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
                      hintText: 'Email',
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
                  child: const Button(
                    disableButton: false,
                    onPressedCallback: null,
                    buttonName: 'Add',
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
