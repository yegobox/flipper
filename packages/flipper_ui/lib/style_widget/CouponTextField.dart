import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomizableTextField extends StatefulWidget {
  final TextEditingController controller;
  final AsyncValue<bool?> validateState;
  final void Function(String) onCouponChanged;
  final String? wording;

  const CustomizableTextField({
    Key? key,
    required this.controller,
    required this.validateState,
    required this.onCouponChanged,
    this.wording = 'Enter Coupon Code',
  }) : super(key: key);

  @override
  _CustomizableTextFieldState createState() => _CustomizableTextFieldState();
}

class _CustomizableTextFieldState extends State<CustomizableTextField> {
  late OutlineInputBorder _border;

  @override
  void initState() {
    super.initState();
    _updateBorder();
  }

  @override
  void didUpdateWidget(CustomizableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.validateState != widget.validateState) {
      _updateBorder();
    }
  }

  void _updateBorder() {
    setState(() {
      _border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: widget.validateState.when(
            data: (isValid) {
              if (isValid == null) return Colors.grey;
              return isValid ? Colors.green : Colors.red;
            },
            loading: () => Colors.grey,
            error: (_, __) => Colors.red,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.wording,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
        onChanged: widget.onCouponChanged,
      ),
    );
  }
}
