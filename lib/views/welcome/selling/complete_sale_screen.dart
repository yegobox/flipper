import 'package:customappbar/customappbar.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/proxy.dart';

class CompleteSaleScreen extends StatefulWidget {
  const CompleteSaleScreen({Key key, this.cashReceived}) : super(key: key);
  final int cashReceived;

  @override
  _CompleteSaleScreenState createState() => _CompleteSaleScreenState();
}

class _CompleteSaleScreenState extends State<CompleteSaleScreen> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          _navigationService.pop();
        },
        disableButton: false,
        showActionButton: true,
        onPressedCallback: () async {},
        actionButtonName: 'Split Amount',
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 48,
        title: null,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Text(
                'RWF' + widget.cashReceived.toString(),
                style: GoogleFonts.lato(fontStyle: FontStyle.normal),
              ),
            ),
            Center(
              child: Text(
                'Select Payment Type Below',
                style: GoogleFonts.lato(fontStyle: FontStyle.normal),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _navigationService.navigateTo(Routing.tenderScreen,
                    arguments: TenderScreenArguments(
                        cashReceived: widget.cashReceived));
              },
              child: ListTile(
                leading: Text(
                  'Cash',
                  style: GoogleFonts.lato(fontStyle: FontStyle.normal),
                ),
                trailing: Wrap(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[const Icon(Icons.arrow_forward_ios)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
