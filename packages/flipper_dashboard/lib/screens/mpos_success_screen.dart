import 'package:flipper_localize/flipper_localize.dart';

import 'package:flipper_dashboard/theme/mpos_motion.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';
import 'package:flutter/material.dart';

/// Sale complete screen ([design_handoff_mobile_pos] Success + ANIMATIONS.md §3).
///
/// Sits in the POS chrome (light surface, ink text, brand-blue action); green
/// is kept to the check badge, where it means "done". No confetti: a till
/// sees this screen hundreds of times a day.
class MposSaleCompleteSnapshot {
  const MposSaleCompleteSnapshot({
    required this.total,
    required this.itemCount,
    required this.methodLabel,
    this.customerName,
    this.tendered,
    this.change,
  });

  final double total;
  final int itemCount;
  final String methodLabel;
  final String? customerName;

  /// Cash handed over and change due — null for non-cash sales, which have
  /// neither, so their rows are hidden.
  final double? tendered;
  final double? change;
}

class MposSuccessScreen extends StatefulWidget {
  const MposSuccessScreen({
    super.key,
    required this.data,
    required this.onNewSale,
    this.onPrintReceipt,
  });

  final MposSaleCompleteSnapshot data;
  final VoidCallback onNewSale;

  /// Hidden when null rather than falling back to [onNewSale].
  final VoidCallback? onPrintReceipt;

  @override
  State<MposSuccessScreen> createState() => _MposSuccessScreenState();
}

class _MposSuccessScreenState extends State<MposSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _receiptController;
  late final Animation<double> _checkScale;
  late final Animation<double> _receiptOpacity;
  late final Animation<Offset> _receiptSlide;

  bool _started = false;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: MposMotion.checkPop,
    );
    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: MposMotion.overshoot),
    );

    _receiptController = AnimationController(
      vsync: this,
      duration: MposMotion.receiptIn,
    );
    final receiptCurve = CurvedAnimation(
      parent: _receiptController,
      curve: MposMotion.decelerate,
    );
    _receiptOpacity = Tween<double>(begin: 0, end: 1).animate(receiptCurve);
    _receiptSlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(receiptCurve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MposMotion.reducedMotion(context)) {
      _checkController.value = 1;
      _receiptController.value = 1;
    } else {
      _checkController.forward();
      Future<void>.delayed(MposMotion.receiptDelay, () {
        if (mounted) _receiptController.forward();
      });
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _receiptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final l10n = context.flipperL10n;
    final subline =
        '${d.methodLabel} · '
        '${l10n.cartItemCount(d.itemCount)} · '
        '${d.customerName ?? l10n.mposWalkIn}';

    return Scaffold(
      backgroundColor: PosTokens.posBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 56),
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          color: MposTokens.gainTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 44,
                          color: MposTokens.gain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.mposSaleComplete,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: PosTokens.ink1,
                        letterSpacing: -0.02,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: PosTokens.ink3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _receiptOpacity,
                      child: SlideTransition(
                        position: _receiptSlide,
                        child: _ReceiptCard(data: d),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  _PrimaryButton(
                    label: l10n.mposNewSale,
                    icon: Icons.add_rounded,
                    onTap: widget.onNewSale,
                  ),
                  if (widget.onPrintReceipt != null) ...[
                    const SizedBox(height: 10),
                    _SecondaryButton(
                      label: l10n.mposPrintReceipt,
                      icon: Icons.receipt_long_outlined,
                      onTap: widget.onPrintReceipt!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.data});

  final MposSaleCompleteSnapshot data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final tendered = data.tendered;
    final change = data.change;
    return MposCard(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        children: [
          _row(l10n.mposTotalPaid, data.total, big: true),
          if (tendered != null && change != null) ...[
            const Divider(height: 20, color: PosTokens.line),
            _row(l10n.mposTendered, tendered),
            _row(l10n.mposChange, change, emphasise: change > 0),
          ],
        ],
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool big = false,
    bool emphasise = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: big ? 15 : 13.5,
              fontWeight: big || emphasise ? FontWeight.w700 : FontWeight.w500,
              color: big || emphasise ? PosTokens.ink1 : PosTokens.ink2,
            ),
          ),
          Text(
            'RWF ${mposMoneyLabel(value)}',
            style: TextStyle(
              fontSize: big ? 22 : (emphasise ? 17 : 14),
              fontWeight: big || emphasise ? FontWeight.w800 : FontWeight.w600,
              color: PosTokens.ink1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          height: MposTokens.checkoutPrimaryHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: MposTokens.gradBtn,
            boxShadow: MposTokens.shadowBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15.5,
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

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: PosTokens.lineStrong, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: PosTokens.ink2),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
