import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_models/realm_model_export.dart';
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
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4.0,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              unit.name!,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            trailing: Radio<String>(
              value: unit.id.toString(),
              groupValue: unit.active! ? unit.id.toString() : '0',
              onChanged: (_) => _onUnitTapped(model, unit),
            ),
          ),
        ),
      );
    });
  }

  void _onUnitTapped(ProductViewModel model, IUnit unit) {
    model.saveFocusedUnit(
        newUnit: unit, id: model.product?.id.toString(), type: type);
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
            multi: 1,
            bottomSpacer: 70,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: model.units.isEmpty
                ? Center(
                    child: Text(
                      'No units available',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  )
                : ListView(
                    children: _getUnitsWidgets(model),
                  ),
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
