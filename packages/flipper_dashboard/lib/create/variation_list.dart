import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';

import 'package:flipper_models/models/variant_stock.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';

class VariationList extends StatelessWidget {
  const VariationList(
      {Key? key, required this.variations, required this.deleteVariant})
      : super(key: key);
  final List<VariantStock> variations;
  final Function deleteVariant;
  Widget _buildVariationsList({required List<VariantStock> variations}) {
    final List<Widget> list = <Widget>[];

    for (var i = 0; i < variations.length; i++) {
      //TODO: show regular when stocked! i.e stock is not 0
      if (variations[i].variantName != 'temp') {
        // &&
        // variations[i].variantName != 'Regular'
        list.add(
          Slidable(
            child: Center(
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: ListView(children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.dehaze,
                    ),
                    subtitle: Text(
                        '${variations[i].variantName} \nRWF ${variations[i].retailPrice}'),
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
                            Routes.receiveStock,
                            arguments: ReceiveStockArguments(
                              variantId: variations[i].id,
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
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  deleteVariant(variations[i].variantId);
                },
              ),
            ],
            actionPane: const SlidableDrawerActionPane(),
          ),
        );
      }
    }
    return Column(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return _buildVariationsList(variations: variations);
  }
}
