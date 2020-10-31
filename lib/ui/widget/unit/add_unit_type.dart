import 'package:customappbar/customappbar.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/model/unit.dart';

import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/product/add/add_product_viewmodel.dart';
import 'package:flipper/ui/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddUnitTypeScreen extends StatelessWidget {
  const AddUnitTypeScreen({
    Key key,
    this.model,
  }) : super(key: key);


  final AddProductViewmodel model;

  List<Widget> _getUnitsWidgets(List<Unit> units, CommonViewModel vm) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < units.length; i++) {
      if (units[i].focused && model.product.id != null) {
        model.updateProductWithCurrentUnit(unit: units[i]);
      }
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(unit: units[i]);
          },
          child: ListTile(
            title: Text(
              units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio(
              value: units[i].id,
              groupValue: units[i].focused ? units[i].id : 0,
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
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              ProxyService.nav.pop();
            },
            title: 'Edit Unit',
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
              model.units.isEmpty
                  ? const SizedBox.shrink()
                  : ListView(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: _getUnitsWidgets(model.units, vm),
                      ).toList(),
                    )
            ],
          ),
        );
      },
    );
  }
}
