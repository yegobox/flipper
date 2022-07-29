import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'preview_sale_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PreviewSaleButton extends StatelessWidget {
  const PreviewSaleButton({
    Key? key,
    required this.saleCounts,
    required this.model,
  }) : super(key: key);
  final int saleCounts;
  final BusinessHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 64,
      child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.blue.withOpacity(0.04);
                }
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed)) {
                  return Colors.blue.withOpacity(0.12);
                }
                return null;
              },
            ),
          ),
          onPressed: () {
            if (model.kOrder == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("No active order to preview"),
                ),
              );
              return;
            }
            showBarModalBottomSheet(
              expand: false,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              context: context,
              barrierColor: Colors.black.withOpacity(0.25),
              backgroundColor: Colors.transparent,
              builder: (context) => PreviewSaleBottomSheet(
                saleCount: saleCounts,
                model: model,
              ),
            );
          },
          child: Text(
              "Preview Sale${saleCounts != 0 ? "(" + saleCounts.toString() + ")" : ""}",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: const Color(0xffFFFFFF)))),
    ));
  }
}
