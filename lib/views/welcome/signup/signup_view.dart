import 'package:customappbar/customappbar.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'signup_viewmodel.dart';


class SignUpView extends StatelessWidget {
  const SignUpView(
      {Key key,
      this.token,
      this.email,
      this.name,
      this.avatar,
      @required this.userId})
      : super(key: key);
  final String token;
  final String email;
  final String name;
  final String userId;
  final String avatar;
  
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, SignUpViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              title: '',
              showActionButton: true,
              disableButton: false,
              actionButtonName: 'Sign Up',
              onPressedCallback: () {
                model.singUp(context: context,token:token,userId:userId);
              },
              icon: Icons.arrow_back,
              multi: 3,
              bottomSpacer: 120,
              action: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  const Text("Let's get started"),
                  const Text(
                      'Sign up for flipper and yegobox is fast and free'),
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
                  key: model.formKey,
                  child: Column(
                    children: <Widget>[
                      const Text('ACCOUNT INFORMATION'),
                      Center(
                        child: Container(
                          width: 300,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            validator: Validators.isValid,
                            controller: model.name,
                            decoration: const InputDecoration(
                                hintText: 'Business name',
                                focusColor: Colors.blue),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          width: 300,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            
                            enabled: false,
                            style: const TextStyle(color: Colors.black),
                            controller: model.email,
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(55, 20, 0, 0),
                        child: Row(
                          children: [
                             const Flexible(
                              child: Text(
                                  "Accept Flipper's Seller Agreement and Privacy Policy"),
                            ),
                            const Radio(
                              value: '1',
                              groupValue:
                                  '1', //TODO(richard): get value from radio and save it too
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        onModelReady: (SignUpViewModel model) {
          model.initFields(name:TextEditingController(),email:TextEditingController(text:email),formKey: GlobalKey<FormState>());
          // model.getCurrentLocation(); //first get business location.
        },
        viewModelBuilder: () => SignUpViewModel());
  }
}
