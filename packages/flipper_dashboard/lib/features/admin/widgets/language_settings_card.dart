import 'package:flipper_dashboard/providers/locale_provider.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _kCardBorder = Color(0xFFE5E7EB);
const Color _kTitleText = Color(0xFF111827);
const Color _kSubtitleText = Color(0xFF6B7280);
const Color _kAccent = Color(0xFF2563EB);

/// Admin Control tile for picking the language the whole app renders in.
///
/// Writes through [appLocaleProvider], which persists the choice and rebuilds
/// `MaterialApp.locale` — the switch is immediate and survives restarts.
class LanguageSettingsCard extends ConsumerWidget {
  const LanguageSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final chosenLocale = ref.watch(appLocaleProvider);
    final effectiveCode = ref.watch(effectiveLanguageCodeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kCardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _kAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AdminDashboardSvgs.picture(
                    AdminDashboardSvgs.appLanguage,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appLanguage,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: _kTitleText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.chooseAppLanguage,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: _kSubtitleText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _currentLabel(
                    l10n,
                    chosenLocale: chosenLocale,
                    effectiveCode: effectiveCode,
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kAccent,
                  ),
                ),
                const SizedBox(width: 8),
                AdminDashboardSvgs.picture(
                  AdminDashboardSvgs.chevronRight,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the chosen language, or the resolved one tagged as automatic when the
  /// admin has not picked explicitly.
  String _currentLabel(
    FlipperAppLocalizations l10n, {
    required Locale? chosenLocale,
    required String effectiveCode,
  }) {
    final name = languageDisplayName(l10n, effectiveCode);
    if (chosenLocale != null) return name;
    return '$name · ${l10n.automatic}';
  }

  Future<void> _openPicker(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => const _LanguagePickerSheet(),
    );
  }
}

class _LanguagePickerSheet extends ConsumerWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.flipperL10n;
    final chosenLocale = ref.watch(appLocaleProvider);
    final effectiveCode = ref.watch(effectiveLanguageCodeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                l10n.selectLanguage,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _kTitleText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                l10n.languageAppliesEverywhere,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: _kSubtitleText,
                  height: 1.35,
                ),
              ),
            ),
            const Divider(height: 1, color: _kCardBorder),
            for (final language in kSelectableLanguages)
              _LanguageOptionTile(
                // The endonym is shown as the primary label so a Kinyarwanda
                // speaker can find their language while the app is still in
                // English.
                title: language.nativeName,
                subtitle: languageDisplayName(l10n, language.code),
                selected: chosenLocale?.languageCode == language.code,
                onTap: () async {
                  await ref
                      .read(appLocaleProvider.notifier)
                      .setLanguage(language.code);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            const Divider(height: 1, color: _kCardBorder),
            _LanguageOptionTile(
              title: l10n.useDeviceLanguage,
              subtitle: languageDisplayName(l10n, effectiveCode),
              selected: chosenLocale == null,
              onTap: () async {
                await ref.read(appLocaleProvider.notifier).useDeviceLanguage();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? _kAccent : _kTitleText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(fontSize: 12, color: _kSubtitleText),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: _kAccent)
          : const Icon(Icons.circle_outlined, color: _kSubtitleText),
    );
  }
}

