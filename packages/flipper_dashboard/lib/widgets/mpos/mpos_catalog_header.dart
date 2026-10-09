import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_app_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

/// Catalog header ([design_handoff_mobile_pos/mpos-catalog.jsx] `.mp-head`).
class MposCatalogHeader extends StatelessWidget {
  const MposCatalogHeader({
    super.key,
    required this.subtitle,
    required this.status,
    required this.searchField,
    required this.onBack,
    required this.onScan,
    this.onScanLongPress,
    this.isScanActive = false,
  });

  final String subtitle;
  final String status;
  final Widget searchField;
  final VoidCallback onBack;
  final VoidCallback onScan;

  /// Long-press turns off barcode auto-add (scan mode) without opening the camera.
  final VoidCallback? onScanLongPress;
  final bool isScanActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MposTokens.head,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MposAppBar(
            title: context.flipperL10n.mposNewSale,
            subtitle: subtitle,
            status: status,
            onBack: onBack,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 10),
                _MposScanButton(
                  onPressed: onScan,
                  onLongPress: onScanLongPress,
                  isActive: isScanActive,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: PosTokens.line),
        ],
      ),
    );
  }
}

class _MposScanButton extends StatelessWidget {
  const _MposScanButton({
    required this.onPressed,
    required this.isActive,
    this.onLongPress,
  });

  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? PosTokens.blueTint : PosTokens.surface,
      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        child: Ink(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            border: Border.all(
              color: isActive ? PosTokens.blue : PosTokens.line,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive
                    ? FluentIcons.barcode_scanner_24_filled
                    : FluentIcons.barcode_scanner_24_regular,
                size: 22,
                color: isActive ? PosTokens.blue : PosTokens.ink2,
              ),
              const SizedBox(width: 7),
              Text(
                context.flipperL10n.mposScan,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? PosTokens.blue : PosTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
