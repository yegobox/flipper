import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/view_models/unit_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddUnitTypeScreen extends StatelessWidget {
  const AddUnitTypeScreen({
    Key key,
  }) : super(key: key);

  List<Widget> _getUnitsWidgets(UnitViewModel model) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < model.units.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(newUnit: model.units[i]);
          },
          child: ListTile(
            title: Text(
              model.units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: model.units[i].id,
              groupValue: model.units[i].focused ? model.units[i].id : 0,
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
        builder: (BuildContext context, UnitViewModel model, Widget child) {
          return Scaffold(
            appBar: CustomAppBar(
              onPop: () {
                ProxyService.nav.pop();
              },
              title: 'Unit Type',
              showActionButton: false,
              disableButton: false,
              onPressedCallback: () {
                ProxyService.nav.pop();
              },
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: Stack(
              children: [
                model.units.isEmpty
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
        onModelReady: (UnitViewModel model) {
          model.loadUnits();
        },
        viewModelBuilder: () => UnitViewModel());
  }
}
