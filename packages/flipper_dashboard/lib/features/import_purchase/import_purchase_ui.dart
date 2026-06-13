import 'package:flutter/material.dart';

import 'import_purchase_helpers.dart';
import 'import_purchase_tokens.dart';

void showImportPurchaseToast(BuildContext context, String message,
    {bool isError = false}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ImportPurchaseTokens.ink,
      margin: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.paddingOf(context).bottom + 26,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(milliseconds: 2600),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? Icons.cancel_outlined : Icons.check_circle_outline,
            color: isError ? const Color(0xFFFF9B9E) : const Color(0xFF6EE7A8),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: ImportPurchaseHelpers.text(
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

class IpmScreenBackground extends StatelessWidget {
  const IpmScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ImportPurchaseTokens.canvas,
      child: child,
    );
  }
}

class IpmPanel extends StatelessWidget {
  const IpmPanel({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface,
        borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusLg),
        border: Border.all(color: ImportPurchaseTokens.line),
        boxShadow: ImportPurchaseTokens.cardShadows,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}

class IpmStatusBadge extends StatelessWidget {
  const IpmStatusBadge({super.key, required this.statusKey});

  final String statusKey;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = switch (statusKey) {
      'pending' || 'wait' || 'waiting' => (
        ImportPurchaseTokens.amberWash,
        ImportPurchaseTokens.amber,
        ImportPurchaseTokens.amberDot,
      ),
      'processing' => (
        ImportPurchaseTokens.accentWash,
        ImportPurchaseTokens.accentStrong,
        ImportPurchaseTokens.accent,
      ),
      'approved' => (
        ImportPurchaseTokens.greenWash,
        ImportPurchaseTokens.greenStrong,
        ImportPurchaseTokens.green,
      ),
      _ => (
        ImportPurchaseTokens.redWash,
        ImportPurchaseTokens.redStrong,
        ImportPurchaseTokens.red,
      ),
    };
    final label = switch (statusKey) {
      'waiting' => 'Pending',
      'wait' => 'Pending',
      'processing' => 'Processing',
      _ => ImportPurchaseHelpers.importStatusLabel(statusKey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: ImportPurchaseHelpers.text(
              size: 12,
              weight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class IpmEmptyState extends StatelessWidget {
  const IpmEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface2,
        borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusLg),
        border: Border.all(color: ImportPurchaseTokens.line2, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ImportPurchaseTokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ImportPurchaseTokens.line),
            ),
            child: Icon(icon, size: 28, color: ImportPurchaseTokens.faint),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: ImportPurchaseHelpers.text(
              size: 16,
              weight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: ImportPurchaseHelpers.text(
              size: 14,
              weight: FontWeight.w500,
              color: ImportPurchaseTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

enum IpmButtonVariant { primary, green, ghost, greenSoft, dangerSoft, amberSoft }

class IpmButton extends StatelessWidget {
  const IpmButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = IpmButtonVariant.primary,
    this.compact = false,
    this.block = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final IpmButtonVariant variant;
  final bool compact;
  final bool block;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final (bg, fg, border) = switch (variant) {
      IpmButtonVariant.primary => (
        ImportPurchaseTokens.accent,
        Colors.white,
        ImportPurchaseTokens.accent,
      ),
      IpmButtonVariant.green => (
        ImportPurchaseTokens.green,
        Colors.white,
        ImportPurchaseTokens.green,
      ),
      IpmButtonVariant.ghost => (
        ImportPurchaseTokens.surface,
        ImportPurchaseTokens.ink2,
        ImportPurchaseTokens.line2,
      ),
      IpmButtonVariant.greenSoft => (
        ImportPurchaseTokens.greenWash,
        ImportPurchaseTokens.greenStrong,
        Colors.transparent,
      ),
      IpmButtonVariant.dangerSoft => (
        ImportPurchaseTokens.redWash,
        ImportPurchaseTokens.redStrong,
        Colors.transparent,
      ),
      IpmButtonVariant.amberSoft => (
        ImportPurchaseTokens.amberWash,
        ImportPurchaseTokens.amber,
        Colors.transparent,
      ),
    };

    final height = compact ? 38.0 : ImportPurchaseTokens.fieldH;
    final child = Row(
      mainAxisSize: block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment:
          block ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: enabled ? fg : fg.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: ImportPurchaseHelpers.text(
            size: compact ? 14 : 14.5,
            weight: FontWeight.w700,
            color: enabled ? fg : fg.withValues(alpha: 0.5),
          ),
        ),
      ],
    );

    return SizedBox(
      width: block ? double.infinity : null,
      height: height,
      child: Material(
        color: enabled ? bg : bg.withValues(alpha: 0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          side: border == Colors.transparent
              ? BorderSide.none
              : BorderSide(color: border),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class IpmIconActionButton extends StatelessWidget {
  const IpmIconActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.accept = true,
    this.retry = false,
    this.loading = false,
    this.size = 38,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool accept;
  final bool retry;
  final bool loading;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch ((retry, accept)) {
      (true, _) => (
        ImportPurchaseTokens.amberWash,
        ImportPurchaseTokens.amber,
      ),
      (false, true) => (
        ImportPurchaseTokens.greenWash,
        ImportPurchaseTokens.green,
      ),
      (false, false) => (
        ImportPurchaseTokens.redWash,
        ImportPurchaseTokens.red,
      ),
    };

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: fg,
                    ),
                  )
                : Icon(icon, size: 20, color: fg),
          ),
        ),
      ),
    );
  }
}

class IpmFieldLabel extends StatelessWidget {
  const IpmFieldLabel(this.text, {super.key, this.uppercase = false});

  final String text;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        uppercase ? text.toUpperCase() : text,
        style: ImportPurchaseHelpers.text(
          size: uppercase ? 11 : 12,
          weight: FontWeight.w700,
          color: uppercase ? ImportPurchaseTokens.muted : ImportPurchaseTokens.ink2,
          letterSpacing: uppercase ? 0.55 : 0.1,
        ),
      ),
    );
  }
}

class IpmTextField extends StatelessWidget {
  const IpmTextField({
    super.key,
    required this.controller,
    this.hint,
    this.numeric = false,
    this.validator,
    this.readOnly = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hint;
  final bool numeric;
  final String? Function(String?)? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: ImportPurchaseHelpers.text(size: 14.5, weight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: ImportPurchaseHelpers.text(
          size: 14.5,
          weight: FontWeight.w400,
          color: ImportPurchaseTokens.faint,
        ),
        filled: true,
        fillColor: ImportPurchaseTokens.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13),
        constraints: const BoxConstraints(minHeight: ImportPurchaseTokens.fieldH),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          borderSide: const BorderSide(color: ImportPurchaseTokens.line2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          borderSide: const BorderSide(color: ImportPurchaseTokens.accent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
          borderSide: const BorderSide(color: ImportPurchaseTokens.red),
        ),
      ),
    );
  }
}

class IpmStatusFilter extends StatelessWidget {
  const IpmStatusFilter({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label = 'Filter by Status',
  });

  final String value;
  final List<MapEntry<String, String>> options;
  final ValueChanged<String> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IpmFieldLabel(label, uppercase: true),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: ImportPurchaseTokens.muted),
          decoration: InputDecoration(
            filled: true,
            fillColor: ImportPurchaseTokens.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 13),
            constraints: const BoxConstraints(minHeight: ImportPurchaseTokens.fieldH),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
              borderSide: const BorderSide(color: ImportPurchaseTokens.line2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ImportPurchaseTokens.radiusSm),
              borderSide: const BorderSide(color: ImportPurchaseTokens.accent),
            ),
          ),
          style: ImportPurchaseHelpers.text(size: 14.5, weight: FontWeight.w600),
          items: options
              .map(
                (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class IpmSegmentedControl extends StatefulWidget {
  const IpmSegmentedControl({
    super.key,
    required this.isImport,
    required this.onChanged,
  });

  final bool isImport;
  final ValueChanged<bool> onChanged;

  @override
  State<IpmSegmentedControl> createState() => _IpmSegmentedControlState();
}

class _IpmSegmentedControlState extends State<IpmSegmentedControl> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.maxWidth.isFinite;
        final stretch = bounded &&
            constraints.maxWidth <= ImportPurchaseTokens.mobileBreakpoint;

        Widget control = _buildTrack(stretch: stretch);

        // Desktop subbar Row gives unbounded width — size to tab content.
        if (!bounded) {
          control = IntrinsicWidth(child: control);
        }

        return control;
      },
    );
  }

  Widget _buildTrack({required bool stretch}) {
    return Container(
      width: stretch ? double.infinity : null,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Half-width thumb that slides between the two tabs. Using
            // AnimatedAlign + FractionallySizedBox (instead of a LayoutBuilder
            // measuring the track) keeps this subtree intrinsic-width friendly,
            // so the desktop IntrinsicWidth wrapper can size to content.
            Positioned.fill(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: const Cubic(0.3, 0.7, 0.4, 1),
                alignment: widget.isImport
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ImportPurchaseTokens.surface,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: ImportPurchaseTokens.cardShadows,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _segTab(
                    selected: widget.isImport,
                    icon: Icons.download_outlined,
                    label: 'Import',
                    onTap: () => widget.onChanged(true),
                  ),
                ),
                Expanded(
                  child: _segTab(
                    selected: !widget.isImport,
                    icon: Icons.shopping_cart_outlined,
                    label: 'Purchase',
                    onTap: () => widget.onChanged(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _segTab({
    required bool selected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? ImportPurchaseTokens.accentStrong
                    : ImportPurchaseTokens.ink2,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: ImportPurchaseHelpers.text(
                  size: 14,
                  weight: FontWeight.w700,
                  color: selected
                      ? ImportPurchaseTokens.accentStrong
                      : ImportPurchaseTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IpmModalShell extends StatelessWidget {
  const IpmModalShell({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onClose,
    required this.body,
    this.footer,
    this.maxWidth = 440,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onClose;
  final Widget body;
  final Widget? footer;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSheet = width <= ImportPurchaseTokens.modalSheetBreakpoint;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: const Color(0x80141C2E),
            ),
          ),
          if (isSheet)
            Align(
              alignment: Alignment.bottomCenter,
              child: _modalCard(context, isSheet: true),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _modalCard(context, isSheet: false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _modalCard(BuildContext context, {required bool isSheet}) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: isSheet ? width : null,
      constraints: BoxConstraints(
        maxWidth: isSheet ? width : maxWidth,
        maxHeight: isSheet ? MediaQuery.sizeOf(context).height * 0.92 : 600,
      ),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(20),
          bottom: isSheet ? Radius.zero : const Radius.circular(18),
        ),
        boxShadow: ImportPurchaseTokens.modalShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ImportPurchaseTokens.accentWash,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: ImportPurchaseTokens.accentStrong),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: ImportPurchaseHelpers.text(
                          size: 18,
                          weight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          subtitle!,
                          style: ImportPurchaseHelpers.text(
                            size: 13,
                            weight: FontWeight.w500,
                            color: ImportPurchaseTokens.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 20),
                  color: ImportPurchaseTokens.muted,
                ),
              ],
            ),
          ),
          Flexible(child: SingleChildScrollView(child: body)),
          if (footer != null)
            Container(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: ImportPurchaseTokens.line)),
              ),
              child: footer,
            ),
        ],
      ),
    );
  }
}

class IpmColumnHeader extends StatelessWidget {
  const IpmColumnHeader(this.text, {super.key, this.align = TextAlign.start});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: align,
      style: ImportPurchaseHelpers.text(
        size: 11.5,
        weight: FontWeight.w800,
        color: ImportPurchaseTokens.muted,
        letterSpacing: 0.5,
      ),
    );
  }
}
