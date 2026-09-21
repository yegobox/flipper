import 'dart:ui' as ui;

import 'package:flipper_payments/src/ui/payment_tokens.dart';
import 'package:flipper_payments/src/ui/payment_typography.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Sticky header + radial gradient + a responsive body for payment screens.
///
/// The body is the handover's two-column layout: a form column that scrolls
/// and, on a wide enough viewport, an [aside] rail — summary, total, call to
/// action — that stays put while the form scrolls under it. Below
/// [twoColumnMinWidth] the rail is not dropped, it moves to the bottom of the
/// single column, which is what `flex-wrap` does in the handover and what a
/// phone needs anyway.
///
/// A screen that passes no [aside] keeps the single column it always had. It
/// still gains [maxContentWidth]: payment screens used to run edge to edge on
/// a desktop window, which left a 56px-tall field stretched across 1400px.
class PaymentScreenShell extends StatelessWidget {
  const PaymentScreenShell({
    super.key,
    required this.title,
    required this.children,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.overlay,
    this.aside,
    this.badge,
    this.maxContentWidth = kPaymentContentMaxWidth,
  });

  /// Handover: `max-width: 1140px; margin: 0 auto`.
  static const double kPaymentContentMaxWidth = 1140;

  /// Handover: the form column's flex basis (430) + the rail's min width
  /// (286) + the gap (16). Narrower than this and the two would wrap, so we
  /// stack instead.
  static const double twoColumnMinWidth = 732;

  /// Handover: `flex: 1 1 318px; min-width: 286px; max-width: 380px`.
  static const double asideMinWidth = 286;
  static const double asideMaxWidth = 380;

  final String title;
  final List<Widget> children;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? overlay;

  /// The sticky rail. Null (or empty) keeps the plain single column.
  final List<Widget>? aside;

  /// Small chip in the header's right slot — the handover's TEST pill.
  final Widget? badge;

  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final asideBlocks = aside ?? const <Widget>[];

    return Scaffold(
      backgroundColor: PaymentTokens.app,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: PaymentTokens.screenBackground),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _Header(
                    title: title,
                    showBack: showBack,
                    onBack: onBack,
                    actions: actions,
                    badge: badge,
                    maxContentWidth: maxContentWidth,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final gutter = _gutter(constraints.maxWidth);
                        final content = constraints.maxWidth - gutter * 2;
                        final twoColumn = asideBlocks.isNotEmpty &&
                            content >= twoColumnMinWidth;

                        return Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: maxContentWidth),
                            child: twoColumn
                                ? _TwoColumnBody(
                                    gutter: gutter,
                                    aside: asideBlocks,
                                    children: children,
                                  )
                                : _SingleColumnBody(
                                    gutter: gutter,
                                    children: [...children, ...asideBlocks],
                                  ),
                          ),
                        );
                      },
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

  /// Handover: `padding: … clamp(16px, 3vw, 24px)`.
  static double _gutter(double width) => (width * 0.03).clamp(16.0, 24.0);
}

class _SingleColumnBody extends StatelessWidget {
  const _SingleColumnBody({required this.gutter, required this.children});

  final double gutter;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 32),
      itemCount: children.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: PaymentTokens.blockGap),
      itemBuilder: (context, index) => children[index],
    );
  }
}

class _TwoColumnBody extends StatelessWidget {
  const _TwoColumnBody({
    required this.gutter,
    required this.children,
    required this.aside,
  });

  final double gutter;
  final List<Widget> children;
  final List<Widget> aside;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ColumnScroller(
              padding: const EdgeInsets.only(bottom: 32),
              children: children,
            ),
          ),
          const SizedBox(width: PaymentTokens.blockGap),
          // The rail does not ride the form's scroll — that is the whole point
          // of `position: sticky`. It scrolls on its own only when it is taller
          // than the viewport, so a short rail simply stays where it is.
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: PaymentScreenShell.asideMinWidth,
              maxWidth: PaymentScreenShell.asideMaxWidth,
            ),
            child: SizedBox(
              width: PaymentScreenShell.asideMaxWidth,
              child: _ColumnScroller(
                padding: const EdgeInsets.only(bottom: 32),
                children: aside,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColumnScroller extends StatelessWidget {
  const _ColumnScroller({required this.padding, required this.children});

  final EdgeInsets padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: PaymentTokens.blockGap),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.showBack,
    required this.onBack,
    required this.actions,
    required this.badge,
    required this.maxContentWidth,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? badge;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && (onBack != null || Navigator.canPop(context));
    final hasActions = actions != null && actions!.isNotEmpty;
    // Handover: 40px side slots; widen the right one when debug actions need
    // the room, so the title stays optically centred in the common case.
    const leftSlotWidth = 40.0;
    // The right slot is 40px to mirror the back button and keep the title
    // optically centred — but a badge is text, and 40px wraps "TEST" to
    // "TES / T". Give the badge the room it needs; the title stays centred
    // enough because the badge is narrow.
    final rightSlotWidth = hasActions
        ? 116.0
        : (badge != null ? 72.0 : 40.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xDBFFFFFF), // rgba(255,255,255,0.86)
            border: Border(
              bottom: BorderSide(color: PaymentTokens.line),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gutter = PaymentScreenShell._gutter(constraints.maxWidth);
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(gutter, 10, gutter, 10),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: PaymentTypography.headerTitle(),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: rightSlotWidth,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: hasActions
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: actions!,
                                  )
                                : (badge ?? const SizedBox.shrink()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
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

/// A small pill for the header's right slot — the handover's TEST chip.
class PaymentHeaderBadge extends StatelessWidget {
  const PaymentHeaderBadge({
    super.key,
    required this.label,
    this.background = PaymentTokens.warnTint,
    this.foreground = PaymentTokens.warnAmber,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontFamily: PaymentTypography.sans,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: foreground,
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
