import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_status_pill.dart';
import 'package:flutter/material.dart';

/// The phone POS screens' top bar: Flipper's [CustomAppBar] (round back
/// button, title, subtitle) with the sale's status pill on the right.
class MposAppBar extends StatelessWidget {
  const MposAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onBack,
    this.backMaestroId,
    this.backSemanticsLabel,
  });

  final String title;
  final String subtitle;
  final String status;
  final VoidCallback onBack;

  /// Stable id for Maestro flows that tap the back button.
  final String? backMaestroId;
  final String? backSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      closeButton: CLOSEBUTTON.WIDGET,
      customLeadingWidget: _MposBack(
        onBack: onBack,
        maestroId: backMaestroId,
        semanticsLabel: backSemanticsLabel,
      ),
      customTrailingWidget: _MposBarPill(status: status),
      bottomSpacer: 64,
      isDividerVisible: false,
      barBackgroundColor: MposTokens.head,
    );
  }
}

class _MposBack extends StatelessWidget {
  const _MposBack({required this.onBack, this.maestroId, this.semanticsLabel});

  final VoidCallback onBack;
  final String? maestroId;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    Widget button = AppBarRoundIconButton(
      icon: Icons.arrow_back,
      onPressed: onBack,
    );
    if (maestroId != null) {
      button = MaestroSemantics(
        id: maestroId!,
        label: semanticsLabel,
        button: true,
        enabled: true,
        child: button,
      );
    }
    // Same 56-wide slot as CustomAppBar's own back button.
    return SizedBox(width: 56, child: Center(child: button));
  }
}

class _MposBarPill extends StatelessWidget {
  const _MposBarPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    // The bar pads 8; this lines the pill up with the 16 used below it.
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: MposStatusPill(status: status),
    );
  }
}
