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

  bool _isButtonDisabled;
  int _customerChangeDue;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = true;
    _customerChangeDue = 0;
  }

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
          Routing.navigator.pop();
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
                  onChanged: (value) {
                    if (int.parse(value) > widget.cashReceived) {
                      setState(() {
                        _isButtonDisabled = false;
                        _customerChangeDue =
                            int.parse(value) - widget.cashReceived;
                      });
                    } else {
                      setState(() {
                        _isButtonDisabled = true;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  enabled: true,
                  style: GoogleFonts.lato(fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    hintText: 'FRW' + widget.cashReceived.toString(),
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
                color: _isButtonDisabled ?const Color(0xFFE3F2FD) : Colors.blue,
                child: SizedBox(
                  width: 380,
                  height: 50,
                  child: FlatButton(
                    color: Colors.blue,
                    disabledColor: const Color(0xFFE3F2FD),
                    onPressed: _handleTender(),
                    child: const Text(
                      'Tender',
                      style:  TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Function _handleTender() {
    if (_isButtonDisabled) {
      return null;
    } else {
      return () {
        StoreProvider.of<AppState>(context).dispatch(
          SavePayment(
            note: 'note',
            customerChangeDue: _customerChangeDue,
            cashReceived: widget.cashReceived,
          ),
        );

        Routing.navigator
            .pushNamedAndRemoveUntil(Routing.dashboard, (route) => false);
      };
    }
  }
}
