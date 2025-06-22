import 'package:flutter/material.dart';

class TaxDropdown extends StatelessWidget {
  final String? selectedValue; // Current selected value
  final List<String> options; // List of available options
  final ValueChanged<String> onChanged; // Callback for value changes
  final String defaultValue; // Default value if no selection is made

  const TaxDropdown({
    Key? key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.defaultValue = "B",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue ?? defaultValue,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      isExpanded: true, // Makes the dropdown fill available space
      underline: SizedBox.shrink(), // Removes the default underline
    );
  }
}
