import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/flo_models.dart';
import '../../theme/flo_theme.dart';
import 'flo_html_text.dart';
import 'flo_icons.dart';
import 'flo_mark.dart';

class FloHomeView extends StatelessWidget {
  const FloHomeView({
    super.key,
    required this.onSuggestionTap,
    required this.shopName,
    this.isMobile = false,
    this.whatsAppConnected = false,
    this.onConnectWhatsApp,
    this.onManageSources,
    this.briefing,
    this.briefingLoading = false,
  });

  final void Function(String question) onSuggestionTap;
  final String shopName;
  final bool isMobile;
  final bool whatsAppConnected;
  final VoidCallback? onConnectWhatsApp;
  final VoidCallback? onManageSources;
  final FloDailyBriefing? briefing;
  final bool briefingLoading;

  /// Starter questions. `q` is sent as the user's message, so it follows the
  /// app language like anything else the user would type.
  static List<Map<String, String>> suggestionsFor(
          FlipperAppLocalizations l10n) =>
      [
        {
          'icon': 'chart',
          'tone': 'blue',
          't': l10n.floSuggestTodayTitle,
          'd': l10n.floSuggestTodayDesc,
          'q': l10n.floSuggestTodayQuestion,
        },
        {
          'icon': 'coins',
          'tone': 'gain',
          't': l10n.floSuggestProfitTitle,
          'd': l10n.floSuggestProfitDesc,
          'q': l10n.floSuggestProfitQuestion,
        },
        {
          'icon': 'users',
          'tone': 'violet',
          't': l10n.floSuggestUsersTitle,
          'd': l10n.floSuggestUsersDesc,
          'q': l10n.floSuggestUsersQuestion,
        },
        {
          'icon': 'trend',
          'tone': 'xp',
          't': l10n.floSuggestTrendTitle,
          'd': l10n.floSuggestTrendDesc,
          'q': l10n.floSuggestTrendQuestion,
        },
      ];

  String _greeting(FlipperAppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.floGoodMorning;
    if (hour < 17) return l10n.floGoodAfternoon;
    return l10n.floGoodEvening;
  }

  String _eyebrow() {
    final now = DateTime.now();
    final day = DateFormat('EEEE').format(now);
    final time = DateFormat('h:mm a').format(now);
    return '${day[0].toUpperCase()}${day.substring(1)} · $time';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    // Split around the highlighted word so it keeps its gradient in any
    // language's word order.
    const highlightToken = '\u0001';
    final askParts =
        l10n.floAskMeAnything(highlightToken).split(highlightToken);
    final askBefore = askParts.first;
    final askAfter = askParts.length > 1 ? askParts.sublist(1).join() : '';
    return Padding(
      padding:
          EdgeInsets.fromLTRB(isMobile ? 16 : 28, 26, isMobile ? 16 : 28, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FloMark(size: 38),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _eyebrow().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.08 * 12,
                        color: FloTheme.ink3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.floGreetingShop(_greeting(l10n), shopName),
                      style: TextStyle(
                        fontSize: isMobile ? 23 : 27,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.03 * (isMobile ? 23 : 27),
                        height: 1.12,
                        color: FloTheme.ink1,
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          askBefore,
                          style: TextStyle(
                            fontSize: isMobile ? 23 : 27,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03 * (isMobile ? 23 : 27),
                            height: 1.12,
                            color: FloTheme.ink1,
                          ),
                        ),
                        FloGradientText(
                          l10n.floAnything,
                          style: TextStyle(
                            fontSize: isMobile ? 23 : 27,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03 * (isMobile ? 23 : 27),
                            height: 1.12,
                          ),
                        ),
                        Text(
                          askAfter,
                          style: TextStyle(
                            fontSize: isMobile ? 23 : 27,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03 * (isMobile ? 23 : 27),
                            height: 1.12,
                            color: FloTheme.ink1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.floHomeIntro,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: FloTheme.ink2,
            ),
          ),
          const SizedBox(height: 22),
          _DailyBriefingCard(
            briefing: briefing,
            loading: briefingLoading,
          ),
          _SectionLabel(l10n.floTryAsking),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: isMobile ? 3.8 : 3.2,
            children: [
              for (final s in suggestionsFor(l10n))
                _SuggestCard(
                  iconName: s['icon']!,
                  tone: s['tone']!,
                  title: s['t']!,
                  desc: s['d']!,
                  onTap: () => onSuggestionTap(s['q']!),
                ),
            ],
          ),
          _SectionLabel(l10n.floChannels),
          if (isMobile)
            Column(
              children: [
                _ChannelCard(
                  title: 'MiniData',
                  desc: l10n.floMiniDataDesc,
                  connected: true,
                  isData: true,
                  actionLabel: l10n.floManage,
                  onAction: onManageSources,
                ),
                const SizedBox(height: 10),
                _ChannelCard(
                  title: 'WhatsApp',
                  desc: whatsAppConnected
                      ? l10n.floWhatsAppConnectedDesc
                      : l10n.floWhatsAppSetupDesc,
                  connected: whatsAppConnected,
                  actionLabel:
                      whatsAppConnected ? l10n.floManage : l10n.floConnect,
                  primaryAction: !whatsAppConnected,
                  onAction: onConnectWhatsApp,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ChannelCard(
                    title: 'MiniData',
                    desc: l10n.floMiniDataDesc,
                    connected: true,
                    isData: true,
                    actionLabel: l10n.floManage,
                    onAction: onManageSources,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ChannelCard(
                    title: 'WhatsApp',
                    desc: whatsAppConnected
                        ? l10n.floWhatsAppConnectedDesc
                        : l10n.floWhatsAppSetupDesc,
                    connected: whatsAppConnected,
                    actionLabel:
                        whatsAppConnected ? l10n.floManage : l10n.floConnect,
                    primaryAction: !whatsAppConnected,
                    onAction: onConnectWhatsApp,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 26, 2, 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.07 * 11.5,
          color: FloTheme.ink3,
        ),
      ),
    );
  }
}

class _DailyBriefingCard extends StatelessWidget {
  const _DailyBriefingCard({
    this.briefing,
    this.loading = false,
  });

  final FloDailyBriefing? briefing;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        briefing?.dateLabel ?? DateFormat('d MMM').format(DateTime.now());
    final l10n = context.flipperL10n;
    final headline = loading
        ? l10n.floLoadingBriefing
        : (briefing?.headline ?? l10n.floBriefingUnavailable);
    final bodyHtml = loading
        ? l10n.floReadingLiveSales
        : (briefing?.bodyHtml ?? l10n.floCheckDataConnection);
    final stats = briefing?.stats ?? const [];

    return Container(
      decoration: BoxDecoration(
        gradient: FloTheme.briefingGrad,
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
        border: Border.all(color: FloTheme.line),
        boxShadow: const [FloTheme.sh2],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 12),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: FloTheme.blueTint,
                    borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloIcons.sparkle(size: 13, color: FloTheme.blue),
                      const SizedBox(width: 6),
                      Text(
                        l10n.floDailyBriefing,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.05 * 11,
                          color: FloTheme.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (loading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    l10n.floDateAuto(dateLabel),
                    style: FloTheme.mono(12).copyWith(color: FloTheme.ink3),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02,
                    color: FloTheme.ink1,
                  ),
                ),
                const SizedBox(height: 5),
                FloHtmlText(bodyHtml),
                if (stats.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final s in stats)
                        _BriefStat(
                          label: s.label,
                          value: s.value,
                          unit: s.unit,
                          delta: s.delta,
                          up: s.up,
                          negative: s.negative,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefStat extends StatelessWidget {
  const _BriefStat({
    required this.label,
    required this.value,
    this.unit,
    this.delta,
    this.up,
    this.negative = false,
  });

  final String label;
  final String value;
  final String? unit;
  final String? delta;
  final bool? up;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        border: Border.all(color: FloTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05 * 10.5,
              color: FloTheme.ink3,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: FloTheme.mono(18).copyWith(
                color: negative ? FloTheme.lossInk : FloTheme.ink1,
              ),
              children: [
                if (unit != null)
                  TextSpan(
                    text: '$unit ',
                    style: FloTheme.mono(11, weight: FontWeight.w600)
                        .copyWith(color: FloTheme.ink3),
                  ),
                TextSpan(text: value),
              ],
            ),
          ),
          if (delta != null && up != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                up!
                    ? FloIcons.up(size: 11, color: FloTheme.gainInk)
                    : FloIcons.down(size: 11, color: FloTheme.lossInk),
                const SizedBox(width: 3),
                Text(
                  delta!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: up! ? FloTheme.gainInk : FloTheme.lossInk,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SuggestCard extends StatelessWidget {
  const _SuggestCard({
    required this.iconName,
    required this.tone,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  final String iconName;
  final String tone;
  final String title;
  final String desc;
  final VoidCallback onTap;

  (Color bg, Color fg) get _colors => switch (tone) {
        'gain' => (FloTheme.gainTint, FloTheme.gainInk),
        'violet' => (FloTheme.violetTint, FloTheme.violet),
        'xp' => (FloTheme.xpTint, const Color(0xFFE08600)),
        _ => (FloTheme.blueTint, FloTheme.blue),
      };

  Widget _icon(Color fg) => switch (iconName) {
        'chart' => FloIcons.chart(size: 19, color: fg),
        'coins' => FloIcons.coins(size: 19, color: fg),
        'users' => FloIcons.users(size: 19, color: fg),
        'trend' => FloIcons.trend(size: 19, color: fg),
        _ => FloIcons.chart(size: 19, color: fg),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Material(
      color: FloTheme.surface,
      borderRadius: BorderRadius.circular(FloTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FloTheme.radiusMd),
            border: Border.all(color: FloTheme.line),
            boxShadow: const [FloTheme.sh1],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: _icon(fg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.01,
                        height: 1.3,
                        color: FloTheme.ink1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: FloTheme.ink3,
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

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.title,
    required this.desc,
    required this.connected,
    required this.actionLabel,
    this.isData = false,
    this.primaryAction = false,
    this.onAction,
  });

  final String title;
  final String desc;
  final bool connected;
  final bool isData;
  final String actionLabel;
  final bool primaryAction;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        border: Border.all(color: FloTheme.line),
        boxShadow: const [FloTheme.sh1],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FloTheme.blueTint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: isData
                ? FloIcons.database(size: 21, color: FloTheme.blue)
                : FloIcons.whatsApp(size: 21, color: FloTheme.blueDeep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.01,
                        color: FloTheme.ink1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            connected ? FloTheme.gainTint : FloTheme.surface2,
                        borderRadius:
                            BorderRadius.circular(FloTheme.radiusPill),
                        border:
                            connected ? null : Border.all(color: FloTheme.line),
                      ),
                      child: Text(
                        connected
                            ? context.flipperL10n.floConnected
                            : context.flipperL10n.floNotSetUp,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.03 * 10,
                          color: connected ? FloTheme.gainInk : FloTheme.ink3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 12, color: FloTheme.ink3, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          primaryAction
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: FloTheme.gradBtn,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [FloTheme.shBlue],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloIcons.link(size: 15, color: Colors.white),
                          const SizedBox(width: 7),
                          Text(
                            actionLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: FloTheme.lineStrong),
                      ),
                      child: Center(
                        child: Text(
                          actionLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: FloTheme.ink2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
