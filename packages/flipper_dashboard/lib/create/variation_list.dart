import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:google_fonts/google_fonts.dart';

class VariationList extends StatelessWidget {
  VariationList({
    Key? key,
    required this.variations,
    required this.deleteVariant,
    required this.model,
  }) : super(key: key);
  final List<Variant> variations;
  final ProductViewModel model;
  final Function deleteVariant;
  final _routerService = locator<RouterService>();
  Widget _buildVariationsList({required List<Variant> variations}) {
    final List<Widget> list = <Widget>[];

    for (var i = 0; i < variations.length; i++) {
      if (variations[i].name != 'temp') {
        list.add(
          StreamBuilder<Stock>(
            stream: ProxyService.isar.stockByVariantIdStream(
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
                        leading: Icon(FluentIcons.cart_24_regular),
                        subtitle: Text(
                          '${variations[i].name} \nRWF ${variations[i].retailPrice}',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextButton(
                              child: Text(
                                stock == null || stock.currentStock == 0.0
                                    ? 'Receive Stock'
                                    : stock.currentStock.toString() +
                                        ' in stock',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                _routerService.navigateTo(ReceiveStockRoute(
                                    variantId: variations[i].id,
                                    existingStock: stock!.currentStock
                                        .toInt()
                                        .toString()));
                              },
                            ),
                          ],
                        ),
                        dense: true,
                      )
                    ]),
                  ),
                ),
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),
                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (_) {
                        deleteVariant(variations[i].id);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: FluentIcons.delete_20_regular,
                      label: 'Delete',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const ScrollMotion(),
                  // All actions are defined in the children parameter.
                  children: [
                    // A SlidableAction can have an icon and/or a label.
                    SlidableAction(
                      onPressed: (_) {
                        deleteVariant(variations[i].id);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: FluentIcons.delete_20_regular,
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
