import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flutter/material.dart';

/// Handoff `.acc-iconbtn` / `.acc-iconbtn.sm` — icon-only row actions.
class AccountingIconButton extends StatelessWidget {
  const AccountingIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.small = false,
    this.tooltip,
  });

  final AccIcon icon;
  final VoidCallback? onPressed;
  final bool small;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final size = small ? 32.0 : 40.0;
    final radius = small ? 8.0 : 10.0;
    final iconSize = small ? 18.0 : 19.0;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        hoverColor: AccountingTokens.surface2,
        child: SizedBox(
          width: size,
          height: size,
          child: AccountingIcon(
            icon: icon,
            size: iconSize,
            color: small ? AccountingTokens.ink3 : AccountingTokens.ink2,
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
