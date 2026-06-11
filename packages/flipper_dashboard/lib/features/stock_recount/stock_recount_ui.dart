import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'stock_recount_helpers.dart';
import 'stock_recount_icons.dart';
import 'stock_recount_tokens.dart';

void showStockRecountToast(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: StockRecountTokens.ink1,
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.paddingOf(context).bottom + 96,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      duration: const Duration(milliseconds: 2600),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: StockRecountTokens.pos,
              shape: BoxShape.circle,
            ),
            child: StockRecountIcons.check(size: 12, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: StockRecountHelpers.text(
                size: 14,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Screen background per `.rc-shell` in recount.css.
class StockRecountScreenBackground extends StatelessWidget {
  const StockRecountScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: StockRecountTokens.appBackgroundDecoration(),
      child: child,
    );
  }
}

/// `.rc-back` / `.rc-iconbtn` — 38×38, radius 11, sh1.
class StockRecountIconButton extends StatelessWidget {
  const StockRecountIconButton({
    super.key,
    required this.iconName,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 18,
  });

  final String iconName;
  final VoidCallback onPressed;
  final String? tooltip;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: StockRecountTokens.surface,
      elevation: 0,
      shadowColor: const Color(0x10102040),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
        side: const BorderSide(color: StockRecountTokens.line),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: StockRecountIcons.svg(
              iconName,
              size: iconSize,
              color: StockRecountTokens.ink2,
            ),
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

class StockRecountFab extends StatelessWidget {
  const StockRecountFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 22,
        bottom: MediaQuery.paddingOf(context).bottom + 22,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  StockRecountTokens.accent,
                  StockRecountTokens.accentDeep,
                ],
              ),
              borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
              boxShadow: const [StockRecountTokens.primaryButtonShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StockRecountIcons.plus(size: 20, color: Colors.white),
                  const SizedBox(width: 9),
                  Text(
                    'New recount',
                    style: StockRecountHelpers.text(
                      size: 15.5,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StockRecountBlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StockRecountBlurredAppBar({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onInfo,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onInfo;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width <= 560;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 64,
          backgroundColor: StockRecountTokens.surface.withValues(alpha: 0.82),
          surfaceTintColor: Colors.transparent,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: StockRecountTokens.line),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              if (leading != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: leading!,
                ),
                const SizedBox(width: 8),
              ],
              if (leading == null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: StockRecountIcons.svg(
                    'flipper-logo',
                    size: 34,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StockRecountHelpers.text(
                        size: narrow ? 17 : 19,
                        weight: FontWeight.w700,
                        letterSpacing: -0.38,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: StockRecountHelpers.text(
                          size: 12.5,
                          color: StockRecountTokens.ink3,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (onInfo != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: StockRecountIconButton(
                  iconName: 'info',
                  onPressed: onInfo!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StockRecountSearchField extends StatefulWidget {
  const StockRecountSearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
    this.height = 52,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final double height;

  @override
  State<StockRecountSearchField> createState() => _StockRecountSearchFieldState();
}

class _StockRecountSearchFieldState extends State<StockRecountSearchField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: widget.height,
      decoration: BoxDecoration(
        color: StockRecountTokens.surface,
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
        border: Border.all(
          color: focused ? StockRecountTokens.accent : StockRecountTokens.line,
          width: 1.5,
        ),
        boxShadow: focused
            ? [
                const BoxShadow(
                  color: StockRecountTokens.accentRing,
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
                ...StockRecountTokens.cardShadows,
              ]
            : StockRecountTokens.cardShadows,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          StockRecountIcons.search(
            size: 19,
            color: focused ? StockRecountTokens.accent : StockRecountTokens.ink3,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: StockRecountHelpers.text(size: 15.5, weight: FontWeight.w500),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: StockRecountHelpers.text(
                  size: 15.5,
                  weight: FontWeight.w400,
                  color: StockRecountTokens.ink4,
                ),
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            InkWell(
              onTap: widget.onClear,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: StockRecountIcons.x(size: 16, color: StockRecountTokens.ink3),
              ),
            ),
        ],
      ),
    );
  }
}

class StockRecountStatusBadge extends StatelessWidget {
  const StockRecountStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: StockRecountTokens.statusBgCss(status),
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
      ),
      child: Text(
        status.toUpperCase(),
        style: StockRecountHelpers.text(
          size: 10.5,
          weight: FontWeight.w700,
          color: StockRecountTokens.statusText(status),
          letterSpacing: 0.525,
        ),
      ),
    );
  }
}

class StockRecountItemSwatch extends StatelessWidget {
  const StockRecountItemSwatch({
    super.key,
    required this.name,
    this.size = 40,
    this.iconName,
  });

  final String name;
  final double size;
  final String? iconName;

  @override
  Widget build(BuildContext context) {
    final color = StockRecountHelpers.swatchColor(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size <= 38 ? 10 : 13),
      ),
      alignment: Alignment.center,
      child: iconName != null
          ? StockRecountIcons.svg(iconName!, size: size * 0.45, color: Colors.white)
          : Text(
              StockRecountHelpers.initials(name),
              style: StockRecountHelpers.text(
                size: size * 0.32,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    );
  }
}

class StockRecountNetPill extends StatelessWidget {
  const StockRecountNetPill({super.key, required this.net});

  final double net;

  @override
  Widget build(BuildContext context) {
    if (net == 0) {
      return _pill(
        bg: StockRecountTokens.surface,
        border: StockRecountTokens.line,
        fg: StockRecountTokens.ink3,
        icon: StockRecountIcons.check(size: 13, color: StockRecountTokens.ink3),
        label: 'Balanced',
      );
    }
    if (net > 0) {
      return _pill(
        bg: StockRecountTokens.posTint,
        border: StockRecountTokens.posBorder,
        fg: StockRecountTokens.posText,
        icon: StockRecountIcons.arrowUp(size: 13, color: StockRecountTokens.posText),
        label: '+${StockRecountHelpers.formatQty(net)} net',
      );
    }
    return _pill(
      bg: StockRecountTokens.negTint,
      border: StockRecountTokens.negBorder,
      fg: StockRecountTokens.negText,
      icon: StockRecountIcons.arrowDown(size: 13, color: StockRecountTokens.negText),
      label: '${StockRecountHelpers.formatSignedVariance(net)} net',
    );
  }

  Widget _pill({
    required Color bg,
    required Color border,
    required Color fg,
    required Widget icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            label,
            style: StockRecountHelpers.text(
              size: 12.5,
              weight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class StockRecountQtyStepper extends StatefulWidget {
  const StockRecountQtyStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;
  final bool enabled;

  @override
  State<StockRecountQtyStepper> createState() => _StockRecountQtyStepperState();
}

class _StockRecountQtyStepperState extends State<StockRecountQtyStepper> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(covariant StockRecountQtyStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minusW = widget.compact ? 36.0 : 40.0;
    final minusH = widget.compact ? 40.0 : 48.0;
    final borderColor =
        widget.compact ? StockRecountTokens.accentTint2 : StockRecountTokens.line;

    return Container(
      width: widget.compact ? double.infinity : null,
      decoration: BoxDecoration(
        color: widget.compact ? Colors.white : null,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: widget.compact ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _stepBtn(
            width: minusW,
            height: minusH,
            icon: StockRecountIcons.minus(
              size: widget.compact ? 17 : 18,
              color: widget.enabled && widget.value > 0
                  ? StockRecountTokens.ink2
                  : StockRecountTokens.ink4,
            ),
            onTap: widget.enabled && widget.value > 0
                ? () => widget.onChanged(widget.value - 1)
                : null,
          ),
          Expanded(
            flex: widget.compact ? 1 : 0,
            child: SizedBox(
              width: widget.compact ? null : 64,
              height: minusH,
              child: TextField(
                enabled: widget.enabled,
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: StockRecountHelpers.text(
                  size: 17,
                  weight: FontWeight.w700,
                  color: widget.compact
                      ? StockRecountTokens.accentDeep
                      : StockRecountTokens.ink1,
                  tabular: true,
                ),
                onSubmitted: (raw) {
                  final parsed = int.tryParse(raw) ?? 0;
                  widget.onChanged(parsed < 0 ? 0 : parsed);
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          _stepBtn(
            width: minusW,
            height: minusH,
            icon: StockRecountIcons.plus(
              size: widget.compact ? 17 : 18,
              color: widget.enabled ? StockRecountTokens.ink2 : StockRecountTokens.ink4,
            ),
            onTap: widget.enabled ? () => widget.onChanged(widget.value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _stepBtn({
    required double width,
    required double height,
    required Widget icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: StockRecountTokens.surface2,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class StockRecountPrimaryButton extends StatelessWidget {
  const StockRecountPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.enabled = true,
    this.loading = false,
    this.height = 52,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final bool enabled;
  final bool loading;
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading && onPressed != null;
    final button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
        gradient: active
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  StockRecountTokens.accent,
                  StockRecountTokens.accentDeep,
                ],
              )
            : null,
        color: active ? null : StockRecountTokens.accent.withValues(alpha: 0.45),
        boxShadow: active ? const [StockRecountTokens.primaryButtonShadow] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: active ? onPressed : null,
          borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SizedBox(
              height: height,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leading != null) ...[
                            leading!,
                            const SizedBox(width: 9),
                          ],
                          Text(
                            label,
                            style: StockRecountHelpers.text(
                              size: 15.5,
                              weight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
    return expanded ? Expanded(child: button) : button;
  }
}

class StockRecountGhostButton extends StatelessWidget {
  const StockRecountGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.expanded = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final bool expanded;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: StockRecountTokens.surface,
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
        border: Border.all(color: StockRecountTokens.lineStrong, width: 1.5),
        boxShadow: StockRecountTokens.cardShadows,
      ),
      child: Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(StockRecountTokens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SizedBox(
            height: 52,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: 9),
                        ],
                        Text(
                          label,
                          style: StockRecountHelpers.text(
                            size: 15.5,
                            weight: FontWeight.w700,
                            color: StockRecountTokens.ink1,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    ),
    );
    return expanded ? Expanded(child: child) : child;
  }
}

/// `.rc-item-del` — 34×34 trash control.
class StockRecountDeleteButton extends StatelessWidget {
  const StockRecountDeleteButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? 'Delete',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Center(
              child: StockRecountIcons.trash(size: 17, color: StockRecountTokens.ink3),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.rc-foot-act` export control on list cards.
class StockRecountExportLink extends StatelessWidget {
  const StockRecountExportLink({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPressed,
      borderRadius: BorderRadius.circular(9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              StockRecountIcons.download(size: 15, color: StockRecountTokens.accent),
            const SizedBox(width: 7),
            Text(
              loading ? 'Exporting…' : 'Export PDF',
              style: StockRecountHelpers.text(
                size: 13,
                weight: FontWeight.w700,
                color: StockRecountTokens.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget stockRecountCard({
  required Widget child,
  Color? borderColor,
  EdgeInsets padding = const EdgeInsets.all(16),
  double radius = StockRecountTokens.radiusLg,
}) {
  return Container(
    decoration: BoxDecoration(
      color: StockRecountTokens.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? StockRecountTokens.line),
      boxShadow: StockRecountTokens.cardShadows,
    ),
    padding: padding,
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}
