import 'package:flipper_dashboard/Comfirm.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';

import 'bottom_sheets/preview_sale_bottom_sheet.dart';

class PreviewSaleButton extends StatefulHookConsumerWidget {
  const PreviewSaleButton(
      {Key? key, this.wording, this.mode = SellingMode.forSelling})
      : super(key: key);
  final String? wording;
  final SellingMode mode;
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
      end: _buttonColor.withOpacity(0.8),
    ).animate(_controller);
  }

  void _handleOrderFlow(BuildContext context, CoreViewModel model) {
    final cartItem = ref.read(productFromSupplier);

    if (cartItem.value != null && cartItem.value!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Comfirm(),
        ),
      );
    } else {
      //TODO: show a notification toast
      toast("There is no item on cart");
    }
  }

  void _handleSaleFlow(BuildContext context, CoreViewModel model) async {
    HapticFeedback.lightImpact();

    _controller.forward();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: PreviewSaleBottomSheet(mode: widget.mode),
        );
      },
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    _controller.reverse();
  }

  String _getFormattedText(String wording, int itemCount) {
    final formattedItemCount = itemCount != 0 ? '($itemCount)' : '';
    final previewText = wording.isNotEmpty ? wording : 'Preview Cart';

    return '$previewText $formattedItemCount';
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.mode == SellingMode.forOrdering
        ? ref.watch(pendingTransactionProvider(TransactionType.cashOut))
        : ref.watch(pendingTransactionProvider(TransactionType.custom));
    final itemCount = ref
            .watch(transactionItemsProvider(transaction.value?.value?.id))
            .value
            ?.length ??
        0;
    // final itemCount = 0;
    final formattedText = _getFormattedText(widget.wording ?? '', itemCount);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        // return Text("here");
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
                onPressed: () {
                  ref.refresh(
                      transactionItemsProvider(transaction.value?.value?.id));
                  widget.mode == SellingMode.forSelling
                      ? _handleSaleFlow(context, model)
                      : _handleOrderFlow(context, model);
                },
                child: Text(
                  formattedText,
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
