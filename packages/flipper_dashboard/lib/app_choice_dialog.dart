import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AppChoiceDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AppChoiceDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(request.title ?? 'Choose Default App'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('POS (Point of Sale)'),
            onTap: () => completer(DialogResponse(confirmed: true, data: {'defaultApp': 'POS'})),
          ),
          ListTile(
            title: const Text('Inventory'),
            onTap: () => completer(DialogResponse(confirmed: true, data: {'defaultApp': 'Inventory'})),
          ),
          ListTile(
            title: const Text('Reports'),
            onTap: () => completer(DialogResponse(confirmed: true, data: {'defaultApp': 'Reports'})),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => completer(DialogResponse(confirmed: true, data: {'defaultApp': 'Settings'})),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => completer(DialogResponse(confirmed: false)),
        ),
      ],
    );
  }
}
