import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'preview_sale_bottom_sheet.dart';

class PreviewSaleButton extends StatefulHookConsumerWidget {
  const PreviewSaleButton({
    Key? key,
  }) : super(key: key);

  @override
  PreviewSaleButtonState createState() => PreviewSaleButtonState();
}

class PreviewSaleButtonState extends ConsumerState<PreviewSaleButton> {
  @override
  Widget build(BuildContext context) {
    final saleCounts = ref.watch(transactionItemsProvider.notifier).counts;
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder.reactive(
        viewModelBuilder: () =>
            CoreViewModel(transaction: currentTransaction.value!),
        builder: (context, model, child) {
          return Expanded(
            child: SizedBox(
              height: 64,
              child: TextButton(
                style: primaryButtonStyle,
                onPressed: () async {
                  HapticFeedback.lightImpact();

                  model.keyboardKeyPressed(key: '+');
                  final transaction =
                      await ProxyService.isar.pendingTransaction(
                    branchId: ProxyService.box.getBranchId()!,
                  );

                  if (transaction == null) {
                    showToast(context, 'No item on cart!', color: Colors.red);
                    return;
                  }

                  model.keypad.setTransaction(transaction);
                  ref
                      .read(transactionItemsProvider.notifier)
                      .updatePendingTransaction();
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    useRootNavigator: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: PreviewSaleBottomSheet(),
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
                child: Text(
                  "Preview Sale ${saleCounts != 0 ? "($saleCounts)" : ""}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
