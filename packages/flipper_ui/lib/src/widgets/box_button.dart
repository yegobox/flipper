import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  final String title;
  final bool disabled;
  final bool busy;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final double borderRadius;
  final Key? key;

  const BoxButton({
    Key? key,
    required this.title,
    this.disabled = false,
    this.busy = false,
    this.borderRadius = 8,
    this.onTap,
    this.leading,
  })  : outline = false,
        key = key,
        super(key: key);

  const BoxButton.outline({
    required this.title,
    this.onTap,
    this.leading,
    this.borderRadius = 8,
    Key? key,
  })  : disabled = false,
        busy = false,
        outline = true,
        key = key,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled || busy ? null : onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      splashColor: outline
          ? Colors.blue.withOpacity(0.1)
          : Colors.white.withOpacity(0.3),
      child: AnimatedContainer(
        key: key,
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: outline
              ? Colors.transparent
              : !disabled
                  ? const Color(0xff006AFE)
                  : Colors.grey[400],
          borderRadius: BorderRadius.circular(borderRadius),
          border: outline
              ? Border.all(color: const Color(0xff006AFE), width: 1.5)
              : null,
          boxShadow: !disabled && !outline
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 4.0,
                  ),
                ]
              : [],
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
                      color: outline ? const Color(0xff006AFE) : Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
