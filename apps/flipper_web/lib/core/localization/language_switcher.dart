import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = context.flipperL10n;

    final options = <(String code, String flag, String label)>[
      ('en', '🇺🇸', l10n.english),
      ('fr', '🇫🇷', l10n.french),
      ('rw', '🇷🇼', l10n.kinyarwanda),
      ('sw', '🇹🇿', l10n.swahili),
    ];

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: l10n.language,
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (BuildContext context) => [
        for (final (code, flag, label) in options)
          PopupMenuItem(
            value: Locale(code),
            child: Row(
              children: [
                Text(flag),
                const SizedBox(width: 8),
                Text(label),
                if (currentLocale.languageCode == code) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check, size: 16),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
