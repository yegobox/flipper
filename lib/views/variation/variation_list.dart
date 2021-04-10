import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_models/variant_stock.dart';
import 'package:flipper_models/view_models/variation_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class VariationList extends StatelessWidget {
  const VariationList({Key key}) : super(key: key);

  Widget _buildVariationsList({List<VariantStock> variations}) {
    final List<Widget> list = <Widget>[];
    for (var i = 0; i < variations.length; i++) {
      //TODO: show regular when stocked! i.e stock is not 0
      if (variations[i].name != 'tmp' && variations[i].name != 'Regular') {
        list.add(
          Center(
            child: SizedBox(
              height: 90,
              width: 350,
              child: ListView(children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.dehaze,
                  ),
                  subtitle: Text(
                      '${variations[i].name} \nRWF ${variations[i].retailPrice}'),
                  trailing:
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    FlatButton(
                      child: Text(
                        variations[i].currentStock == 0
                            ? 'Receive Stock'
                            : variations[i].currentStock.toString() +
                                ' ' +
                                'in Stock',
                      ),
                      onPressed: () {
                        ProxyService.nav.navigateTo(
                          Routing.receiveStock,
                          arguments: ReceiveStockScreenArguments(
                            id: variations[i].id,
                          ),
                        );
                      },
                    ),
                  ]),
                  dense: true,
                )
              ]),
            ),
          ),
        );
      }
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => VariationViewModel(),
      onModelReady: (VariationViewModel model) {
        model.getVariationsByProductId();
      },
      builder: (BuildContext context, VariationViewModel model, Widget child) {
        return _buildVariationsList(variations: model.variations);
      },
    );
  }
}
