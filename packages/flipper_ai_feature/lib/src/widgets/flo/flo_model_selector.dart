import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

import '../../models/flo_ai_mode.dart';
import '../../theme/flo_theme.dart';

/// AI mode picker for the Flo header: **On-Device**, **Cloud** or **Claude**
/// (the user's own subscription, desktop only).
///
/// Cloud chat is routed through the data-connector, which selects the actual
/// cloud model server-side, so the client never picks a specific cloud model.
/// Options the platform can't offer are omitted; with only Cloud left, a static
/// pill is shown.
class FloModelSelector extends StatelessWidget {
  const FloModelSelector({
    super.key,
    required this.localAvailable,
    required this.claudeAvailable,
    required this.mode,
    required this.onChanged,
  });

  /// Whether on-device inference is available on this device.
  final bool localAvailable;

  /// Whether the Claude CLI option should be offered (desktop platforms).
  final bool claudeAvailable;

  final FloAiMode mode;

  final ValueChanged<FloAiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    if (!localAvailable && !claudeAvailable) {
      return _pill(
        icon: Icons.cloud_outlined,
        iconColor: FloTheme.blue,
        label: l10n.floModeCloud,
        showChevron: false,
      );
    }

    final current = _spec(l10n, mode);
    return PopupMenuButton<FloAiMode>(
      tooltip: l10n.floChooseAiMode,
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final m in FloAiMode.values)
          if (m == FloAiMode.cloud ||
              (m == FloAiMode.onDevice && localAvailable) ||
              (m == FloAiMode.claude && claudeAvailable))
            _menuItem(
              value: m,
              selected: m == mode,
              spec: _spec(l10n, m),
            ),
      ],
      child: _pill(
        icon: current.icon,
        iconColor: current.color,
        label: current.title,
        showChevron: true,
      ),
    );
  }

  _ModeSpec _spec(FlipperAppLocalizations l10n, FloAiMode m) => switch (m) {
        FloAiMode.onDevice => _ModeSpec(
            Icons.offline_bolt_outlined,
            FloTheme.gain,
            l10n.floModeOnDevice,
            l10n.floOnDeviceSubtitle,
          ),
        FloAiMode.cloud => _ModeSpec(
            Icons.cloud_outlined,
            FloTheme.blue,
            l10n.floModeCloud,
            l10n.floCloudSubtitle,
          ),
        FloAiMode.claude => _ModeSpec(
            Icons.auto_awesome_outlined,
            FloTheme.blue,
            l10n.floModeClaude,
            l10n.floClaudeSubtitle,
          ),
      };

  PopupMenuItem<FloAiMode> _menuItem({
    required FloAiMode value,
    required bool selected,
    required _ModeSpec spec,
  }) {
    final (icon, iconColor, title, subtitle) =
        (spec.icon, spec.color, spec.title, spec.subtitle);
    return PopupMenuItem<FloAiMode>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: FloTheme.ink3)),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check, size: 15, color: FloTheme.blue),
        ],
      ),
    );
  }

  Widget _pill({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool showChevron,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: FloTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: FloTheme.ink2,
            ),
          ),
          if (showChevron) ...[
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 16, color: FloTheme.ink3),
          ],
        ],
      ),
    );
  }
}

class _ModeSpec {
  const _ModeSpec(this.icon, this.color, this.title, this.subtitle);
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
}
