import 'package:flutter/material.dart';

import '../../theme/flo_theme.dart';
import 'flo_icons.dart';
import 'flo_mark.dart';

enum FloPanelMode { askFlo, messages }

class FloHeader extends StatelessWidget {
  const FloHeader({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.isMobile,
    this.miniDataConnected = true,
    this.whatsAppConnected = false,
    this.unreadCount = 0,
    this.onNewChat,
    this.onConnectWhatsApp,
    this.onManageSources,
    this.onMenuToggle,
    this.menuOpen = false,
    this.menuContent,
    this.modelSelector,
  });

  final FloPanelMode mode;
  final ValueChanged<FloPanelMode> onModeChanged;
  final bool isMobile;
  final bool miniDataConnected;
  final bool whatsAppConnected;
  final int unreadCount;
  final VoidCallback? onNewChat;
  final VoidCallback? onConnectWhatsApp;
  final VoidCallback? onManageSources;
  final VoidCallback? onMenuToggle;
  final bool menuOpen;
  final Widget? menuContent;

  /// Optional AI model picker (local vs cloud) rendered in the header.
  final Widget? modelSelector;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 12 : 14,
      ),
      decoration: const BoxDecoration(
        color: FloTheme.surface,
        border: Border(bottom: BorderSide(color: FloTheme.line)),
      ),
      child: Row(
        children: [
          if (!isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      'Flo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.02,
                        color: FloTheme.ink1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: FloTheme.blueTint,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Business AI',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.04,
                          color: FloTheme.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                if (miniDataConnected)
                  Row(
                    children: const [
                      FloLiveDot(),
                      SizedBox(width: 6),
                      Text(
                        'MiniData connected · live',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: FloTheme.ink3,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          const Spacer(),
          _ModeTabs(
            mode: mode,
            unreadCount: unreadCount,
            whatsAppConnected: whatsAppConnected,
            isMobile: isMobile,
            onChanged: onModeChanged,
          ),
          const Spacer(),
          if (!isMobile) ...[
            _HeaderChips(
              whatsAppConnected: whatsAppConnected,
              onManageSources: onManageSources,
              onConnectWhatsApp: onConnectWhatsApp,
            ),
            const SizedBox(width: 8),
            _HeadBtn(
              label: 'New chat',
              icon: FloIcons.newChat(size: 17, color: FloTheme.ink2),
              onTap: onNewChat,
            ),
            const SizedBox(width: 8),
          ],
          if (modelSelector != null && mode == FloPanelMode.askFlo) ...[
            modelSelector!,
            const SizedBox(width: 8),
          ],
          Stack(
            clipBehavior: Clip.none,
            children: [
              _HeadBtn(
                icon: FloIcons.plus(size: 17, color: FloTheme.ink2),
                iconOnly: true,
                onTap: onMenuToggle,
              ),
              if (menuOpen && menuContent != null)
                Positioned(
                  top: 44,
                  right: 0,
                  child: menuContent!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({
    required this.mode,
    required this.unreadCount,
    required this.whatsAppConnected,
    required this.isMobile,
    required this.onChanged,
  });

  final FloPanelMode mode;
  final int unreadCount;
  final bool whatsAppConnected;
  final bool isMobile;
  final ValueChanged<FloPanelMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: FloTheme.surface2,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
        border: Border.all(color: FloTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeTab(
            label: 'Ask Flo',
            icon: FloIcons.sparkle(
              size: 15,
              color: mode == FloPanelMode.askFlo ? FloTheme.ink1 : FloTheme.ink3,
            ),
            selected: mode == FloPanelMode.askFlo,
            onTap: () => onChanged(FloPanelMode.askFlo),
            compact: isMobile,
          ),
          _ModeTab(
            label: 'Messages',
            icon: FloIcons.whatsApp(
              size: 15,
              color: mode == FloPanelMode.messages ? FloTheme.ink1 : FloTheme.ink3,
            ),
            selected: mode == FloPanelMode.messages,
            onTap: () => onChanged(FloPanelMode.messages),
            compact: isMobile,
            badge: whatsAppConnected && unreadCount > 0 ? unreadCount : null,
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.compact = false,
    this.badge,
  });

  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 14),
          decoration: BoxDecoration(
            color: selected ? FloTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(FloTheme.radiusPill),
            boxShadow: selected ? const [FloTheme.sh1] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? FloTheme.ink1 : FloTheme.ink3,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: FloTheme.wa,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$badge',
                    style: FloTheme.mono(10.5, weight: FontWeight.w700)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderChips extends StatelessWidget {
  const _HeaderChips({
    required this.whatsAppConnected,
    this.onManageSources,
    this.onConnectWhatsApp,
  });

  final bool whatsAppConnected;
  final VoidCallback? onManageSources;
  final VoidCallback? onConnectWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ChanChip(
          label: 'MiniData',
          icon: FloIcons.database(size: 14, color: FloTheme.blue),
          connected: true,
          isMiniData: true,
          onTap: onManageSources,
        ),
        const SizedBox(width: 8),
        whatsAppConnected
            ? _ChanChip(
                label: 'WhatsApp',
                icon: FloIcons.whatsApp(size: 14, color: FloTheme.waDeep),
                connected: true,
                isWhatsApp: true,
                onTap: onConnectWhatsApp,
              )
            : _ConnectChip(onTap: onConnectWhatsApp),
      ],
    );
  }
}

class _ChanChip extends StatelessWidget {
  const _ChanChip({
    required this.label,
    required this.icon,
    required this.connected,
    this.isMiniData = false,
    this.isWhatsApp = false,
    this.onTap,
  });

  final String label;
  final Widget icon;
  final bool connected;
  final bool isMiniData;
  final bool isWhatsApp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isWhatsApp ? FloTheme.waTint : FloTheme.surface;
    final border = isWhatsApp ? const Color(0xFFBCE7CC) : FloTheme.line;
    final fg = isWhatsApp ? FloTheme.waDeep : FloTheme.ink2;
    final dotColor = isWhatsApp ? FloTheme.wa : FloTheme.gain;
    final dotGlow = isWhatsApp ? const Color(0xFFCFF0DC) : FloTheme.gainTint;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FloTheme.radiusPill),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(FloTheme.radiusPill),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: dotGlow, spreadRadius: 3)],
              ),
            ),
            const SizedBox(width: 7),
            icon,
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectChip extends StatelessWidget {
  const _ConnectChip({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FloTheme.radiusPill),
      child: FloDashedOutline(
        radius: FloTheme.radiusPill,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: FloTheme.surface2,
            borderRadius: BorderRadius.circular(FloTheme.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloIcons.whatsApp(size: 14, color: FloTheme.wa),
              const SizedBox(width: 6),
              const Text(
                'Connect WhatsApp',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: FloTheme.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeadBtn extends StatelessWidget {
  const _HeadBtn({
    this.label,
    required this.icon,
    this.iconOnly = false,
    this.onTap,
  });

  final String? label;
  final Widget icon;
  final bool iconOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FloTheme.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 36,
          width: iconOnly ? 36 : null,
          padding: iconOnly ? null : const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: FloTheme.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              if (!iconOnly && label != null) ...[
                const SizedBox(width: 7),
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: FloTheme.ink2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FloMenuPopover extends StatelessWidget {
  const FloMenuPopover({
    super.key,
    required this.onNewChat,
    required this.onWhatsApp,
    required this.onSources,
    required this.whatsAppConnected,
  });

  final VoidCallback onNewChat;
  final VoidCallback onWhatsApp;
  final VoidCallback onSources;
  final bool whatsAppConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 246,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: FloTheme.surface,
        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
        border: Border.all(color: FloTheme.line),
        boxShadow: const [FloTheme.sh3],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MenuItem(
            icon: FloIcons.newChat(size: 16, color: FloTheme.blue),
            iconBg: FloTheme.blueTint,
            title: 'New conversation',
            onTap: onNewChat,
          ),
          const Divider(height: 12, color: FloTheme.lineSoft),
          _MenuItem(
            icon: FloIcons.whatsApp(size: 16, color: FloTheme.waDeep),
            iconBg: FloTheme.waTint,
            title: 'Connect WhatsApp',
            subtitle: 'Chat with Flo & customers',
            badge: whatsAppConnected ? 'On' : 'Off',
            badgeOn: whatsAppConnected,
            onTap: onWhatsApp,
          ),
          _MenuItem(
            icon: FloIcons.database(size: 16, color: FloTheme.blue),
            iconBg: FloTheme.blueTint,
            title: 'Manage data sources',
            subtitle: 'MiniData · Supabase',
            onTap: onSources,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.title,
    this.subtitle,
    this.badge,
    this.badgeOn = false,
    required this.onTap,
  });

  final Widget icon;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final String? badge;
  final bool badgeOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: FloTheme.ink1,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: FloTheme.ink3,
                        ),
                      ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeOn ? FloTheme.waTint : FloTheme.surface2,
                    borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                    border: badgeOn ? null : Border.all(color: FloTheme.line),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeOn ? FloTheme.waDeep : FloTheme.ink3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
