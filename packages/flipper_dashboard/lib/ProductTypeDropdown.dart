import 'package:flutter/material.dart';

class ProductTypeDropdown extends StatefulWidget {
  final String? selectedValue; // Currently selected value
  final ValueChanged<String?> onChanged; // Callback to handle value changes

  const ProductTypeDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ProductTypeDropdownState createState() => _ProductTypeDropdownState();
}

class _ProductTypeDropdownState extends State<ProductTypeDropdown> {
  final List<Map<String, String>> options = [
    {"name": "Raw Material", "value": "1"},
    {"name": "Finished Product", "value": "2"},
    {"name": "Service without stock", "value": "3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButton<String>(
          value: widget.selectedValue,
          onChanged: widget.onChanged,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['name']!),
            );
          }).toList(),
          isExpanded: true,
          underline: const SizedBox(), // Remove the default underline
          hint: const Text("Select Product Type"), // Placeholder text
        ),
      ),
    );
  }
}
