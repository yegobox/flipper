import 'package:flutter/material.dart';

class FluentButtonBase extends StatefulWidget {
  const FluentButtonBase({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    this.borderRadius = 4,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  State<FluentButtonBase> createState() => _FluentButtonBaseState();
}

class _FluentButtonBaseState extends State<FluentButtonBase> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isEnabled = widget.onPressed != null;

    final accentColor = colorScheme.primary;

    Color backgroundColor() {
      if (!isEnabled) {
        return isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF9F9F9);
      }
      if (_hovered) {
        return isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8);
      }
      return isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF3F3F3);
    }

    return FocusableActionDetector(
      enabled: isEnabled,
      mouseCursor:
          isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowHoverHighlight: (value) {
        setState(() => _hovered = value);
      },
      onShowFocusHighlight: (value) {
        setState(() => _focused = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: backgroundColor(),
          border: Border.all(
            width: _focused ? 2 : 1,
            color: !isEnabled
                ? colorScheme.outline.withValues(alpha: 0.1)
                : _focused
                    ? accentColor
                    : _hovered
                        ? accentColor.withValues(alpha: 0.6)
                        : colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: _hovered && isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: isEnabled
                ? accentColor.withValues(alpha: 0.12)
                : Colors.transparent,
            highlightColor: Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class SaveTicketButton extends StatelessWidget {
  const SaveTicketButton({
    super.key,
    required this.onPressed,
    this.label = 'Save Ticket (Park)',
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FluentButtonBase(
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
