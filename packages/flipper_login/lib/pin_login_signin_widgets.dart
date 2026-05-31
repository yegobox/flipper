import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_login/pin_login_signin_motion.dart';
import 'package:flipper_login/pin_login_signin_text.dart';
import 'package:flipper_login/signin_tokens.dart';
import 'package:flutter/material.dart';

class SignInBrandHeader extends StatelessWidget {
  const SignInBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FlipperBrandBadge(size: 32),
        const SizedBox(width: 11),
        Text(
          'Flipper',
          style: context.signInText(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class SignInAccountChip extends StatelessWidget {
  final String initial;
  final String name;
  final String subtitle;
  final VoidCallback? onNotYou;

  const SignInAccountChip({
    super.key,
    required this.initial,
    required this.name,
    required this.subtitle,
    this.onNotYou,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: SignInTokens.surface2,
        borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
        border: Border.all(color: SignInTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SignInTokens.brandGradient,
            ),
            child: Text(
              initial.toUpperCase(),
              style: context.signInText(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.signInText(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: context.signInText(
                    fontSize: 12.5,
                    color: SignInTokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onNotYou,
            style: TextButton.styleFrom(
              foregroundColor: SignInTokens.blue,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Not you?',
              style: context.signInText(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: SignInTokens.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInPinCells extends StatelessWidget {
  final String pin;
  final bool showDigits;
  final bool hasError;
  final int activeIndex;
  final bool compact;
  final bool pinFocused;
  final VoidCallback onTap;

  const SignInPinCells({
    super.key,
    required this.pin,
    required this.showDigits,
    required this.hasError,
    required this.activeIndex,
    required this.compact,
    required this.pinFocused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cellHeight =
        compact ? SignInTokens.pinCellHeightCompact : SignInTokens.pinCellHeight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: List.generate(SignInTokens.pinCellCount, (i) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i < SignInTokens.pinCellCount - 1 ? (compact ? 7 : 10) : 0,
              ),
              child: _SignInPinCell(
                index: i,
                digit: i < pin.length ? pin[i] : null,
                showDigit: showDigits,
                isActive: pinFocused && i == activeIndex && !hasError,
                hasError: hasError,
                height: cellHeight,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SignInPinCell extends StatelessWidget {
  final int index;
  final String? digit;
  final bool showDigit;
  final bool isActive;
  final bool hasError;
  final double height;

  const _SignInPinCell({
    required this.index,
    required this.digit,
    required this.showDigit,
    required this.isActive,
    required this.hasError,
    required this.height,
  });

  bool get filled => digit != null;

  @override
  Widget build(BuildContext context) {
    Color border = SignInTokens.line;
    Color background = SignInTokens.surface;
    List<BoxShadow>? shadows;

    if (hasError) {
      border = SignInTokens.danger;
      background = SignInTokens.dangerTint;
    } else if (filled) {
      border = SignInTokens.blue;
      background = SignInTokens.blueTint;
    } else if (isActive) {
      border = SignInTokens.blue;
      background = SignInTokens.surface;
      shadows = [
        BoxShadow(
          color: SignInTokens.blueTint,
          spreadRadius: 4,
        ),
      ];
    }

    return AnimatedContainer(
      duration: SignInMotion.cellTransition,
      curve: SignInMotion.cellCurve,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
        border: Border.all(color: border, width: 1.5),
        boxShadow: shadows,
      ),
      child: filled
          ? (showDigit
              ? Text(
                  digit!,
                  style: context.signInPinDigit(
                    fontSize: height >= SignInTokens.pinCellHeight ? 24 : 22,
                  ),
                )
              : _SignInPinDot(key: ValueKey('dot-$index-$digit')))
          : null,
    );
  }
}

class _SignInPinDot extends StatelessWidget {
  const _SignInPinDot({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: SignInMotion.dotPop,
      curve: SignInMotion.dotPopCurve,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: SignInTokens.ink1,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SignInPinStatusLine extends StatelessWidget {
  final bool hasError;
  final bool isSuccess;
  final String message;
  final String successBusinessName;

  const SignInPinStatusLine({
    super.key,
    required this.hasError,
    required this.isSuccess,
    required this.message,
    this.successBusinessName = 'your business',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: SignInMotion.statusReveal,
      switchInCurve: SignInMotion.statusRevealCurve,
      switchOutCurve: SignInMotion.statusRevealCurve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isSuccess) {
      return Row(
        key: const ValueKey('success'),
        children: [
          const Icon(Icons.check_circle_outline,
              size: 15, color: SignInTokens.win),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Verified — opening $successBusinessName…',
              style: context.signInText(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SignInTokens.win,
              ),
            ),
          ),
        ],
      );
    }
    if (hasError && message.isNotEmpty) {
      return Row(
        key: ValueKey('error-$message'),
        children: [
          const Icon(Icons.info_outline, size: 15, color: SignInTokens.danger),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              message,
              style: context.signInText(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SignInTokens.danger,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox(key: ValueKey('empty'), height: 18);
  }
}

class SignInPinKeypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onToggleShow;
  final bool enabled;

  const SignInPinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onToggleShow,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final keyStyle = context.signInPinDigit(fontSize: 22);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.45,
      children: [
        for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
          _SignInKeypadKey(
            enabled: enabled,
            onTap: () => onDigit(d),
            child: Text(d, style: keyStyle),
          ),
        _SignInKeypadKey(
          enabled: enabled,
          onTap: onToggleShow,
          isAction: true,
          child: const Icon(Icons.visibility_outlined,
              color: SignInTokens.ink3, size: 20),
        ),
        _SignInKeypadKey(
          enabled: enabled,
          onTap: () => onDigit('0'),
          child: Text('0', style: keyStyle),
        ),
        _SignInKeypadKey(
          enabled: enabled,
          onTap: onBackspace,
          isAction: true,
          child: const Icon(Icons.backspace_outlined,
              color: SignInTokens.ink3, size: 20),
        ),
      ],
    );
  }
}

class _SignInKeypadKey extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isAction;
  final bool enabled;

  const _SignInKeypadKey({
    required this.child,
    required this.onTap,
    this.isAction = false,
    this.enabled = true,
  });

  @override
  State<_SignInKeypadKey> createState() => _SignInKeypadKeyState();
}

class _SignInKeypadKeyState extends State<_SignInKeypadKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = _pressed && !widget.isAction
        ? SignInTokens.blueTint
        : (widget.isAction ? Colors.transparent : SignInTokens.surface2);

    return Listener(
      onPointerDown: widget.enabled
          ? (_) => setState(() => _pressed = true)
          : null,
      onPointerUp: widget.enabled
          ? (_) => setState(() => _pressed = false)
          : null,
      onPointerCancel: widget.enabled
          ? (_) => setState(() => _pressed = false)
          : null,
      child: AnimatedScale(
        scale: _pressed && widget.enabled ? SignInMotion.pressScale : 1,
        duration: SignInMotion.pressFeedback,
        curve: SignInMotion.pressCurve,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
            side: widget.isAction
                ? BorderSide.none
                : const BorderSide(color: SignInTokens.line),
          ),
          child: InkWell(
            onTap: widget.enabled ? widget.onTap : null,
            borderRadius: BorderRadius.circular(SignInTokens.radiusMd),
            splashColor: SignInTokens.blueTint.withValues(alpha: 0.5),
            child: SizedBox(
              height: 56,
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInBottomBar extends StatelessWidget {
  const SignInBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '© Flipper ${DateTime.now().year}',
          style: context.signInText(fontSize: 13, color: SignInTokens.ink3),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.verified_user_outlined,
                size: 14, color: SignInTokens.win),
            const SizedBox(width: 6),
            Text(
              'Secured with end-to-end encryption',
              style: context.signInText(fontSize: 12.5, color: SignInTokens.ink3),
            ),
          ],
        ),
      ],
    );
  }
}
