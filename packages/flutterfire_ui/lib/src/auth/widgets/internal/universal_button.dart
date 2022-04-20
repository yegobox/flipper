import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'platform_widget.dart';

enum ButtonVariant {
  text,
  filled,
  outlined,
}

class UniversalButton extends PlatformWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final IconData? icon;
  final TextDirection? direction;
  final ButtonVariant? variant;
  final Color? color;

  const UniversalButton({
    Key? key,
    this.text,
    this.child,
    this.onPressed,
    this.icon,
    this.direction = TextDirection.ltr,
    this.variant,
    this.color,
  })  : assert(text != null || child != null),
        super(key: key);

  ButtonVariant get _variant {
    return variant ?? ButtonVariant.filled;
  }

  @override
  Widget buildCupertino(BuildContext context) {
    late Widget button;

    final child = Row(
      textDirection: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          if (direction == TextDirection.rtl) const SizedBox(width: 8),
          Icon(icon, size: 20),
          if (direction == TextDirection.ltr) const SizedBox(width: 8),
        ],
        this.child ?? Text(text!),
      ],
    );

    if (_variant == ButtonVariant.text || _variant == ButtonVariant.outlined) {
      button = CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: child,
      );
    } else {
      button = CupertinoButton.filled(
        onPressed: onPressed,
        child: child,
      );
    }

    if (color != null) {
      return CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(primaryColor: color),
        child: button,
      );
    } else {
      return button;
    }
  }

  @override
  Widget buildMaterial(BuildContext context) {
    final child = this.child ?? Text(text!);

    ButtonStyle? style;

    if (color != null) {
      MaterialStateColor? foregroundColor;
      MaterialStateColor? backgroundColor;

      if (variant == ButtonVariant.text) {
        foregroundColor = MaterialStateColor.resolveWith((_) => color!);
      } else {
        backgroundColor = MaterialStateColor.resolveWith((_) => color!);
      }

      style = ButtonStyle(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        overlayColor: MaterialStateColor.resolveWith(
          (states) => color!.withAlpha(20),
        ),
      );
    }

    if (icon != null) {
      switch (_variant) {
        case ButtonVariant.text:
          return TextButton.icon(
            icon: Icon(icon),
            onPressed: onPressed,
            label: child,
            style: style,
          );
        case ButtonVariant.filled:
          return ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: child,
            style: style,
          );
        case ButtonVariant.outlined:
          return OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: child,
            style: style,
          );
      }
    } else {
      switch (_variant) {
        case ButtonVariant.text:
          return TextButton(
            onPressed: onPressed,
            style: style,
            child: child,
          );
        case ButtonVariant.filled:
          return ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          );
        case ButtonVariant.outlined:
          return OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          );
      }
    }
  }
}
