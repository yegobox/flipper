import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TBusiness {
  String name;
  String password;
  String agreeTerms;
  String email;
}

class CreateBusinessScreen extends StatefulWidget {
  CreateBusinessScreen({Key key}) : super(key: key);

  @override
  _CreateBusinessScreenState createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final TBusiness tBusiness = TBusiness();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Routing.navigator.pop();
            },
            title: "",
            disableButton: false,
            showActionButton: true,
            actionButtonName: "Create",
            onPressedCallback: () {
              StoreProvider.of<AppState>(context).dispatch(AppAction(
                  actions: AppActions((a) => a..name = "createBusiness")));
            },
            icon: Icons.arrow_back,
            multi: 3,
            bottomSpacer: 120,
            action: Column(
              children: <Widget>[
                // ignore: prefer_const_literals_to_create_immutables
                const Text("Let's get started"),
                Text("Sign up for flipper and yegobox is fast and free"),
                Text("No commitment or long-term contracts.")
              ],
            ),
          ),
          backgroundColor: HexColor("#dfe4ea"),
          body: Wrap(
            children: <Widget>[
              Container(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text("ACCOUNT INFORMATION"),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Business name";
                            }
                            return null;
                          },
                          onSaved: (name) {
                            tBusiness.name = name;
                          },
                          decoration: InputDecoration(
                              hintText: "Business name",
                              focusColor: Colors.blue),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: FlatButton(
                        child: Text("invisible button"),
                        onPressed: vm.hasAction ? _handleFormSubmit() : null,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // ignore: always_declare_return_types
  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(ResetAppAction());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    StoreProvider.of<AppState>(context).dispatch(ResetAppAction());
    final business = Business((b) => b
      ..name = tBusiness.name
      ..hexColor = "#f5a623"
      ..type = BusinessType.NORMAL);
    StoreProvider.of<AppState>(context).dispatch(WithBusiness(business));
    StoreProvider.of<AppState>(context).dispatch(CreateBusiness());
    //finally verify if all is good and go to dashboard.
    StoreProvider.of<AppState>(context).dispatch(VerifyAuthenticationState());
  }
}
