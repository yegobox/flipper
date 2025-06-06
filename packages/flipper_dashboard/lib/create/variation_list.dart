import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:google_fonts/google_fonts.dart';

class VariationList extends StatelessWidget {
  VariationList({
    Key? key,
    required this.variations,
    required this.deleteVariant,
  }) : super(key: key);

  final List<Variant> variations;
  final Function deleteVariant;
  final _routerService = locator<RouterService>();

  Widget _buildVariationListItem(Variant variant) {
    return Slidable(
      key: Key('slidable-${variant.id}'),
      child: Center(
        child: SizedBox(
          height: 90,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(FluentIcons.cart_24_regular),
                subtitle: Text(
                  '${variant.name} \nRWF ${variant.retailPrice}',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: Text(
                        variant.stock == null ||
                                variant.stock!.currentStock == 0.0
                            ? 'Receive Stock'
                            : '${variant.stock!.currentStock} in stock',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {
                        _routerService.navigateTo(
                          ReceiveStockRoute(
                            variantId: variant.id,
                            existingStock:
                                variant.stock!.currentStock.toString(),
                          ),
                        );
                      },
                    )
                  ],
                ),
                dense: true,
              ),
            ],
          ),
        ),
      ),
      startActionPane: _buildActionPane(variant),
      endActionPane: _buildActionPane(variant),
    );
  }

  ActionPane _buildActionPane(Variant variant) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (_) {
            deleteVariant(variant.id);
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: FluentIcons.delete_20_regular,
          label: 'Delete',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: variations
            .where((variant) => variant.name != 'temp')
            .map((variant) => _buildVariationListItem(variant))
            .toList(),
      ),
    );
  }
}
