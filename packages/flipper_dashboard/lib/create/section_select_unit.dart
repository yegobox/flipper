import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionSelectUnit extends StatelessWidget {
  SectionSelectUnit({Key? key, required this.product, required this.type})
      : super(key: key);
  final Product product;
  final String type;
  final _routerService = locator<RouterService>();
  Text unitSelector(Product units) {
    late Text text = Text(
      'Select Unit',
      style: GoogleFonts.poppins(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
    );

    if (product.unit != '') {
      text = Text(
        product.unit ?? 'Select Unit',
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
      );
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            _routerService.navigateTo(ListUnitsRoute(type: type));
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.4),
            dense: true,
            leading: Text(
              'Unit Type',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Wrap(
              children: [
                unitSelector(product),
                Theme(
                  data: ThemeData(
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                    ),
                  ),
                  child: const Icon(FluentIcons.arrow_forward_20_regular),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
