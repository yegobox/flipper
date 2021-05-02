import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';

class ListUnits extends StatelessWidget {
  const ListUnits({Key? key, required this.type}) : super(key: key);
  final String type;

  List<Widget> _getUnitsWidgets(ProductViewModel model) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < model.units.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            model.saveFocusedUnit(
                newUnit: model.units[i], id: model.product.id, type: type);
          },
          child: ListTile(
            title: Text(
              model.units[i].name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: Radio<Object?>(
              value: model.units[i].id,
              groupValue: model.units[i].focused ? model.units[i].id : 0,
              onChanged: (value) {},
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
              ProxyService.nav.back();
            },
            title: 'Unit Type',
            showActionButton: false,
            disableButton: false,
            onPressedCallback: () {
              ProxyService.nav.back();
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
      onModelReady: (ProductViewModel model) {
        model.loadUnits();
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
