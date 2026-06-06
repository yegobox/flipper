import 'package:flipper_design_system/flipper_design_system.dart';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mobile dashboard hero gauge — single gradient semicircle arc per design handoff.
class DashboardHomeGauge extends StatefulWidget {
  const DashboardHomeGauge({
    super.key,
    required this.value,
    required this.revenue,
    required this.grossProfit,
    required this.deductions,
    required this.profitType,
    required this.periodLabel,
    required this.isEmpty,
    this.deltaPercent,
    this.comparisonLabel,
  });

  final double value;
  final double revenue;
  final double grossProfit;
  final double deductions;
  final String profitType;
  final String periodLabel;
  final bool isEmpty;
  final int? deltaPercent;
  final String? comparisonLabel;

  @override
  State<DashboardHomeGauge> createState() => _DashboardHomeGaugeState();
}

class _DashboardHomeGaugeState extends State<DashboardHomeGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _arcAnimation;
  late Animation<double> _valueAnimation;

  static const _duration = Duration(milliseconds: 700);
  static const _curve = Curves.easeOutCubic;

  static const Color _gain = Color(0xFF10B981);
  static const Color _gainInk = Color(0xFF047857);
  static const Color _lossInk = Color(0xFFB42318);
  static const Color _line = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _arcAnimation = CurvedAnimation(parent: _controller, curve: _curve);
    _valueAnimation = CurvedAnimation(parent: _controller, curve: _curve);
    if (!widget.isEmpty) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant DashboardHomeGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final fillChanged = oldWidget.value != widget.value ||
        oldWidget.revenue != widget.revenue ||
        oldWidget.profitType != widget.profitType ||
        oldWidget.isEmpty != widget.isEmpty;
    if (fillChanged) {
      if (widget.isEmpty) {
        _controller.value = 0;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _targetFill {
    if (widget.isEmpty || widget.revenue <= 0) return 0;
    return (widget.value / widget.revenue).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final metricShort =
        widget.profitType == 'Gross Profit' ? 'Gross' : 'Net';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedBuilder(
                        animation: _arcAnimation,
                        builder: (context, _) {
                          final fill = reduceMotion
                              ? _targetFill
                              : _targetFill * _arcAnimation.value;
                          return CustomPaint(
                            size: const Size(double.infinity, 140),
                            painter: _DashboardArcPainter(
                              fillFraction: fill,
                              isEmpty: widget.isEmpty,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'RWF',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _valueAnimation,
                              builder: (context, _) {
                                final displayed = widget.isEmpty
                                    ? 0.0
                                    : reduceMotion
                                        ? widget.value
                                        : lerpDouble(
                                              0,
                                              widget.value,
                                              _valueAnimation.value,
                                            )!;
                                return Text(
                                  formatNumber(displayed),
                                  style: FlipperFonts.mono(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w700,
                                    color: widget.isEmpty
                                        ? Colors.grey.shade400
                                        : Colors.black87,
                                    letterSpacing: -1.5,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            _buildDeltaChip(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$metricShort profit · ${widget.periodLabel}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: _line),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _splitCell(
                    dotColor: _gain,
                    label: 'Gross profit',
                    value: widget.grossProfit,
                    valueColor:
                        widget.isEmpty ? Colors.grey.shade400 : _gainInk,
                  ),
                ),
                VerticalDivider(width: 1, color: _line),
                Expanded(
                  child: _splitCell(
                    dotColor: const Color(0xFFE5484D),
                    label: 'Tax & expenses',
                    value: widget.deductions,
                    valueColor:
                        widget.isEmpty ? Colors.grey.shade400 : _lossInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeltaChip() {
    if (widget.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'No transactions yet',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final delta = widget.deltaPercent;
    if (delta == null) return const SizedBox.shrink();

    final isUp = delta >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7EF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: _gainInk,
          ),
          const SizedBox(width: 2),
          Text(
            '${isUp ? '' : ''}${delta.abs()}% vs ${widget.comparisonLabel ?? 'last period'}',
            style: FlipperFonts.mono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _gainInk,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _splitCell({
    required Color dotColor,
    required String label,
    required double value,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.isEmpty ? '0' : formatNumber(value),
            style: FlipperFonts.mono(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardArcPainter extends CustomPainter {
  _DashboardArcPainter({
    required this.fillFraction,
    required this.isEmpty,
  });

  final double fillFraction;
  final bool isEmpty;

  static const _strokeWidth = 18.0;
  static const _gain = Color(0xFF10B981);
  static const _loss = Color(0xFFE5484D);
  static const _line = Color(0xFFE5E7EB);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 8);
    final radius = math.min(size.width / 2 - 28, size.height - 20);

    final trackRect = Rect.fromCircle(center: center, radius: radius);
    final trackPaint = Paint()
      ..color = _line
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(trackRect, math.pi, math.pi, false, trackPaint);

    if (!isEmpty && fillFraction > 0.001) {
      final sweep = math.pi * fillFraction;
      final fillPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = const SweepGradient(
          startAngle: math.pi,
          endAngle: 2 * math.pi,
          colors: [
            Color(0xFF10B981),
            Color(0xFF22D3EE),
            Color(0xFF2563EB),
          ],
          stops: [0.0, 0.6, 1.0],
        ).createShader(trackRect);

      canvas.drawArc(trackRect, math.pi, sweep, false, fillPaint);
    }

    final startX = center.dx + radius * math.cos(math.pi);
    final startY = center.dy + radius * math.sin(math.pi);
    final endX = center.dx + radius * math.cos(2 * math.pi);
    final endY = center.dy + radius * math.sin(2 * math.pi);

    canvas.drawCircle(
      Offset(startX, startY),
      4,
      Paint()..color = isEmpty ? Colors.grey.shade400 : _gain,
    );
    canvas.drawCircle(
      Offset(endX, endY),
      4,
      Paint()
        ..color = isEmpty
            ? Colors.grey.shade400.withValues(alpha: 0.4)
            : _loss.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant _DashboardArcPainter oldDelegate) =>
      oldDelegate.fillFraction != fillFraction ||
      oldDelegate.isEmpty != isEmpty;
}
