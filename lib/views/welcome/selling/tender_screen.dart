import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/flipperNavigation_service.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenderScreen extends StatefulWidget {
  const TenderScreen({Key key, this.cashReceived}) : super(key: key);

  final double cashReceived;

  @override
  _TenderScreenState createState() => _TenderScreenState();
}

class _TenderScreenState extends State<TenderScreen> {
  final FlipperNavigationService _navigationService = ProxyService.nav;
  // final BlueToothService _bluetoothService = ProxyService.blue;
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          _navigationService.popUntil(Routing.dashboard);
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
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 370,
            height: 50,
            child: Container(
              child: Form(
                child: TextFormField(
                  autofocus: true,
                  onChanged: (String value) {
                    if (double.parse(value) > widget.cashReceived) {
                      setState(() {
                        _isButtonDisabled = false;
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
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
                color:
                    _isButtonDisabled ? const Color(0xFFE3F2FD) : Colors.blue,
                child: SizedBox(
                  width: 380,
                  height: 50,
                  child: FlatButton(
                    color: Colors.blue,
                    disabledColor: const Color(0xFFE3F2FD),
                    onPressed: _handleTender(),
                    child: const Text(
                      'Tender',
                      style: TextStyle(color: Colors.white),
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
      return () async {
        // StoreProvider.of<AppState>(context).dispatch(
        //   SavePayment(
        //     note: 'note',
        //     customerChangeDue: int.parse(_customerChangeDue),
        //     cashReceived: widget.cashReceived,
        //   ),
        // );
        // TODO(richard): finish printing to work proper
        // await _bluetoothService.printReceipt();
        _navigationService.popUntil(Routing.dashboard);
      };
    }
  }
}
