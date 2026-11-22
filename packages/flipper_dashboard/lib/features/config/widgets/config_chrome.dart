import 'package:flipper_dashboard/features/config/system_config_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// The settings-dialog chrome shared by System Configuration, Tax Settings
/// and the receipt header editor, so every settings surface looks the same.

/// The dialog card: header, scrolling body, optional footer.
class ConfigDialogCard extends StatelessWidget {
  const ConfigDialogCard({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.maxWidth = SystemConfigTokens.cardMaxWidth,
  });

  final Widget header;
  final Widget body;
  final Widget? footer;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SystemConfigTokens.cardRadius),
        boxShadow: SystemConfigTokens.cardShadow,
      ),
      child: Material(
        color: SystemConfigTokens.surface,
        borderRadius: BorderRadius.circular(SystemConfigTokens.cardRadius),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            header,
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SystemConfigTokens.cardPaddingH,
                  22,
                  SystemConfigTokens.cardPaddingH,
                  22,
                ),
                child: body,
              ),
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

/// Icon tile, title, subtitle and a close button.
class ConfigHeader extends StatelessWidget {
  const ConfigHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onClose,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SystemConfigTokens.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: SystemConfigTokens.accentTint,
              borderRadius: BorderRadius.circular(
                SystemConfigTokens.iconRadius,
              ),
            ),
            child: Icon(icon, size: 20, color: SystemConfigTokens.accent),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.01 * 21,
                    color: SystemConfigTokens.ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    color: SystemConfigTokens.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null) ConfigCloseButton(onTap: onClose!),
        ],
      ),
    );
  }
}

class ConfigCloseButton extends StatefulWidget {
  const ConfigCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<ConfigCloseButton> createState() => _ConfigCloseButtonState();
}

class _ConfigCloseButtonState extends State<ConfigCloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        key: const ValueKey('configClose'),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _hovered
                ? SystemConfigTokens.inputFill
                : SystemConfigTokens.surface,
            borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
            border: Border.all(color: SystemConfigTokens.border),
          ),
          child: const Icon(
            Icons.close,
            size: 16,
            color: SystemConfigTokens.secondary,
          ),
        ),
      ),
    );
  }
}

/// Uppercase brand-blue label with a rule running to the edge.
class ConfigSectionLabel extends StatelessWidget {
  const ConfigSectionLabel({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.16 * 11,
            color: SystemConfigTokens.accent,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: SystemConfigTokens.border,
          ),
        ),
      ],
    );
  }
}

/// Secondary line under a [ConfigSectionLabel].
class ConfigSectionHint extends StatelessWidget {
  const ConfigSectionHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 12.5,
        color: SystemConfigTokens.secondary,
      ),
    );
  }
}

/// Bordered, rounded group of rows (the "General" card).
class ConfigGroup extends StatelessWidget {
  const ConfigGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: SystemConfigTokens.border),
        borderRadius: BorderRadius.circular(SystemConfigTokens.sectionRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SystemConfigTokens.sectionRadius),
        child: Column(children: children),
      ),
    );
  }
}

/// A row inside a [ConfigGroup]; every row but the first draws a top rule.
class ConfigGroupRow extends StatelessWidget {
  const ConfigGroupRow({super.key, required this.child, this.first = false});

  final Widget child;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: first
          ? null
          : const BoxDecoration(
              border: Border(
                top: BorderSide(color: SystemConfigTokens.divider),
              ),
            ),
      child: child,
    );
  }
}

/// Label above a filled field, brand-blue focus ring.
class ConfigTextField extends StatefulWidget {
  const ConfigTextField({
    super.key,
    required this.fieldKey,
    required this.controller,
    this.label,
    this.validator,
    this.helper,
    this.hintText,
    this.prefixIcon,
    this.suffixText,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.autofocus = false,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String? label;
  final String? Function(String?)? validator;
  final String? helper;
  final String? hintText;
  final IconData? prefixIcon;
  final String? suffixText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;

  @override
  State<ConfigTextField> createState() => _ConfigTextFieldState();
}

class _ConfigTextFieldState extends State<ConfigTextField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(SystemConfigTokens.fieldRadius),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    final muted = GoogleFonts.outfit(
      fontSize: 11.5,
      color: SystemConfigTokens.muted,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SystemConfigTokens.secondary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SystemConfigTokens.fieldRadius),
            boxShadow: _focused
                ? const [
                    BoxShadow(
                      color: SystemConfigTokens.focusRing,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            key: widget.fieldKey,
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            validator: widget.validator,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: SystemConfigTokens.ink,
            ),
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: _focused
                  ? SystemConfigTokens.surface
                  : SystemConfigTokens.inputFill,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.outfit(
                fontSize: 14,
                color: PosTokens.ink4,
              ),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(
                      widget.prefixIcon,
                      size: 18,
                      color: _focused
                          ? SystemConfigTokens.accent
                          : SystemConfigTokens.muted,
                    ),
              suffixText: widget.suffixText,
              suffixStyle: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SystemConfigTokens.secondary,
              ),
              // Helper and the length counter share one line.
              helperText: widget.helper,
              helperStyle: muted,
              helperMaxLines: 2,
              counterStyle: muted,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: _border(SystemConfigTokens.inputBorder),
              enabledBorder: _border(SystemConfigTokens.inputBorder),
              focusedBorder: _border(SystemConfigTokens.accent),
              errorBorder: _border(PosTokens.loss),
              focusedErrorBorder: _border(PosTokens.loss),
            ),
          ),
        ),
      ],
    );
  }
}

enum ConfigNoticeTone { warning, success, error }

/// Tinted one-line notice: a missing value, a save that worked or failed.
class ConfigNotice extends StatelessWidget {
  const ConfigNotice({
    super.key,
    required this.tone,
    required this.message,
    this.onDismiss,
  });

  final ConfigNoticeTone tone;
  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final (bg, border, ink, icon) = switch (tone) {
      ConfigNoticeTone.warning => (
        PosTokens.warnTint,
        PosTokens.warnAmber.withValues(alpha: 0.35),
        const Color(0xFF9A5B00),
        Icons.warning_amber_rounded,
      ),
      ConfigNoticeTone.success => (
        const Color(0xFFEAF7EE),
        PosTokens.gain.withValues(alpha: 0.3),
        PosTokens.gainInk,
        Icons.check_circle_outline,
      ),
      ConfigNoticeTone.error => (
        PosTokens.lossTint,
        PosTokens.loss.withValues(alpha: 0.35),
        PosTokens.lossInk,
        Icons.error_outline,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(SystemConfigTokens.vatRadius),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ink,
              ),
            ),
          ),
          if (onDismiss != null)
            InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.close, size: 16, color: ink),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact brand-blue action ("Save receipt header").
class ConfigActionButton extends StatelessWidget {
  const ConfigActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon = Icons.check,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: SystemConfigTokens.accent,
        disabledBackgroundColor: SystemConfigTokens.accent.withValues(
          alpha: 0.5,
        ),
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SystemConfigTokens.fieldRadius),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      icon: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
