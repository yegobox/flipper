import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final double borderRadius;
  final Color? color;

  const BoxButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.busy = false,
    this.borderRadius = 8,
    this.onTap,
    this.leading,
    this.color,
  })  : outline = false,
        super(key: key);

  const BoxButton.outline({
    Key? key,
    required this.title,
    this.onTap,
    this.leading,
    this.borderRadius = 8,
    this.color,
  })  : disabled = false,
        busy = false,
        outline = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = outline
        ? Colors.transparent
        : disabled
            ? Colors.grey[400]
            : color ?? const Color(0xff006AFE);

    final textColor = outline ? const Color(0xff006AFE) : Colors.white;

    final border =
        outline ? Border.all(color: const Color(0xff006AFE), width: 1.5) : null;

    final List<BoxShadow> boxShadow = !disabled && !outline && color == null
        ? [
            BoxShadow(
              color: const Color(0xff006AFE).withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 4.0,
            ),
          ]
        : <BoxShadow>[];

    return InkWell(
      onTap: disabled || busy ? null : onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      splashColor: outline
          ? const Color(0xff006AFE).withOpacity(0.1)
          : Colors.white.withOpacity(0.3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: boxShadow,
        ),
        child: busy
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) leading!,
                  if (leading != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
