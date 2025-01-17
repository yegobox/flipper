import 'package:flutter/material.dart';

class DropdownButtonWithLabel extends StatelessWidget {
  final String label; // Label for the dropdown
  final String? selectedValue; // Currently selected value
  final List<String> options; // List of dropdown options
  final ValueChanged<String?> onChanged; // Callback to handle value changes

  const DropdownButtonWithLabel({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 30,
              isExpanded: true,
              underline: const SizedBox(), // Remove the default underline
            ),
          ),
        ],
      ),
    );
  }
}
