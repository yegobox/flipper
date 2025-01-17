import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class UnitOfMeasureDropdown extends StatelessWidget {
  final List<String> items; // List of unit names
  final String? selectedItem; // Currently selected unit
  final ValueChanged<String?>? onChanged; // Callback for value changes
  final bool isLoading; // Indicates if data is loading
  final String? error; // Error message (if any)

  const UnitOfMeasureDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
     this.onChanged,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    }

    if (error != null) {
      return Center(
        child: Text('Error: $error'), // Show an error message
      );
    }

    return Container(
      width: double.infinity,
      child: DropdownSearch<String>(
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
          ),
        ),
      ),
    );
  }
}
