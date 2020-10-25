import 'package:customappbar/customappbar.dart';

import 'package:flipper/routes/router.gr.dart';

import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'business_viewmodel.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({Key key}) : super(key: key);

  @override
  _CreateBusinessScreenState createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,BusinessViewModel model, Widget child){
      return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: '',
            disableButton: false,
            showActionButton: true,
            actionButtonName: 'Create',
            onPressedCallback: () {
             model.createBusiness();
            },
            icon: Icons.arrow_back,
            multi: 3,
            bottomSpacer: 120,
            action: Column(
              children: [
                // ignore: prefer_const_literals_to_create_immutables
                const Text("Let's get started"),
                const Text('Sign up for flipper and yegobox is fast and free'),
                const Text('No commitment or long-term contracts.')
              ],
            ),
          ),
          backgroundColor: HexColor('#dfe4ea'),
          body: Wrap(
            children: <Widget>[
              Container(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text('ACCOUNT INFORMATION'),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Business name';
                            }
                            return null;
                          },
                          controller: model.name,
                          decoration: const InputDecoration(
                              hintText: 'Business name',
                              focusColor: Colors.blue),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: FlatButton(
                        child:const Text('invisible button'),
                        onPressed: model.nameisEmpty ? model.handleFormSubmit() : null,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
    }, viewModelBuilder: ()=>BusinessViewModel());
  }


}
