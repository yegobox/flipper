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
import 'package:flipper_loading/indicator/ball_pulse_indicator.dart';
import 'package:flipper_loading/loading.dart';

typedef void CompleteTransaction();

class PreviewSaleButton extends StatefulHookConsumerWidget {
  const PreviewSaleButton({
    Key? key,
    this.wording,
    this.mode = SellingMode.forSelling,
    required this.completeTransaction,
  }) : super(key: key);
  final String? wording;
  final SellingMode mode;
  final CompleteTransaction? completeTransaction;
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
      toast("There is no item on cart");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return SizedBox(
          height: 64,
          child: AnimatedBuilder(
            animation: _buttonColorTween,
            builder: (context, child) {
              return TextButton(
                style: primaryButtonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return _buttonColorTween.value;
                      }
                      return primaryButtonStyle.backgroundColor!
                          .resolve(states);
                    },
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        talker.info("init callback to complete transaction");
                        widget.completeTransaction!();
                      },
                child: isLoading
                    ? Loading(
                        indicator: BallPulseIndicator(),
                        size: 50.0,
                        color: Colors.white,
                      )
                    : Text(
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
