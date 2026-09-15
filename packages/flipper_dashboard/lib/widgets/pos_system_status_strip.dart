import 'package:flipper_dashboard/features/config/widgets/system_config_modal.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show statusTextProvider;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Compact desktop system-status notice (tax server / connectivity).
///
/// Replaces the full-width red [AppBar] on desktop: a 32px tinted strip
/// under the top bar that stays visible without dominating the register.
/// Driven by the same [statusTextProvider] the mobile status bar uses; the
/// [Status] service keeps rechecking on its own 5s timer, which is the only
/// retry the app has ever had.
class PosSystemStatusStrip extends ConsumerWidget {
  const PosSystemStatusStrip({super.key});

  /// Raw messages emitted by [StatusAppBarForWindowsAndWeb].
  static const taxServerDownMessage = 'Tax Server is down';
  static const internetDownMessage =
      'Flipper could not connect to the internet';

  static const double height = 32;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raw = ref.watch(statusTextProvider).value ?? '';
    if (raw.trim().isEmpty) return const SizedBox.shrink();

    final l10n = context.flipperL10n;
    final isTax = raw == taxServerDownMessage;
    final message = switch (raw) {
      taxServerDownMessage => l10n.taxServerUnreachableStatus,
      internetDownMessage => l10n.internetUnavailableStatus,
      _ => raw,
    };

    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          color: PosTokens.lossTint,
          border: Border(bottom: BorderSide(color: PosTokens.line)),
        ),
        child: Row(
          children: [
            const Icon(
              FluentIcons.warning_16_regular,
              size: PosTokens.iconSm,
              color: PosTokens.lossInk,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: PosTokens.lossInk,
                  height: 1.2,
                ),
              ),
            ),
            if (isTax) ...[
              const SizedBox(width: 8),
              TextButton(
                key: const Key('pos-status-tax-settings'),
                onPressed: () => showSystemConfigModal(context),
                style: TextButton.styleFrom(
                  foregroundColor: PosTokens.lossInk,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 24),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(l10n.taxSettings),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
