import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, tonal }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.padding,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final EdgeInsets? padding;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderRadius = BorderRadius.circular(28.0);
    final content = isLoading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _foregroundColor(theme),
            ),
          );

    final child = Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: content,
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return Container(
          decoration: BoxDecoration(
            color: _backgroundColor(theme),
            borderRadius: borderRadius,
          ),
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              padding: EdgeInsets.zero,
            ),
            child: child,
          ),
        );

      case AppButtonVariant.tonal:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
      case AppButtonVariant.secondary:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: content,
        );
    }
  }

  Color _backgroundColor(ThemeData theme) {
    // Use neutral dark look similar to HomeScreen primary
    return Colors.grey.shade900;
  }

  Color _foregroundColor(ThemeData theme) {
    if (variant == AppButtonVariant.secondary) return Colors.black;
    return Colors.white;
  }
}
