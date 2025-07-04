import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';

class CloseShiftDialog extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const CloseShiftDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _CloseShiftDialogState createState() => _CloseShiftDialogState();
}

class _CloseShiftDialogState extends State<CloseShiftDialog> {
  final TextEditingController _closingBalanceController = TextEditingController();
  double _cashDifference = 0.0;

  @override
  void initState() {
    super.initState();
    _closingBalanceController.addListener(_calculateCashDifference);
    _calculateCashDifference(); // Calculate initial difference
  }

  @override
  void dispose() {
    _closingBalanceController.removeListener(_calculateCashDifference);
    _closingBalanceController.dispose();
    super.dispose();
  }

  void _calculateCashDifference() {
    final openingBalance = (widget.request.data?['openingBalance'] as num?)?.toDouble() ?? 0.0;
    final cashSales = (widget.request.data?['cashSales'] as num?)?.toDouble() ?? 0.0;
    final expectedCash = (widget.request.data?['expectedCash'] as num?)?.toDouble() ?? 0.0;
    final closingBalance = double.tryParse(_closingBalanceController.text) ?? 0.0;

    setState(() {
      _cashDifference = closingBalance - expectedCash;
    });
  }

  @override
  Widget build(BuildContext context) {
    final openingBalance = (widget.request.data?['openingBalance'] as num?)?.toDouble() ?? 0.0;
    final cashSales = (widget.request.data?['cashSales'] as num?)?.toDouble() ?? 0.0;
    final expectedCash = (widget.request.data?['expectedCash'] as num?)?.toDouble() ?? 0.0;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.request.title ?? 'Close Shift',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Opening Balance: ${openingBalance.toStringAsFixed(2)}'),
            Text('Cash Sales: ${cashSales.toStringAsFixed(2)}'),
            Text('Expected Cash: ${expectedCash.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            TextField(
              controller: _closingBalanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Closing Balance',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cash Difference: ${_cashDifference.toStringAsFixed(2)}',
              style: TextStyle(
                color: _cashDifference == 0
                    ? Colors.black
                    : _cashDifference > 0
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => widget.completer(DialogResponse(confirmed: false)),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final closingBalance = double.tryParse(_closingBalanceController.text);
                    if (closingBalance != null) {
                      widget.completer(DialogResponse(confirmed: true, data: closingBalance));
                    } else {
                      // Show error or prevent closing
                      // ProxyService.notification.showSnackBar(
                      //     message: 'Please enter a valid closing balance.');
                    }
                  },
                  child: const Text('Close Shift'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}