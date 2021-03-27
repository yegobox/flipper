import 'package:flipper_models/variant_stock.dart';
import 'package:flipper/routes/router.gr.dart';

import 'file:///E:/demos/flipper/packages/flipper_models/lib/view_models/variation_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class VariationList extends StatelessWidget {
  const VariationList({Key key}) : super(key: key);

  Widget _buildVariationsList({List<VariantStock> variations}) {
    // final Logger log = Logging.getLogger('variation List:)');
    final List<Widget> list = <Widget>[];

    if (variations.length < 2) {
      return const SizedBox
          .shrink(); //we do not show a regular variant if it is only variant we have, otherwise if a user has added other non default variants then show them
    }
    for (var i = 0; i < variations.length; i++) {
      if (variations[i].name != 'tmp') {
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
    if (list.isEmpty) {
      return const SizedBox.shrink();
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
