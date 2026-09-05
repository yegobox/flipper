import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// One row of the "here is exactly what you are about to lose" preview.
class DestructiveConfirmLine {
  const DestructiveConfirmLine({required this.label, this.meta, this.trailing});

  /// Primary text, e.g. the item name.
  final String label;

  /// Secondary text under [label], e.g. `1 × RWF 3,500`.
  final String? meta;

  /// Right-aligned amount.
  final String? trailing;
}

/// Confirmation for an irreversible action, in the POS design language.
///
/// Shows the caller's [lines] so the decision is made against the real rows
/// rather than a bare count, and keeps the dialog open (buttons disabled,
/// spinner in the confirm button) while [onConfirm] runs, so a slow delete
/// cannot be double-submitted or dismissed halfway.
///
/// Returns true only when the action was confirmed — and, when [onConfirm] is
/// given, only when it reported success.
Future<bool> showDestructiveConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  String? footnote,
  List<DestructiveConfirmLine> lines = const [],
  int maxVisibleLines = 4,
  String? totalLabel,
  String? totalValue,
  IconData icon = FluentIcons.delete_20_filled,
  Future<bool> Function()? onConfirm,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x59101828),
    builder: (context) => _DestructiveConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel ?? context.flipperL10n.cancel,
      footnote: footnote,
      lines: lines,
      maxVisibleLines: maxVisibleLines,
      totalLabel: totalLabel,
      totalValue: totalValue,
      icon: icon,
      onConfirm: onConfirm,
    ),
  );
  return confirmed ?? false;
}

class _DestructiveConfirmDialog extends StatefulWidget {
  const _DestructiveConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.footnote,
    required this.lines,
    required this.maxVisibleLines,
    required this.totalLabel,
    required this.totalValue,
    required this.icon,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final String? footnote;
  final List<DestructiveConfirmLine> lines;
  final int maxVisibleLines;
  final String? totalLabel;
  final String? totalValue;
  final IconData icon;
  final Future<bool> Function()? onConfirm;

  @override
  State<_DestructiveConfirmDialog> createState() =>
      _DestructiveConfirmDialogState();
}

class _DestructiveConfirmDialogState extends State<_DestructiveConfirmDialog> {
  bool _busy = false;

  Future<void> _confirm() async {
    final onConfirm = widget.onConfirm;
    if (onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _busy = true);
    final ok = await onConfirm();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      // Left open on failure: the caller has shown why, and the user still has
      // the same decision in front of them.
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasDetails =
        widget.lines.isNotEmpty ||
        (widget.totalLabel != null && widget.totalValue != null);

    return PopScope(
      canPop: !_busy,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Container(
            decoration: BoxDecoration(
              color: PosTokens.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: PosTokens.line),
              boxShadow: PosTokens.shadow2,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Everything above the buttons scrolls, so a long preview or a
                // short window never clips the actions off the bottom.
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: PosTokens.lossTint,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  widget.icon,
                                  size: 22,
                                  color: PosTokens.lossInk,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: PosTokens.ink1,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.message,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.45,
                                        color: PosTokens.ink2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasDetails) ...[
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: _details(textTheme),
                          ),
                        ],
                        if (widget.footnote != null) ...[
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  FluentIcons.info_16_regular,
                                  size: 15,
                                  color: PosTokens.ink3,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    widget.footnote!,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      height: 1.35,
                                      color: PosTokens.ink3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _cancelButton(),
                      const SizedBox(width: 10),
                      _confirmButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _details(TextTheme textTheme) {
    final visible = widget.lines.take(widget.maxVisibleLines).toList();
    final hidden = widget.lines.length - visible.length;
    final showTotal = widget.totalLabel != null && widget.totalValue != null;

    return Container(
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PosTokens.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _line(visible[i], textTheme),
          ],
          if (hidden > 0) ...[
            const SizedBox(height: 10),
            Text(
              context.flipperL10n.plusMoreItems(hidden),
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: PosTokens.ink3,
              ),
            ),
          ],
          if (showTotal) ...[
            if (visible.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: PosTokens.line),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Text(
                  widget.totalLabel!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PosTokens.ink2,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    widget.totalValue!,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: PosTokens.posPriceStyle(textTheme, fontSize: 17),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _line(DestructiveConfirmLine line, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: PosTokens.ink1,
                ),
              ),
              if (line.meta != null) ...[
                const SizedBox(height: 2),
                Text(
                  line.meta!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PosTokens.ink3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (line.trailing != null) ...[
          const SizedBox(width: 12),
          Text(
            line.trailing!,
            style: PosTokens.posMonoStyle(
              textTheme,
              fontSize: 13.5,
              color: PosTokens.ink2,
            ),
          ),
        ],
      ],
    );
  }

  Widget _cancelButton() {
    return TextButton(
      autofocus: true,
      onPressed: _busy ? null : () => Navigator.of(context).pop(false),
      style: TextButton.styleFrom(
        foregroundColor: PosTokens.ink2,
        backgroundColor: PosTokens.surface,
        disabledForegroundColor: PosTokens.ink4,
        minimumSize: const Size(96, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: PosTokens.lineStrong),
        ),
      ),
      child: Text(widget.cancelLabel),
    );
  }

  Widget _confirmButton() {
    return FilledButton(
      onPressed: _busy ? null : _confirm,
      style: FilledButton.styleFrom(
        backgroundColor: PosTokens.loss,
        foregroundColor: Colors.white,
        disabledBackgroundColor: PosTokens.loss.withValues(alpha: 0.55),
        disabledForegroundColor: Colors.white,
        minimumSize: const Size(132, 46),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 17),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.confirmLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}
