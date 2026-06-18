import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/supplier.model.dart';

Future<Supplier?> showNewSupplierModal(
  BuildContext context,
  WidgetRef ref, {
  String initialName = '',
  bool useImportPurchaseTheme = false,
}) {
  return showDialog<Supplier>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => _NewSupplierDialog(
      initialName: initialName,
      useImportPurchaseTheme: useImportPurchaseTheme,
    ),
  );
}

class _NewSupplierDialog extends ConsumerStatefulWidget {
  const _NewSupplierDialog({
    required this.initialName,
    required this.useImportPurchaseTheme,
  });

  final String initialName;
  final bool useImportPurchaseTheme;

  @override
  ConsumerState<_NewSupplierDialog> createState() => _NewSupplierDialogState();
}

class _NewSupplierDialogState extends ConsumerState<_NewSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _tinController;
  late final TextEditingController _phoneController;
  bool _saving = false;

  Color get _accent => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.accent
      : const Color(0xFF0097A7);
  Color get _labelColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.ink2
      : const Color(0xFF374151);
  Color get _hintColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.faint
      : const Color(0xFF9CA3AF);
  Color get _borderColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.line2
      : const Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _tinController = TextEditingController();
    _phoneController = TextEditingController();
    for (final c in [_nameController, _tinController, _phoneController]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _nameController.text.trim().isNotEmpty && !_saving;

  InputDecoration _decoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _hintColor, fontSize: 15),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accent, width: 1.5),
        ),
      );

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final tinError = validatePartyTin(_tinController.text);
    if (tinError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tinError)));
      return;
    }

    setState(() => _saving = true);
    final supplier = await ref.read(manualPurchaseProvider.notifier).createSupplier(
          name: _nameController.text.trim(),
          tin: _tinController.text.trim(),
          phone: _phoneController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (supplier != null) {
      Navigator.of(context).pop(supplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ImportPurchaseTokens.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ImportPurchaseTokens.accentWash,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.store_outlined,
                        color: _accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New supplier',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: _labelColor,
                            ),
                          ),
                          Text(
                            'Created without leaving this purchase',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: _hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 20),
                      color: _hintColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Supplier name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _labelColor,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: _decoration(hint: 'e.g. Acme Distributors Ltd'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TIN (optional)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _labelColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _tinController,
                            keyboardType: TextInputType.number,
                            decoration: _decoration(hint: '1000123456'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone (optional)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _labelColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _decoration(hint: '+250 7...'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _canSubmit ? _submit : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        disabledBackgroundColor: _borderColor,
                      ),
                      icon: _saving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: const Text('Create & select'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
