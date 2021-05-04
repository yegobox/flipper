import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/models/variation.dart';

class VariationList extends StatelessWidget {
  const VariationList(
      {Key? key, required this.variations, required this.deleteVariant})
      : super(key: key);
  final List<Variation> variations;
  final Function deleteVariant;
  Widget _buildVariationsList({required List<Variation> variations}) {
    final List<Widget> list = <Widget>[];

    for (var i = 0; i < variations.length; i++) {
      if (variations[i].name != 'temp') {
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
                  deleteVariant(variations[i].id);
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
