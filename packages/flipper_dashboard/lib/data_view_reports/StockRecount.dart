// a model that take stock id and how input field to enter the new count give me statless widget for that see Refund for example

import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

class StockRecount extends StatelessWidget {
  final String stockId;
  final Function(String) onRecount;
  final String itemName;

  StockRecount({
    required this.stockId,
    required this.onRecount,
    required this.itemName,
  });

  final formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
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
              l10n.reportStockRecountFor(itemName),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.reportNewCount,
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
                  return l10n.reportPleaseEnterNumber;
                }
                if (int.tryParse(value) == null) {
                  return l10n.pleaseEnterValidNumber;
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
                    text: l10n.submit,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FlipperButton(
                    onPressed: () => Navigator.pop(context),
                    text: l10n.cancel,
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
