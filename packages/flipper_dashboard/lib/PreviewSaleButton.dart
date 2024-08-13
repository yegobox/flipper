import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flipper_loading/indicator/ball_pulse_indicator.dart';
import 'package:flipper_loading/loading.dart';

class PreviewSaleButton extends StatefulHookConsumerWidget {
  const PreviewSaleButton(
      {super.key,
      this.completeTransaction,
      this.previewCart,
      this.wording,
      required this.mode});

  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String? wording;
  final SellingMode mode;
  @override
  _PreviewsalebuttonState createState() => _PreviewsalebuttonState();
}

class _PreviewsalebuttonState extends ConsumerState<PreviewSaleButton> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final finalWording = widget.wording ?? "Pay";
    return SizedBox(
      height: 64,
      child: TextButton(
        style: primaryButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                // return _buttonColorTween.value;
              }
              return primaryButtonStyle.backgroundColor!.resolve(states);
            },
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                if (widget.previewCart != null) {
                  talker.warning("Previewing Cart");
                  return widget.previewCart?.call();
                }
                if (widget.mode == SellingMode.forSelling) {
                  talker.info("While selling");
                  widget.completeTransaction!();
                  return;
                }
                if (widget.mode == SellingMode.forOrdering) {
                  talker.info("While ordering");
                  widget.previewCart!();
                  return;
                }
              },
        child: isLoading
            ? Loading(
                indicator: BallPulseIndicator(),
                size: 50.0,
                color: Colors.white,
              )
            : Text(
                finalWording,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
