import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flipper_dashboard/payment/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Fixed header + radial gradient + scrollable body for payment screens.
class PaymentScreenShell extends StatelessWidget {
  const PaymentScreenShell({
    super.key,
    required this.title,
    required this.children,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.overlay,
  });

  final String title;
  final List<Widget> children;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && (onBack != null || Navigator.canPop(context));
    final hasActions = actions != null && actions!.isNotEmpty;
    // Handover: 44px side slots; widen right when debug/actions need more room.
    const leftSlotWidth = 44.0;
    final rightSlotWidth = hasActions ? 116.0 : 44.0;

    return Scaffold(
      backgroundColor: PaymentTokens.app,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: PaymentTokens.screenBackground),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: leftSlotWidth,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: canPop
                                ? _IconCircleButton(
                                    icon: FluentIcons.chevron_left_20_regular,
                                    onTap: onBack ??
                                        () => Navigator.maybePop(context),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            style: PaymentTypography.headerTitle(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: rightSlotWidth,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: hasActions
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: actions!,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: PaymentTokens.scrollPadding,
                      itemCount: children.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: PaymentTokens.blockGap),
                      itemBuilder: (context, index) => children[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PaymentTokens.surface,
      shape: const CircleBorder(),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: PaymentTokens.line),
            boxShadow: PaymentTokens.sh1,
          ),
          child: Icon(icon, size: 20, color: PaymentTokens.ink1),
        ),
      ),
    );
  }
}

/// Centered loading state inside the shell body area.
class PaymentCenterLoading extends StatelessWidget {
  const PaymentCenterLoading({super.key, this.message = 'Loading…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: PaymentTokens.blue,
              backgroundColor: PaymentTokens.line,
            ),
          ),
          const SizedBox(height: 18),
          Text(message, style: PaymentTypography.hint()),
        ],
      ),
    );
  }
}
