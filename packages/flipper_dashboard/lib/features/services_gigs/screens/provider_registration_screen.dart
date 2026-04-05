import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/models/service_gig_request.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  /// When non-null, form is pre-filled (edit). Hub may still refresh after pop.
  final ServiceGigProvider? initialProfile;

  const ProviderRegistrationScreen({Key? key, this.initialProfile})
    : super(key: key);

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = ServiceGigProviderRepository();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _servicesController = TextEditingController();
  final _areaController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = true;
  bool _submitting = false;
  bool _hasExistingProfile = false;
  DateTime? _preservedCreatedAt;
  final Set<String> _categoryIds = {};

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final userId = ProxyService.box.getUserId();
    ServiceGigProvider? profile = widget.initialProfile;
    profile ??= userId != null ? await _repo.load(userId) : null;

    final phone = profile?.phone ?? ProxyService.box.getUserPhone() ?? '';

    if (mounted) {
      setState(() {
        _hasExistingProfile = profile != null;
        if (profile != null) {
          _preservedCreatedAt = profile.createdAt;
          _displayNameController.text = profile.displayName;
          _bioController.text = profile.bio;
          _servicesController.text = profile.services.join('\n');
          _areaController.text = profile.serviceArea ?? '';
          _phoneController.text = phone;
          _categoryIds
            ..clear()
            ..addAll(profile.serviceCategories);
        } else {
          _phoneController.text = phone;
        }
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _servicesController.dispose();
    _areaController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  List<String> _parseServiceLines() {
    final raw = _servicesController.text;
    final parts = raw.split(RegExp(r'[\n,]+'));
    return parts.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = ProxyService.box.getUserId();
    if (userId == null || userId.isEmpty) {
      if (mounted) {
        showErrorNotification(
          context,
          'You need to be signed in to register as a provider.',
        );
      }
      return;
    }

    final services = _parseServiceLines();
    if (services.isEmpty) {
      showWarningNotification(
        context,
        'Add at least one service you can provide.',
      );
      return;
    }

    setState(() => _submitting = true);

    final profile = ServiceGigProvider(
      userId: userId,
      businessId: ProxyService.box.getBusinessId(),
      branchId: ProxyService.box.getBranchId(),
      displayName: _displayNameController.text.trim(),
      bio: _bioController.text.trim(),
      services: services,
      serviceCategories: _categoryIds.toList(),
      serviceArea: _areaController.text.trim().isEmpty
          ? null
          : _areaController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      createdAt: _preservedCreatedAt ?? widget.initialProfile?.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    final outcome = await _repo.save(profile);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (outcome.synced) {
      showSuccessNotification(context, 'Provider profile saved.');
    } else if (outcome.serverErrorMessage != null &&
        outcome.serverErrorMessage!.isNotEmpty) {
      showErrorNotification(
        context,
        'Could not save online: ${outcome.serverErrorMessage}',
      );
    } else {
      showInfoNotification(
        context,
        'Saved on this device. Will sync when the server is available.',
      );
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final title = _hasExistingProfile
        ? 'Your provider profile'
        : 'Become a provider';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tell customers what you offer. You can update this anytime.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _displayNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _decoration('Display name'),
                      style: GoogleFonts.poppins(fontSize: 15),
                      validator: (v) {
                        final t = v?.trim() ?? '';
                        if (t.length < 2) {
                          return 'Enter a name (at least 2 characters).';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _decoration('Contact phone'),
                      style: GoogleFonts.poppins(fontSize: 15),
                      validator: (v) {
                        final t = v?.trim() ?? '';
                        if (t.isEmpty) {
                          return 'Phone helps customers reach you.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: _decoration('About you'),
                      style: GoogleFonts.poppins(fontSize: 15),
                      validator: (v) {
                        final t = v?.trim() ?? '';
                        if (t.length < 12) {
                          return 'Add a short bio (at least 12 characters).';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Services you provide',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'One per line (e.g. plumbing, home cleaning, delivery).',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _servicesController,
                      maxLines: 6,
                      decoration: _decoration('Services'),
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _areaController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _decoration(
                        'Service area (optional)',
                        hint: 'Neighborhood, city, or radius',
                      ),
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Categories (optional)',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Helps customers filter the directory.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ServiceCategory.defaultCategories.map((c) {
                        final selected = _categoryIds.contains(c.id);
                        return FilterChip(
                          label: Text(
                            c.name,
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              if (selected) {
                                _categoryIds.remove(c.id);
                              } else {
                                _categoryIds.add(c.id);
                              }
                            });
                          },
                          selectedColor: const Color(
                            0xFF0D9488,
                          ).withValues(alpha: 0.25),
                          checkmarkColor: const Color(0xFF0D9488),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
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
                              _hasExistingProfile
                                  ? 'Save changes'
                                  : 'Submit registration',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D9488), width: 2),
      ),
      labelStyle: GoogleFonts.poppins(fontSize: 14),
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
    );
  }
}
