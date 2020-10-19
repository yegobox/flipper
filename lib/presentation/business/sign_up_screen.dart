import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:flipper/domain/redux/permission/permission_check.dart';
import 'package:flipper/domain/redux/user/user_actions.dart';
import 'package:flipper/model/app_action.dart';
import 'package:flipper/model/business.dart';
import 'package:flipper/model/fuser.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class TBusiness {
  String name;
  String password;
  String agreeTerms;
  String email;
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key, this.token, this.email, this.name, this.avatar,@required this.userId})
      : super(key: key);
  final String token;
  final String email;
  final String name;
  final String userId;
  final String avatar;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TBusiness tBusiness = TBusiness();
  Position _position;
  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator();
    const LocationOptions locationOptions =
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
        .dispatch(const CheckPermission(checking: true));
    _getCurrentLocation();
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Scaffold(
          appBar: CommonAppBar(
            title: '',
            showActionButton: true,
            disableButton: false,
            actionButtonName: 'Sign Up',
            onPressedCallback: () {
              StoreProvider.of<AppState>(context).dispatch(AppAction(
                  actions: AppActions(
                      (AppActionsBuilder a) => a..name = 'createBusiness')));
            },
            icon: Icons.arrow_back,
            multi: 3,
            bottomSpacer: 120,
            action: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
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
                          validator: Validators.isValid,
                          onChanged: (String name) {
                            tBusiness.name = name;
                          },
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
                          initialValue: widget.email,
                          enabled: false,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String email) {
                            tBusiness.email = email;
                          },
                          decoration: const InputDecoration(hintText: 'Email'),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(55, 20, 0, 0),
                      child: Row(
                        children: <Widget>[
                          const Flexible(
                            child: Text(
                                "Accept Flipper's Seller Agreement and Privacy Policy"),
                          ),
                          Radio(
                            value: '1',
                            groupValue:
                                '1', //set a toggle here to accept or deny.
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
                        child: const Text('invisible button'),
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

  // ignore: always_declare_return_types
  _handleFormSubmit() {
    StoreProvider.of<AppState>(context).dispatch(AppAction(
        actions: AppActions((AppActionsBuilder a) => a..name = 'showLoader')));

    if (_formKey.currentState == null) {
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final String lat = _position == null ? '0' : _position.latitude.toString();
      final String long = _position == null ? '0' : _position.longitude.toString();

      if (tBusiness.name == null) {
        return;
      }
      final Business business = Business(
        (BusinessBuilder b) => b
          ..id = Uuid().v1()
          ..name = tBusiness.name
          ..active = true
          ..country ='Rwanda'
          ..currency = 'RWF'
          ..categoryId = '1'
          ..typeId = '1'
          ..latitude = lat ?? '0'
          ..longitude = long ?? '0'
          ..active = true
          ..type = 'NORMAL',
      );

      final FUser user = FUser(
        (FUserBuilder user) => user
          ..email = widget.email
          ..active = true
          ..id = widget.userId
          ..createdAt = DateTime.now().toIso8601String()
          ..updatedAt = DateTime.now().toIso8601String()
          ..token = widget.token
          ..name = widget.name,
      );
      // TODO(richard): submit business on remote, and branch so we wont have issue on next login
      StoreProvider.of<AppState>(context).dispatch(WithUser(user: user));
      StoreProvider.of<AppState>(context).dispatch(WithBusiness(business));
      StoreProvider.of<AppState>(context).dispatch(CreateUser(user));
    }
  }
}
