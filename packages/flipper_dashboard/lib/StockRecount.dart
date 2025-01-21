// a model that take stock id and how input field to enter the new count give me statless widget for that see Refund for example

import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

class StockRecount extends StatelessWidget {
  final String stockId;
  final Function(String) onRecount;
  final String itemName;

  StockRecount(
      {required this.stockId, required this.onRecount, required this.itemName});

  final formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Stock Recount #${itemName}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'New Count',
                prefixIcon: Icon(Icons.inventory),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FlipperButton(
                    textColor: Colors.black,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onRecount(_controller.text);
                        Navigator.pop(context);
                      }
                    },
                    text: 'Submit',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FlipperButton(
                    onPressed: () => Navigator.pop(context),
                    text: 'Cancel',
                    textColor: Colors.blue,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
