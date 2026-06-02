import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

class MposSectionLabel extends StatelessWidget {
  const MposSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.06 * 11.5,
          color: PosTokens.ink3,
        ),
      ),
    );
  }
}
