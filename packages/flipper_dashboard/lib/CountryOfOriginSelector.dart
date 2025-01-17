
import 'package:flutter/material.dart';

class CountryOfOriginSelector extends StatefulWidget {
  @override
  _CountryOfOriginSelectorState createState() => _CountryOfOriginSelectorState();
}

class _CountryOfOriginSelectorState extends State<CountryOfOriginSelector> {
  // List of countries
  final List<Map<String, String>> countries = [
    {"name": "United States", "code": "US"},
    {"name": "United Kingdom", "code": "UK"},
    {"name": "Canada", "code": "CA"},
    {"name": "India", "code": "IN"},
    {"name": "Germany", "code": "DE"},
  ];

  // State variable to hold the selected country code
  String? selectedCountry;

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
          value: selectedCountry,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedCountry = newValue; // Update selected country
              });
            }
          },
          items: countries.map((country) {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Text(country['name']!),
            );
          }).toList(),
          isExpanded: true,
          underline: const SizedBox(), // Remove the default underline
          hint: const Text("Select Country of Origin"), // Placeholder text
        ),
      ),
    );
  }
}
