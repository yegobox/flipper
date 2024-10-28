import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// First, let's create a proper state class to handle loading status

// Modified PreviewSaleButton
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

  Future<void> _handleButtonPress(WidgetRef ref) async {
    final loadingNotifier = ref.read(loadingProvider.notifier);

    switch (mode) {
      case SellingMode.forSelling:
        if (completeTransaction != null) {
          try {
            loadingNotifier.startLoading();
            completeTransaction?.call();
            // Note: Don't stop loading here - let the completion handler do it
          } catch (e) {
            loadingNotifier.setError(e.toString());
          }
        }
        break;
      case SellingMode.forOrdering:
        if (previewCart != null) {
          try {
            loadingNotifier.startLoading();
            previewCart?.call();
            // Note: Don't stop loading here - let the completion handler do it
          } catch (e) {
            loadingNotifier.setError(e.toString());
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(loadingProvider);

    return SizedBox(
      height: 64,
      width: 64,
      child: TextButton(
        key: const Key("PaymentButton"),
        style: _getButtonStyle(),
        onPressed:
            loadingState.isLoading ? null : () => _handleButtonPress(ref),
        child: _ButtonContent(
          isLoading: loadingState.isLoading,
          wording: wording,
          error: loadingState.error,
        ),
      ),
    );
  }
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

// Modified _ButtonContent to handle errors
class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isLoading,
    required this.wording,
    this.error,
  });

  final bool isLoading;
  final String wording;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Text(
        error!,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      );
    }

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
