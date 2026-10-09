/// Building blocks shared by the pay screens: a sheet that is a bottom sheet
/// on a phone and a dialog on a desk, money fields, payment-method chips and
/// the breakdown rows a payslip is made of.
library;

import 'package:flipper_hr/features/ui/hr_theme.dart';
import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/pay/data/pay_period.dart';
import 'package:flipper_hr/features/people/data/employee.dart';
import 'package:flipper_hr/features/people/data/money_format.dart';
import 'package:flipper_hr/features/ui/hr_l10n.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Below this width a sheet slides up from the bottom; above it, a dialog.
const double hrSheetBreakpoint = 720;

/// Opens [builder] as a bottom sheet on a phone and a centred dialog on a
/// wider screen — the shape each platform's users expect for "do one thing".
Future<T?> showHrSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double maxWidth = 560,
}) {
  final narrow = MediaQuery.sizeOf(context).width < hrSheetBreakpoint;
  if (narrow) {
    return showModalBottomSheet<T>(
      context: context,
      // Over the whole screen — the app bar and the bottom bar too — as a
      // sheet is on every phone; hrOverlay carries HR's theme across.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: HrTokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HrTokens.radiusLg),
        ),
      ),
      builder: (sheetContext) => hrOverlay(
        context,
        Padding(
          // Lifts the sheet above the keyboard.
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: builder(sheetContext),
        ),
      ),
    );
  }
  return showHrDialog<T>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 760),
        child: builder(context),
      ),
    ),
  );
}

/// A sheet's frame: a title, an optional subtitle, scrolling content and a
/// pinned row of actions, so the primary button never scrolls out of reach.
class HrSheetFrame extends StatelessWidget {
  const HrSheetFrame({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: HrType.title),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: HrType.caption),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
        if (actions.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: HrTokens.line)),
            ),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 8,
              children: actions,
            ),
          ),
      ],
    );
  }
}

/// Parses what someone typed into a money field: `150,000` → 150000.
double? parseMoneyInput(String raw) {
  final cleaned = raw.replaceAll(RegExp(r'[,\s]'), '');
  if (cleaned.isEmpty) return null;
  return double.tryParse(cleaned);
}

/// A labelled money field with the currency as a prefix.
class HrMoneyField extends StatelessWidget {
  const HrMoneyField({
    super.key,
    required this.controller,
    required this.label,
    required this.currency,
    this.helper,
    this.errorText,
    this.onChanged,
    this.autofocus = false,
    this.fieldKey,
  });

  final TextEditingController controller;
  final String label;
  final String currency;
  final String? helper;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: hrInputDecoration(
        label: label,
        helper: helper,
        errorText: errorText,
        prefix: '$currency ',
      ),
    );
  }
}

/// The text-field look every pay form shares.
InputDecoration hrInputDecoration({
  required String label,
  String? helper,
  String? errorText,
  String? prefix,
  String? hint,
}) => InputDecoration(
  labelText: label,
  helperText: helper,
  helperMaxLines: 3,
  errorText: errorText,
  errorMaxLines: 3,
  hintText: hint,
  prefixText: prefix,
  isDense: true,
  filled: true,
  fillColor: HrTokens.surface2,
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
);

/// Cash, mobile money or bank — chosen with one tap.
class HrMethodChips extends StatelessWidget {
  const HrMethodChips({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PaymentMethod value;
  final ValueChanged<PaymentMethod> onChanged;

  static IconData iconFor(PaymentMethod m) => switch (m) {
    PaymentMethod.cash => Icons.payments_outlined,
    PaymentMethod.mobileMoney => Icons.phone_android,
    PaymentMethod.bankTransfer => Icons.account_balance_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final m in const [
          PaymentMethod.cash,
          PaymentMethod.mobileMoney,
          PaymentMethod.bankTransfer,
        ])
          ChoiceChip(
            key: Key('hr-method-${m.wire}'),
            selected: value == m,
            onSelected: (_) => onChanged(m),
            avatar: Icon(iconFor(m), size: 16),
            label: Text(m.label),
            showCheckmark: false,
            selectedColor: HrTokens.accentTint,
            side: BorderSide(
              color: value == m ? HrTokens.accent : HrTokens.border,
            ),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: value == m ? HrTokens.accent : HrTokens.ink2,
            ),
          ),
      ],
    );
  }
}

/// One line of a breakdown: a label on the left, an amount on the right.
class HrAmountRow extends StatelessWidget {
  const HrAmountRow({
    super.key,
    required this.label,
    required this.amount,
    required this.currency,
    this.hint,
    this.negative = false,
    this.strong = false,
    this.trailing,
  });

  final String label;
  final String? hint;
  final double amount;
  final String currency;

  /// Shown as a deduction: a minus sign.
  final bool negative;
  final bool strong;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final style = strong ? HrType.bodyStrong : HrType.body;
    final value = negative && amount != 0
        ? '−${formatMoney(amount, currency)}'
        : formatMoney(amount, currency);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: style),
                if (hint != null) Text(hint!, style: HrType.caption),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            Text(
              value,
              style: style.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                color: negative ? HrTokens.ink2 : null,
              ),
            ),
        ],
      ),
    );
  }
}

/// The big number at the bottom of a breakdown.
class HrTotalBanner extends StatelessWidget {
  const HrTotalBanner({
    super.key,
    required this.label,
    required this.amount,
    required this.currency,
    this.caption,
    this.valueKey,
  });

  final String label;
  final double amount;
  final String currency;
  final String? caption;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HrTokens.accentTint,
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: HrType.bodyStrong.copyWith(color: HrTokens.accent),
                ),
                if (caption != null) Text(caption!, style: HrType.caption),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatMoney(amount, currency),
              key: valueKey,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: HrTokens.ink1,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A heading inside a sheet.
class HrSubheading extends StatelessWidget {
  const HrSubheading(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(text.toUpperCase(), style: HrType.overline),
  );
}

/// A soft callout: the reminder of what has already been paid, a warning.
class HrCallout extends StatelessWidget {
  const HrCallout({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.tone = HrTone.info,
    this.calloutKey,
  });

  final String message;
  final IconData icon;
  final HrTone tone;
  final Key? calloutKey;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      HrTone.warning => (const Color(0xFFFFF7ED), const Color(0xFFB45309)),
      HrTone.danger => (HrTokens.dangerTint, const Color(0xFFB91C1C)),
      HrTone.positive => (const Color(0xFFECFDF5), const Color(0xFF047857)),
      _ => (HrTokens.surface2, HrTokens.ink2),
    };
    return Container(
      key: calloutKey,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(HrTokens.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: HrType.body.copyWith(color: fg, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// `October 2026` for a calendar month, `5–11 Oct 2026` for anything else.
String formatPayPeriod(DateTime start, DateTime end) {
  final l10n = FlipperL10n.current;
  final wholeMonth =
      start.day == 1 &&
      start.month == end.month &&
      start.year == end.year &&
      end.day == DateTime(end.year, end.month + 1, 0).day;
  if (wholeMonth) return '${hrMonthName(l10n, start.month)} ${start.year}';
  if (start.year == end.year && start.month == end.month) {
    return '${start.day}–${end.day} ${hrMonthShortName(l10n, end.month)} ${end.year}';
  }
  return '${formatShortDate(start)} – ${formatShortDate(end)}';
}

String formatPeriodOf(PayPeriod p) => formatPayPeriod(p.start, p.end);

/// Asks for a reason, for a void or a write-off. Null when cancelled.
Future<String?> askReason(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = true,
}) {
  return showHrDialog<String>(
    context: context,
    builder: (_) => _ReasonDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      destructive: destructive,
    ),
  );
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.destructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final bool destructive;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message, style: HrType.body),
          const SizedBox(height: 14),
          TextField(
            key: const Key('hr-reason-field'),
            controller: _controller,
            autofocus: true,
            maxLines: 2,
            onChanged: (_) => setState(() {}),
            decoration: hrInputDecoration(label: l10n.hrPayReason),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('hr-reason-confirm'),
          onPressed: _controller.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(_controller.text.trim()),
          style: FilledButton.styleFrom(
            backgroundColor: widget.destructive
                ? HrTokens.danger
                : HrTokens.accent,
          ),
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// A one-line message at the bottom of the screen.
void hrToast(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? HrTokens.danger : HrTokens.ink1,
      ),
    );
}
