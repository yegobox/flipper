import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter/material.dart';

/// Primary CTA below customer search — same [FlipperButton] as Pay.
class AddNewCustomerButton extends StatelessWidget {
  const AddNewCustomerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FlipperButton(
      width: double.infinity,
      height: PosTokens.payButtonHeight,
      color: PosTokens.blue,
      text: isLoading ? 'Opening…' : label,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
