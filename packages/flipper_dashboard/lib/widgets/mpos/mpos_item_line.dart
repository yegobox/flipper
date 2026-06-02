import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_models/helperModels/extensions.dart';

class MposItemLine extends StatefulWidget {
  const MposItemLine({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.baseUnitPrice,
    required this.qty,
    required this.canEdit,
    required this.onDecrement,
    required this.onIncrement,
    required this.onDelete,
    required this.onPriceChanged,
    required this.onPriceReset,
  });

  final String name;
  final double unitPrice;
  final double baseUnitPrice;
  final double qty;
  final bool canEdit;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onDelete;
  final ValueChanged<double> onPriceChanged;
  final VoidCallback onPriceReset;

  @override
  State<MposItemLine> createState() => _MposItemLineState();
}

class _MposItemLineState extends State<MposItemLine> {
  bool _priceOpen = false;
  late TextEditingController _priceController;

  bool get _isCustomPrice =>
      (widget.unitPrice - widget.baseUnitPrice).abs() > 0.001;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.unitPrice.round().toString(),
    );
  }

  @override
  void didUpdateWidget(MposItemLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unitPrice != widget.unitPrice && !_priceOpen) {
      _priceController.text = widget.unitPrice.round().toString();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final lineTotal = widget.unitPrice * widget.qty;
    final swatchColor = mposColorForName(widget.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: swatchColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  mposAbbreviation(widget.name),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
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
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: PosTokens.ink1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Text(
                          'RWF ${mposMoneyLabel(widget.unitPrice)} each',
                          style: mposMonoStyle(
                            theme,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PosTokens.ink3,
                          ),
                        ),
                        if (_isCustomPrice)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              'edited',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: PosTokens.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                lineTotal.toCurrencyFormatted(),
                style: mposMonoStyle(theme, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stepper(
                qty: widget.qty,
                enabled: widget.canEdit,
                onDecrement: widget.onDecrement,
                onIncrement: widget.onIncrement,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.canEdit)
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _priceOpen = !_priceOpen),
                      icon: Icon(
                        _priceOpen
                            ? Icons.check_rounded
                            : Icons.sell_outlined,
                        size: 15,
                      ),
                      label: Text(_priceOpen ? 'Done' : 'Price'),
                      style: TextButton.styleFrom(
                        foregroundColor: PosTokens.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: widget.canEdit ? widget.onDelete : null,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: PosTokens.ink4,
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ],
          ),
          if (_priceOpen && widget.canEdit) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PosTokens.surface2,
                borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                border: Border.all(color: PosTokens.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit price${_isCustomPrice ? ' · default RWF ${mposMoneyLabel(widget.baseUnitPrice)}' : ''}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.ink2,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: PosTokens.surface,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: PosTokens.line, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: PosTokens.surface2,
                            border: Border(
                              right: BorderSide(color: PosTokens.line),
                            ),
                          ),
                          child: const Text(
                            'RWF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: PosTokens.ink3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d.]'),
                              ),
                            ],
                            style: mposMonoStyle(theme, fontSize: 17),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (v) {
                              final p = double.tryParse(v);
                              if (p != null && p > 0) {
                                widget.onPriceChanged(p);
                              }
                            },
                          ),
                        ),
                        if (_isCustomPrice)
                          IconButton(
                            onPressed: () {
                              widget.onPriceReset();
                              _priceController.text = widget.baseUnitPrice
                                  .round()
                                  .toString();
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 15),
                            color: PosTokens.ink3,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.qty,
    required this.enabled,
    required this.onDecrement,
    required this.onIncrement,
  });

  final double qty;
  final bool enabled;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  String _formatQty(double q) {
    return q.toStringAsFixed(q.truncateToDouble() == q ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: PosTokens.line, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove_rounded,
            onTap: enabled && qty > 1 ? onDecrement : null,
          ),
          Container(
            width: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: PosTokens.line),
              ),
            ),
            child: Text(
              _formatQty(qty),
              style: mposMonoStyle(Theme.of(context).textTheme, fontSize: 15),
            ),
          ),
          _StepBtn(icon: Icons.add_rounded, onTap: enabled ? onIncrement : null),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.surface,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 38,
          child: Icon(
            icon,
            size: 16,
            color: onTap != null ? PosTokens.blue : PosTokens.ink4,
          ),
        ),
      ),
    );
  }
}
