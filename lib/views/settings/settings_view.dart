import 'package:flipper/views/settings/bluethooth/bluethooth_viewmodel.dart';
import 'package:flipper_models/printable.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:customappbar/customappbar.dart';
import 'package:flipper_services/proxy.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _toggled =false;

  @override
  Widget build(BuildContext context) {
    final List<Printable> print = [];
    // test data to print:
    print.add(Printable((PrintableBuilder p) => p
      ..price = 400
      ..unit = 'kg'
      ..quantity = 10
      ..amount = 10
      ..name = 'B'));
    print.add(Printable((PrintableBuilder p) => p
      ..price = 400
      ..unit = 'kg'
      ..quantity = 10
      ..amount = 10
      ..name = 'B'));
    //end test data to print:
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, BlueToothViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Settings',
              showActionButton: false,
              onPressedCallback: () async {
                ProxyService.nav.pop();
              },
              rightActionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: model.state.bluethioothDevices != null &&
                              model.state.bluethioothDevices.isNotEmpty
                          ? model.state.bluethioothDevices.length
                          : 0,
                      itemBuilder: (context, index) {
                        return SwitchListTile(
                          title: Text(
                              '${model.state.bluethioothDevices[index]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.black)),
                          subtitle: const Text('Click to connect'),
                          value: _toggled,
                          controlAffinity: ListTileControlAffinity.trailing, onChanged: (bool value) {
                            setState(() {
                              _toggled = value;
                            });
                        },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OutlineButton(
                    onPressed: model.state.blueConnected
                        ? model.blue.printGraphics
                        : null,
                    child: const Text('Print'),
                  ),
                  OutlineButton(
                    onPressed: () => {
                      if (model.state.blueConnected)
                        {model.blue.printTicket(printables: print)}
                    },
                    child: const Text('Print Ticket'),
                  ),
                ],
              ),
            ),
          );
        },
        onModelReady: (BlueToothViewModel model){
          model.getBluetooth(); //start by searching available devices
        },
        viewModelBuilder: () => BlueToothViewModel());
  }
}
