import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppIconsGrid extends ConsumerWidget {
  final bool isBigScreen;
  final Function(String appId)? onAppLongPress;
  final Function(String appId) onAppTap;

  const AppIconsGrid({
    Key? key,
    required this.isBigScreen,
    required this.onAppTap,
    this.onAppLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> apps = [
      {
        'icon': FluentIcons.box_24_regular,
        'color': const Color(0xFF66AAFF),
        'label': "Inventory",
        'id': 'inventory',
        'description': 'Complete inventory management system'
      },
      {
        'icon': FluentIcons.chat_24_regular,
        'color': const Color(0xFF4CAF50),
        'label': "Chat AI",
        'id': 'chat',
        'description': 'AI-powered business assistant'
      },
      {
        'icon': FluentIcons.building_shop_24_regular,
        'color': const Color(0xFFFFA726),
        'label': "Marketplace",
        'id': 'marketplace',
        'description': 'Online store management'
      },
      {
        'icon': FluentIcons.settings_24_regular,
        'color': const Color(0xFF9C27B0),
        'label': "Settings",
        'id': 'settings',
        'description': 'System configuration'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isBigScreen ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return GestureDetector(
            onTap: () => onAppTap(app['id']),
            onLongPress: () {
              if (onAppLongPress != null) {
                onAppLongPress!(app['id']);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    app['icon'],
                    size: 32,
                    color: app['color'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    app['label'],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      app['description'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
