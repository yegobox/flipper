import 'package:flipper/views/settings/bluethooth/bluethooth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:customappbar/customappbar.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              actionButtonName: 'Save',
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Search Paired Bluetooth'),
                  OutlineButton(
                    onPressed: () {
                      model.getBluetooth();
                    },
                    child: const Text('Search'),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: model.state.bluethioothDevices != null &&
                              model.state.bluethioothDevices.isNotEmpty
                          ? model.state.bluethioothDevices.length
                          : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            final String select =
                                model.state.bluethioothDevices[index];
                            final List list = select.split('#');
                            // String name = list[0];
                            final String mac = list[1];
                            model.setConnect(mac);
                          },
                          title: Text(
                              '${model.state.bluethioothDevices[index]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: Colors.black)),
                          subtitle: const Text('Click to connect'),
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
                    onPressed: model.state.blueConnected
                        ? model.blue.printTicket
                        : null,
                    child: const Text('Print Ticket'),
                  ),
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => BlueToothViewModel());
  }
}
