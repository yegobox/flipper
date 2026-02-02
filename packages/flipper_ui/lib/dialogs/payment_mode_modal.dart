import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// Helper to show the dialog in WoltModalSheet style
Future<void> showPaymentModeModal({
  required BuildContext context,
  required Future<void> Function(FinanceProvider) onPaymentModeSelected,
}) async {
  // Fetch finance providers using ProxyService.strategy
  final financeProviders = await ProxyService.strategy.financeProviders();

  if (!context.mounted) return;

  final formKey = GlobalKey<PaymentModeFormState>();

  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        _buildPaymentModePage(
            context, financeProviders, onPaymentModeSelected, formKey),
      ];
    },
    modalTypeBuilder: (context) => WoltModalType.dialog(),
  );
}

/// The Sliver Page for WoltModalSheet
SliverWoltModalSheetPage _buildPaymentModePage(
  BuildContext context,
  List<FinanceProvider> financeProviders,
  Future<void> Function(FinanceProvider) onPaymentModeSelected,
  GlobalKey<PaymentModeFormState> formKey,
) {
  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    pageTitle: Container(
      padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF01B8E4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.payment_rounded,
                color: Color(0xFF01B8E4), size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            'Select Payment Mode',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ],
      ),
    ),
    mainContentSliversBuilder: (_) => [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: 120.0,
          ),
          child: PaymentModeForm(
            key: formKey,
            financeProviders: financeProviders,
            onPaymentModeSelected: onPaymentModeSelected,
          ),
        ),
      ),
    ],
    stickyActionBar: Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 56),
                side: const BorderSide(color: Color(0xFFE1E2E4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF42474E),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => formKey.currentState?.submit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01B8E4),
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 56),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Confirm',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PaymentModeForm extends StatefulWidget {
  final List<FinanceProvider> financeProviders;
  final Future<void> Function(FinanceProvider) onPaymentModeSelected;

  const PaymentModeForm({
    Key? key,
    required this.financeProviders,
    required this.onPaymentModeSelected,
  }) : super(key: key);

  @override
  PaymentModeFormState createState() => PaymentModeFormState();
}

class PaymentModeFormState extends State<PaymentModeForm> {
  String? _selectedPaymentMode;
  bool _isProcessing = false;

  Future<void> submit() async {
    if (_isProcessing) return;

    if (_selectedPaymentMode != null) {
      if (mounted) setState(() => _isProcessing = true);
      try {
        final selectedProvider = widget.financeProviders.firstWhere(
          (provider) => provider.id == _selectedPaymentMode,
        );
        await widget.onPaymentModeSelected(selectedProvider);
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isProcessing)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFFF1F4F9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF01B8E4)),
              minHeight: 2,
            ),
          ),
        Text(
          'Select Financing Option',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF42474E),
          ),
        ),
        const SizedBox(height: 16),
        ...widget.financeProviders.map((provider) {
          final isSelected = _selectedPaymentMode == provider.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: _isProcessing
                  ? null
                  : () => setState(() => _selectedPaymentMode = provider.id),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF01B8E4).withValues(alpha: 0.05)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF01B8E4)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF01B8E4)
                              : const Color(0xFF74777F),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF01B8E4),
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name,
                            style: GoogleFonts.poppins(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 16,
                              color: const Color(0xFF1A1C1E),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Interest: ${provider.interestRate}%',
                              style: GoogleFonts.poppins(
                                color: Colors.orange.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
