import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Stock editor for a single variant, styled with the product-editor tokens so
/// it reads as part of the editor rather than a legacy Material dialog.
///
/// Reductions below the stock already on record stay blocked for variants that
/// are registered with RRA (`ebmSynced == true`) — those need a stock
/// adjustment so the movement is reported. The floor is surfaced inside the
/// sheet (disabled minus button + inline hint + disabled primary action)
/// instead of a toast: toasts raised from inside a modal sheet paint behind its
/// barrier, so the old build simply looked like nothing happened.
void showEditQuantityDialog(
  BuildContext context,
  Variant variant,
  ScannViewModel model,
  VoidCallback onDialogClosed,
) {
  WoltModalSheet.show<void>(
    context: context,
    // Providing this callback replaces Wolt's default pop, so close explicitly
    // — otherwise a barrier tap leaves the sheet open.
    onModalDismissedWithBarrierTap: () {
      Navigator.of(context).pop();
      onDialogClosed();
    },
    pageListBuilder: (BuildContext context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          isTopBarLayerAlwaysVisible: false,
          hasTopBarLayer: false,
          backgroundColor: ProductEditorTokens.surface,
          child: _EditQuantitySheet(
            variant: variant,
            model: model,
            onDialogClosed: onDialogClosed,
          ),
        ),
      ];
    },
  );
}

class _EditQuantitySheet extends StatefulWidget {
  const _EditQuantitySheet({
    required this.variant,
    required this.model,
    required this.onDialogClosed,
  });

  final Variant variant;
  final ScannViewModel model;
  final VoidCallback onDialogClosed;

  @override
  State<_EditQuantitySheet> createState() => _EditQuantitySheetState();
}

class _EditQuantitySheetState extends State<_EditQuantitySheet> {
  late final TextEditingController _controller;
  late final double _baseStock;
  late final double _floor;

  bool get _isService => widget.variant.itemTyCd == "3";

  @override
  void initState() {
    super.initState();
    _baseStock =
        (widget.variant.stock?.currentStock ?? widget.variant.qty ?? 0)
            .toDouble();
    _floor = widget.variant.ebmSynced == true ? _baseStock : 0.0;
    _controller = TextEditingController(text: _fmt(_baseStock));
    // Pre-select so the first keystroke replaces the value instead of appending.
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _fmt(double value) =>
      value == value.truncateToDouble() ? value.toStringAsFixed(0) : '$value';

  double? get _value => double.tryParse(_controller.text.trim());

  String? get _error {
    if (_isService) return null;
    final value = _value;
    if (value == null) return 'Enter a number';
    if (value < 0) return 'Quantity cannot be negative';
    if (value < _floor) {
      return 'Stock reported to RRA can only be increased here. '
          'Use a stock adjustment to go below ${_fmt(_floor)}.';
    }
    return null;
  }

  bool get _canDecrement => !_isService && (_value ?? _baseStock) > _floor;

  void _setValue(double value) {
    final text = _fmt(value);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() {});
  }

  void _step(double delta) {
    final current = _value ?? _baseStock;
    final next = current + delta;
    _setValue(next < _floor ? _floor : next);
  }

  void _close() {
    Navigator.of(context).pop();
    widget.onDialogClosed();
  }

  void _submit() {
    if (_isService) {
      // Services carry no stock; normalise to 0 so nothing stale is reported.
      widget.model.updateVariantQuantity(widget.variant.id, 0.0);
      _close();
      return;
    }
    final value = _value;
    if (value == null || _error != null) {
      setState(() {});
      return;
    }
    widget.model.updateVariantQuantity(widget.variant.id, value);
    _close();
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final value = _value;
    final delta = (value ?? _baseStock) - _baseStock;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          const SizedBox(height: 18),
          const Divider(height: 1, color: ProductEditorTokens.lineSoft),
          const SizedBox(height: 18),
          if (_isService)
            _notice(
              'Services do not carry stock. Saving keeps this variant at 0.',
              ProductEditorTokens.blue,
              ProductEditorTokens.blueTint,
              Icons.info_outline,
            )
          else ...[
            Row(
              children: [
                Text(
                  'QUANTITY',
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: ProductEditorTokens.ink3,
                  ),
                ),
                const Spacer(),
                _currentStockChip(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StepButton(
                  icon: Icons.remove,
                  color: ProductEditorTokens.loss,
                  onPressed: _canDecrement ? () => _step(-1) : null,
                  semanticLabel: _canDecrement
                      ? 'Decrease by 1'
                      : 'Cannot go below ${_fmt(_floor)}',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _quantityField(hasError: error != null),
                  ),
                ),
                _StepButton(
                  icon: Icons.add,
                  color: ProductEditorTokens.gain,
                  onPressed: () => _step(1),
                  semanticLabel: 'Increase by 1',
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (error != null)
              _notice(
                error,
                ProductEditorTokens.loss,
                PosTokens.lossTint,
                Icons.error_outline,
              )
            else if (delta != 0)
              _notice(
                delta > 0
                    ? 'Adds ${_fmt(delta)} to current stock.'
                    : 'Removes ${_fmt(-delta)} from current stock.',
                delta > 0 ? ProductEditorTokens.gain : ProductEditorTokens.ink2,
                delta > 0
                    ? ProductEditorTokens.winTint
                    : ProductEditorTokens.surface2,
                delta > 0 ? Icons.trending_up : Icons.trending_down,
              )
            else
              _notice(
                'Stock stays at ${_fmt(_baseStock)}.',
                ProductEditorTokens.ink3,
                ProductEditorTokens.surface2,
                Icons.inventory_outlined,
              ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _GhostAction(label: 'Cancel', onPressed: _close),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _PrimaryAction(
                  label: _isService ? 'Got it' : 'Update stock',
                  onPressed: error == null ? _submit : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: ProductEditorTokens.blueTint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: ProductEditorTokens.blue,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit quantity',
                style: GoogleFonts.outfit(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w800,
                  color: ProductEditorTokens.ink1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.variant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: ProductEditorTokens.surface2,
          borderRadius: BorderRadius.circular(11),
          child: InkWell(
            onTap: _close,
            borderRadius: BorderRadius.circular(11),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: ProductEditorTokens.line, width: 1.5),
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: ProductEditorTokens.ink2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentStockChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Text(
        'ON HAND ${_fmt(_baseStock)}',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: ProductEditorTokens.ink2,
        ),
      ),
    );
  }

  Widget _quantityField({required bool hasError}) {
    final borderColor = hasError
        ? ProductEditorTokens.loss
        : ProductEditorTokens.lineStrong;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1.5),
    );

    return TextField(
      controller: _controller,
      // The editor keeps focus on its scan field, so without autofocus the
      // keystrokes typed here would land in the barcode input behind the sheet.
      autofocus: true,
      enabled: !_isService,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      style: GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ProductEditorTokens.ink1,
      ),
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ProductEditorTokens.surface2,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: border(borderColor),
        enabledBorder: border(borderColor),
        focusedBorder: border(
          hasError ? ProductEditorTokens.loss : ProductEditorTokens.blue,
        ),
      ),
    );
  }

  Widget _notice(String message, Color ink, Color background, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: ink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.semanticLabel,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  /// Plain [Semantics] rather than a [Tooltip]: a Tooltip's OverlayPortal child
  /// cannot attach while the modal's LayoutBuilder is performing layout.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final tint = enabled
        ? color.withValues(alpha: 0.10)
        : ProductEditorTokens.surface2;

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: tint,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: enabled
                    ? color.withValues(alpha: 0.30)
                    : ProductEditorTokens.line,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: enabled ? color : ProductEditorTokens.ink4,
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostAction extends StatelessWidget {
  const _GhostAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ProductEditorTokens.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: ProductEditorTokens.lineStrong,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: ProductEditorTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: enabled ? ProductEditorTokens.gradBtn : null,
            color: enabled
                ? null
                : ProductEditorTokens.blue.withValues(alpha: 0.35),
            boxShadow: enabled
                ? const [
                    BoxShadow(
                      color: Color(0x402563EB),
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, size: 17, color: Colors.white),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
