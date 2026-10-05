import 'dart:ui' as ui;

import 'package:flipper_web/features/home/sections/books_home_hero_mock.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flipper_web/features/home/widgets/books_theme_toggle.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
    final l10n = booksHomeL10n(context);
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
                      const BooksThemeToggle(size: 34),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () => _showMobileMenu(
                          context,
                          onNavTap,
                          onSignIn,
                          onStartFree,
                        ),
                        icon: Icon(Icons.menu_rounded, color: AppColors.ink1),
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
                                  label: booksHomeNavLabel(link, l10n),
                                  onTap: () => onNavTap(link),
                                ),
                              ],
                              const SizedBox(width: 18),
                              const BooksThemeToggle(),
                              const SizedBox(width: 14),
                              NavTextLink(
                                label: l10n.webHomeLogIn,
                                onTap: onSignIn,
                              ),
                              const SizedBox(width: 12),
                              PrimaryButton(
                                label: l10n.webHomeStartFree,
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
    final l10n = booksHomeL10n(context);
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
                  booksHomeNavLabel(link, l10n),
                  style: AppText.body.copyWith(color: AppColors.ink1),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavTap(link);
                },
              ),
            BooksThemeToggleTile(onToggled: () => Navigator.pop(ctx)),
            const SizedBox(height: 12),
            GhostButton(
              label: l10n.webHomeLogIn,
              onTap: () {
                Navigator.pop(ctx);
                onSignIn();
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: l10n.webHomeStartFree,
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
        color: AppColors.wash(0.025),
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
        final l10n = booksHomeL10n(context);
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
                                l10n.webHomeHeroLine1,
                                style: AppText.h1(h1),
                                textAlign: TextAlign.center,
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${l10n.webHomeHeroLine2Lead} ',
                                    style: AppText.h1(h1),
                                  ),
                                  GradientText(
                                    l10n.webHomeHeroLine2Accent,
                                    style: AppText.h1(h1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          SizedBox(
                            width: AppSpace.heroSubMaxW.clamp(
                              0,
                              w - gutter * 2,
                            ),
                            child: Text(
                              l10n.webHomeHeroBody,
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
                                  label: l10n.webHomeStartFree,
                                  onTap: onStartFree,
                                  showArrow: true,
                                ),
                              ),
                              IntrinsicWidth(
                                child: GhostButton(
                                  label: l10n.webHomeSeeHowItWorks,
                                  onTap: onSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              HeroCheckItem(l10n.webHomeCheckEbmReady),
                              HeroCheckItem(l10n.webHomeCheckOffline),
                              HeroCheckItem(l10n.webHomeCheckRwf),
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
    final l10n = booksHomeL10n(context);
    return BooksHomeSection(
      padding: const EdgeInsets.fromLTRB(28, 40, 28, 8),
      child: Reveal(
        child: Column(
          children: [
            Text(
              l10n.webHomeTrustTagline,
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
              children: [
                TrustChip(
                  icon: BooksIcon.shield,
                  bold: 'EBM 2.1',
                  label: l10n.webHomeTrustTaxIntegration,
                ),
                TrustChip(
                  icon: BooksIcon.trendUp,
                  bold: '12,400+',
                  label: l10n.webHomeTrustBusinesses,
                ),
                TrustChip(
                  icon: BooksIcon.card,
                  label: l10n.webHomeTrustMomoBank,
                ),
                TrustChip(
                  icon: BooksIcon.clock,
                  label: l10n.webHomeTrustRealtimeLedger,
                ),
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
          final l10n = booksHomeL10n(context);

          return Column(
            children: [
              Reveal(
                child: SectionHead(
                  eyebrow: l10n.webHomeSuiteEyebrow,
                  title: l10n.webHomeSuiteTitle,
                  body: l10n.webHomeSuiteBody,
                ),
              ),
              const SizedBox(height: 56),
              if (stacked)
                Column(
                  children: [
                    Reveal(child: _SuiteCard.pos(l10n)),
                    const _Connector(vertical: true),
                    Reveal(
                      delay: const Duration(milliseconds: 80),
                      child: _SuiteCard.books(l10n),
                    ),
                    const _Connector(vertical: true),
                    Reveal(
                      delay: const Duration(milliseconds: 160),
                      child: _SuiteCard.flow(l10n),
                    ),
                  ],
                )
              else
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Reveal(child: _SuiteCard.pos(l10n))),
                      const _Connector(),
                      Expanded(
                        child: Reveal(
                          delay: const Duration(milliseconds: 80),
                          child: _SuiteCard.books(l10n),
                        ),
                      ),
                      const _Connector(),
                      Expanded(
                        child: Reveal(
                          delay: const Duration(milliseconds: 160),
                          child: _SuiteCard.flow(l10n),
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
                    color: AppColors.wash(0.015),
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
                                  children: [
                                    TextSpan(
                                      text: '${l10n.webHomeLoopSellOnPos} ',
                                    ),
                                    TextSpan(
                                      text: l10n.webHomeLoopPostsToBooks,
                                      style: TextStyle(
                                        color: AppColors.ink0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: ' → '),
                                    TextSpan(
                                      text: l10n.webHomeLoopFlowReconciles,
                                      style: TextStyle(
                                        color: AppColors.ink0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: ' ${l10n.webHomeLoopTail}'),
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

  factory _SuiteCard.pos(FlipperAppLocalizations l10n) => _SuiteCard(
    productLabel: 'FLIPPER POS',
    role: l10n.webHomePosRole,
    tagline: l10n.webHomePosTagline,
    body: l10n.webHomePosBody,
    icon: BooksIcon.cart,
    gradient: AppGrad.suitePosIcon,
    labelColor: AppColors.ink3,
    glowColor: AppColors.blue,
  );

  factory _SuiteCard.books(FlipperAppLocalizations l10n) => _SuiteCard(
    productLabel: 'FLIPPER BOOKS',
    role: l10n.webHomeBooksRole,
    tagline: l10n.webHomeBooksTagline,
    body: l10n.webHomeBooksBody,
    icon: BooksIcon.book,
    gradient: AppGrad.suiteBooksIcon,
    labelColor: AppColors.cyan,
    glowColor: AppColors.cyan,
    highlighted: true,
  );

  factory _SuiteCard.flow(FlipperAppLocalizations l10n) => _SuiteCard(
    productLabel: 'FLIPPER FLOW',
    role: l10n.webHomeFlowRole,
    tagline: l10n.webHomeFlowTagline,
    body: l10n.webHomeFlowBody,
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
            AppColors.glow(AppColors.blue, 0.04),
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
    final l10n = booksHomeL10n(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EyebrowLabel(l10n.webHomeMeetFlow),
        const SizedBox(height: 16),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${l10n.webHomeFlowHeadlineLead} ',
              style: AppText.h2(booksHomeH2SizeOf(context)),
            ),
            GradientText(
              l10n.webHomeFlowHeadlineAccent,
              style: AppText.h2(booksHomeH2SizeOf(context)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            l10n.webHomeFlowLead,
            style: AppText.lead.copyWith(fontSize: 17),
          ),
        ),
        const SizedBox(height: 36),
        for (final item in [
          (
            BooksIcon.listLines,
            l10n.webHomeFlowAutoCat,
            l10n.webHomeFlowAutoCatBody,
          ),
          (
            BooksIcon.refreshLoop,
            l10n.webHomeFlowRecon,
            l10n.webHomeFlowReconBody,
          ),
          (BooksIcon.shieldCheck, l10n.webHomeFlowTax, l10n.webHomeFlowTaxBody),
          (
            BooksIcon.alert,
            l10n.webHomeFlowAnomaly,
            l10n.webHomeFlowAnomalyBody,
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
                    color: AppColors.wash(0.03),
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
          label: l10n.webHomeExploreFlow,
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
    final l10n = booksHomeL10n(context);
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
                                    l10n.webHomeWatchingLedger,
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
              _bubble(l10n.webHomeChatUser1, mine: true),
              const SizedBox(height: 12),
              _bubble(l10n.webHomeChatBot1, mine: false, child: _jeEntry(l10n)),
              const SizedBox(height: 12),
              _bubble(l10n.webHomeChatUser2, mine: true),
              const SizedBox(height: 12),
              _bubble(l10n.webHomeChatBot2, mine: false),
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
              : AppColors.wash(0.04),
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

  Widget _jeEntry(FlipperAppLocalizations l10n) {
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
            color: AppColors.wash(0.03),
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
                BooksLineIcon(
                  BooksIcon.check,
                  size: 13,
                  color: AppColors.green,
                ),
                const SizedBox(width: 5),
                Text(
                  l10n.booksBalanced,
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

  static List<(String, String, BooksIcon)> _itemsFor(
    FlipperAppLocalizations l10n,
  ) => [
    (
      l10n.booksFinancialStatements,
      l10n.webHomeCapStatementsBody,
      BooksIcon.chartLine,
    ),
    (
      l10n.booksBankReconciliation,
      l10n.webHomeCapBankRecBody,
      BooksIcon.bankLines,
    ),
    (l10n.webHomeCapArAp, l10n.webHomeCapArApBody, BooksIcon.dollar),
    (l10n.booksTaxVat, l10n.webHomeCapTaxBody, BooksIcon.shieldCheck),
    (l10n.booksChartOfAccounts, l10n.webHomeCapCoaBody, BooksIcon.doc),
    (
      l10n.webHomeCapMultiBranch,
      l10n.webHomeCapMultiBranchBody,
      BooksIcon.building,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    final items = _itemsFor(l10n);
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = booksHomeCols(constraints.maxWidth);

          return Reveal(
            child: Column(
              children: [
                SectionHead(
                  eyebrow: l10n.webHomeInsideBooks,
                  title: l10n.webHomeCapTitle,
                  body: l10n.webHomeCapBody,
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
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
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
  final FlipperAppLocalizations l10n;

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
                  eyebrow: l10n.webHomePricingEyebrow,
                  title: l10n.webPricingTitle,
                  body: l10n.webHomePricingBody,
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
                        title: l10n.webPlanMobile,
                        price: '5,000',
                        period: l10n.webCurrencyPerMonth,
                        features: [
                          l10n.webFeatureMobileAppAccess,
                          l10n.webFeatureBasicBusinessTools,
                          l10n.webFeatureDataEncryption,
                          l10n.webFeatureSingleDevice,
                          l10n.webFeatureTaxReportingAddon,
                        ],
                        popular: false,
                        onStart: onStartFree,
                        cta: l10n.webGetStarted,
                      ),
                    ),
                    SizedBox(width: oneCol ? 0 : 18, height: oneCol ? 18 : 0),
                    Flexible(
                      child: Transform.translate(
                        offset: oneCol ? Offset.zero : const Offset(0, -8),
                        child: _PricingCard(
                          title: l10n.webPlanMobileDesktop,
                          price: '120,000',
                          period: l10n.webCurrencyPerMonth,
                          features: [
                            l10n.webFeatureMobileDesktopAppAccess,
                            l10n.webFeatureAdvancedBusinessTools,
                            l10n.webFeatureMilitaryGradeEncryption,
                            l10n.webFeaturePrioritySupport,
                            l10n.webFeatureMultipleDevices,
                            l10n.webFeatureAdvancedAnalytics,
                            l10n.webFeatureTaxReportingAddon,
                          ],
                          popular: true,
                          onStart: onStartFree,
                          cta: l10n.webGetStarted,
                        ),
                      ),
                    ),
                    SizedBox(width: oneCol ? 0 : 18, height: oneCol ? 18 : 0),
                    Flexible(
                      child: _PricingCard(
                        title: l10n.webPlanEnterprise,
                        price: '1.5M+',
                        period: l10n.webCurrencyPerMonth,
                        features: [
                          l10n.webFeatureFullPlatformAccess,
                          l10n.webFeatureEnterpriseGradeSecurity,
                          l10n.webFeature247DedicatedSupport,
                          l10n.webFeatureUnlimitedUsersBranches,
                          l10n.webFeatureCustomIntegrations,
                          l10n.webFeaturePremiumTaxConsulting,
                        ],
                        popular: false,
                        onStart: onStartFree,
                        cta: l10n.webHomeContactSales,
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
                  AppColors.wash(0.012),
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
                          children: [
                            _bandCopy(context, onStartFree, onSignIn, bandH2),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _bandCopy(
                                context,
                                onStartFree,
                                onSignIn,
                                bandH2,
                              ),
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
    BuildContext context,
    VoidCallback onStartFree,
    VoidCallback onSignIn,
    double h2Size,
  ) {
    final l10n = booksHomeL10n(context);
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
            l10n.webHomeBandTitle,
            style: AppText.h2(h2Size).copyWith(color: AppColors.onBrand),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            l10n.webHomeBandBody,
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
                label: l10n.webHomeStartFree,
                onTap: onStartFree,
                showArrow: true,
              ),
            ),
            IntrinsicWidth(
              child: OutlineWhiteButton(
                label: l10n.webHomeTalkToSales,
                onTap: onSignIn,
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 36,
          runSpacing: 12,
          children: [
            _BandStat('12,400+', l10n.webHomeTrustBusinesses),
            _BandStat('RWF 1.2B', l10n.webHomeStatProcessedMonthly),
            _BandStat('99.9%', l10n.webHomeStatUptime),
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
          style: AppText.mono(
            size: 26,
            w: FontWeight.w700,
            c: AppColors.onBrand,
          ),
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
        color: AppColors.cardOnBrand,
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
                  booksHomeL10n(context).webHomeRevenueThisWeek,
                  style: AppText.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteCardMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '18%',
                style: AppText.mono(
                  size: 11,
                  w: FontWeight.w700,
                  c: AppColors.whiteCardGain,
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
              c: AppColors.whiteCardInk,
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
                              : AppColors.whiteCardBar,
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
              color: AppColors.saleCheckBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: BooksLineIcon(
                BooksIcon.check,
                size: 16,
                color: AppColors.whiteCardGain,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booksHomeL10n(context).webHomeNewSale,
                  style: AppText.h4.copyWith(
                    fontSize: 12.5,
                    color: AppColors.whiteCardInk,
                  ),
                ),
                Text(
                  'Solar Kit · MoMo',
                  style: AppText.small.copyWith(
                    color: AppColors.whiteCardMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+12,000',
            style: AppText.mono(
              size: 14,
              w: FontWeight.w800,
              c: AppColors.whiteCardGain,
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
                color: AppColors.onBrand,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booksHomeL10n(context).webHomeDays(12),
                style: AppText.mono(
                  size: 16,
                  w: FontWeight.w800,
                  c: AppColors.whiteCardInk,
                ),
              ),
              Text(
                booksHomeL10n(context).webHomeSalesStreak,
                style: AppText.small.copyWith(color: AppColors.whiteCardMuted),
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
                                  booksHomeL10n(context).webHomeFooterTagline,
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
                        for (final col in _footerColumnsFor(
                          booksHomeL10n(context),
                        ))
                          Expanded(flex: 10, child: col),
                      ],
                    )
                  else ...[
                    const BooksWordmark(logoSize: 30),
                    const SizedBox(height: 16),
                    Text(
                      booksHomeL10n(context).webHomeFooterTagline,
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
                      children: _footerColumnsFor(booksHomeL10n(context)),
                    ),
                  ],
                  // .foot-bottom: margin-top 56, padding-top 24, color ink-4.
                  const SizedBox(height: 56),
                  Divider(color: AppColors.line, height: 1),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        booksHomeL10n(context).webHomeCopyright,
                        style: AppText.small.copyWith(color: AppColors.ink4),
                      ),
                      const Spacer(),
                      for (final (i, link) in [
                        booksHomeL10n(context).webHomePrivacy,
                        booksHomeL10n(context).webHomeTerms,
                        booksHomeL10n(context).security,
                        _currentLanguageName(booksHomeL10n(context)),
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

  static List<_FooterColumn> columnsFor(FlipperAppLocalizations l10n) => [
    _FooterColumn(
      title: l10n.webHomeFooterPlatform,
      links: ['Flipper POS', 'Flipper Books', 'Flipper Flow', l10n.pricing],
    ),
    _FooterColumn(
      title: 'BOOKS',
      links: [
        l10n.booksFinancialStatements,
        l10n.booksBankReconciliation,
        l10n.booksTaxVat,
        l10n.webHomeCapMultiBranch,
      ],
    ),
    _FooterColumn(
      title: l10n.webHomeFooterCompany,
      links: [
        l10n.webHomeAbout,
        l10n.webHomeBlog,
        l10n.webHomeCareers,
        l10n.webHomeContact,
      ],
    ),
    _FooterColumn(
      title: l10n.webHomeFooterSupport,
      links: [
        l10n.webHomeHelpCenter,
        l10n.webHomeDownload,
        l10n.webHomeStatus,
        l10n.webHomeCommunity,
      ],
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
              style: AppText.small.copyWith(
                fontSize: 14,
                color: AppColors.ink2,
              ),
            ),
          ),
      ],
    );
  }
}

List<_FooterColumn> _footerColumnsFor(FlipperAppLocalizations l10n) =>
    _FooterColumn.columnsFor(l10n);

/// Name of the language the page is currently rendered in.
String _currentLanguageName(FlipperAppLocalizations l10n) =>
    switch (l10n.localeName.split(RegExp('[_-]')).first) {
      'fr' => l10n.french,
      'rw' => l10n.kinyarwanda,
      'sw' => l10n.swahili,
      _ => l10n.english,
    };

/// Display text for a landing-page nav id ([BooksHomeHeader] link values
/// stay English because the page routes on them).
String booksHomeNavLabel(String id, FlipperAppLocalizations l10n) =>
    switch (id) {
      'Platform' => l10n.webHomeNavPlatform,
      'Features' => l10n.webHomeNavFeatures,
      'Pricing' => l10n.pricing,
      _ => id,
    };

void booksHomeGoSignup(BuildContext context) => context.go('/signup');

void booksHomeGoLogin(BuildContext context) => context.go('/login');
