import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flipper_web/features/home/widgets/books_theme_toggle.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _navLinks = ['Platform', 'Flow AI', 'Features', 'Pricing'];

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
                      const BooksWordmark(),
                      const Spacer(),
                      const BooksThemeToggle(),
                      const SizedBox(width: 8),
                      _MenuButton(
                        onTap: () => _showMobileMenu(
                          context,
                          onNavTap,
                          onSignIn,
                          onStartFree,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const BooksWordmark(),
                      const SizedBox(width: 48),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              for (final (i, link) in _navLinks.indexed) ...[
                                if (i > 0) const SizedBox(width: 30),
                                NavTextLink(
                                  label: booksHomeNavLabel(link, l10n),
                                  onTap: () => onNavTap(link),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const BooksThemeToggle(),
                      const SizedBox(width: 10),
                      LineButton(
                        label: l10n.webHomeLogIn,
                        onTap: onSignIn,
                        height: AppText.buttonHeightNav,
                      ),
                      const SizedBox(width: 8),
                      InkButton(
                        label: l10n.webHomeStartFree,
                        onTap: onStartFree,
                        height: AppText.buttonHeightNav,
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
      backgroundColor: AppColors.bgRaised,
      shape: const RoundedRectangleBorder(),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final link in _navLinks)
              ListTile(
                contentPadding: EdgeInsets.zero,
                shape: Border(bottom: BorderSide(color: AppColors.line)),
                title: Text(
                  booksHomeNavLabel(link, l10n).toUpperCase(),
                  style: AppText.label(size: 12.5, c: AppColors.ink),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onNavTap(link);
                },
              ),
            BooksThemeToggleTile(onToggled: () => Navigator.pop(ctx)),
            const SizedBox(height: 16),
            LineButton(
              label: l10n.webHomeLogIn,
              onTap: () {
                Navigator.pop(ctx);
                onSignIn();
              },
            ),
            const SizedBox(height: 10),
            InkButton(
              label: l10n.webHomeStartFree,
              arrow: true,
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

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        width: AppText.buttonHeightNav,
        height: AppText.buttonHeightNav,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lineStrong),
        ),
        child: Icon(Icons.menu_rounded, size: 18, color: AppColors.ink),
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
        final gutter = booksHomeGutter(w);
        final wide = w > 960;

        final buttons = [
          InkButton(
            label: l10n.webHomeStartFree,
            onTap: onStartFree,
            arrow: true,
          ),
          LineButton(label: l10n.webHomeSeeHowItWorks, onTap: onSecondary),
        ];
        final body = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(l10n.webHomeHeroBody, style: AppText.lead),
        );

        return ScanlineBackground(
          child: Stack(
            children: [
              // The product name, poster-size and barely there, behind the
              // headline.
              Positioned(
                top: 18,
                left: gutter,
                right: gutter,
                child: IgnorePointer(
                  child: GiantWord(
                    'FLIPPER',
                    color: AppColors.ink.withValues(alpha: 0.045),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, wide ? 96 : 64, gutter, 0),
                child: Center(
                  // Same text column as [BooksHomeSection], which insets the
                  // gutter inside the max width rather than outside it.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppSpace.maxW - gutter * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Reveal(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.webHomePoweredBy} Flow AI'
                                    .toUpperCase(),
                                style: AppText.label(),
                              ),
                              const SizedBox(height: 28),
                              EditorialHeadline(
                                lead:
                                    '${l10n.webHomeHeroLine1}\n'
                                    '${l10n.webHomeHeroLine2Lead}',
                                accent: l10n.webHomeHeroLine2Accent,
                                size: booksHomeDisplaySize(w),
                              ),
                              const SizedBox(height: 44),
                              if (wide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: body,
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    buttons[0],
                                    const SizedBox(width: 10),
                                    buttons[1],
                                  ],
                                )
                              else ...[
                                body,
                                const SizedBox(height: 28),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: buttons,
                                ),
                              ],
                              const SizedBox(height: 36),
                              Wrap(
                                spacing: 22,
                                runSpacing: 10,
                                children: [
                                  for (final item in [
                                    l10n.webHomeCheckEbmReady,
                                    l10n.webHomeCheckOffline,
                                    l10n.webHomeCheckRwf,
                                  ])
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item.toUpperCase(),
                                          style: AppText.label(
                                            c: AppColors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: wide ? 140 : 88),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The ticker under the hero: what the product covers, scrolling past.
class BooksHomeMarquee extends StatelessWidget {
  const BooksHomeMarquee({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return MarqueeTicker(
      items: [
        'EBM 2.1 ${l10n.webHomeTrustTaxIntegration}',
        '12,400+ ${l10n.webHomeTrustBusinesses}',
        l10n.webHomeTrustMomoBank,
        l10n.webHomeTrustRealtimeLedger,
        l10n.webHomeCheckOffline,
        l10n.booksFinancialStatements,
        l10n.booksBankReconciliation,
        l10n.webHomeCapArAp,
        l10n.booksTaxVat,
        l10n.webHomeCapMultiBranch,
        'Flow AI',
      ],
    );
  }
}

/// A section's headline with its body: side by side on wide screens, the body
/// sitting on the headline's baseline; stacked otherwise.
class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.lead,
    required this.accent,
    required this.body,
  });

  final String lead;
  final String accent;
  final String body;

  @override
  Widget build(BuildContext context) {
    final headline = EditorialHeadline(
      lead: lead,
      accent: accent,
      size: booksHomeH2SizeOf(context),
      accentOnNewLine: true,
    );
    final text = Text(body, style: AppText.lead.copyWith(fontSize: 17));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 960) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headline,
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: text,
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(flex: 2, child: headline),
            const SizedBox(width: 56),
            Expanded(child: text),
          ],
        );
      },
    );
  }
}

class BooksHomeSuiteSection extends StatelessWidget {
  const BooksHomeSuiteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth > 860 ? 3 : 1;

          return Reveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionIndex(
                  number: '01',
                  label: l10n.webHomeSuiteEyebrow,
                  trailing: 'POS · Books · Flow',
                ),
                const SizedBox(height: 56),
                _SectionIntro(
                  lead: l10n.webHomeSuiteTitleLead,
                  accent: l10n.webHomeSuiteTitleAccent,
                  body: l10n.webHomeSuiteBody,
                ),
                const SizedBox(height: 56),
                RuledGrid(
                  columns: cols,
                  children: [
                    IndexCell(
                      tag: 'Flipper POS',
                      number: '01',
                      title: l10n.webHomePosRole,
                      subtitle: l10n.webHomePosTagline,
                      body: l10n.webHomePosBody,
                    ),
                    IndexCell(
                      tag: 'Flipper Books',
                      number: '02',
                      title: l10n.webHomeBooksRole,
                      subtitle: l10n.webHomeBooksTagline,
                      body: l10n.webHomeBooksBody,
                    ),
                    IndexCell(
                      tag: 'Flipper Flow',
                      number: '03',
                      title: l10n.webHomeFlowRole,
                      subtitle: l10n.webHomeFlowTagline,
                      body: l10n.webHomeFlowBody,
                    ),
                  ],
                ),
                // The loop closes the grid as its last, full-width row.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.lineStrong),
                      right: BorderSide(color: AppColors.lineStrong),
                      bottom: BorderSide(color: AppColors.lineStrong),
                    ),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      Text(
                        '↻',
                        style: AppText.label(size: 14, c: AppColors.accent),
                      ),
                      Text(
                        '${l10n.webHomeLoopSellOnPos} '
                                '${l10n.webHomeLoopPostsToBooks} → '
                                '${l10n.webHomeLoopFlowReconciles}'
                            .toUpperCase(),
                        style: AppText.label(c: AppColors.ink),
                      ),
                      Text(
                        l10n.webHomeLoopTail,
                        style: AppText.body.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BooksHomeFlowSection extends StatelessWidget {
  const BooksHomeFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth <= 1040;

          return Reveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionIndex(
                  number: '02',
                  label: l10n.webHomeMeetFlow,
                  trailing: l10n.webHomeWatchingLedger,
                ),
                const SizedBox(height: 56),
                if (stacked) ...[
                  _flowCopy(context),
                  const SizedBox(height: 48),
                  const _FlowChatPanel(),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _flowCopy(context)),
                      const SizedBox(width: 64),
                      const Expanded(child: _FlowChatPanel()),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _flowCopy(BuildContext context) {
    final l10n = booksHomeL10n(context);
    final items = [
      (l10n.webHomeFlowAutoCat, l10n.webHomeFlowAutoCatBody),
      (l10n.webHomeFlowRecon, l10n.webHomeFlowReconBody),
      (l10n.webHomeFlowTax, l10n.webHomeFlowTaxBody),
      (l10n.webHomeFlowAnomaly, l10n.webHomeFlowAnomalyBody),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorialHeadline(
          lead: l10n.webHomeFlowHeadlineLead,
          accent: l10n.webHomeFlowHeadlineAccent,
          size: booksHomeH2SizeOf(context),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            l10n.webHomeFlowLead,
            style: AppText.lead.copyWith(fontSize: 17),
          ),
        ),
        const SizedBox(height: 40),
        for (final (i, item) in items.indexed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.line),
                bottom: i == items.length - 1
                    ? BorderSide(color: AppColors.line)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    String.fromCharCode(0x41 + i),
                    style: AppText.label(size: 12, c: AppColors.accentInk),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1, style: AppText.title(19)),
                      const SizedBox(height: 6),
                      Text(
                        item.$2,
                        style: AppText.body.copyWith(fontSize: 14.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32),
        LineButton(
          label: l10n.webHomeExploreFlow,
          onTap: () {},
          height: 44,
          arrow: true,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        border: Border.all(color: AppColors.lineStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  color: AppColors.invertBg,
                  child: Center(
                    child: BooksLineIcon(
                      BooksIcon.flow,
                      size: 17,
                      color: AppColors.invertFg,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flow AI', style: AppText.title(15)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(width: 6, height: 6, color: AppColors.gain),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.webHomeWatchingLedger.toUpperCase(),
                              style: AppText.label(size: 10, c: AppColors.gain),
                              overflow: TextOverflow.ellipsis,
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
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _bubble(l10n.webHomeChatUser1, mine: true),
                const SizedBox(height: 12),
                _bubble(
                  l10n.webHomeChatBot1,
                  mine: false,
                  child: _jeEntry(l10n),
                ),
                const SizedBox(height: 12),
                _bubble(l10n.webHomeChatUser2, mine: true),
                const SizedBox(height: 12),
                _bubble(l10n.webHomeChatBot2, mine: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(String text, {required bool mine, Widget? child}) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: mine ? 340 : 440),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: mine ? AppColors.invertBg : AppColors.bg,
          border: mine ? null : Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppText.body.copyWith(
                fontSize: 13.5,
                height: 1.5,
                color: mine ? AppColors.invertFg : AppColors.ink,
              ),
            ),
            if (child != null) ...[const SizedBox(height: 10), child],
          ],
        ),
      ),
    );
  }

  Widget _jeEntry(FlipperAppLocalizations l10n) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: AppColors.line)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            color: AppColors.bgSunken,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'JE-1048 · 31 MAY 2026',
                    style: AppText.mono(size: 11.5, c: AppColors.accentInk),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                BooksLineIcon(BooksIcon.check, size: 13, color: AppColors.gain),
                const SizedBox(width: 5),
                Text(
                  l10n.booksBalanced.toUpperCase(),
                  style: AppText.label(size: 10, c: AppColors.gain),
                ),
              ],
            ),
          ),
          _jeLine('1020', 'MoMo — MTN', '12,000'),
          _jeLine('4010', 'Sales Revenue', '12,000'),
        ],
      ),
    );
  }

  Widget _jeLine(String code, String acct, String amt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Text(code, style: AppText.mono(size: 12, c: AppColors.faint)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              acct,
              style: AppText.small.copyWith(color: AppColors.muted),
            ),
          ),
          Text(amt, style: AppText.mono(size: 12)),
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
          return Reveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionIndex(
                  number: '03',
                  label: l10n.webHomeInsideBooks,
                  trailing: l10n.webHomeNavFeatures,
                ),
                const SizedBox(height: 56),
                _SectionIntro(
                  lead: l10n.webHomeCapTitleLead,
                  accent: l10n.webHomeCapTitleAccent,
                  body: l10n.webHomeCapBody,
                ),
                const SizedBox(height: 56),
                RuledGrid(
                  columns: booksHomeCols(constraints.maxWidth),
                  children: [
                    for (final (i, item) in items.indexed)
                      IndexCell(
                        icon: item.$3,
                        number: '${i + 1}'.padLeft(2, '0'),
                        title: item.$1,
                        body: item.$2,
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
          final oneCol = constraints.maxWidth <= 860;

          return Reveal(
            child: Column(
              key: sectionKey,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionIndex(
                  number: '04',
                  label: l10n.webHomePricingEyebrow,
                  trailing: 'RWF',
                ),
                const SizedBox(height: 56),
                _SectionIntro(
                  lead: l10n.webHomePricingTitleLead,
                  accent: l10n.webHomePricingTitleAccent,
                  body: l10n.webHomePricingBody,
                ),
                const SizedBox(height: 56),
                RuledGrid(
                  columns: oneCol ? 1 : 3,
                  children: [
                    _PricingColumn(
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
                    _PricingColumn(
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
                    _PricingColumn(
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

class _PricingColumn extends StatelessWidget {
  const _PricingColumn({
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

  /// The popular plan is set as an inverted block.
  final bool popular;
  final VoidCallback onStart;
  final String cta;

  @override
  Widget build(BuildContext context) {
    final fg = popular ? AppColors.invertFg : AppColors.ink;
    final soft = popular
        ? AppColors.invertFg.withValues(alpha: 0.68)
        : AppColors.muted;

    return Container(
      color: popular ? AppColors.invertBg : null,
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title.toUpperCase(), style: AppText.label(c: fg)),
              ),
              if (popular) const MostPopularTag(),
            ],
          ),
          const SizedBox(height: 40),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              price,
              style: AppText.display(
                64,
                c: fg,
              ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
          const SizedBox(height: 8),
          Text(period, style: AppText.small.copyWith(color: soft)),
          const SizedBox(height: 26),
          Container(
            height: 1,
            color: popular
                ? AppColors.invertFg.withValues(alpha: 0.2)
                : AppColors.line,
          ),
          const SizedBox(height: 20),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BooksLineIcon(
                    BooksIcon.check,
                    size: 15,
                    color: feature.startsWith('+')
                        ? soft
                        : popular
                        ? AppColors.invertFg
                        : AppColors.accentInk,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppText.body.copyWith(
                        fontSize: 14,
                        height: 1.4,
                        color: feature.startsWith('+') ? soft : fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          const SizedBox(height: 24),
          if (popular)
            InkButton(label: cta, onTap: onStart, arrow: true, onInverse: true)
          else
            LineButton(label: cta, onTap: onStart),
        ],
      ),
    );
  }
}

/// The closing call to action: a poster-size "Start *counting.*" and the
/// numbers under it.
class BooksHomeCta extends StatelessWidget {
  const BooksHomeCta({
    super.key,
    required this.onStartFree,
    required this.onTalkToSales,
  });

  final VoidCallback onStartFree;
  final VoidCallback onTalkToSales;

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Reveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionIndex(number: '05', label: l10n.webHomeCtaKicker),
                const SizedBox(height: 88),
                EditorialHeadline(
                  lead: l10n.webHomeCtaLead,
                  accent: l10n.webHomeCtaAccent,
                  size: booksHomeDisplaySize(MediaQuery.sizeOf(context).width),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      l10n.webHomeBandBody,
                      style: AppText.lead,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    InkButton(
                      label: l10n.webHomeStartFree,
                      onTap: onStartFree,
                      arrow: true,
                    ),
                    LineButton(
                      label: l10n.webHomeTalkToSales,
                      onTap: onTalkToSales,
                    ),
                  ],
                ),
                const SizedBox(height: 88),
                RuledGrid(
                  columns: w > 560 ? 3 : 1,
                  children: [
                    _Stat('12,400+', l10n.webHomeTrustBusinesses),
                    _Stat('RWF 1.2B', l10n.webHomeStatProcessedMonthly),
                    _Stat('99.9%', l10n.webHomeStatUptime),
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

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppText.display(48)),
          ),
          const SizedBox(height: 10),
          Text(label.toUpperCase(), style: AppText.label()),
        ],
      ),
    );
  }
}

class BooksHomeFooter extends StatelessWidget {
  const BooksHomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final gutter = booksHomeGutter(w);
        final wide = w > 1040;
        final columns = _FooterColumn.columnsFor(l10n);
        final brand = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BooksWordmark(),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                l10n.webHomeFooterTagline,
                style: AppText.small.copyWith(
                  fontSize: 13.5,
                  color: AppColors.muted,
                  height: 1.6,
                ),
              ),
            ),
          ],
        );

        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.lineStrong)),
          ),
          padding: EdgeInsets.fromLTRB(gutter, 64, gutter, 0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpace.maxW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 16, child: brand),
                        for (final col in columns)
                          Expanded(flex: 10, child: col),
                      ],
                    )
                  else ...[
                    brand,
                    const SizedBox(height: 36),
                    LayoutBuilder(
                      builder: (context, inner) => Wrap(
                        spacing: 24,
                        runSpacing: 28,
                        children: [
                          for (final col in columns)
                            SizedBox(
                              width: (inner.maxWidth - 24) / 2,
                              child: col,
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 56),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.line)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 22,
                      runSpacing: 10,
                      children: [
                        Text(
                          l10n.webHomeCopyright.toUpperCase(),
                          style: AppText.label(size: 10.5, c: AppColors.faint),
                        ),
                        Wrap(
                          spacing: 22,
                          children: [
                            for (final link in [
                              l10n.webHomePrivacy,
                              l10n.webHomeTerms,
                              l10n.security,
                              _currentLanguageName(l10n),
                            ])
                              Text(
                                link.toUpperCase(),
                                style: AppText.label(
                                  size: 10.5,
                                  c: AppColors.faint,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  IgnorePointer(
                    child: GiantWord('FLIPPER BOOKS', color: AppColors.ink),
                  ),
                  SizedBox(height: gutter),
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
        Text(title.toUpperCase(), style: AppText.label(c: AppColors.faint)),
        const SizedBox(height: 16),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Text(
              link,
              style: AppText.small.copyWith(
                fontSize: 14,
                color: AppColors.muted,
              ),
            ),
          ),
      ],
    );
  }
}

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
