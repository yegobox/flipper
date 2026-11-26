import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

import '../../../theme/pos_tokens.dart';
import 'variance_reason_dialog.dart';

/// Production's dialog frame: a white card with a title row, a body and a
/// ghost Cancel beside one filled action. Replaces the stock [AlertDialog]s.
class ProductionDialogShell extends StatelessWidget {
  const ProductionDialogShell({
    super.key,
    required this.title,
    required this.child,
    required this.actions,
    this.icon,
    this.tone = PosTokens.blue,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final IconData? icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: PosTokens.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: PosTokens.line),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tone.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
                      ),
                      child: Icon(icon, size: 18, color: tone),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: PosTokens.sectionTitle.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DefaultTextStyle.merge(
                style: PosTokens.body.copyWith(color: PosTokens.ink2),
                child: child,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actions[i],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ButtonStyle productionPrimaryButtonStyle([Color tone = PosTokens.blue]) =>
    ElevatedButton.styleFrom(
      backgroundColor: tone,
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: const Size(0, PosTokens.controlHeight),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      textStyle: PosTokens.bodyStrong,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
      ),
    );

ButtonStyle productionGhostButtonStyle() => TextButton.styleFrom(
  foregroundColor: PosTokens.ink2,
  minimumSize: const Size(0, PosTokens.controlHeight),
  padding: const EdgeInsets.symmetric(horizontal: 14),
  textStyle: PosTokens.bodyStrong,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(PosTokens.radiusMd),
  ),
);

/// Asks [message] with Cancel / [confirmLabel]; true only on confirm.
Future<bool> showProductionConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  IconData? icon,
  Color tone = PosTokens.blue,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => ProductionDialogShell(
      title: title,
      icon: icon,
      tone: tone,
      actions: [
        TextButton(
          style: productionGhostButtonStyle(),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.flipperL10n.cancel),
        ),
        ElevatedButton(
          style: productionPrimaryButtonStyle(tone),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
      child: Text(message),
    ),
  );
  return confirmed == true;
}

/// Above this share off plan, recording asks why ([VarianceReasonDialog]).
const double kVarianceReasonThresholdPercent = 10;

/// How far [actual] is from [planned], in percent of the plan. Zero when
/// nothing was planned, so an unplanned order never divides by zero.
double variancePercent({required double actual, required double planned}) {
  if (planned <= 0) return 0;
  return ((actual - planned) / planned * 100).abs();
}

/// Asks how much was made against [workOrder]. Pops
/// `{'quantity': double, 'varianceReason': String?}`, or null on cancel.
class RecordOutputDialog extends StatefulWidget {
  const RecordOutputDialog({super.key, required this.workOrder});

  final WorkOrder workOrder;

  @override
  State<RecordOutputDialog> createState() => _RecordOutputDialogState();
}

class _RecordOutputDialogState extends State<RecordOutputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !(_formKey.currentState?.validate() ?? false)) return;
    final quantity = double.parse(_controller.text.trim());
    String? varianceReason;
    if (variancePercent(
          actual: quantity,
          planned: widget.workOrder.plannedQuantity,
        ) >
        kVarianceReasonThresholdPercent) {
      setState(() => _submitting = true);
      final result = await VarianceReasonDialog.show(context);
      if (!mounted) return;
      setState(() => _submitting = false);
      varianceReason = result?['reason'] as String?;
    }
    Navigator.of(
      context,
    ).pop({'quantity': quantity, 'varianceReason': varianceReason});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final wo = widget.workOrder;
    return ProductionDialogShell(
      title: l10n.productionOutputRecordOutput,
      icon: Icons.add_task_rounded,
      actions: [
        TextButton(
          style: productionGhostButtonStyle(),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          style: productionPrimaryButtonStyle(),
          onPressed: _submitting ? null : _submit,
          child: Text(l10n.productionOutputRecord),
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wo.variantName ?? l10n.productionOutputUnknown,
              style: PosTokens.bodyStrong,
            ),
            const SizedBox(height: 2),
            Text(
              l10n.productionOutputTargetLabel(
                wo.plannedQuantity.toStringAsFixed(0),
              ),
              style: PosTokens.meta,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              style: PosTokens.body.copyWith(fontSize: 15),
              decoration: productionInputDecoration(
                label: l10n.productionOutputActualQuantity,
                suffixText: l10n.productionOutputUnits,
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return l10n.productionOutputRequired;
                final quantity = double.tryParse(text);
                if (quantity == null || quantity <= 0) {
                  return l10n.invalidQuantity;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// The one field look for Production's forms and dialogs.
InputDecoration productionInputDecoration({
  String? label,
  String? hint,
  String? suffixText,
  IconData? prefixIcon,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(PosTokens.radiusLg),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixText: suffixText,
    isDense: true,
    filled: true,
    fillColor: PosTokens.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(prefixIcon, size: 18, color: PosTokens.ink3),
    labelStyle: const TextStyle(color: PosTokens.ink2, fontSize: 13),
    hintStyle: const TextStyle(color: PosTokens.ink4),
    suffixStyle: PosTokens.meta,
    border: border(PosTokens.lineStrong),
    enabledBorder: border(PosTokens.lineStrong),
    focusedBorder: border(PosTokens.blue, 1.5),
    errorBorder: border(PosTokens.loss),
    focusedErrorBorder: border(PosTokens.loss, 1.5),
  );
}
