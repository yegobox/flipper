import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/permission/permission_check.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/user.dart';
import 'package:flipper/presentation/common/common_app_bar.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';

class TBusiness {
  String name;
  String password;
  String agreeTerms;
  String email;
}

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key, this.token, this.email, this.name, this.avatar})
      : super(key: key);
  final String token;
  final String email;
  final String name;
  final String avatar;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TBusiness tBusiness = TBusiness();
  Position _position;
  _getCurrentLocation() async {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position location) {
      setState(() {
        _position = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //grant that we have the permission we need for this activity
    StoreProvider.of<AppState>(context)
        .dispatch(CheckPermission(checking: true));
    _getCurrentLocation();
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            title: "",
            showActionButton: true,
            disableButton: false,
            actionButtonName: S.of(context).signup,
            onPressedCallback: () {
              StoreProvider.of<AppState>(context).dispatch(AppAction(
                  actions: AppActions((a) => a..name = "createBusiness")));
            },
            icon: Icons.arrow_back,
            multi: 3,
            bottomSpacer: 120,
            action: Column(
              children: <Widget>[
                Text("Let's get started"),
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
                    Text("ACCOUNT INFORMATION"),
                    Center(
                      child: Container(
                        width: 300,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: Validators.isStringHasMoreChars,
                          onChanged: (name) {
                            tBusiness.name = name;
                          },
                          decoration: InputDecoration(
                              hintText: "Business name",
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
                          initialValue: widget.email,
                          enabled: false,
                          style: TextStyle(color: Colors.black),
                          onChanged: (email) {
                            tBusiness.email = email;
                          },
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(55, 20, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                                "Accept Flipper's Seller Agreement and Privacy Policy"),
                          ),
                          Radio(
                            value: "1",
                            groupValue:
                                "1", //set a toggle here to accept or deny.
                            onChanged: (String agreeTerm) {
                              tBusiness.agreeTerms = agreeTerm;
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: FlatButton(
                        child: Text("invisible button"),
                        onPressed: vm.appAction != null &&
                                vm.appAction.name == 'createBusiness'
                            ? _handleFormSubmit()
                            : null,
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

  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(
        AppAction(actions: AppActions((a) => a..name = "showLoader")));

    if (_formKey.currentState == null) {
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //todo: make sure location permission is not denied or error is handled popper.
      double lat = _position == null ? 0 : _position.latitude;
      double long = _position == null ? 0 : _position.longitude;

      Business business = Business(
        (b) => b
          ..name = tBusiness.name
          ..latitude = lat ?? 0
          ..longitude = long ?? 0
          ..active = true
          ..type = BusinessType.NORMAL,
      );

      User user = User(
        (user) => user
          ..email = widget.email
          ..token = widget.token
          ..name = widget.name,
      );
      StoreProvider.of<AppState>(context).dispatch(WithBusiness(business));
      StoreProvider.of<AppState>(context).dispatch(WithUser(user));
      StoreProvider.of<AppState>(context).dispatch(CreateUser(user));
    }
  }
}
