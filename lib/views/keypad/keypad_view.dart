import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/views/keypad/key_pad_buttons.dart';
import 'package:flipper/views/welcome/payable/payable_viewmodel.dart';


import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class KeyPadView extends StatelessWidget {
   KeyPadView({Key key}) : super(key: key);

 
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, PayableViewModel model, Widget child) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Column(children:[
               
                 Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75.3,
                  color: Colors.white30,
                  child: ListTile(
                    trailing: FlatButton(
                      child: Text(model.payable.text),
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
                ]),
                
               
                const Positioned(
                  top: 35,
                  left: 5,
                  right: 5,
                  child: KeyPadButtons(),
                )
              ],
            ),
          );
        },
        onModelReady: (PayableViewModel model) {
          model.initFields();
        },
        viewModelBuilder: () => PayableViewModel());
  }
}
