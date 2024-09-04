import 'package:flipper_models/realm/schemas.dart';
import 'package:flutter/material.dart';

class CustomSupplierDropdown extends StatelessWidget {
  final List<Branch> suppliers;
  final Branch? selectedSupplier;
  final ValueChanged<Branch?> onChanged;

  const CustomSupplierDropdown({
    Key? key,
    required this.suppliers,
    required this.selectedSupplier,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Branch>(
          value: selectedSupplier,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black87, fontSize: 16),
          hint: Text('Select Supplier'),
          isExpanded: true,
          onChanged: onChanged,
          items: suppliers.map<DropdownMenuItem<Branch>>((Branch supplier) {
            return DropdownMenuItem<Branch>(
              value: supplier,
              child: Text(supplier.name ?? "-"),
            );
          }).toList(),
        ),
      ),
    );
  }
}
