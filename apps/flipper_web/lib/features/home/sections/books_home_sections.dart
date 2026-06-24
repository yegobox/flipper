import 'dart:ui' as ui;

import 'package:flipper_web/features/home/sections/books_home_hero_mock.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flipper_web/l10n/app_localizations.dart';
import 'package:flipper_web/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BooksHomeHeader extends StatelessWidget {
  const BooksHomeHeader({
    super.key,
    required this.scrolled,
    required this.onStartFree,
    required this.onNavTap,
    required this.onSignIn,
  });

  final bool scrolled;
  final VoidCallback onStartFree;
  final ValueChanged<String> onNavTap;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w <= 1040;
        final gutter = booksHomeGutter(w);

        return StickyHeaderShell(
          scrolled: scrolled,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter, vertical: 14),
            child: compact
                ? Row(
                    children: [
                      const BooksWordmark(logoSize: 30),
                      const Spacer(),
                      IconButton(
                        onPressed: () => _showMobileMenu(
                          context,
                          onNavTap,
                          onSignIn,
                          onStartFree,
                        ),
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: AppColors.ink1,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const BooksWordmark(logoSize: 30),
                      Expanded(
                        child: Center(child: _SuiteSwitcher(onTap: onNavTap)),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (final (i, link) in [
                                'Platform',
                                'Flow AI',
                                'Features',
                                'Pricing',
                              ].indexed) ...[
                                if (i > 0) const SizedBox(width: 26),
                                NavTextLink(
                                  label: link,
                                  onTap: () => onNavTap(link),
                                ),
                              ],
                              const SizedBox(width: 18),
                              NavTextLink(label: 'Log in', onTap: onSignIn),
                              const SizedBox(width: 12),
                              PrimaryButton(
                                label: 'Start free',
                                onTap: onStartFree,
                                height: AppText.buttonHeightNav,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showMobileMenu(
    BuildContext context,
    ValueChanged<String> onNavTap,
    VoidCallback onSignIn,
    VoidCallback onStartFree,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpace.rLg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final link in ['Platform', 'Flow AI', 'Features', 'Pricing'])
              ListTile(
                title: Text(
                  link,
                  style: AppText.body.copyWith(color: AppColors.ink1),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavTap(link);
                },
              ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Log in',
              onTap: () {
                Navigator.pop(ctx);
                onSignIn();
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Start free',
              onTap: () {
                Navigator.pop(ctx);
                onStartFree();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SuiteSwitcher extends StatelessWidget {
  const _SuiteSwitcher({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SuitePill(
            label: 'POS',
            icon: BooksIcon.cart,
            active: false,
            onTap: () => onTap('POS'),
          ),
          _SuitePill(
            label: 'Books',
            icon: BooksIcon.book,
            active: true,
            onTap: () {},
          ),
          _SuitePill(
            label: 'Flow',
            icon: BooksIcon.flow,
            active: false,
            onTap: () => onTap('Flow'),
          ),
        ],
      ),
    );
  }
}

class _SuitePill extends StatelessWidget {
  const _SuitePill({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final BooksIcon icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          gradient: active ? AppGrad.brand : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BooksLineIcon(
              icon,
              size: 15,
              color: active ? AppColors.suiteActiveInk : AppColors.ink3,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppText.small.copyWith(
                fontSize: 13.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? AppColors.suiteActiveInk : AppColors.ink3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksHomeHero extends StatelessWidget {
  const BooksHomeHero({
    super.key,
    required this.onStartFree,
    required this.onSecondary,
  });

  final VoidCallback onStartFree;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h1 = booksHomeH1Size(w);
        final gutter = booksHomeGutter(w);
        final showStage = w > 860 && booksHomeShowDeviceMocks;

        return HeroBackground(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              gutter,
              64,
              gutter,
              showStage ? 0 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSpace.maxW),
                child: Column(
                  children: [
                    Reveal(
                      child: Column(
                        children: [
                          const HeroTopBadge(),
                          const SizedBox(height: 26),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Accounting',
                                style: AppText.h1(h1),
                                textAlign: TextAlign.center,
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('that ', style: AppText.h1(h1)),
                                  GradientText(
                                    'does itself.',
                                    style: AppText.h1(h1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          SizedBox(
                            width: AppSpace.heroSubMaxW.clamp(0, w - gutter * 2),
                            child: Text(
                              'Flipper Books is modern accounting for growing businesses. '
                              'Every sale from Flipper POS posts straight to your ledger — and '
                              'Flow AI categorizes, reconciles, and files the rest. You just run '
                              'your business.',
                              style: AppText.lead.copyWith(
                                fontSize: (w * 0.015).clamp(16.0, 20.0),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 34),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 14,
                            runSpacing: 14,
                            children: [
                              IntrinsicWidth(
                                child: PrimaryButton(
                                  label: 'Start free',
                                  onTap: onStartFree,
                                  showArrow: true,
                                ),
                              ),
                              IntrinsicWidth(
                                child: GhostButton(
                                  label: 'See how it works',
                                  onTap: onSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              HeroCheckItem('RRA / EBM-ready'),
                              HeroCheckItem('Works offline'),
                              HeroCheckItem('RWF-native'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (showStage) ...[
                      const SizedBox(height: 56),
                      Reveal(
                        delay: const Duration(milliseconds: 120),
                        child: RepaintBoundary(child: BooksHeroStage(width: w)),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BooksHomeTrustStrip extends StatelessWidget {
  const BooksHomeTrustStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return BooksHomeSection(
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 8),
      child: Reveal(
        child: Column(
          children: [
            Text(
              'Built for Rwandan businesses — and the way money actually moves.',
              style: AppText.small.copyWith(
                fontSize: 13,
                letterSpacing: 0.52,
                color: AppColors.ink3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 12,
              children: const [
                TrustChip(
                  icon: BooksIcon.shield,
                  bold: 'EBM 2.1',
                  label: 'tax integration',
                ),
                TrustChip(
                  icon: BooksIcon.trendUp,
                  bold: '12,400+',
                  label: 'businesses',
                ),
                TrustChip(icon: BooksIcon.card, label: 'MoMo & bank sync'),
                TrustChip(icon: BooksIcon.clock, label: 'Real-time ledger'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BooksHomeSuiteSection extends StatelessWidget {
  const BooksHomeSuiteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final stacked = w <= 860;

          return Column(
            children: [
              Reveal(
                child: const SectionHead(
                  eyebrow: 'One platform',
                  title: 'Three apps. One ledger. Zero double-entry.',
                  body:
                      "Flipper POS, Books, and Flow aren't integrations bolted together — "
                      "they're one system. Money moves through it once, and your books stay closed.",
                ),
              ),
              const SizedBox(height: 56),
              if (stacked)
                Column(
                  children: [
                    Reveal(child: _SuiteCard.pos()),
                    const _Connector(vertical: true),
                    Reveal(
                      delay: const Duration(milliseconds: 80),
                      child: _SuiteCard.books(),
                    ),
                    const _Connector(vertical: true),
                    Reveal(
                      delay: const Duration(milliseconds: 160),
                      child: _SuiteCard.flow(),
                    ),
                  ],
                )
              else
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Reveal(child: _SuiteCard.pos())),
                      const _Connector(),
                      Expanded(
                        child: Reveal(
                          delay: const Duration(milliseconds: 80),
                          child: _SuiteCard.books(),
                        ),
                      ),
                      const _Connector(),
                      Expanded(
                        child: Reveal(
                          delay: const Duration(milliseconds: 160),
                          child: _SuiteCard.flow(),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 28),
              Reveal(
                delay: const Duration(milliseconds: 200),
                child: DashedOutlineContainer(
                  radius: 999,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: ColoredBox(
                    color: Colors.white.withValues(alpha: 0.015),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              BooksLineIcon(
                                BooksIcon.refreshLoop,
                                size: 18,
                                color: AppColors.cyan,
                              ),
                              Text.rich(
                                TextSpan(
                                  style: AppText.body.copyWith(
                                    fontSize: 14,
                                    color: AppColors.ink2,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Sell on POS → '),
                                    TextSpan(
                                      text: 'posts to Books',
                                      style: TextStyle(
                                        color: AppColors.ink0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' → '),
                                    TextSpan(
                                      text: 'Flow reconciles',
                                      style: TextStyle(
                                        color: AppColors.ink0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' → you see profit in real time. One loop, fully automatic.',
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({this.vertical = false});

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: RotatedBox(
          quarterTurns: 1,
          child: SizedBox(
            width: 38,
            height: 26,
            child: BooksLineIcon(
              BooksIcon.arrowConnector,
              size: 26,
              color: AppColors.ink4,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: SizedBox(
          width: 38,
          height: 26,
          child: BooksLineIcon(
            BooksIcon.arrowConnector,
            size: 26,
            color: AppColors.ink4,
          ),
        ),
      ),
    );
  }
}

class _SuiteCard extends StatelessWidget {
  const _SuiteCard({
    required this.productLabel,
    required this.role,
    required this.tagline,
    required this.body,
    required this.icon,
    required this.gradient,
    required this.labelColor,
    required this.glowColor,
    this.glowAlpha = 0.2,
    this.highlighted = false,
  });

  factory _SuiteCard.pos() => const _SuiteCard(
    productLabel: 'FLIPPER POS',
    role: 'Sell',
    tagline: 'The front counter',
    body:
        'Ring up sales on mobile or desktop, scan stock, take cash or MoMo. '
        'Works the second you open the shop — online or off.',
    icon: BooksIcon.cart,
    gradient: AppGrad.suitePosIcon,
    labelColor: AppColors.ink3,
    glowColor: AppColors.blue,
  );

  factory _SuiteCard.books() => const _SuiteCard(
    productLabel: 'FLIPPER BOOKS',
    role: 'Account',
    tagline: 'The source of truth',
    body:
        'Every sale lands as a balanced journal entry. Real-time P&L, cash flow, '
        'receivables and EBM-ready tax — no spreadsheets, no month-end scramble.',
    icon: BooksIcon.book,
    gradient: AppGrad.suiteBooksIcon,
    labelColor: AppColors.cyan,
    glowColor: AppColors.cyan,
    highlighted: true,
  );

  factory _SuiteCard.flow() => const _SuiteCard(
    productLabel: 'FLIPPER FLOW',
    role: 'Automate',
    tagline: 'The AI bookkeeper',
    body:
        'Flow watches the whole flow — categorizing, reconciling, flagging anomalies '
        'and prepping tax. The work that used to take an accountant a week happens in real time.',
    icon: BooksIcon.flow,
    gradient: AppGrad.suiteFlowIcon,
    labelColor: AppColors.amber,
    glowColor: AppColors.amber,
    glowAlpha: 0.17,
  );

  final String productLabel;
  final String role;
  final String tagline;
  final String body;
  final BooksIcon icon;
  final Gradient gradient;
  final Color labelColor;
  final Color glowColor;
  final double glowAlpha;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppGrad.suiteCardFill,
        borderRadius: BorderRadius.circular(AppSpace.rLg),
        border: Border.all(
          color: highlighted
              ? AppColors.cyan.withValues(alpha: 0.30)
              : AppColors.line,
        ),
        boxShadow: highlighted ? AppShadow.cyanSuiteGlow : null,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -40,
            top: -60,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      stops: const [0, 0.7],
                      colors: [
                        glowColor.withValues(alpha: glowAlpha),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: BooksLineIcon(
                    icon,
                    size: 24,
                    color: AppColors.suiteActiveInk,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                productLabel,
                style: AppText.eyebrow.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(role, style: AppText.h3.copyWith(fontSize: 21)),
              const SizedBox(height: 3),
              Text(
                tagline,
                style: AppText.small.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: AppText.body.copyWith(fontSize: 14, height: 1.55),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BooksHomeFlowSection extends StatelessWidget {
  const BooksHomeFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.blue.withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
      ),
      child: BooksHomeSection(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final stacked = w <= 1040;

            return Reveal(
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _flowCopy(context, w),
                        const SizedBox(height: 40),
                        const _FlowChatPanel(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _flowCopy(context, w)),
                        const SizedBox(width: 64),
                        const Expanded(child: _FlowChatPanel()),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _flowCopy(BuildContext context, double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EyebrowLabel('Meet Flow AI'),
        const SizedBox(height: 16),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Your books, kept by an ',
              style: AppText.h2(booksHomeH2SizeOf(context)),
            ),
            GradientText(
              'AI bookkeeper.',
              style: AppText.h2(booksHomeH2SizeOf(context)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Flow turns raw transactions into clean, audit-ready accounting — and asks you '
            'only when it genuinely needs a decision. Sleep free from the hassle of accounting tasks.',
            style: AppText.lead.copyWith(fontSize: 17),
          ),
        ),
        const SizedBox(height: 36),
        for (final item in [
          (
            BooksIcon.listLines,
            'Auto-categorization',
            'Each sale, expense and transfer is coded to the right account the instant it happens.',
          ),
          (
            BooksIcon.refreshLoop,
            'Bank & MoMo reconciliation',
            'Flow matches your ledger to statements automatically and surfaces only true exceptions.',
          ),
          (
            BooksIcon.shieldCheck,
            'Tax & VAT, prepared',
            'EBM-ready filings drafted from your live ledger, so RRA deadlines stop being a panic.',
          ),
          (
            BooksIcon.alert,
            'Anomaly alerts',
            'Duplicate entries, margin dips and unusual spend get flagged before they become a problem.',
          ),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.line2),
                  ),
                  child: Center(
                    child: BooksLineIcon(
                      item.$1,
                      size: 20,
                      color: AppColors.cyan,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$2, style: AppText.h4.copyWith(fontSize: 16.5)),
                      const SizedBox(height: 5),
                      Text(
                        item.$3,
                        style: AppText.body.copyWith(fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        GhostButton(
          label: 'Explore Flow AI',
          onTap: () {},
          height: AppText.buttonHeightNav,
          compact: true,
          showArrow: true,
        ),
      ],
    );
  }
}

class _FlowChatPanel extends StatelessWidget {
  const _FlowChatPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: AppGrad.soft,
              ),
            ),
          ),
        ),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.line)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: AppGrad.brand,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: BooksLineIcon(
                              BooksIcon.flow,
                              size: 19,
                              color: AppColors.suiteActiveInk,
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flow AI',
                                style: AppText.h4.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.green.withValues(
                                            alpha: 0.8,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Watching your ledger',
                                    style: AppText.small.copyWith(
                                      fontSize: 11.5,
                                      color: AppColors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _bubble(
                'A new sale came in on POS for RWF 12,000, paid by MoMo. Book it.',
                mine: true,
              ),
              const SizedBox(height: 12),
              _bubble(
                "Done — posted a balanced entry and reconciled it to your MTN MoMo account. Here's the journal entry:",
                mine: false,
                child: _jeEntry(),
              ),
              const SizedBox(height: 12),
              _bubble('Anything I should look at this week?', mine: true),
              const SizedBox(height: 12),
              _bubble(
                "VAT for May is ready to file (RWF 318,400) and one supplier was charged twice — I've flagged it in Payables.",
                mine: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bubble(String text, {required bool mine, Widget? child}) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: mine ? 340 : 420),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: mine
              ? AppColors.blue.withValues(alpha: 0.16)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(mine ? 14 : 5),
            bottomRight: Radius.circular(mine ? 5 : 14),
          ),
          border: Border.all(
            color: mine
                ? AppColors.blue.withValues(alpha: 0.24)
                : AppColors.line,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppText.body.copyWith(
                fontSize: 13.5,
                color: AppColors.ink1,
              ),
            ),
            if (child != null) ...[const SizedBox(height: 10), child],
          ],
        ),
      ),
    );
  }

  Widget _jeEntry() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(11),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            color: Colors.white.withValues(alpha: 0.03),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'JE-1048 · 31 May 2026',
                    style: AppText.mono(
                      size: 11.5,
                      c: AppColors.blue,
                      w: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const BooksLineIcon(
                  BooksIcon.check,
                  size: 13,
                  color: AppColors.green,
                ),
                const SizedBox(width: 5),
                Text(
                  'Balanced',
                  style: AppText.small.copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _jeLine('1020', 'MoMo — MTN', '12,000', debit: true),
          _jeLine('4010', 'Sales Revenue', '12,000', debit: false),
        ],
      ),
    );
  }

  Widget _jeLine(String code, String acct, String amt, {required bool debit}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Text(code, style: AppText.mono(size: 12, c: AppColors.ink4)),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              acct,
              style: AppText.small.copyWith(color: AppColors.ink2),
            ),
          ),
          Text(amt, style: AppText.mono(size: 12, w: FontWeight.w600)),
        ],
      ),
    );
  }
}

class BooksHomeCapabilitiesSection extends StatelessWidget {
  const BooksHomeCapabilitiesSection({super.key});

  static const _items = [
    (
      'Financial statements',
      'Income statement, balance sheet and cash flow generated live from your general ledger.',
      BooksIcon.chartLine,
    ),
    (
      'Bank reconciliation',
      'Match ledger lines to bank and MoMo statements in one pass, with exceptions surfaced for you.',
      BooksIcon.bankLines,
    ),
    (
      'Receivables & payables',
      'Track who owes you and what you owe, with aging buckets and gentle automatic reminders.',
      BooksIcon.dollar,
    ),
    (
      'Tax & VAT',
      'EBM 2.1 integration and VAT computed continuously — filings drafted before the deadline.',
      BooksIcon.shieldCheck,
    ),
    (
      'Chart of accounts',
      'A numbered, audit-friendly ledger structure that adapts to how your business is organized.',
      BooksIcon.doc,
    ),
    (
      'Multi-branch',
      'Consolidate every shop into one set of books, then drill into any branch on its own.',
      BooksIcon.building,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = booksHomeCols(constraints.maxWidth);

          return Reveal(
            child: Column(
              children: [
                const SectionHead(
                  eyebrow: 'INSIDE BOOKS',
                  title: 'Everything an accountant does — built in.',
                  body:
                      "Double-entry accounting that's serious enough for your auditor and simple enough to run yourself.",
                ),
                const SizedBox(height: 56),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: cols == 1 ? 1.55 : 1.35,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Reveal(
                      delay: Duration(milliseconds: i * 80),
                      child: HoverLiftCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 26,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.line2),
                              ),
                              child: Center(
                                child: BooksLineIcon(
                                  item.$3,
                                  size: 22,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              item.$1,
                              style: AppText.h4.copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                item.$2,
                                style: AppText.body.copyWith(
                                  fontSize: 13.5,
                                  color: AppColors.ink2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BooksHomePricingSection extends StatelessWidget {
  const BooksHomePricingSection({
    super.key,
    required this.sectionKey,
    required this.onStartFree,
    required this.l10n,
  });

  final GlobalKey sectionKey;
  final VoidCallback onStartFree;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final oneCol = w <= 860;

          return Reveal(
            child: Column(
              key: sectionKey,
              children: [
                SectionHead(
                  eyebrow: 'PRICING',
                  title: l10n.pricingTitle,
                  body:
                      'Choose the plan that works best for you. Every plan includes the full '
                      'Flipper suite — POS, Books and Flow.',
                ),
                const SizedBox(height: 56),
                Flex(
                  direction: oneCol ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: oneCol
                      ? CrossAxisAlignment.stretch
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _PricingCard(
                        title: l10n.planMobile,
                        price: l10n.priceMobile,
                        period: l10n.currencyPerMonth,
                        features: [
                          l10n.featureMobileAppAccess,
                          l10n.featureBasicBusinessTools,
                          l10n.featureDataEncryption,
                          l10n.featureSingleDevice,
                          l10n.featureTaxReportingMobile,
                        ],
                        popular: false,
                        onStart: onStartFree,
                        cta: l10n.getStarted,
                      ),
                    ),
                    SizedBox(width: oneCol ? 0 : 18, height: oneCol ? 18 : 0),
                    Flexible(
                      child: Transform.translate(
                        offset: oneCol ? Offset.zero : const Offset(0, -8),
                        child: _PricingCard(
                          title: l10n.planMobileDesktop,
                          price: l10n.priceMobileDesktop,
                          period: l10n.currencyPerMonth,
                          features: [
                            l10n.featureMobileDesktopAppAccess,
                            l10n.featureAdvancedBusinessTools,
                            l10n.featureMilitaryGradeEncryption,
                            l10n.featurePrioritySupport,
                            l10n.featureMultipleDevices,
                            l10n.featureAdvancedAnalytics,
                            l10n.featureTaxReportingDesktop,
                          ],
                          popular: true,
                          onStart: onStartFree,
                          cta: l10n.getStarted,
                        ),
                      ),
                    ),
                    SizedBox(width: oneCol ? 0 : 18, height: oneCol ? 18 : 0),
                    Flexible(
                      child: _PricingCard(
                        title: l10n.planEnterprise,
                        price: '1.5M+',
                        period: l10n.currencyPerMonth,
                        features: [
                          l10n.featureFullPlatformAccess,
                          l10n.featureEnterpriseGradeSecurity,
                          l10n.feature247DedicatedSupport,
                          l10n.featureUnlimitedUsersBranches,
                          l10n.featureCustomIntegrations,
                          l10n.featurePremiumTaxConsulting,
                        ],
                        popular: false,
                        onStart: onStartFree,
                        cta: 'Contact sales',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.popular,
    required this.onStart,
    required this.cta,
  });

  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool popular;
  final VoidCallback onStart;
  final String cta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      decoration: BoxDecoration(
        gradient: popular
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.green.withValues(alpha: 0.07),
                  Colors.white.withValues(alpha: 0.012),
                ],
              )
            : AppGrad.pricingCardFill,
        borderRadius: BorderRadius.circular(AppSpace.rLg),
        border: Border.all(
          color: popular
              ? AppColors.green.withValues(alpha: 0.45)
              : AppColors.line,
        ),
        boxShadow: popular ? AppShadow.popularGlow : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (popular) const MostPopularTag(),
          if (popular) const SizedBox(height: 16),
          Text(title, style: AppText.h3.copyWith(fontSize: 19)),
          const SizedBox(height: 14),
          Text(price, style: AppText.mono(size: 38, w: FontWeight.w700)),
          Text(period, style: AppText.small.copyWith(fontSize: 13)),
          const SizedBox(height: 24),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooksLineIcon(
                    BooksIcon.check,
                    size: 17,
                    color: feature.startsWith('+')
                        ? AppColors.ink3
                        : AppColors.green,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppText.body.copyWith(
                        fontSize: 13.5,
                        height: 1.4,
                        color: feature.startsWith('+')
                            ? AppColors.ink3
                            : AppColors.ink2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 26),
          if (popular)
            PrimaryButton(
              label: cta,
              onTap: onStart,
              height: AppText.buttonHeightHero,
            )
          else
            GhostButton(
              label: cta,
              onTap: onStart,
              height: AppText.buttonHeightHero,
            ),
        ],
      ),
    );
  }
}

class BooksHomeBrandBand extends StatelessWidget {
  const BooksHomeBrandBand({
    super.key,
    required this.onStartFree,
    required this.onSignIn,
  });

  final VoidCallback onStartFree;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final gutter = booksHomeGutter(w);
        final stacked = w <= 860;
        final showVisual = w > 860 && booksHomeShowDeviceMocks;
        // CSS .brand-band h2 = clamp(30px, 3.6vw, 48px)
        final bandH2 = (MediaQuery.sizeOf(context).width * 0.036).clamp(
          30.0,
          48.0,
        );

        return Padding(
          // CSS brand-band section uses `padding-top: 0` — it sits directly
          // under the pricing block's bottom padding.
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, AppSpace.sectionY),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.maxW),
              child: Reveal(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: stacked ? 32 : 56,
                    vertical: stacked ? 52 : 60,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppGrad.band,
                    borderRadius: BorderRadius.circular(AppSpace.rXl),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                    boxShadow: AppShadow.bandShadow,
                  ),
                  child: stacked
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_bandCopy(onStartFree, onSignIn, bandH2)],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _bandCopy(onStartFree, onSignIn, bandH2),
                            ),
                            if (showVisual)
                              Expanded(
                                child: RepaintBoundary(
                                  child: SizedBox(
                                    height: 380,
                                    child: _BandVisual(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bandCopy(
    VoidCallback onStartFree,
    VoidCallback onSignIn,
    double h2Size,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FLIPPER BUSINESS OS',
          // .bb-eyebrow letter-spacing: .18em on 12px = 2.16
          style: AppText.eyebrow.copyWith(
            letterSpacing: 2.16,
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          // .brand-band h2 { max-width: 14ch } — ch ≈ 0.5em for Geist, so the
          // headline wraps to three lines like the reference.
          constraints: BoxConstraints(maxWidth: h2Size * 7),
          child: Text(
            'Your shop, your books, all in one place.',
            style: AppText.h2(h2Size).copyWith(color: AppColors.ink0),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            'Start selling on Flipper today and let Flow keep your books — automatically, '
            'in real time. Pick up right where you left off.',
            style: AppText.lead.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            IntrinsicWidth(
              child: WhiteButton(
                label: 'Start free',
                onTap: onStartFree,
                showArrow: true,
              ),
            ),
            IntrinsicWidth(
              child: OutlineWhiteButton(label: 'Talk to sales', onTap: onSignIn),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 36,
          runSpacing: 12,
          children: [
            _BandStat('12,400+', 'businesses'),
            _BandStat('RWF 1.2B', 'processed monthly'),
            _BandStat('99.9%', 'uptime'),
          ],
        ),
      ],
    );
  }
}

class _BandStat extends StatelessWidget {
  const _BandStat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppText.mono(size: 26, w: FontWeight.w700, c: AppColors.ink0),
        ),
        Text(
          label,
          style: AppText.small.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _BandVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 440,
          height: 440,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              ),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 8,
          child: Floaty(
            child: Transform.rotate(
              angle: -0.052,
              child: const _BandChartCard(),
            ),
          ),
        ),
        Positioned(
          top: 92,
          right: 0,
          child: Floaty(
            period: const Duration(seconds: 6),
            phase: 0.6,
            child: Transform.rotate(angle: 0.087, child: const _BandSaleCard()),
          ),
        ),
        Positioned(
          bottom: 18,
          left: 56,
          child: Floaty(
            period: const Duration(seconds: 5),
            phase: 0.3,
            child: Transform.rotate(
              angle: -0.026,
              child: const _BandStreakCard(),
            ),
          ),
        ),
      ],
    );
  }
}

class _BandWhiteCard extends StatelessWidget {
  const _BandWhiteCard({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.ink0,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadow.whiteCard,
      ),
      child: child,
    );
  }
}

class _BandChartCard extends StatelessWidget {
  const _BandChartCard();

  static const _bars = [0.4, 0.64, 0.52, 0.86, 0.7, 1.0];

  @override
  Widget build(BuildContext context) {
    return _BandWhiteCard(
      width: 218,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revenue · this week',
                  style: AppText.small.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '18%',
                style: AppText.mono(
                  size: 11,
                  w: FontWeight.w700,
                  c: AppColors.greenInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'RWF 248,500',
            style: AppText.mono(
              size: 19,
              w: FontWeight.w800,
              c: AppColors.ink1,
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: i < _bars.length - 1 ? 4 : 0,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: i == _bars.length - 1
                              ? AppGrad.brand
                              : null,
                          color: i == _bars.length - 1
                              ? null
                              : AppColors.blue.withValues(alpha: 0.15),
                        ),
                        child: SizedBox(height: 48 * _bars[i]),
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

class _BandSaleCard extends StatelessWidget {
  const _BandSaleCard();

  @override
  Widget build(BuildContext context) {
    return _BandWhiteCard(
      width: 200,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: BooksLineIcon(
                BooksIcon.check,
                size: 16,
                color: AppColors.greenInk,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New sale',
                  style: AppText.h4.copyWith(
                    fontSize: 12.5,
                    color: AppColors.ink1,
                  ),
                ),
                Text(
                  'Solar Kit · MoMo',
                  style: AppText.small.copyWith(color: AppColors.ink3),
                ),
              ],
            ),
          ),
          Text(
            '+12,000',
            style: AppText.mono(
              size: 14,
              w: FontWeight.w800,
              c: AppColors.greenInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _BandStreakCard extends StatelessWidget {
  const _BandStreakCard();

  @override
  Widget build(BuildContext context) {
    return _BandWhiteCard(
      width: 176,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppGrad.streakFlame,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: BooksLineIcon(
                BooksIcon.flame,
                size: 16,
                color: AppColors.ink0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12 days',
                style: AppText.mono(
                  size: 16,
                  w: FontWeight.w800,
                  c: AppColors.ink1,
                ),
              ),
              Text(
                'Sales streak',
                style: AppText.small.copyWith(color: AppColors.ink3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BooksHomeFooter extends StatelessWidget {
  const BooksHomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final gutter = booksHomeGutter(w);
        final linkCols = w <= 1040 ? 2 : 4;

        return Container(
          margin: const EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          padding: EdgeInsets.fromLTRB(gutter, 72, gutter, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.maxW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (w > 1040)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // .foot-grid: 1.6fr for the brand, 1fr for each column.
                        Expanded(
                          flex: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BooksWordmark(logoSize: 30),
                              const SizedBox(height: 16),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                ),
                                child: Text(
                                  'The connected business platform for Africa — point of sale, '
                                  'accounting and an AI bookkeeper, in one place.',
                                  style: AppText.small.copyWith(
                                    fontSize: 13.5,
                                    color: AppColors.ink3,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (final col in _footerColumns)
                          Expanded(flex: 10, child: col),
                      ],
                    )
                  else ...[
                    const BooksWordmark(logoSize: 30),
                    const SizedBox(height: 16),
                    Text(
                      'The connected business platform for Africa — point of sale, '
                      'accounting and an AI bookkeeper, in one place.',
                      style: AppText.small.copyWith(
                        fontSize: 13.5,
                        color: AppColors.ink3,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: linkCols,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 2.8,
                      children: _footerColumns,
                    ),
                  ],
                  // .foot-bottom: margin-top 56, padding-top 24, color ink-4.
                  const SizedBox(height: 56),
                  Divider(color: AppColors.line, height: 1),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        '© 2026 Flipper. Made for Rwandan business.',
                        style: AppText.small.copyWith(color: AppColors.ink4),
                      ),
                      const Spacer(),
                      for (final (i, link) in [
                        'Privacy',
                        'Terms',
                        'Security',
                        'English',
                      ].indexed) ...[
                        if (i > 0) const SizedBox(width: 22),
                        Text(
                          link,
                          style: AppText.small.copyWith(color: AppColors.ink4),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});

  final String title;
  final List<String> links;

  static const columns = [
    _FooterColumn(
      title: 'PLATFORM',
      links: ['Flipper POS', 'Flipper Books', 'Flipper Flow', 'Pricing'],
    ),
    _FooterColumn(
      title: 'BOOKS',
      links: [
        'Financial statements',
        'Bank reconciliation',
        'Tax & VAT',
        'Multi-branch',
      ],
    ),
    _FooterColumn(
      title: 'COMPANY',
      links: ['About', 'Blog', 'Careers', 'Contact'],
    ),
    _FooterColumn(
      title: 'SUPPORT',
      links: ['Help center', 'Download', 'Status', 'Community'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // .foot-col h5: 12px, letter-spacing .08em (= 0.96), ink-3.
          title,
          style: AppText.eyebrow.copyWith(
            fontSize: 12,
            letterSpacing: 0.96,
            color: AppColors.ink3,
          ),
        ),
        const SizedBox(height: 16),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Text(
              // .foot-col a: 14px, ink-2.
              link,
              style: AppText.small.copyWith(fontSize: 14, color: AppColors.ink2),
            ),
          ),
      ],
    );
  }
}

const _footerColumns = _FooterColumn.columns;

AppLocalizations booksHomeL10n(BuildContext context) =>
    AppLocalizations.of(context) ?? AppLocalizationsEn();

void booksHomeGoSignup(BuildContext context) => context.go('/signup');

void booksHomeGoLogin(BuildContext context) => context.go('/login');
