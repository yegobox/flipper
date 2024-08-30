import 'package:flutter/material.dart';

class FlipperCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FlipperCloseButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: const Icon(Icons.close));
  }
}
