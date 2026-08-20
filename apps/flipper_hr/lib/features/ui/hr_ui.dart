/// Flipper HR's page-level building blocks.
///
/// The pages used to reach straight for Material's `Card`, `Chip` and
/// `textTheme`, which meant every surface picked its own elevation, radius and
/// grey. This is the small kit they share instead: a panel, a section header, a
/// stat tile, a pill, an avatar and an empty state — the whole visual vocabulary
/// of the product, defined once against [HrTokens].
library;

import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flutter/material.dart';

// ─── Type scale ───────────────────────────────────────────────────────────────

/// The five sizes anything on a page is allowed to be.
///
/// Deliberately short. A dashboard reads as designed when there are four or five
/// text sizes on it, not eleven.
abstract final class HrType {
  static const TextStyle display = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: HrTokens.ink1,
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
    color: HrTokens.ink1,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13.5,
    color: HrTokens.ink2,
    height: 1.4,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: HrTokens.ink1,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: HrTokens.ink3,
    height: 1.35,
  );

  /// Small caps over a group of things. The one place letter-spacing is used.
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: HrTokens.ink3,
    letterSpacing: 0.7,
  );
}

// ─── Panel ────────────────────────────────────────────────────────────────────

/// A white surface with a hairline border. The only container a page needs.
///
/// No elevation: shadows on a dense page turn into grey mush, and a 1px border
/// separates panels at any zoom level.
class HrPanel extends StatelessWidget {
  const HrPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  /// Makes the whole panel a target. Adds a hover state, so a panel that does
  /// nothing never looks like it might.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    // A Material rather than a DecoratedBox: anything with its own ink — a
    // ListTile, a button, an InkWell — paints onto the nearest Material, and a
    // plain coloured box between them hides the splash.
    return Material(
      color: color ?? HrTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusLg),
        side: const BorderSide(color: HrTokens.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              hoverColor: HrTokens.surface2,
              child: content,
            ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

/// A panel's heading: what this block is, and the one thing to do about it.
class HrSectionHeader extends StatelessWidget {
  const HrSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;

  /// Shown as a pill beside the title — how many things are in this block.
  final int? count;

  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: HrType.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (count != null) ...[
                    const SizedBox(width: 8),
                    HrPill(label: '$count', tone: HrTone.info),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: HrType.caption),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: HrTokens.accent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

// ─── Stat tile ────────────────────────────────────────────────────────────────

/// One number, what it counts, and an icon to find it by.
class HrStatTile extends StatelessWidget {
  const HrStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.hint,
    this.tone = HrTone.info,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;

  /// A line under the number, when the number alone does not say enough.
  final String? hint;

  final HrTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(tone);

    return SizedBox(
      width: 188,
      child: HrPanel(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.background,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 16, color: palette.foreground),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: HrTokens.ink1,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: HrType.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (hint != null) ...[
              const SizedBox(height: 6),
              Text(
                hint!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: palette.foreground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Pill ─────────────────────────────────────────────────────────────────────

/// The tones a status can carry. Colour is never the only signal — every pill
/// also says a word.
enum HrTone { neutral, info, positive, warning, danger }

class HrPill extends StatelessWidget {
  const HrPill({
    super.key,
    required this.label,
    this.tone = HrTone.neutral,
    this.icon,
  });

  final String label;
  final HrTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(tone);
    return Container(
      padding: EdgeInsets.fromLTRB(icon == null ? 9 : 7, 3, 9, 3),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: palette.foreground),
            const SizedBox(width: 4),
          ],
          // Flexible, because a pill lands in table cells whose width belongs
          // to the table: "Terminated" in a narrow status column has to
          // ellipsize rather than overflow the row it sits in.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: palette.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Palette {
  const _Palette(this.background, this.foreground);
  final Color background;
  final Color foreground;
}

_Palette _palette(HrTone tone) => switch (tone) {
  HrTone.neutral => const _Palette(Color(0xFFF1F5F9), Color(0xFF475569)),
  HrTone.info => const _Palette(HrTokens.accentTint, HrTokens.accent),
  HrTone.positive => const _Palette(Color(0xFFECFDF5), Color(0xFF047857)),
  HrTone.warning => const _Palette(Color(0xFFFFF7ED), Color(0xFFB45309)),
  HrTone.danger => const _Palette(Color(0xFFFEF2F2), Color(0xFFB91C1C)),
};

// ─── Avatar ───────────────────────────────────────────────────────────────────

/// A person, as initials on a colour that is always the same for them.
///
/// The colour is derived from the seed rather than assigned, so the same person
/// is the same colour on the roster, the approvals queue and the dashboard —
/// which is what makes a list of avatars scannable instead of decorative.
class HrPersonAvatar extends StatelessWidget {
  const HrPersonAvatar({
    super.key,
    required this.initials,
    required this.seed,
    this.radius = 16,
  });

  final String initials;

  /// Whatever identifies this person — an id, or their name.
  final String seed;

  final double radius;

  /// Muted enough to sit behind text, distinct enough to tell apart.
  static const _palette = [
    _Palette(Color(0xFFEFF6FF), Color(0xFF1D4ED8)),
    _Palette(Color(0xFFECFDF5), Color(0xFF047857)),
    _Palette(Color(0xFFFDF4FF), Color(0xFFA21CAF)),
    _Palette(Color(0xFFFFF7ED), Color(0xFFB45309)),
    _Palette(Color(0xFFEEF2FF), Color(0xFF4338CA)),
    _Palette(Color(0xFFF0FDFA), Color(0xFF0F766E)),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palette[_hash(seed) % _palette.length];
    return Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.background,
        shape: BoxShape.circle,
      ),
      child: initials.isEmpty
          ? Icon(Icons.person_outline, size: radius, color: palette.foreground)
          : Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.7,
                fontWeight: FontWeight.w700,
                color: palette.foreground,
              ),
            ),
    );
  }

  static int _hash(String value) {
    var h = 0;
    for (final unit in value.codeUnits) {
      h = (h * 31 + unit) & 0x7fffffff;
    }
    return h;
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

/// What a block says when it has nothing to show.
///
/// Always a sentence about why it is empty, never just "No data" — an empty
/// approvals queue is good news and should read like it.
class HrEmptyState extends StatelessWidget {
  const HrEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.title,
    this.actionLabel,
    this.actionKey,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;

  /// A short heading above [message]. Omitted where the message says it all.
  final String? title;

  final String message;
  final String? actionLabel;

  /// Identifies the action for tests, which tap it by key.
  final Key? actionKey;

  final VoidCallback? onAction;

  /// Inside a panel next to other panels, rather than filling a page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 18 : 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 36 : 46,
            height: compact ? 36 : 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: HrTokens.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: compact ? 18 : 22, color: HrTokens.ink3),
          ),
          SizedBox(height: compact ? 10 : 14),
          if (title != null) ...[
            Text(title!, textAlign: TextAlign.center, style: HrType.title),
            const SizedBox(height: 6),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: HrType.caption,
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 8 : 14),
            TextButton(
              key: actionKey,
              onPressed: onAction,
              style: TextButton.styleFrom(foregroundColor: HrTokens.accent),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────

/// The primary action's shape, used everywhere one exists.
ButtonStyle hrPrimaryButtonStyle({double height = 40}) =>
    FilledButton.styleFrom(
      backgroundColor: HrTokens.accent,
      foregroundColor: Colors.white,
      minimumSize: Size(0, height),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusSm),
      ),
    );

/// A secondary action: the same shape, drawn as an outline.
ButtonStyle hrSecondaryButtonStyle({double height = 40}) =>
    OutlinedButton.styleFrom(
      foregroundColor: HrTokens.ink1,
      backgroundColor: HrTokens.surface,
      minimumSize: Size(0, height),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      side: const BorderSide(color: HrTokens.border),
      textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusSm),
      ),
    );

// ─── Search field ─────────────────────────────────────────────────────────────

/// The one search input shape — the topbar's and the roster toolbar's.
class HrSearchField extends StatelessWidget {
  const HrSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.height = 36,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 13.5, color: HrTokens.ink1),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 13.5, color: HrTokens.ink4),
          prefixIcon: const Icon(Icons.search, size: 18, color: HrTokens.ink3),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
          isDense: true,
          filled: true,
          fillColor: HrTokens.surface2,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HrTokens.radiusSm),
            borderSide: const BorderSide(color: HrTokens.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HrTokens.radiusSm),
            borderSide: const BorderSide(color: HrTokens.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HrTokens.radiusSm),
            borderSide: const BorderSide(color: HrTokens.accent, width: 1.5),
          ),
        ),
      ),
    );
  }
}
