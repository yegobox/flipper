import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_status_pill.dart';
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
  });

  final String subtitle;
  final String status;
  final Widget searchField;
  final VoidCallback onBack;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MposTokens.head,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: Row(
              children: [
                _MposBackButton(onPressed: onBack),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New sale',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.01,
                          color: PosTokens.ink1,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: PosTokens.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
                MposStatusPill(status: status),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 10),
                _MposScanButton(onPressed: onScan),
              ],
            ),
          ),
          const Divider(height: 1, color: PosTokens.line),
        ],
      ),
    );
  }
}

class _MposBackButton extends StatelessWidget {
  const _MposBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.surface2,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: PosTokens.line),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 22,
            color: PosTokens.ink1,
          ),
        ),
      ),
    );
  }
}

class _MposScanButton extends StatelessWidget {
  const _MposScanButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.blueTint,
      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.qr_code_scanner_rounded, color: PosTokens.blue),
                const SizedBox(width: 7),
                Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.blue,
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
