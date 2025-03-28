import 'package:flutter/material.dart';

class DropdownButtonWithLabel extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final Map<String, String?>? displayNames;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onAdd;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final Color? borderColor;
  final Color? textColor;

  const DropdownButtonWithLabel({
    super.key,
    required this.label,
    this.selectedValue,
    required this.options,
    this.displayNames,
    required this.onChanged,
    this.onAdd,
    this.isRequired = false,
    this.validator,
    this.isEnabled = true,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure selected value is valid
    final validatedSelectedValue =
        options.contains(selectedValue) ? selectedValue : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor ?? Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: validatedSelectedValue,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              suffixIcon: onAdd != null
                  ? IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: isEnabled ? onAdd : null,
                      tooltip: 'Add',
                    )
                  : null,
            ),
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  // Use display name if available, otherwise use the value itself
                  displayNames?[value] ?? value,
                  style: TextStyle(
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
                ),
              );
            }).toList(),
            onChanged: isEnabled ? onChanged : null,
            validator: validator ??
                (value) {
                  if (isRequired && (value == null || value.isEmpty)) {
                    return '$label is required';
                  }
                  return null;
                },
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.arrow_drop_down,
              color: isEnabled ? Colors.black : Colors.grey,
            ),
            isExpanded: true,
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
