import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TenderScreen extends StatefulWidget {
  TenderScreen({Key key, this.cashReceived}) : super(key: key);

  final int cashReceived;

  @override
  _TenderScreenState createState() => _TenderScreenState();
}

class _TenderScreenState extends State<TenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Router.navigator.pop();
        },
        disableButton: false,
        showActionButton: false,
        onPressedCallback: () async {},
        icon: Icons.arrow_back,
        multi: 3,
        bottomSpacer: 48,
        title: null,
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Form(
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  enabled: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: "FRW" + widget.cashReceived.toString()),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              color: Colors.blue,
              child: SizedBox(
                width: 380,
                height: 50,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(
                      SavePayment(
                        note: "note",
                        cashReceived: widget.cashReceived,
                      ),
                    );

                    Router.navigator.pushNamedAndRemoveUntil(
                        Router.dashboard, (route) => false);
                  },
                  child: Text(
                    S.of(context).tender,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
