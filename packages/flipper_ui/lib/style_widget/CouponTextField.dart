import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponTextField extends StatefulWidget {
  final TextEditingController couponController;
  final AsyncValue<bool?> couponValidationState;
  final void Function(String) onCouponChanged;

  const CouponTextField({
    Key? key,
    required this.couponController,
    required this.couponValidationState,
    required this.onCouponChanged,
  }) : super(key: key);

  @override
  _CouponTextFieldState createState() => _CouponTextFieldState();
}

class _CouponTextFieldState extends State<CouponTextField> {
  late OutlineInputBorder _border;

  @override
  void initState() {
    super.initState();
    _updateBorder();
  }

  @override
  void didUpdateWidget(CouponTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.couponValidationState != widget.couponValidationState) {
      _updateBorder();
    }
  }

  void _updateBorder() {
    setState(() {
      _border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: widget.couponValidationState.when(
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
        controller: widget.couponController,
        decoration: InputDecoration(
          labelText: 'Enter Coupon Code',
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
        onChanged: widget.onCouponChanged,
      ),
    );
  }
}
