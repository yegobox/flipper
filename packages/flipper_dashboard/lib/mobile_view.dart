import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/widgets/mobile_dashboard_shell.dart';

class MobileView extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;

  const MobileView({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
  }) : super(key: key);

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  @override
  Widget build(BuildContext context) {
    return MobileDashboardShell(
      controller: widget.controller,
      isBigScreen: widget.isBigScreen,
      model: widget.model,
    );
  }
}
