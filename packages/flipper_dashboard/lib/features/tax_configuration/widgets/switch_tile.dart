import 'package:flutter/material.dart';

class TaxConfigSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TaxConfigSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile.adaptive(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }
}
