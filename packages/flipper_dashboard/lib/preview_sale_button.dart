import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'preview_sale_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PreviewSaleButton extends StatelessWidget {
  const PreviewSaleButton({
    Key? key,
    required this.model,
  }) : super(key: key);
  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 64,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
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
        onPressed: () async {
          Transaction? transaction = await ProxyService.isar
              .pendingTransaction(branchId: ProxyService.box.getBranchId()!);
          if (transaction == null) {
            showToast(context, 'No item on cart!', color: Colors.red);
            return;
          }
          model.keypad.setTransaction(transaction);
          showBarModalBottomSheet(
            overlayStyle: SystemUiOverlayStyle.light,
            expand: false,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
            ),
            context: context,
            useRootNavigator: true,
            topControl: SizedBox(
              height: 89,
            ),
            barrierColor: Colors.black.withOpacity(0.25),
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              child: PreviewSaleBottomSheet(
                model: model,
              ),
            ),
          ).whenComplete(() {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor:
                  Colors.white, // change the color of the navigation bar
              systemNavigationBarIconBrightness:
                  Brightness.dark, // set the icon color to dark
            ));
          });
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Colors
                .transparent, // set the navigation bar color to transparent
            systemNavigationBarIconBrightness:
                Brightness.light, // set the icon color to light
          ));
        },
        child: StreamBuilder<List<TransactionItem>>(
            stream: ProxyService.isar.transactionItemsStream(),
            builder: (context, snapshot) {
              final transactionItems =
                  snapshot.data ?? []; // Retrieve the data from the stream
              final saleCounts = transactionItems
                  .length; // Calculate the saleCounts based on the transactionItems

              return Text(
                "Preview Sale${saleCounts != 0 ? "($saleCounts)" : ""}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: const Color(0xffFFFFFF),
                ),
              );
            }),
      ),
    ));
  }
}
