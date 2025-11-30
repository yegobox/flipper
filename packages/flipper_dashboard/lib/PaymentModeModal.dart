//PaymentModeModal.dart
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';

class PaymentModeModal extends StatefulWidget {
  final List<FinanceProvider> financeProviders;
  final Future<void> Function(String) onPaymentModeSelected;

  const PaymentModeModal({
    required this.financeProviders,
    required this.onPaymentModeSelected,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentModeModalState createState() => _PaymentModeModalState();
}

class _PaymentModeModalState extends State<PaymentModeModal> {
  String? _selectedPaymentMode;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text(
        'Select Payment Mode',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Finance Providers
            RadioGroup<String>(
              groupValue: _selectedPaymentMode,
              onChanged: (value) {
                setState(() => _selectedPaymentMode = value);
              },
              child: Column(
                children: widget.financeProviders.map((provider) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: RadioListTile<String>(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(provider.name),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Credit (${provider.interestRate}%)',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value: provider.id,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlipperButtonFlat(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        FlipperButton(
          onPressed: _isProcessing
              ? null
              : () async {
                  if (_selectedPaymentMode != null) {
                    setState(() {
                      _isProcessing = true;
                    });
                    try {
                      await widget.onPaymentModeSelected(_selectedPaymentMode!);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      debugPrint('Payment processing error: $e');
                      if (mounted) {
                        showErrorNotification(context, 'Payment failed');
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isProcessing = false;
                        });
                      }
                    }
                  } else {
                    showWarningNotification(
                      context,
                      'Please select a payment mode',
                    );
                  }
                },
          text: _isProcessing ? 'Processing...' : 'Confirm',
          textColor: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}

Future<void> showPaymentModeModal(
  BuildContext context,
  Future<void> Function(FinanceProvider) onPaymentModeSelected,
) async {
  // Fetch finance providers using ProxyService.strategy
  final financeProviders = await ProxyService.strategy.financeProviders();

  showDialog(
    context: context,
    builder: (context) {
      return PaymentModeModal(
        financeProviders: financeProviders,
        onPaymentModeSelected: (selectedMode) async {
          final selectedProvider = financeProviders.firstWhere(
            (provider) => provider.id == selectedMode,
          );
          await onPaymentModeSelected(selectedProvider);
        },
      );
    },
  );
}
