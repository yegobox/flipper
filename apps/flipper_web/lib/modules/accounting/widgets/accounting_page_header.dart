import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flutter/material.dart';

class AccountingPageHeader extends StatelessWidget {
  const AccountingPageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow.toUpperCase(), style: AccountingTokens.eyebrow),
        const SizedBox(height: 6),
        Text(title, style: AccountingTokens.pageH1),
        const SizedBox(height: 4),
        Text(subtitle, style: AccountingTokens.sans(fontSize: 13.5, color: AccountingTokens.ink3)),
      ],
    );

    final actionBlock = actions.isEmpty
        ? null
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: actions,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackActions = constraints.maxWidth < 520;
          if (actionBlock == null || stackActions) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBlock,
                if (actionBlock != null) ...[const SizedBox(height: 12), actionBlock],
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: titleBlock),
              Flexible(child: actionBlock),
            ],
          );
        },
      ),
    );
  }
}

class AccountingButton extends StatelessWidget {
  const AccountingButton({
    super.key,
    required this.label,
    this.accIcon,
    this.icon,
    this.onPressed,
    this.primary = false,
    this.small = false,
    this.enabled = true,
  });

  final String label;
  final AccIcon? accIcon;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool primary;
  final bool small;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final height = small ? 34.0 : 40.0;
    final hPad = small ? 10.0 : 18.0;
    final labelStyle = AccountingTokens.sans(
      fontSize: small ? 13 : 14,
      fontWeight: FontWeight.w600,
      color: primary ? Colors.white : AccountingTokens.ink1,
    );

    Widget buildContent({required bool iconOnly}) {
      final iconSize = small ? 15.0 : 17.0;
      final iconColor = primary ? Colors.white : AccountingTokens.ink1;
      final iconWidget = accIcon != null
          ? AccountingIcon(icon: accIcon!, size: iconSize, color: iconColor)
          : icon != null
              ? Icon(icon, size: iconSize, color: iconColor)
              : null;

      if (iconOnly && iconWidget != null) return iconWidget;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconWidget != null) ...[
            iconWidget,
            if (!iconOnly) const SizedBox(width: 6),
          ],
          if (!iconOnly)
            Flexible(
              child: Text(
                label,
                style: labelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
        ],
      );
    }

    final buttonStyle = primary
        ? FilledButton.styleFrom(
            backgroundColor: AccountingTokens.accent,
            disabledBackgroundColor: AccountingTokens.accent.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(horizontal: hPad),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: AccountingTokens.ink1,
            side: const BorderSide(color: AccountingTokens.line),
            padding: EdgeInsets.symmetric(horizontal: hPad),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          );

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Table cells / PopupMenuButton can leave very little width for the label.
          final iconOnly =
              constraints.hasBoundedWidth && constraints.maxWidth < 56;
          final content = buildContent(iconOnly: iconOnly);

          final child = iconOnly
              ? content
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: content,
                );

          if (primary) {
            return FilledButton(
              onPressed: enabled ? onPressed : null,
              style: buttonStyle,
              child: child,
            );
          }
          return OutlinedButton(
            onPressed: enabled ? onPressed : null,
            style: buttonStyle,
            child: child,
          );
        },
      ),
    );
  }
}

class AccountingCard extends StatelessWidget {
  const AccountingCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
        border: Border.all(color: AccountingTokens.line),
        boxShadow: const [BoxShadow(color: Color(0x0A0B1220), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

class AccountingCardHeader extends StatelessWidget {
  const AccountingCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AccountingTokens.cardTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AccountingTokens.sans(fontSize: 12.5, color: AccountingTokens.ink3)),
                ],
              ],
            ),
          ),
          if (trailing != null) Flexible(child: trailing!),
        ],
      ),
    );
  }
}
