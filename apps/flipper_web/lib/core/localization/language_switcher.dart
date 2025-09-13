import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('🇺🇸'),
              const SizedBox(width: 8),
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Icon(Icons.check, size: 16),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('fr'),
          child: Row(
            children: [
              const Text('🇷🇼'),
              const SizedBox(width: 8),
              const Text('Kinyarwanda'),
              if (currentLocale.languageCode == 'fr')
                const Icon(Icons.check, size: 16),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('sw'),
          child: Row(
            children: [
              const Text('🇹🇿'),
              const SizedBox(width: 8),
              const Text('Kiswahili'),
              if (currentLocale.languageCode == 'sw')
                const Icon(Icons.check, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
