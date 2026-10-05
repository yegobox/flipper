import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';

class SwitchBranchView extends StatefulWidget {
  SwitchBranchView({Key? key}) : super(key: key);

  @override
  _SwitchBranchViewState createState() => _SwitchBranchViewState();
}

class _SwitchBranchViewState extends State<SwitchBranchView> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(context.flipperL10n.switchBranchAble));
  }
}
