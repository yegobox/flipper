import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'preview_sale_bottom_sheet.dart';

class PreviewSaleButton extends StatelessWidget {
  const PreviewSaleButton({
    Key? key,
    required this.model,
  }) : super(key: key);
  final CoreViewModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 64,
        child: TextButton(
          style: primaryButtonStyle,
          onPressed: () async {
            HapticFeedback.lightImpact();

            model.keyboardKeyPressed(key: '+');
            final transaction = await ProxyService.isar.pendingTransaction(
              branchId: ProxyService.box.getBranchId()!,
            );

            if (transaction == null) {
              showToast(context, 'No item on cart!', color: Colors.red);
              return;
            }

            model.keypad.setTransaction(transaction);

            showFlexibleBottomSheet(
              context: context,
              useRootNavigator: true,
              minHeight: 0,
              initHeight: 0.5,
              maxHeight: 1,
              anchors: [0, 0.5, 1],
              isSafeArea: true,
              barrierColor: Colors.black.withOpacity(0.25),
              builder: (BuildContext context, ScrollController scrollController,
                  double bottomSheetOffset) {
                return PreviewSaleBottomSheet(
                  model: model,
                );
              },
            );

            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: Colors
                  .transparent, // set the navigation bar color to transparent
              systemNavigationBarIconBrightness:
                  Brightness.light, // set the icon color to light
            ));
          },
          child: StreamBuilder<List<TransactionItem>>(
            stream: model.transactionItemsStream(),
            builder: (context, snapshot) {
              final transactionItems = snapshot.data ?? [];
              final saleCounts = transactionItems.length;

              return Text(
                "Preview Sale ${saleCounts != 0 ? "($saleCounts)" : ""}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: const Color(0xffFFFFFF),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
