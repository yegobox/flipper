import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/views/keypad/key_pad_buttons.dart';
import 'package:flipper/views/welcome/payable/payable_viewmodel.dart';
// import 'package:flipper/widget/keypad/key_pad_buttons.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class KeyPadWidget extends StatefulWidget {
  const KeyPadWidget({Key key}) : super(key: key);

  @override
  _KeyPadWidgetState createState() => _KeyPadWidgetState();
}

class _KeyPadWidgetState extends State<KeyPadWidget> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,PayableViewModel model, Widget child){
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
                      model.payable.text
                    ),
                    onPressed: () {},
                  ),
                  leading: FlatButton(
                    onPressed: () {
                      _navigationService.navigateTo(Routing.addNoteScreen);
                    },
                    child: Text(model.note.text),
                  ),
                ),
              ),
              KeyPadButtons()
            ],
          ),
        );
    }, 
    onModelReady: (PayableViewModel model){
      model.initFields();
    },
    viewModelBuilder: ()=>PayableViewModel());
  }
}
