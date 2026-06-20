import 'dart:ui';

import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flutter/material.dart';

/// Hero product stage — macOS Books window + POS phone + Flow toast (handoff § hero-stage).
class BooksHeroStage extends StatelessWidget {
  const BooksHeroStage({super.key, required this.width});

  final double width;

  static const _stageMaxW = 1080.0;
  static const _chartHeights = [0.42, 0.55, 0.48, 0.67, 0.60, 0.78, 0.72, 0.96];

  @override
  Widget build(BuildContext context) {
    final stageW = width > _stageMaxW ? _stageMaxW : width;
    final showFloats = width > 860 && booksHomeShowDeviceMocks;
    final showSidebar = width > 560;

    return RepaintBoundary(
      child: Padding(
        // Reference: .pos-float is absolutely positioned (bottom: -44px) and
        // overflows into the next section WITHOUT reserving layout space. So the
        // stage reserves no bottom gap — the phone overflows via the Stack's
        // Clip.none into the hero/trust spacing below.
        padding: const EdgeInsets.only(top: 56),
        child: Center(
          child: SizedBox(
            width: stageW,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
                        child: Opacity(
                          opacity: 0.55,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppGrad.soft,
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _BkAppWindow(
                  width: stageW,
                  showSidebar: showSidebar,
                  chartHeights: _chartHeights,
                ),
                if (showFloats) ...[
                  Positioned(
                    right: -34,
                    top: 96,
                    child: Floaty(
                      period: const Duration(seconds: 5),
                      child: const _FlowToast(),
                    ),
                  ),
                  Positioned(
                    left: -54,
                    bottom: -44,
                    child: Floaty(
                      period: const Duration(seconds: 6),
                      phase: 0.6,
                      child: const _PosPhoneMock(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BkAppWindow extends StatelessWidget {
  const _BkAppWindow({
    required this.width,
    required this.showSidebar,
    required this.chartHeights,
  });

  final double width;
  final bool showSidebar;
  final List<double> chartHeights;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpace.rLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGrad.glassCard,
            borderRadius: BorderRadius.circular(AppSpace.rLg),
            border: Border.all(color: AppColors.line2),
            boxShadow: AppShadow.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _BkTopBar(),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showSidebar) SizedBox(width: 200, child: _BkSidebar()),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 420),
                        child: _BkMain(chartHeights: chartHeights),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BkTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const FlipperMarkLogo(size: 16),
            const SizedBox(width: 8),
            Text(
              'Flipper Books — Demo Shop Ltd',
              style: AppText.small.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink2,
              ),
            ),
            const Spacer(),
            Text(
              'FY 2026 · RWF',
              style: AppText.small.copyWith(fontSize: 12, color: AppColors.ink4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BkSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _navLabel('Overview'),
            _navItem('Dashboard', BooksIcon.grid, active: true),
            _navLabel('Daybook'),
            _navItem('Journal entries', BooksIcon.journal, badge: '2'),
            _navItem('General ledger', BooksIcon.layers),
            _navItem('Bank reconciliation', BooksIcon.bankLines),
            _navLabel('Reports'),
            _navItem('Financial statements', BooksIcon.chartLine),
          ],
        ),
      ),
    );
  }

  Widget _navLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
      child: Text(
        text.toUpperCase(),
        style: AppText.small.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: AppColors.ink4,
        ),
      ),
    );
  }

  Widget _navItem(
    String label,
    BooksIcon icon, {
    bool active = false,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: active ? AppColors.blue.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          BooksLineIcon(
            icon,
            size: 16,
            color: active ? AppColors.ink0 : AppColors.ink3,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppText.small.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.ink0 : AppColors.ink3,
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badge,
                style: AppText.small.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.amber,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BkMain extends StatelessWidget {
  const _BkMain({required this.chartHeights});

  final List<double> chartHeights;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FINANCIAL OVERVIEW',
                      style: AppText.small.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Books at a glance',
                      style: AppText.h3.copyWith(fontSize: 22, letterSpacing: -0.44),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  'May 2026',
                  style: AppText.small.copyWith(fontSize: 12, color: AppColors.ink3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _BkKpi(
                  label: 'Net income',
                  icon: BooksIcon.trendUp,
                  value: '4.82M',
                  delta: '▲ 18.4%',
                  up: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BkKpi(
                  label: 'Cash on hand',
                  icon: BooksIcon.card,
                  value: '11.3M',
                  delta: '▲ 6.1%',
                  up: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BkKpi(
                  label: 'Receivables',
                  icon: BooksIcon.dollar,
                  value: '2.07M',
                  delta: '▼ 3.2%',
                  up: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 14,
                  child: _RevenueChart(chartHeights: chartHeights),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 10,
                  child: _ProfitLossPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BkKpi extends StatelessWidget {
  const _BkKpi({
    required this.label,
    required this.icon,
    required this.value,
    required this.delta,
    required this.up,
  });

  final String label;
  final BooksIcon icon;
  final String value;
  final String delta;
  final bool up;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BooksLineIcon(icon, size: 14, color: AppColors.ink3),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.small.copyWith(fontSize: 11.5, color: AppColors.ink3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppText.mono(size: 22, w: FontWeight.w700, c: AppColors.ink0),
          ),
          const SizedBox(height: 4),
          Text(
            delta,
            style: AppText.small.copyWith(
              fontSize: 11.5,
              color: up ? AppColors.green : AppColors.downKpi,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart({required this.chartHeights});

  final List<double> chartHeights;

  static const _barGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xD93F86FF), Color(0x403F86FF)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Revenue trend',
                style: AppText.h4.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                'Last 8 months',
                style: AppText.small.copyWith(fontSize: 11, color: AppColors.blue),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 96,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < chartHeights.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < chartHeights.length - 1 ? 8 : 0),
                      child: _ChartBar(
                        height: 96 * chartHeights[i],
                        highlight: i == chartHeights.length - 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.height, required this.highlight});

  final double height;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
        gradient: highlight ? AppGrad.brand : _RevenueChart._barGradient,
        boxShadow: highlight ? AppShadow.cyanGlow : null,
      ),
    );
  }
}

class _ProfitLossPanel extends StatelessWidget {
  static final _footerLabelStyle = AppText.small.copyWith(
    fontSize: 13,
    height: 1.1,
    fontWeight: FontWeight.w700,
    color: AppColors.green,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Profit & loss',
                style: AppText.h4.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                'May',
                style: AppText.small.copyWith(fontSize: 11, height: 1.1, color: AppColors.blue),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _plRow('Net revenue', '18.9M', showBorder: false),
                      _plRow('Cost of sales', '−9.2M'),
                      _plRow('Operating exp.', '−4.9M'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        Text('Net income', style: _footerLabelStyle),
                        const Spacer(),
                        Text(
                          '4.82M',
                          style: AppText.mono(
                            size: 16,
                            w: FontWeight.w800,
                            c: AppColors.green,
                          ).copyWith(height: 1.1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _plRow(String label, String value, {bool showBorder = true}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showBorder ? Border(top: BorderSide(color: AppColors.line)) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(label, style: AppText.small.copyWith(fontSize: 12.5, height: 1.15, color: AppColors.ink2)),
            const Spacer(),
            Text(
              value,
              style: AppText.mono(size: 12.5, w: FontWeight.w600, c: AppColors.ink1)
                  .copyWith(height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowToast extends StatelessWidget {
  const _FlowToast();

  static const _bg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFA161E32), Color(0xFA0E1422)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        gradient: _bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.75),
            blurRadius: 60,
            spreadRadius: -18,
            offset: const Offset(0, 24),
          ),
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.06),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: AppGrad.brand,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: BooksLineIcon(BooksIcon.flow, size: 17, color: AppColors.suiteActiveInk),
                ),
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flow AI',
                    style: AppText.h4.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'AUTO-POSTED',
                    style: AppText.small.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.cyan,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 11),
          Text.rich(
            TextSpan(
              style: AppText.body.copyWith(fontSize: 12.5, color: AppColors.ink2, height: 1.45),
              children: const [
                TextSpan(text: 'New sale on '),
                TextSpan(
                  text: 'Flipper POS',
                  style: TextStyle(color: AppColors.ink0, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' — categorized to '),
                TextSpan(
                  text: 'Sales Revenue',
                  style: TextStyle(color: AppColors.ink0, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' and reconciled to MoMo.'),
              ],
            ),
          ),
          const SizedBox(height: 11),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Row(
                children: [
                  Text(
                    'JE-1048',
                    style: AppText.mono(size: 11.5, w: FontWeight.w600, c: AppColors.blue),
                  ),
                  Text(
                    ' · balanced',
                    style: AppText.small.copyWith(fontSize: 11.5, color: AppColors.ink3),
                  ),
                  const Spacer(),
                  Text(
                    '+12,000',
                    style: AppText.mono(size: 11.5, w: FontWeight.w700, c: AppColors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosPhoneMock extends StatelessWidget {
  const _PosPhoneMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.line2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 80,
            spreadRadius: -24,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ColoredBox(
          color: const Color(0xFF0D1320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                child: Row(
                  children: [
                    Text(
                      'New sale',
                      style: AppText.h4.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '● PENDING',
                        style: AppText.small.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      BooksLineIcon(BooksIcon.search, size: 13, color: AppColors.ink4),
                      const SizedBox(width: 7),
                      Text(
                        'Search or scan…',
                        style: AppText.small.copyWith(fontSize: 11, color: AppColors.ink4),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                child: Column(
                  children: [
                    _posItem('SO', 'Smoke 006', '80 left', '30', AppColors.posSo),
                    const SizedBox(height: 8),
                    _posItem('CC', 'Coupe Coupe', '367 left', '2,400', AppColors.posCc),
                    const SizedBox(height: 8),
                    _posItem('FC', 'Fanta Citron', '142 left', '800', AppColors.posFc),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _posItem(String abbr, String name, String stock, String price, Color color) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              abbr,
              style: AppText.small.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.ink0,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppText.small.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink0,
                  ),
                ),
                Text(
                  stock,
                  style: AppText.small.copyWith(fontSize: 9.5, color: AppColors.ink4),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppText.mono(size: 11, w: FontWeight.w700, c: AppColors.ink1),
          ),
          const SizedBox(width: 9),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue,
            ),
            child: const Center(
              child: BooksLineIcon(BooksIcon.plus, size: 13, color: AppColors.ink0),
            ),
          ),
        ],
      ),
    );
  }
}
