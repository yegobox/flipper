import 'package:flutter/cupertino.dart';
import 'package:flutterfire_ui/auth.dart';

import 'universal_button.dart';

class _LoadingButtonContent extends StatelessWidget {
  final String label;
  final bool isLoading;
  const _LoadingButtonContent({
    Key? key,
    required this.label,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCupertino = CupertinoUserInterfaceLevel.maybeOf(context) != null;

    Widget child = Text(label);

    if (isLoading) {
      child = LoadingIndicator(
        size: isCupertino ? 20 : 16,
        borderWidth: 1,
      );
    }

    return child;
  }
}

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;
  final ButtonVariant? variant;

  const LoadingButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.icon,
    this.color,
    this.variant = ButtonVariant.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = _LoadingButtonContent(label: label, isLoading: isLoading);

    return UniversalButton(
      color: color,
      icon: icon,
      onPressed: onTap,
      variant: variant,
      child: content,
    );
  }
}
