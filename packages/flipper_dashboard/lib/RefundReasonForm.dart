import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';

/// RRA refund reason code written before legacy VAT refund submission.
const String kDefaultRraRefundReasonCode = '05';

const List<String> kRefundReasonChipLabels = [
  'Customer request',
  'Wrong item',
  'Damaged / faulty',
  'Duplicate charge',
  'Other',
];

abstract final class _ChipColors {
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE8ECF4);
  static const ink2 = Color(0xFF374151);
  static const loss = Color(0xFFE5484D);
  static const lossInk = Color(0xFFB42318);
}

class RefundReasonForm extends StatefulWidget {
  const RefundReasonForm({
    super.key,
    this.enabled = true,
    this.initialLabel = 'Other',
  });

  final bool enabled;
  final String initialLabel;

  @override
  State<RefundReasonForm> createState() => _RefundReasonFormState();
}

class _RefundReasonFormState extends State<RefundReasonForm> {
  late String _selectedLabel;

  @override
  void initState() {
    super.initState();
    _selectedLabel = kRefundReasonChipLabels.contains(widget.initialLabel)
        ? widget.initialLabel
        : kRefundReasonChipLabels.last;
    _persistReason();
  }

  void _handleReasonChange(String label) {
    if (!widget.enabled) return;
    setState(() => _selectedLabel = label);
    _persistReason();
  }

  void _persistReason() {
    ProxyService.box.writeString(
      key: 'getRefundReason',
      value: kDefaultRraRefundReasonCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.flipperL10n.refundReason.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kRefundReasonChipLabels.map((label) {
            final selected = _selectedLabel == label;
            return _RefundReasonChip(
              label: label,
              selected: selected,
              enabled: widget.enabled,
              onTap: () => _handleReasonChange(label),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RefundReasonChip extends StatelessWidget {
  const _RefundReasonChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: selected ? const Color(0xFFFEF4F4) : _ChipColors.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? _ChipColors.loss : _ChipColors.line,
            width: 1.5,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: selected ? _ChipColors.lossInk : _ChipColors.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
