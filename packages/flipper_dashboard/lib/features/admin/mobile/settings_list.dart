import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_section_label.dart';
import 'package:flutter/material.dart';

// The phone settings list: grey outline icons, ink text, hairline dividers.
// Colour is kept for meaning only — blue on controls, red for destructive
// rows — so the screen reads as a business tool rather than an app launcher.

const double _kIconSize = 20;
const double _kRowMinHeight = 52;
const double _kSidePad = 16;

/// A labelled card of [SettingsRow]s and [SettingsSwitchRow]s.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.label, required this.children});

  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        // Inset to the text column, like the rows' own content.
        rows.add(
          const Divider(
            height: 1,
            thickness: 0.6,
            indent: _kSidePad + _kIconSize + 14,
            color: PosTokens.line,
          ),
        );
      }
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: MposSectionLabel(label!),
          ),
          const SizedBox(height: 8),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: PosTokens.surface,
            borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            border: Border.all(color: PosTokens.line),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            child: Column(children: rows),
          ),
        ),
      ],
    );
  }
}

/// A tappable row that opens something: icon, title, optional value, chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  /// Current state shown before the chevron, e.g. "English".
  final String? value;

  /// Red title and icon, no chevron — for actions that delete data.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final ink = destructive ? PosTokens.lossInk : PosTokens.ink1;
    // One button node for screen readers: title (and value) read together.
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _kRowMinHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _kSidePad,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: _kIconSize,
                    color: destructive ? PosTokens.lossInk : PosTokens.ink3,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ink,
                      ),
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        value!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 14,
                          color: PosTokens.ink3,
                        ),
                      ),
                    ),
                  ],
                  if (!destructive) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: PosTokens.ink4,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row with an inline switch, for settings that need no page of their own.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _kRowMinHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(_kSidePad, 8, 8, 8),
            child: Row(
              children: [
                Icon(icon, size: _kIconSize, color: PosTokens.ink3),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: PosTokens.ink1,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.3,
                            color: PosTokens.ink3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: PosTokens.blue,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: PosTokens.line,
                  inactiveThumbColor: Colors.white,
                  // M3 draws a dark outline round an off switch; a hairline
                  // keeps the off state as quiet as the rest of the list.
                  trackOutlineColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.transparent
                        : PosTokens.ink4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The header of a page pushed from settings: Flipper's [CustomAppBar] with
/// its round back button, which shows only when there is somewhere to go back
/// to, like Material's [AppBar].
CustomAppBar settingsPageAppBar(BuildContext context, String title) {
  final canPop = ModalRoute.of(context)?.canPop ?? false;
  return CustomAppBar(
    title: title,
    closeButton: canPop ? CLOSEBUTTON.ICON : CLOSEBUTTON.NONE,
    icon: Icons.arrow_back,
    onPop: () => Navigator.of(context).maybePop(),
    bottomSpacer: 64,
    multi: 0.8, // preferredSize matches the 64dp bar
    isDividerVisible: false,
    barBackgroundColor: MposTokens.head,
  );
}

/// A full page for one settings area: back button, title, scrolling body on
/// the POS grey.
class SettingsSubpage extends StatelessWidget {
  const SettingsSubpage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  static Future<void> push(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsSubpage(title: title, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MposTokens.bg,
      appBar: settingsPageAppBar(context, title),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: child,
        ),
      ),
    );
  }
}
