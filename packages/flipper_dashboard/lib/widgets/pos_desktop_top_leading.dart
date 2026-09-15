import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Left cluster of the desktop POS top bar: wordmark + screen context. The
/// Flipper logo mark lives in [DashboardLayout]'s sidebar header column on
/// every page.
class PosDesktopTopLeading extends ConsumerWidget {
  const PosDesktopTopLeading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'FLIPPER',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: PosTokens.ink1,
            letterSpacing: 0.2,
          ),
        ),
        Container(
          width: 1,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: PosTokens.line,
        ),
        const Text(
          'Point of Sale',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: PosTokens.ink3,
          ),
        ),
      ],
    );
  }
}
