import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RowsPerPageInput extends ConsumerStatefulWidget {
  const RowsPerPageInput({
    Key? key,
    required this.rowsPerPageProvider,
  }) : super(key: key);

  final StateProvider<int> rowsPerPageProvider;

  @override
  ConsumerState<RowsPerPageInput> createState() => _RowsPerPageInputState();
}

class _RowsPerPageInputState extends ConsumerState<RowsPerPageInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: ref.read(widget.rowsPerPageProvider).toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Rows Per Page',
          labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          suffixIcon: Icon(Icons.numbers, color: Colors.grey[500]),
        ),
        style: TextStyle(fontSize: 16.0, color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a number';
          }
          if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          if (value.isNotEmpty) {
            int? newValue = int.tryParse(value);
            if (newValue != null && newValue > 0) {
              ref.read(widget.rowsPerPageProvider.notifier).state = newValue;
            }
          }
        },
      ),
    );
  }
}
