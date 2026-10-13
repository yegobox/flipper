import 'package:flipper_web/features/apps/atlas_downloads.dart';
import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// `/apps`: everything Flipper OS runs, and Atlas — the launcher that
/// installs it on a computer and keeps it up to date. After
/// getartcraft.com/apps, in the landing page's look.
class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: BooksHomeTheme.of(Theme.of(context).brightness),
      child: AppsPage(
        onOpen: (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
      ),
    );
  }
}

class AppsPage extends StatefulWidget {
  const AppsPage({super.key, required this.onOpen, this.platform});

  /// Opens a download or store link (outside the page).
  final ValueChanged<Uri> onOpen;

  /// The computer to offer Atlas for; the browser's own by default.
  final TargetPlatform? platform;

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavTap(String id) {
    if (id == 'Apps') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: AppCurves.reveal,
      );
    } else {
      context.go('/');
    }
  }

  void _open(String url) => widget.onOpen(Uri.parse(url));

  @override
  Widget build(BuildContext context) {
    final atlas = AtlasPlatform.of(widget.platform ?? defaultTargetPlatform);
    return Material(
      color: AppColors.bg,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              forceMaterialTransparency: true,
              toolbarHeight: booksHomeHeaderHeight,
              automaticallyImplyLeading: false,
              flexibleSpace: BooksHomeHeader(
                active: 'Apps',
                onStartFree: () => booksHomeGoSignup(context),
                onSignIn: () => booksHomeGoLogin(context),
                onNavTap: _onNavTap,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _AppsHero(atlas: atlas, open: _open),
                  _Lineup(atlas: atlas, open: _open),
                  _WhereItRuns(
                    atlas: atlas,
                    open: _open,
                    onWeb: () => booksHomeGoLogin(context),
                  ),
                  const BooksHomeFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 01: "Seven apps. *One OS.*" beside the Atlas download card.
class _AppsHero extends StatelessWidget {
  const _AppsHero({required this.atlas, required this.open});

  final AtlasPlatform? atlas;
  final ValueChanged<String> open;

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    return ScanlineBackground(
      child: BooksHomeSection(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 960;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditorialHeadline(
                  lead: l10n.webAppsLead,
                  accent: l10n.webAppsAccent,
                  size: booksHomeDisplaySize(
                    MediaQuery.sizeOf(context).width,
                  ).clamp(48.0, 112.0),
                  accentOnNewLine: true,
                ),
                const SizedBox(height: 28),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Text(l10n.webAppsBody, style: AppText.lead),
                ),
              ],
            );
            final card = _AtlasCard(atlas: atlas, open: open);

            return Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionIndex(
                    number: '01',
                    label: l10n.webAppsKicker,
                    trailing: 'Atlas',
                  ),
                  const SizedBox(height: 56),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: copy),
                        const SizedBox(width: 56),
                        Expanded(flex: 4, child: card),
                      ],
                    )
                  else ...[
                    copy,
                    const SizedBox(height: 40),
                    card,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// "Recommended: Atlas" — the one download, for this computer, then the
/// others, then the three steps.
class _AtlasCard extends StatelessWidget {
  const _AtlasCard({required this.atlas, required this.open});

  final AtlasPlatform? atlas;
  final ValueChanged<String> open;

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    final atlas = this.atlas;
    final others = [
      for (final (label, url) in atlasInstallers)
        if (url != atlas?.url) (label, url),
    ];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        border: Border.all(color: AppColors.lineStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const FlipperMark(size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.webAppsRecommended.toUpperCase(),
                      style: AppText.label(c: AppColors.accentInk),
                    ),
                    const SizedBox(height: 2),
                    Text('Atlas', style: AppText.title(26)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.webAppsAtlasPitch, style: AppText.body),
          const SizedBox(height: 24),
          if (atlas != null)
            InkButton(
              label: l10n.webAppsDownloadFor(atlas.label),
              arrow: true,
              onTap: () => open(atlas.url),
            )
          else ...[
            Text(l10n.webAppsOnPhone, style: AppText.body),
            const SizedBox(height: 12),
            RuledGrid(
              columns: 1,
              children: [
                BooksHomeStoreCell(
                  platform: 'Android',
                  label: l10n.webHomeNativePlay,
                  icon: Icons.android_rounded,
                  onTap: () => open(booksHomePlayStoreUrl),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.webAppsAlsoFor.toUpperCase(),
                style: AppText.label(c: AppColors.faint),
              ),
              for (final (label, url) in others)
                BooksHomeTextLink(label: label, onTap: () => open(url)),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: AppColors.line),
          const SizedBox(height: 20),
          for (final (i, step) in [
            l10n.webAppsStep1,
            l10n.webAppsStep2,
            l10n.webAppsStep3,
          ].indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      '0${i + 1}',
                      style: AppText.label(size: 12, c: AppColors.accentInk),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      step,
                      style: AppText.body.copyWith(
                        fontSize: 14.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          BooksHomeTextLink(
            label: l10n.webAppsAllReleases,
            onTap: () => open(AtlasDownloads.releases),
          ),
        ],
      ),
    );
  }
}

/// 02: every app in Flipper OS, numbered, and a last cell that installs
/// them all.
class _Lineup extends StatelessWidget {
  const _Lineup({required this.atlas, required this.open});

  final AtlasPlatform? atlas;
  final ValueChanged<String> open;

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    final apps = [
      (
        'Flipper POS',
        l10n.webAppsPosTitle,
        l10n.webHomeHeroPosAccent,
        l10n.webHomePosBody,
      ),
      (
        'Flipper Books',
        l10n.webAppsBooksTitle,
        l10n.webHomeHeroLine2Accent,
        l10n.webHomeBooksBody,
      ),
      (
        'Flipper Flow',
        'Flow AI',
        l10n.webHomeFlowTagline,
        l10n.webHomeFlowBody,
      ),
      (
        'Flipper Hotel',
        l10n.webAppsHotelTitle,
        l10n.webHomeHeroHotelAccent,
        l10n.webAppsHotelBody,
      ),
      (
        'Flipper Bar',
        l10n.webAppsBarTitle,
        l10n.webHomeHeroBarAccent,
        l10n.webAppsBarBody,
      ),
      (
        'Flipper Kitchen',
        l10n.webAppsKitchenTitle,
        l10n.webHomeHeroKitchenAccent,
        l10n.webAppsKitchenBody,
      ),
      (
        'Flipper HR',
        l10n.webAppsHrTitle,
        l10n.webHomeHeroPayrollAccent,
        l10n.webAppsHrBody,
      ),
    ];

    return BooksHomeSection(
      child: LayoutBuilder(
        builder: (context, constraints) => Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionIndex(
                number: '02',
                label: l10n.webAppsLineupKicker,
                trailing: l10n.webAppsIncluded,
              ),
              const SizedBox(height: 56),
              EditorialHeadline(
                lead: l10n.webAppsLineupLead,
                accent: l10n.webAppsLineupAccent,
                size: booksHomeH2SizeOf(context),
                accentOnNewLine: true,
              ),
              const SizedBox(height: 48),
              RuledGrid(
                columns: booksHomeCols(constraints.maxWidth),
                children: [
                  for (final (i, (tag, title, accent, body)) in apps.indexed)
                    IndexCell(
                      tag: tag,
                      number: '${i + 1}'.padLeft(2, '0'),
                      title: title,
                      subtitle: accent,
                      body: body,
                    ),
                  _GetThemAllCell(atlas: atlas, open: open),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The lineup's last cell: Atlas, which installs every app above.
class _GetThemAllCell extends StatelessWidget {
  const _GetThemAllCell({required this.atlas, required this.open});

  final AtlasPlatform? atlas;
  final ValueChanged<String> open;

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);
    final atlas = this.atlas;
    return PressScale(
      onTap: () => open(atlas?.url ?? AtlasDownloads.releases),
      child: Container(
        decoration: const BoxDecoration(gradient: AppGrad.panel),
        padding: const EdgeInsets.fromLTRB(26, 22, 26, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FlipperMark(size: 22, color: AppGrad.onPanel),
                const Spacer(),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 20,
                  color: AppGrad.onPanel,
                ),
              ],
            ),
            const SizedBox(height: 44),
            Text('Atlas', style: AppText.title(26, c: AppGrad.onPanel)),
            const SizedBox(height: 14),
            Text(
              l10n.webAppsAtlasPitch,
              style: AppText.body.copyWith(
                fontSize: 14.5,
                color: AppGrad.onPanelSoft,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              (atlas == null
                      ? l10n.webAppsAllReleases
                      : l10n.webAppsDownloadFor(atlas.label))
                  .toUpperCase(),
              style: AppText.label(c: AppGrad.onPanel),
            ),
          ],
        ),
      ),
    );
  }
}

/// 03: where Flipper OS runs — the computer launcher, the stores, the web.
class _WhereItRuns extends StatelessWidget {
  const _WhereItRuns({
    required this.atlas,
    required this.open,
    required this.onWeb,
  });

  final AtlasPlatform? atlas;
  final ValueChanged<String> open;
  final VoidCallback onWeb;

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
                SectionIndex(number: '03', label: l10n.webAppsWhereKicker),
                const SizedBox(height: 40),
                RuledGrid(
                  columns: w > 960
                      ? 4
                      : w > 560
                      ? 2
                      : 1,
                  children: [
                    BooksHomeStoreCell(
                      platform: 'Windows · macOS · Linux',
                      label: l10n.webAppsViaAtlas,
                      icon: Icons.desktop_windows_rounded,
                      onTap: () => open(atlas?.url ?? AtlasDownloads.releases),
                    ),
                    BooksHomeStoreCell(
                      platform: 'Android',
                      label: l10n.webHomeNativePlay,
                      icon: Icons.android_rounded,
                      onTap: () => open(booksHomePlayStoreUrl),
                    ),
                    BooksHomeStoreCell(
                      platform: 'Windows',
                      label: l10n.webHomeNativeWindows,
                      icon: Icons.window_rounded,
                      onTap: () => open(booksHomeMicrosoftStoreUrl),
                    ),
                    BooksHomeStoreCell(
                      platform: l10n.webAppsInBrowser,
                      label: l10n.webAppsOpenWeb,
                      icon: Icons.public_rounded,
                      onTap: onWeb,
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
