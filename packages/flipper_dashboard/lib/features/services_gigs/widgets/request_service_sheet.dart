import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom-sheet content: pick an offered service (if listed), describe the job, submit request.
class RequestServiceSheet extends StatefulWidget {
  final ServiceGigProvider provider;

  const RequestServiceSheet({Key? key, required this.provider})
    : super(key: key);

  @override
  State<RequestServiceSheet> createState() => _RequestServiceSheetState();
}

class _RequestServiceSheetState extends State<RequestServiceSheet> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _amountController = TextEditingController();
  final _repo = ServiceGigRequestRepository();

  String? _selectedService;
  bool _submitting = false;

  ServiceGigProvider get _p => widget.provider;

  @override
  void initState() {
    super.initState();
    final services = _p.services
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (services.length == 1) {
      _selectedService = services.first;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final services = _p.services
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (services.isNotEmpty &&
        (_selectedService == null || _selectedService!.isEmpty)) {
      showWarningNotification(context, context.flipperL10n.gigsChooseService);
      return;
    }

    final rawAmount = _amountController.text.replaceAll(RegExp(r'[\s,]'), '');
    final amount = int.tryParse(rawAmount);
    if (amount == null || amount < 100) {
      showWarningNotification(context, context.flipperL10n.gigsErrMinAmount);
      return;
    }

    setState(() => _submitting = true);
    try {
      await _repo.createRequest(
        providerUserId: _p.userId,
        requestedService: _selectedService,
        customerMessage: _messageController.text,
        paymentAmountRwf: amount,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ServiceGigRequestException catch (e) {
      if (!mounted) return;
      showErrorNotification(context, e.message);
    } catch (e) {
      if (!mounted) return;
      showErrorNotification(
        context,
        context.flipperL10n.gigsSomethingWentWrong,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final services = _p.services
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

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
                _p.displayName,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_p.serviceArea != null && _p.serviceArea!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _p.serviceArea!,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                _p.bio,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.45,
                  color: Colors.grey.shade800,
                ),
              ),
              if (services.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  context.flipperL10n.gigsWhichService,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: services.map((s) {
                    final selected = _selectedService == s;
                    return FilterChip(
                      label: Text(s, style: GoogleFonts.outfit(fontSize: 13)),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedService = selected ? null : s;
                        });
                      },
                      selectedColor: const Color(
                        0xFF0D9488,
                      ).withValues(alpha: 0.25),
                      checkmarkColor: const Color(0xFF0D9488),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                context.flipperL10n.gigsAmountYouWillPay,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.outfit(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'e.g. 5000',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF0D9488),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
                validator: (v) {
                  final t = v?.replaceAll(RegExp(r'[\s,]'), '') ?? '';
                  final n = int.tryParse(t);
                  if (n == null || n < 100) {
                    return context.flipperL10n.gigsMinimum100Rwf;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Text(
                context.flipperL10n.gigsDescribeNeed,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                minLines: 3,
                style: GoogleFonts.outfit(fontSize: 15),
                decoration: InputDecoration(
                  hintText: context.flipperL10n.gigsDescribeNeedExample,
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF0D9488),
                      width: 2,
                    ),
                  ),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.length < 20) {
                    return context.flipperL10n.gigsErrMoreDetail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                context.flipperL10n.gigsProviderHas30Min,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  height: 1.35,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.flipperL10n.gigsSendRequest,
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      ),
              ),
              TextButton(
                onPressed: _submitting
                    ? null
                    : () => Navigator.of(context).pop(false),
                child: Text(
                  context.flipperL10n.cancel,
                  style: GoogleFonts.outfit(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
