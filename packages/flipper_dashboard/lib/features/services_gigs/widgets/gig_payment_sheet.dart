import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_dashboard/services/payment_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom sheet: MTN MoMo payment for a gig request (customer only).
class GigPaymentSheet extends StatefulWidget {
  final ServiceGigRequest request;
  final String providerLabel;

  const GigPaymentSheet({
    Key? key,
    required this.request,
    required this.providerLabel,
  }) : super(key: key);

  @override
  State<GigPaymentSheet> createState() => _GigPaymentSheetState();
}

class _GigPaymentSheetState extends State<GigPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requestRepo = ServiceGigRequestRepository();
  bool _submitting = false;
  String? _sheetError;

  ServiceGigRequest get _r => widget.request;

  /// Agreed budget from the request; when set, amount field is read-only and submission uses this value.
  bool get _amountLocked => _r.paymentAmountRwf != null;

  @override
  void initState() {
    super.initState();
    final phone = ProxyService.box.getUserPhone();
    if (phone != null && phone.isNotEmpty) {
      _phoneController.text = phone;
    }
    final budget = _r.paymentAmountRwf;
    if (budget != null) {
      _amountController.text = budget.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final int amount;
    if (_amountLocked) {
      amount = _r.paymentAmountRwf!;
    } else {
      final rawAmount =
          _amountController.text.replaceAll(RegExp(r'[\s,]'), '');
      final parsed = int.tryParse(rawAmount);
      if (parsed == null || parsed < 100) {
        showWarningNotification(
          context,
          'Enter an amount of at least 100 RWF.',
        );
        return;
      }
      amount = parsed;
    }
    if (amount < 100) {
      showWarningNotification(
        context,
        'Enter an amount of at least 100 RWF.',
      );
      return;
    }

    final phone = _phoneController.text.trim().replaceAll(RegExp(r'\s'), '');
    if (phone.length < 9) {
      showWarningNotification(
        context,
        'Enter a valid MTN mobile number.',
      );
      return;
    }

    setState(() {
      _submitting = true;
      _sheetError = null;
    });

    final paymentService = PaymentService(context);
    final settlement = await paymentService.waitForPaymentConfirmation(
      phoneNumber: phone,
      finalPrice: amount,
      payerMessage: 'Gig service payment',
    );

    if (!mounted) return;

    if (!settlement.confirmed) {
      const msg =
          'Payment was not confirmed. Approve the MTN prompt on your phone, or try again. '
          'If money left your account, contact support with this request.';
      setState(() {
        _submitting = false;
        _sheetError = msg;
      });
      showErrorNotification(context, msg);
      return;
    }

    try {
      await _requestRepo.markCustomerPaymentComplete(
        requestId: _r.id,
        paymentAmountRwf: amount,
        mtnFinancialTransactionId: settlement.financialTransactionId,
        mtnPaymentReference: settlement.paymentReference.isNotEmpty
            ? settlement.paymentReference
            : null,
        mtnSettledAmountRwf: settlement.settledAmountRwf,
      );
    } on ServiceGigRequestException catch (e) {
      if (!mounted) return;
      const followUp =
          'If money left your wallet, contact support with this request.';
      setState(() {
        _submitting = false;
        _sheetError = '${e.message}\n$followUp';
      });
      showErrorNotification(context, e.message);
      showWarningNotification(context, followUp);
      return;
    } catch (_) {
      if (!mounted) return;
      const msg =
          'Payment may have been sent but we could not update the request.';
      setState(() {
        _submitting = false;
        _sheetError = msg;
      });
      showErrorNotification(context, msg);
      return;
    }

    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: 16 + bottomInset + keyboard,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pay ${widget.providerLabel}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We send an MTN MoMo prompt to the number below. Approve it on your phone; '
                'we wait up to 5 minutes for confirmation before marking this request paid.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                readOnly: _amountLocked,
                enableInteractiveSelection: !_amountLocked,
                keyboardType: TextInputType.number,
                inputFormatters: _amountLocked
                    ? const <TextInputFormatter>[]
                    : [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Amount (RWF)',
                  hintText: _amountLocked ? null : 'e.g. 5000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.payments_outlined),
                  filled: _amountLocked,
                  fillColor:
                      _amountLocked ? Colors.grey.shade100 : null,
                ),
                validator: (v) {
                  if (_amountLocked) {
                    final n = _r.paymentAmountRwf;
                    if (n == null || n < 100) return 'Minimum 100 RWF';
                    return null;
                  }
                  final t = v?.replaceAll(RegExp(r'[\s,]'), '') ?? '';
                  final n = int.tryParse(t);
                  if (n == null || n < 100) {
                    return 'Minimum 100 RWF';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'MTN MoMo number',
                  hintText: '2507XXXXXXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                validator: (v) {
                  final t = v?.trim().replaceAll(RegExp(r'\s'), '') ?? '';
                  if (t.length < 9) return 'Enter your MoMo number';
                  return null;
                },
              ),
              if (_sheetError != null) ...[
                const SizedBox(height: 16),
                Material(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _sheetError!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.35,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _submitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Waiting for payment…',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Send payment request',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
              ),
              TextButton(
                onPressed:
                    _submitting ? null : () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
