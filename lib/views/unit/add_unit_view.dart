import 'package:customappbar/customappbar.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper/views/unit/add_unit_viewmodal.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';

class AddUnitTypeScreen extends StatelessWidget {
  const AddUnitTypeScreen({
    Key key,
  }) : super(key: key);

  List<Widget> _getUnitsWidgets(AddUnitViewModel model) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < model.sharedStateService.units.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(unit: model.sharedStateService.units[i]);
          },
          child: ListTile(
            title: Text(
              model.sharedStateService.units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: model.sharedStateService.units[i].id,
              groupValue: model.sharedStateService.units[i].focused
                  ? model.sharedStateService.units[i].id
                  : 0,
              onChanged: (Object value) {},
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, AddUnitViewModel model, Widget child) {
          return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Unit Type',
              showActionButton: true,
              disableButton: false,
              actionButtonName: 'Save',
              onPressedCallback: () {
                ProxyService.nav.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Stack(
              children: [
                model.sharedStateService.units.isEmpty
                    ? const SizedBox.shrink()
                    : ListView(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: _getUnitsWidgets(model),
                        ).toList(),
                      )
              ],
            ),
          );
        },
        viewModelBuilder: () => AddUnitViewModel());
  }
}
