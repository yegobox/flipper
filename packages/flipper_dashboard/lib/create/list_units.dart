import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class ListUnits extends StatelessWidget {
  ListUnits({Key? key, required this.type}) : super(key: key);
  final String type;
  final _routerService = locator<RouterService>();
  List<Widget> _getUnitsWidgets(ProductViewModel model) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < model.units.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(
                newUnit: model.units[i], id: model.product.id!!, type: type);
          },
          child: ListTile(
            title: Text(
              model.units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio<int>(
              value: model.units[i].id,
              groupValue: model.units[i].active ? model.units[i].id : 0,
              onChanged: (value) {
                model.saveFocusedUnit(
                    newUnit: model.units[i],
                    id: model.product.id!!,
                    type: type);
              },
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              _routerService.pop();
            },
            title: 'Unit Type',
            showActionButton: false,
            disableButton: false,
            onActionButtonClicked: () {
              _routerService.pop();
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
      onViewModelReady: (ProductViewModel model) {
        model.loadUnits();
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
