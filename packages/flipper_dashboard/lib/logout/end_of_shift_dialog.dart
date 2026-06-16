import 'package:flipper_dashboard/logout/end_of_shift_summary.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum EndOfShiftAction { signOut, switchBranch }

class EndOfShiftDialog extends StatefulWidget {
  final String? branchName;

  const EndOfShiftDialog({super.key, this.branchName});

  static Future<EndOfShiftAction?> show(
    BuildContext context, {
    String? branchName,
  }) {
    return showDialog<EndOfShiftAction>(
      context: context,
      barrierColor: const Color(0x66101828),
      builder: (_) => EndOfShiftDialog(branchName: branchName),
    );
  }

  @override
  State<EndOfShiftDialog> createState() => _EndOfShiftDialogState();
}

class _EndOfShiftDialogState extends State<EndOfShiftDialog> {
  static const double _shellWidth = 440;
  static const double _shellMinHeight = 548;

  late Future<EndOfShiftSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = loadEndOfShiftSummary(branchName: widget.branchName);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: _shellWidth,
          minWidth: _shellWidth,
          minHeight: _shellMinHeight,
        ),
        child: Material(
          color: PosTokens.surface,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder<EndOfShiftSummary>(
            future: _summaryFuture,
            builder: (context, snapshot) {
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              final summary = snapshot.data ?? EndOfShiftSummary.empty;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: isLoading
                    ? const _EndOfShiftSkeleton(key: ValueKey('loading'))
                    : _EndOfShiftBody(
                        key: const ValueKey('loaded'),
                        summary: summary,
                        onSignOut: () => Navigator.pop(
                          context,
                          EndOfShiftAction.signOut,
                        ),
                        onSwitchBranch: () => Navigator.pop(
                          context,
                          EndOfShiftAction.switchBranch,
                        ),
                        onStaySignedIn: () => Navigator.pop(context),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EndOfShiftSkeleton extends StatelessWidget {
  const _EndOfShiftSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 148, height: 24, radius: 6),
                    const SizedBox(height: 8),
                    _SkeletonBox(width: 196, height: 14, radius: 4),
                  ],
                ),
              ),
              const _SkeletonBox(width: 36, height: 36, radius: 18),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PosTokens.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PosTokens.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: _SkeletonBox(width: 140, height: 12, radius: 4),
                    ),
                    _SkeletonBox(width: 72, height: 26, radius: 999),
                  ],
                ),
                const SizedBox(height: 14),
                _SkeletonBox(width: 120, height: 12, radius: 4),
                const SizedBox(height: 8),
                _SkeletonBox(width: 180, height: 32, radius: 6),
                const SizedBox(height: 14),
                _SkeletonBox(width: double.infinity, height: 8, radius: 999),
                const SizedBox(height: 12),
                _SkeletonBox(width: double.infinity, height: 14, radius: 4),
                const SizedBox(height: 8),
                _SkeletonBox(width: double.infinity, height: 14, radius: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, 1),
                        painter: _DottedLinePainter(color: PosTokens.lineStrong),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _SkeletonBox(
                        width: double.infinity,
                        height: 38,
                        radius: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SkeletonBox(
                        width: double.infinity,
                        height: 38,
                        radius: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SkeletonBox(width: double.infinity, height: 50, radius: 12),
          const SizedBox(height: 10),
          _SkeletonBox(width: double.infinity, height: 50, radius: 12),
          const SizedBox(height: 4),
          Center(child: _SkeletonBox(width: 108, height: 14, radius: 4)),
          const SizedBox(height: 6),
          Center(
            child: _SkeletonBox(
              width: 280,
              height: 12,
              radius: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: PosTokens.line.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _EndOfShiftBody extends StatelessWidget {
  final EndOfShiftSummary summary;
  final VoidCallback onSignOut;
  final VoidCallback onSwitchBranch;
  final VoidCallback onStaySignedIn;

  const _EndOfShiftBody({
    super.key,
    required this.summary,
    required this.onSignOut,
    required this.onSwitchBranch,
    required this.onStaySignedIn,
  });

  String get _currency => ProxyService.box.defaultCurrency();

  String _money(double value) {
    return '$_currency ${NumberFormat('#,##0', 'en_US').format(value)}';
  }

  String _durationLabel(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m';
    return '<1m';
  }

  String _shiftDateLabel() {
    final start = summary.shiftStartedAt ?? DateTime.now();
    final day = DateFormat('MMM d').format(start).toUpperCase();
    return "TODAY'S SHIFT · $day";
  }

  @override
  Widget build(BuildContext context) {
    final cash = summary.cashDrawer;
    final mobile = summary.mobileMoney;
    final total = summary.totalCollected > 0
        ? summary.totalCollected
        : cash + mobile;
    final cashFraction = total > 0 ? (cash / total).clamp(0.0, 1.0) : 1.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End of shift',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: PosTokens.ink1,
                        letterSpacing: -0.4,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${summary.agentLabel} · ${summary.branchName}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PosTokens.ink3,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onStaySignedIn,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: PosTokens.surface2,
                  foregroundColor: PosTokens.ink3,
                  minimumSize: const Size(36, 36),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PosTokens.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PosTokens.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        summary.hasOpenShift
                            ? _shiftDateLabel()
                            : 'NO OPEN SHIFT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: PosTokens.ink3,
                        ),
                      ),
                    ),
                    if (summary.hasOpenShift)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: PosTokens.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: PosTokens.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: PosTokens.ink3,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _durationLabel(summary.shiftDuration),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PosTokens.ink2,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Collected this shift',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: PosTokens.ink3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _money(total),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: PosTokens.ink1,
                    letterSpacing: -0.8,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 8,
                    child: Row(
                      children: [
                        if (cashFraction > 0)
                          Expanded(
                            flex: (cashFraction * 1000).round().clamp(1, 1000),
                            child: ColoredBox(
                              color: total > 0
                                  ? const Color(0xFF2563EB)
                                  : PosTokens.line,
                            ),
                          ),
                        if (cashFraction < 1)
                          Expanded(
                            flex: ((1 - cashFraction) * 1000)
                                .round()
                                .clamp(1, 1000),
                            child: ColoredBox(
                              color: total > 0
                                  ? const Color(0xFF7C3AED)
                                  : PosTokens.line,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _PaymentLegendRow(
                  color: const Color(0xFF2563EB),
                  label: 'Cash drawer',
                  amount: _money(cash),
                ),
                const SizedBox(height: 8),
                _PaymentLegendRow(
                  color: const Color(0xFF7C3AED),
                  label: 'Mobile money',
                  amount: _money(mobile),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, 1),
                        painter: _DottedLinePainter(color: PosTokens.lineStrong),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _ShiftStat(
                        icon: Icons.receipt_long_outlined,
                        value: '${summary.salesCompleted}',
                        label: 'Sales completed',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ShiftStat(
                        icon: Icons.inventory_2_outlined,
                        value: '${summary.itemsSold}',
                        label: 'Items sold',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onSignOut,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF04438),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text(
              'Close shift & sign out',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onSwitchBranch,
            style: OutlinedButton.styleFrom(
              foregroundColor: PosTokens.ink1,
              backgroundColor: PosTokens.surface,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: PosTokens.lineStrong),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            label: const Text(
              'Switch branch',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: onStaySignedIn,
            style: TextButton.styleFrom(
              foregroundColor: PosTokens.ink3,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text(
              'Stay signed in',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 15,
                color: const Color(0xFF16A34A).withValues(alpha: 0.9),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Your sales are saved — the drawer will be reconciled on close.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: PosTokens.ink3,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String amount;

  const _PaymentLegendRow({
    required this.color,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PosTokens.ink2,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: PosTokens.ink1,
          ),
        ),
      ],
    );
  }
}

class _ShiftStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ShiftStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: PosTokens.ink3),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: PosTokens.ink1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: PosTokens.ink3,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 4.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
