import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/widgets/mobile_dashboard_shell.dart';

class Apps extends StatefulHookConsumerWidget {
  final TextEditingController controller;
  final bool isBigScreen;
  final CoreViewModel model;
  final Function(String appId)? onAppLongPress;

  const Apps({
    Key? key,
    required this.controller,
    required this.isBigScreen,
    required this.model,
    this.onAppLongPress,
  }) : super(key: key);

  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends ConsumerState<Apps> {
  @override
  Widget build(BuildContext context) {
    return MobileDashboardShell(
      controller: widget.controller,
      isBigScreen: widget.isBigScreen,
      model: widget.model,
    );
  }
}
