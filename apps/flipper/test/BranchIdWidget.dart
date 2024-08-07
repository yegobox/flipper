import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class BranchIdWidget extends StatefulWidget {
  const BranchIdWidget({Key? key}) : super(key: key);

  @override
  _BranchIdWidgetState createState() => _BranchIdWidgetState();
}

class _BranchIdWidgetState extends State<BranchIdWidget> {
  int? _branchId;

  @override
  void initState() {
    super.initState();
    _loadBranchId();
  }

  Future<void> _loadBranchId() async {
    final branchId = await ProxyService.box.getBranchId();
    setState(() {
      _branchId = branchId;
    });
  }

  Future<void> _saveBranchId() async {
    await ProxyService.box.writeInt(key: "getBranchId", value: 1);
    await _loadBranchId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Current Branch ID: ${_branchId ?? "Not set"}'),
        ElevatedButton(
          onPressed: _saveBranchId,
          child: Text('Set Branch ID to 1'),
        ),
      ],
    );
  }
}
