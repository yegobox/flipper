import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class TenderScreen extends StatefulWidget {
  TenderScreen({Key key, this.cashReceived}) : super(key: key);

  final int cashReceived;

  @override
  _TenderScreenState createState() => _TenderScreenState();
}

class _TenderScreenState extends State<TenderScreen> {
  bool _isEmpty = true;
  bool _hasErrors = false;

  @override
  Widget build(BuildContext context) {
    final theme = _hasErrors
        ? AppTheme.inputDecorationErrorTheme
        : (_isEmpty
            ? AppTheme.inputDecorationEmptyTheme
            : AppTheme.inputDecorationFilledTheme);

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
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 370,
            height: 50,
            child: Container(
              child: Form(
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  enabled: true,
                  style: GoogleFonts.lato(fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.green),
                    // ),
                    hintText: "FRW" + widget.cashReceived.toString(),
                  ).applyDefaults(theme),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
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
                )),
          )
        ],
      ),
    );
  }
}
