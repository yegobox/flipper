import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';

/// Mobile bar screen shell: header / scroll / footer column.
class BarMobileShell extends StatelessWidget {
  const BarMobileShell({
    super.key,
    required this.body,
    this.header,
    this.footer,
    this.backgroundColor = BarTokens.posBg,
  });

  final Widget body;
  final Widget? header;
  final Widget? footer;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) header!,
          Expanded(child: body),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}
