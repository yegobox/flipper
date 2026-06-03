import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

class MposCard extends StatelessWidget {
  const MposCard({
    super.key,
    required this.child,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusLg),
        border: Border.all(color: PosTokens.line),
        boxShadow: PosTokens.shadow1,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );
  }
}
