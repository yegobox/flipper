import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Left cluster of the desktop POS top bar: branding only (tools live in ribbon + catalog search).
class PosDesktopTopLeading extends ConsumerWidget {
  const PosDesktopTopLeading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosHandoffIcons.svg('flipper-logo', size: 30),
        const SizedBox(width: 11),
        const Text(
          'FLIPPER',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: PosTokens.ink1,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(width: 11),
        const Text(
          'Point of Sale',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PosTokens.ink3,
          ),
        ),
      ],
    );
  }
}
