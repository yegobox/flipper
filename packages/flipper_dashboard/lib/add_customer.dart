// ignore_for_file: unused_result

library flipper_login;

import 'package:email_validator/email_validator.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

final isWindows = UniversalPlatform.isWindows;

class AddCustomer extends StatefulHookConsumerWidget {
  // Not const: avoids hot-reload crashes when new fields are added to mounted
  // widgets (null bool → "Null is not a subtype of type bool").
  AddCustomer({
    Key? key,
    required this.transactionId,
    this.searchedKey,
    this.customer,
    bool showSheetHandle = true,
    bool panelMode = false,
    this.onCompleted,
    this.onDismissed,
  })  : _showSheetHandle = showSheetHandle,
        _panelMode = panelMode,
        super(key: key);

  final String transactionId;
  final String? searchedKey;
  final Customer? customer;

  /// Nullable storage so hot-reload of older instances cannot throw on read.
  final bool? _showSheetHandle;
  final bool? _panelMode;

  bool get showSheetHandle => _showSheetHandle ?? true;

  /// Side panel layout: scrollable fields + pinned save button (no empty gap).
  bool get panelMode => _panelMode ?? false;

  /// Called with a success message instead of [Navigator.pop] when set
  /// (used by the Customers desktop side panel).
  final ValueChanged<String>? onCompleted;

  /// Close without saving (panel X / cancel). Defaults to [Navigator.pop].
  final VoidCallback? onDismissed;

  @override
  AddCustomerState createState() => AddCustomerState();
}

class AddCustomerState extends ConsumerState<AddCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tinNumberController = TextEditingController();

  String selectedCustomerTypeValue = 'Individual';
  bool isLoading = false;

  bool get _isBusiness => selectedCustomerTypeValue == 'Business';

  bool isEmail(String? s) {
    if (s == null || s.isEmpty) {
      return false;
    }
    return EmailValidator.validate(s);
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.custNm!;
      _phoneController.text = widget.customer!.telNo!;
      _emailController.text = widget.customer!.email ?? '';
      _tinNumberController.text = widget.customer!.custTin ?? '';
      selectedCustomerTypeValue = widget.customer!.customerType ?? 'Individual';
    } else {
      if (isNumeric(widget.searchedKey)) {
        _phoneController.text = widget.searchedKey!;
      }
      if (!isNumeric(widget.searchedKey) && !isEmail(widget.searchedKey)) {
        _nameController.text = widget.searchedKey ?? '';
      }
      if (isEmail(widget.searchedKey)) {
        _emailController.text = widget.searchedKey!;
      }
    }
    for (final c in [
      _nameController,
      _phoneController,
      _emailController,
      _tinNumberController,
    ]) {
      c.addListener(_onFieldsChanged);
    }
  }

  void _onFieldsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _phoneController,
      _emailController,
      _tinNumberController,
    ]) {
      c.removeListener(_onFieldsChanged);
      c.dispose();
    }
    super.dispose();
  }

  String get _previewTitle {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) return name;
    return _isBusiness ? 'New business' : 'New customer';
  }

  String get _previewSubtitle {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) return phone;
    return 'No phone yet';
  }

  String get _previewInitials {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) return mposAbbreviation(name);
    return 'NC';
  }

  void _dismiss() {
    if (widget.onDismissed != null) {
      widget.onDismissed!();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _complete(String message) {
    if (widget.onCompleted != null) {
      widget.onCompleted!(message);
    } else {
      Navigator.of(context).pop(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        final header = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showSheetHandle) ...[
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PosTokens.lineStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ] else
              const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit customer' : 'New customer',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: PosTokens.ink1,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _dismiss,
                    style: IconButton.styleFrom(
                      backgroundColor: PosTokens.surface2,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ],
        );

        final fields = Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PreviewCard(
                  initials: _previewInitials,
                  title: _previewTitle,
                  subtitle: _previewSubtitle,
                  color: mposColorForName(_previewTitle),
                ),
                const SizedBox(height: 18),
                const _FieldLabel('Customer type'),
                const SizedBox(height: 8),
                _CustomerTypeToggle(
                  isBusiness: _isBusiness,
                  onChanged: (business) {
                    setState(() {
                      selectedCustomerTypeValue =
                          business ? 'Business' : 'Individual';
                    });
                  },
                ),
                const SizedBox(height: 16),
                _CustomerFormField(
                  label: _isBusiness ? 'Business name' : 'Full name',
                  controller: _nameController,
                  hint: _isBusiness
                      ? 'e.g. Kigali Traders Ltd'
                      : 'e.g. Jean Mukamana',
                  icon: _isBusiness
                      ? Icons.storefront_outlined
                      : Icons.person_outline_rounded,
                  validator: (value) =>
                      validatePartyName(value, isBusiness: _isBusiness),
                ),
                const SizedBox(height: 14),
                _CustomerFormField(
                  label: 'Phone number',
                  controller: _phoneController,
                  hint: '07XX XXX XXX',
                  icon: Icons.smartphone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: validatePartyPhone,
                ),
                const SizedBox(height: 14),
                _CustomerFormField(
                  label: 'Email address',
                  optional: true,
                  controller: _emailController,
                  hint: 'name@email.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: validatePartyEmail,
                ),
                const SizedBox(height: 14),
                _CustomerFormField(
                  label: 'TIN number',
                  optional: true,
                  controller: _tinNumberController,
                  hint: 'Tax ID for invoices',
                  icon: Icons.tag_outlined,
                  keyboardType: TextInputType.number,
                  validator: validatePartyTin,
                ),
              ],
            ),
          ),
        );

        final saveButton = Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: SizedBox(
            width: double.infinity,
            height: MposTokens.checkoutPrimaryHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isLoading ? null : MposTokens.gradBtn,
                color: isLoading ? PosTokens.ink4 : null,
                borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                boxShadow: isLoading ? null : MposTokens.shadowBlue,
              ),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() => isLoading = true);
                        try {
                          await model.addCustomer(
                            id: widget.customer?.id,
                            customerType: selectedCustomerTypeValue,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            name: _nameController.text,
                            tinNumber: _tinNumberController.text,
                            transactionId: widget.transactionId,
                          );
                          ref.invalidate(customersProvider);
                          model.getTransactionById();
                          if (!context.mounted) return;
                          _complete(
                            isEditing
                                ? 'Customer updated successfully!'
                                : 'Customer added and attached',
                          );
                        } catch (e) {
                          if (mounted) {
                            showCustomSnackBarUtil(
                              context,
                              e.toString().isNotEmpty
                                  ? e.toString()
                                  : 'Failed to add customer',
                              backgroundColor: Colors.red,
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isEditing
                                ? 'Save changes'
                                : 'Add & attach customer',
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );

        final padded = Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: widget.panelMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header,
                    Expanded(child: SingleChildScrollView(child: fields)),
                    saveButton,
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [header, fields, saveButton],
                  ),
                ),
        );

        // Scaffold only for snackbar host; panelMode fills the side column.
        return Scaffold(
          backgroundColor: PosTokens.surface,
          resizeToAvoidBottomInset: true,
          body: padded,
        );
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String initials;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: PosTokens.ink3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.optional = false});

  final String text;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink1,
            ),
          ),
          if (optional)
            const TextSpan(
              text: ' · optional',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: PosTokens.ink3,
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomerTypeToggle extends StatelessWidget {
  const _CustomerTypeToggle({
    required this.isBusiness,
    required this.onChanged,
  });

  final bool isBusiness;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeOption(
            label: 'Individual',
            icon: Icons.person_outline_rounded,
            selected: !isBusiness,
            onTap: () => onChanged(false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TypeOption(
            label: 'Business',
            icon: Icons.apartment_outlined,
            selected: isBusiness,
            onTap: () => onChanged(true),
          ),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? PosTokens.blueTint : PosTokens.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? PosTokens.blue : PosTokens.line,
            width: selected ? 1.5 : 1,
          ),
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? PosTokens.blue : PosTokens.ink3,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? PosTokens.blue : PosTokens.ink2,
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _CustomerFormField extends StatelessWidget {
  const _CustomerFormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.optional = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool optional;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, optional: optional),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: PosTokens.ink1,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: PosTokens.ink4,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, size: 20, color: PosTokens.ink3),
            filled: true,
            fillColor: PosTokens.surface,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.loss),
            ),
          ),
        ),
      ],
    );
  }
}
