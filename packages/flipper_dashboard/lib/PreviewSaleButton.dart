import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewSaleButton extends ConsumerWidget {
  const PreviewSaleButton({
    super.key,
    this.completeTransaction,
    this.previewCart,
    this.wording = 'Pay',
    required this.mode,
  });

  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String wording;
  final SellingMode mode;

  void _handleButtonPress(WidgetRef ref) {
    switch (mode) {
      case SellingMode.forSelling:
        if (completeTransaction != null) {
          ref.read(loadingProvider.notifier).state = true;
          completeTransaction?.call();
        }
        break;
      case SellingMode.forOrdering:
        if (previewCart != null) {
          ref.read(loadingProvider.notifier).state = true;
          previewCart?.call();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 64,
      width: 64,
      child: TextButton(
        key: const Key("PaymentButton"),
        style: _getButtonStyle(),
        onPressed:
            ref.watch(loadingProvider) ? null : () => _handleButtonPress(ref),
        child: _ButtonContent(
          isLoading: ref.watch(loadingProvider),
          wording: wording,
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.blue.shade700;
          }
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.blue;
        },
      ),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isLoading,
    required this.wording,
  });

  final bool isLoading;
  final String wording;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
        : Text(
            wording,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
