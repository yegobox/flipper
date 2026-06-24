import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';

/// Binary AI mode picker for the Flo header: **On-Device** vs **Cloud**.
///
/// Cloud chat is routed through the data-connector, which selects the actual
/// cloud model server-side — so the client never picks a specific cloud model
/// here. The only meaningful choice is local vs cloud. When on-device AI isn't
/// supported on this platform/device, only Cloud is shown (and selected).
class FloModelSelector extends StatelessWidget {
  const FloModelSelector({
    super.key,
    required this.localAvailable,
    required this.useLocal,
    required this.onChanged,
  });

  /// Whether on-device inference is available on this device.
  final bool localAvailable;

  /// Current mode: true = on-device, false = cloud.
  final bool useLocal;

  /// Emits the new mode (true = local, false = cloud).
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // No local option → a static "Cloud" indicator, nothing to switch.
    if (!localAvailable) {
      return _pill(
        icon: Icons.cloud_outlined,
        iconColor: FloTheme.blue,
        label: 'Cloud',
        showChevron: false,
      );
    }

    return PopupMenuButton<bool>(
      tooltip: 'Choose AI mode',
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (context) => [
        _menuItem(
          value: true,
          selected: useLocal,
          icon: Icons.offline_bolt_outlined,
          iconColor: FloTheme.gain,
          title: 'On-Device',
          subtitle: 'Free · offline · private',
        ),
        _menuItem(
          value: false,
          selected: !useLocal,
          icon: Icons.cloud_outlined,
          iconColor: FloTheme.blue,
          title: 'Cloud',
          subtitle: 'More capable · uses connection',
        ),
      ],
      child: _pill(
        icon: useLocal ? Icons.offline_bolt_outlined : Icons.cloud_outlined,
        iconColor: useLocal ? FloTheme.gain : FloTheme.blue,
        label: useLocal ? 'On-Device' : 'Cloud',
        showChevron: true,
      ),
    );
  }

  PopupMenuItem<bool> _menuItem({
    required bool value,
    required bool selected,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return PopupMenuItem<bool>(
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
                    style: const TextStyle(
                        fontSize: 11, color: FloTheme.ink3)),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check, size: 15, color: FloTheme.blue),
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
