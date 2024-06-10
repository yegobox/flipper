import 'package:flipper_dashboard/Comfirm.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';

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
    final cartItem = ref.watch(productFromSupplier); // Use watch here

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

  ////TODO: when working on order resume this.
  // void _handleSaleFlow(BuildContext context, CoreViewModel model) async {
  //   HapticFeedback.lightImpact();

  //   _controller.forward();

  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
  //     ),
  //     useRootNavigator: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.only(top: 20.0),
  //         child: PreviewSaleBottomSheet(mode: widget.mode),
  //       );
  //     },
  //   );

  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     systemNavigationBarColor: Colors.transparent,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   ));
  //   _controller.reverse();
  // }

  @override
  Widget build(BuildContext context) {
    final pendingTransaction =
        ref.watch(pendingTransactionProvider(TransactionType.sale));
    final _routerService = locator<RouterService>();

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CoreViewModel(),
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
                  if (pendingTransaction.asData?.value.asData?.value.subTotal
                          .round() ==
                      0) {
                    showSnackBar(context, "Your cart is empty",
                        textColor: Colors.white, backgroundColor: Colors.green);
                    return;
                  }

                  /// clause the bottom sheet before navigating to transaction because if we don't then it will try to rebuild when we navigate back

                  _routerService.navigateTo(
                    PaymentsRoute(
                      transaction: pendingTransaction.value!.value!,
                    ),
                  );
                },
                child: Text(
                  "Pay",
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
