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
    for (var i = 0; i < model.state.units.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(newUnit: model.state.units[i]);
          },
          child: ListTile(
            title: Text(
              model.state.units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: model.state.units[i].id,
              groupValue:
                  model.state.units[i].focused ? model.state.units[i].id : 0,
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
                model.state.units.isEmpty
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
