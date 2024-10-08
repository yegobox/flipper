import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableDropdown extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?>? onChanged;

  ReusableDropdown({
    required this.options,
    this.selectedOption,
    this.onChanged,
  });

  @override
  _ReusableDropdownState createState() => _ReusableDropdownState();
}

class _ReusableDropdownState extends State<ReusableDropdown> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedOption,
        items: widget.options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedOption = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        },
        icon: Icon(
          FluentIcons.arrow_down_20_regular,
          color: Colors.grey,
          size: 20,
        ),
        alignment: AlignmentDirectional.topStart,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }
}
