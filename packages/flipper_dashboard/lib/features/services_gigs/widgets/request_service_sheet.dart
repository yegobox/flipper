import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_request_repository.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom-sheet content: pick an offered service (if listed), describe the job, submit request.
class RequestServiceSheet extends StatefulWidget {
  final ServiceGigProvider provider;

  const RequestServiceSheet({Key? key, required this.provider}) : super(key: key);

  @override
  State<RequestServiceSheet> createState() => _RequestServiceSheetState();
}

class _RequestServiceSheetState extends State<RequestServiceSheet> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _repo = ServiceGigRequestRepository();

  String? _selectedService;
  bool _submitting = false;

  ServiceGigProvider get _p => widget.provider;

  @override
  void initState() {
    super.initState();
    final services = _p.services.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (services.length == 1) {
      _selectedService = services.first;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final services = _p.services.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (services.isNotEmpty && (_selectedService == null || _selectedService!.isEmpty)) {
      showWarningNotification(context, 'Choose which service you need.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await _repo.createRequest(
        providerUserId: _p.userId,
        requestedService: _selectedService,
        customerMessage: _messageController.text,
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
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final services = _p.services.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

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
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_p.serviceArea != null && _p.serviceArea!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _p.serviceArea!,
                    style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.45,
                  color: Colors.grey.shade800,
                ),
              ),
              if (services.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  'Which service do you need?',
                  style: GoogleFonts.poppins(
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
                      label: Text(s, style: GoogleFonts.poppins(fontSize: 13)),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedService = selected ? null : s;
                        });
                      },
                      selectedColor:
                          const Color(0xFF0D9488).withValues(alpha: 0.25),
                      checkmarkColor: const Color(0xFF0D9488),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                'Describe what you need',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                minLines: 3,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText:
                      'Example: Fix a leaking kitchen tap this weekend. I am available Saturday morning.',
                  hintStyle: GoogleFonts.poppins(
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
                    return 'Please add a bit more detail (at least 20 characters).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'The provider has 30 minutes to accept. After that, you can send a new request.',
                style: GoogleFonts.poppins(
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
                        'Send request',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
              ),
              TextButton(
                onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
