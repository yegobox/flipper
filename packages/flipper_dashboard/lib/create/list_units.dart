import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.router.dart';
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
    return List.generate(model.units.length, (index) {
      final unit = model.units[index];
      return GestureDetector(
        onTap: () => _onUnitTapped(model, unit),
        child: ListTile(
          title: Text(
            unit.name,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: Radio<String>(
            value: unit.id,
            groupValue: unit.active ? unit.id : '0',
            onChanged: (_) => _onUnitTapped(model, unit),
          ),
        ),
      );
    });
  }

  void _onUnitTapped(ProductViewModel model, IUnit unit) {
    model.saveFocusedUnit(newUnit: unit, id: model.product?.id, type: type);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            onPop: () {
              _routerService.navigateTo(AddProductViewRoute(
                productId: model.product!.id,
              ));
            },
            title: 'Unit Type',
            showActionButton: false,
            disableButton: false,
            onActionButtonClicked: () {
              _routerService.navigateTo(AddProductViewRoute(
                productId: model.product!.id,
              ));
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
      onViewModelReady: (ProductViewModel model) async {
        await model.getProduct();
        model.loadUnits();
      },
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}
