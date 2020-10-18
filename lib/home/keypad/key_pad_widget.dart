import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/key_pad_buttons.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyPadWidget extends StatefulWidget {
  const KeyPadWidget({Key key}) : super(key: key);

  @override
  _KeyPadWidgetState createState() => _KeyPadWidgetState();
}

class _KeyPadWidgetState extends State<KeyPadWidget> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        final MoneyMaskedTextController moneyFormat =  MoneyMaskedTextController(
            leftSymbol: '\RWF', decimalSeparator: '.', thousandSeparator: ',');

        double cleanValue = 0;
        cleanValue = vm.keypad == null ? 0 : vm.keypad.amount.toDouble();
        moneyFormat
            .updateValue(vm.keypad == null ? 0.00 : cleanValue.toDouble());

        return Scaffold(
          body: Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 75.3,
                color: Colors.white30,
                child: ListTile(
                  trailing: FlatButton(
                    child: Text(
                      moneyFormat.text,
                      style: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color: Theme.of(context).appBarTheme.color,
                          fontSize:
                              Theme.of(context)
                    .textTheme
                    .headline6.fontSize),
                    ),
                    onPressed: () {},
                  ),
                  leading: FlatButton(
                    onPressed: () {
                      _navigationService.navigateTo(Routing.addNoteScreen);
                    },
                    child: Text(
                      vm.note == null
                          ? 'Add a note'
                          : vm.note.length > 4
                              ? vm.note.substring(0, 4)
                              : vm.note,
                      style: GoogleFonts.lato(
                          fontStyle: FontStyle.normal,
                          color:Theme.of(context).accentColor,
                          fontSize:
                              Theme.of(context).textTheme.headline5.fontSize),
                    ),
                  ),
                ),
              ),
              const KeyPadButtons()
            ],
          ),
        );
      },
    );
  }
}
