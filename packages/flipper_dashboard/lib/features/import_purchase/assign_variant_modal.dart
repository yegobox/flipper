import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'import_purchase_ui.dart';
import 'ipm_variant_combo.dart';

enum IpmPurchaseMappingMode { createNew, mapExisting }

class IpmPurchaseMappingResult {
  const IpmPurchaseMappingResult({
    required this.mode,
    required this.name,
    required this.supplyPrice,
    required this.retailPrice,
    this.catalogVariant,
  });

  final IpmPurchaseMappingMode mode;
  final String name;
  final double supplyPrice;
  final double retailPrice;
  final Variant? catalogVariant;
}

class IpmPurchaseMappingSaveResult {
  const IpmPurchaseMappingSaveResult({
    required this.success,
    this.createdItemCd,
    this.closeModal = true,
    this.message,
  });

  final bool success;
  final String? createdItemCd;
  final bool closeModal;
  final String? message;
}

Future<void> showIpmAssignVariantModal(
  BuildContext context, {
  required Variant item,
  required IpmPurchaseMappingMode initialMode,
  required Future<IpmPurchaseMappingSaveResult> Function(
    IpmPurchaseMappingResult result,
  ) onSave,
  String? initialCatalogVariantId,
  String? initialItemCd,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _AssignVariantModalBody(
          item: item,
          initialMode: initialMode,
          initialCatalogVariantId: initialCatalogVariantId,
          initialItemCd: initialItemCd,
          onSave: onSave,
          onClose: () => Navigator.of(dialogContext).pop(),
        ),
      );
    },
  );
}

class _AssignVariantModalBody extends StatefulWidget {
  const _AssignVariantModalBody({
    required this.item,
    required this.initialMode,
    required this.onSave,
    required this.onClose,
    this.initialCatalogVariantId,
    this.initialItemCd,
  });

  final Variant item;
  final IpmPurchaseMappingMode initialMode;
  final String? initialCatalogVariantId;
  final String? initialItemCd;
  final Future<IpmPurchaseMappingSaveResult> Function(
    IpmPurchaseMappingResult result,
  ) onSave;
  final VoidCallback onClose;

  @override
  State<_AssignVariantModalBody> createState() => _AssignVariantModalBodyState();
}

class _AssignVariantModalBodyState extends State<_AssignVariantModalBody> {
  late IpmPurchaseMappingMode _mode;
  late final TextEditingController _nameController;
  late final TextEditingController _supplyController;
  late final TextEditingController _retailController;
  String? _selectedCatalogVariantId;
  Variant? _selectedCatalogVariant;
  String? _displayItemCd;
  bool _saving = false;
  bool _showDoneOnly = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _selectedCatalogVariantId = widget.initialCatalogVariantId;
    _displayItemCd = widget.initialItemCd;
    _nameController = TextEditingController(text: widget.item.name);
    _supplyController = TextEditingController(
      text: widget.item.supplyPrice?.toString() ?? '',
    );
    _retailController = TextEditingController(
      text: widget.item.retailPrice?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _supplyController.dispose();
    _retailController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_saving) return false;
    if (_mode == IpmPurchaseMappingMode.mapExisting &&
        (_selectedCatalogVariantId == null ||
            _selectedCatalogVariantId!.isEmpty)) {
      return false;
    }
    final name = _nameController.text.trim();
    final supply = double.tryParse(_supplyController.text);
    final retail = double.tryParse(_retailController.text);
    return name.isNotEmpty &&
        supply != null &&
        supply > 0 &&
        retail != null &&
        retail > 0;
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    try {
      final result = await widget.onSave(
        IpmPurchaseMappingResult(
          mode: _mode,
          name: _nameController.text.trim(),
          supplyPrice: double.parse(_supplyController.text),
          retailPrice: double.parse(_retailController.text),
          catalogVariant: _mode == IpmPurchaseMappingMode.mapExisting
              ? (_selectedCatalogVariant ??
                  Variant(
                    id: _selectedCatalogVariantId!,
                    name: _nameController.text.trim(),
                    branchId: widget.item.branchId,
                  ))
              : null,
        ),
      );
      if (!mounted) return;
      if (!result.success) return;
      if (result.createdItemCd != null && result.createdItemCd!.isNotEmpty) {
        setState(() {
          _displayItemCd = result.createdItemCd;
          _showDoneOnly = true;
        });
      }
      if (result.closeModal) {
        widget.onClose();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _copyItemCd() {
    final code = _displayItemCd;
    if (code == null || code.isEmpty) return;
    Clipboard.setData(ClipboardData(text: code));
    showImportPurchaseToast(context, 'Item code copied');
  }

  @override
  Widget build(BuildContext context) {
    return IpmModalShell(
      title: 'Map purchase line',
      subtitle: widget.item.name,
      icon: Icons.local_offer_outlined,
      maxWidth: 440,
      showBackdrop: false,
      onClose: widget.onClose,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_displayItemCd != null && _displayItemCd!.isNotEmpty) ...[
              const IpmFieldLabel('RRA item code'),
              IpmCopyableValue(
                value: _displayItemCd!,
                onCopy: _copyItemCd,
              ),
              const SizedBox(height: 14),
            ],
            IpmChoiceOption(
              selected: _mode == IpmPurchaseMappingMode.createNew,
              icon: Icons.add_circle_outline,
              title: 'Create new variant',
              description:
                  'Creates a catalog item now and maps this purchase line to it.',
              onTap: () => setState(() => _mode = IpmPurchaseMappingMode.createNew),
            ),
            const SizedBox(height: 10),
            IpmChoiceOption(
              selected: _mode == IpmPurchaseMappingMode.mapExisting,
              icon: Icons.merge_type,
              title: 'Map to existing variant',
              description: 'Adds this quantity to a variant you already stock.',
              onTap: () => setState(() => _mode = IpmPurchaseMappingMode.mapExisting),
            ),
            if (_mode == IpmPurchaseMappingMode.mapExisting) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFE8ECF2)),
              const SizedBox(height: 14),
              const IpmFieldLabel('Existing variant'),
              IpmVariantCombo(
                selectedVariantId: _selectedCatalogVariantId,
                placeholder: 'Select a variant…',
                onSelected: (catalog) {
                  setState(() {
                    _selectedCatalogVariant = catalog;
                    _selectedCatalogVariantId = catalog?.id;
                    _displayItemCd = catalog?.itemCd;
                    if (catalog != null && _nameController.text.trim().isEmpty) {
                      _nameController.text = catalog.name;
                    }
                  });
                },
              ),
            ],
            const SizedBox(height: 14),
            const IpmFieldLabel('Name'),
            IpmTextField(controller: _nameController, onChanged: (_) => setState(() {})),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IpmFieldLabel('Supply Price'),
                      IpmTextField(
                        controller: _supplyController,
                        numeric: true,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IpmFieldLabel('Retail Price'),
                      IpmTextField(
                        controller: _retailController,
                        numeric: true,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IpmButton(
            label: 'Cancel',
            variant: IpmButtonVariant.ghost,
            onPressed: _saving ? null : widget.onClose,
          ),
          const SizedBox(width: 10),
          IpmButton(
            label: _saving
                ? 'Creating…'
                : (_showDoneOnly ? 'Done' : 'Save mapping'),
            icon: Icons.check,
            onPressed: _showDoneOnly
                ? widget.onClose
                : (_canSave ? _save : null),
          ),
        ],
      ),
    );
  }
}
