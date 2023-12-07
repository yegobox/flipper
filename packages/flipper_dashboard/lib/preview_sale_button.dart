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
  const PreviewSaleButton({Key? key, this.wording, this.forOrdering = false})
      : super(key: key);
  final String? wording;
  final bool forOrdering;
  @override
  PreviewSaleButtonState createState() => PreviewSaleButtonState();
}

class PreviewSaleButtonState extends ConsumerState<PreviewSaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _buttonColorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final Color _buttonColor = primaryButtonStyle.backgroundColor!.resolve({})!;

    _buttonColorTween = ColorTween(
      begin: primaryButtonStyle.backgroundColor?.resolve(Set.of([])),
      end: _buttonColor
          .withOpacity(0.8), // Change this to the desired pressed color
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CoreViewModel(
          transaction: ref.watch(pendingTransactionProvider).value),
      builder: (context, model, child) {
        return SizedBox(
          height: 64,
          child: AnimatedBuilder(
            animation: _buttonColorTween,
            builder: (context, child) {
              return TextButton(
                style: primaryButtonStyle.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return _buttonColorTween.value;
                      }
                      return primaryButtonStyle.backgroundColor!
                          .resolve(states);
                    },
                  ),
                ),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  model.keyboardKeyPressed(key: '+');

                  _controller.forward(); // Start the animation
                  final transaction =
                      await ProxyService.isar.pendingTransaction(
                    branchId: ProxyService.box.getBranchId()!,
                  );

                  if (transaction == null) {
                    showToast(context, 'No item on cart!', color: Colors.red);
                    return;
                  }

                  model.keypad.setTransaction(transaction);

                  showModalBottomSheet(
                    // backgroundColor: Colors.red,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    useRootNavigator: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: PreviewSaleBottomSheet(
                            forOrdering: widget.forOrdering),
                      );
                    },
                  );

                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarIconBrightness: Brightness.light,
                  ));
                  _controller.reverse();
                },
                child: Text(
                  widget.wording == null
                      ? "Preview Sale ${ref.watch(transactionItemsProvider.notifier).counts != 0 ? "(${ref.watch(transactionItemsProvider.notifier).counts})" : ""}"
                      : "Preview Cart ${ref.watch(transactionItemsProvider.notifier).counts != 0 ? "(${ref.watch(transactionItemsProvider.notifier).counts})" : ""}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
