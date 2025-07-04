import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class StartShiftDialog extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const StartShiftDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _StartShiftDialogState createState() => _StartShiftDialogState();
}

class _StartShiftDialogState extends State<StartShiftDialog> {
  final TextEditingController _openingBalanceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request.title ?? 'Start New Shift',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _openingBalanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Opening Cash Float',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _startShift,
                    child: const Text('Start Shift'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _startShift() async {
    setState(() {
      _isLoading = true;
    });

    final userId = ProxyService.box.getUserId();
    final openingBalance = double.tryParse(_openingBalanceController.text) ?? 0.0;

    if (userId != null) {
      try {
        await ProxyService.strategy.startShift(
          userId: userId,
          openingBalance: openingBalance,
        );
        widget.completer(DialogResponse(confirmed: true));
      } catch (e) {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start shift: $e')),
        );
        widget.completer(DialogResponse(confirmed: false));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in.')),
      );
      widget.completer(DialogResponse(confirmed: false));
      setState(() {
        _isLoading = false;
      });
    }
  }
}
