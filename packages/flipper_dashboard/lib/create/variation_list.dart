import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';
// import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar_models.dart';

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
          StreamBuilder<Stock>(
            stream: ProxyService.isarApi.stockByVariantIdStream(
              variantId: variations[i].id,
            ),
            builder: (context, snapshot) {
              final Stock? stock = snapshot.data;
              return Slidable(
                key: Key('slidable-${variations[i].id}'),
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
                                GoRouter.of(context).push(Routes.stock +
                                    "/${variations[i].id}/${stock!.currentStock.toInt().toString()}");
                              },
                            ),
                          ],
                        ),
                        dense: true,
                      )
                    ]),
                  ),
                ),
                endActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),

                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(
                      key: Key('dismiss-${variations[i].id}'),
                      onDismissed: () {}),

                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (_) {
                        deleteVariant(variations[i].id);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
              );
            },
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
