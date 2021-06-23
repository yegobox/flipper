import 'package:flipper/routes.router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_models/stock.dart';

class VariationList extends StatelessWidget {
  const VariationList({
    Key? key,
    required this.variations,
    required this.deleteVariant,
    required this.model,
  }) : super(key: key);
  final List<Variant> variations;
  final ProductViewModel model;
  final Function deleteVariant;
  Widget _buildVariationsList({required List<Variant> variations}) {
    final List<Widget> list = <Widget>[];

    for (var i = 0; i < variations.length; i++) {
      if (variations[i].name != 'temp') {
        list.add(
          Container(
            child: StreamBuilder<Stock>(
              stream: ProxyService.api.stockByVariantIdStream(
                variantId: variations[i].id,
              ),
              builder: (context, snapshot) {
                final Stock? stock = snapshot.data;
                return Slidable(
                  child: Center(
                    child: SizedBox(
                      height: 90,
                      width: double.infinity,
                      child: Column(children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.dehaze,
                          ),
                          subtitle: Text(
                              '${variations[i].name} \nRWF ${stock != null ? stock.retailPrice : 0.0}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  stock == null || stock.currentStock == 0.0
                                      ? 'Receive Stock'
                                      : stock.currentStock.toString() +
                                          ' in stock',
                                ),
                                onPressed: () {
                                  ProxyService.nav.navigateTo(
                                    Routes.stock,
                                    arguments: ReceiveStockArguments(
                                      variantId: variations[i].id,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
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
                );
              },
            ),
          ),
        );
      }
    }
    return Wrap(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return _buildVariationsList(variations: variations);
  }
}
