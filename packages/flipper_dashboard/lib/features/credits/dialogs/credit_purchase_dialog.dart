import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/credits/widgets/credit_purchase_widget.dart';

class CreditPurchaseDialog extends StatelessWidget {
  final VoidCallback? onPaymentSuccess;

  const CreditPurchaseDialog({Key? key, this.onPaymentSuccess})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 0, right: 0),
                child: CreditPurchaseWidget(
                  onPaymentSuccess: () {
                    onPaymentSuccess?.call();
                    // Optional: Close this dialog on success, or let user close it via the status dialog
                    // For now, keeping it open to show the CreditWidget underneath might be redundant if the Widget has its own visual.
                    // But CreditPurchaseWidget has its own container style.
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
