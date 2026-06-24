import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/manual_purchase/new_supplier_modal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/supplier.model.dart';

typedef SupplierSelectedCallback = void Function(Supplier supplier);
typedef SupplierTextChangedCallback = void Function(String text);
typedef SuppliersChangedCallback = VoidCallback;

class SupplierSearchField extends ConsumerStatefulWidget {
  const SupplierSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suppliers,
    required this.onSupplierSelected,
    required this.onTextChanged,
    required this.onSuppliersChanged,
    this.validator,
    this.useImportPurchaseTheme = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Supplier> suppliers;
  final SupplierSelectedCallback onSupplierSelected;
  final SupplierTextChangedCallback onTextChanged;
  final SuppliersChangedCallback onSuppliersChanged;
  final String? Function(String?)? validator;
  final bool useImportPurchaseTheme;

  @override
  ConsumerState<SupplierSearchField> createState() =>
      _SupplierSearchFieldState();
}

class _SupplierSearchFieldState extends ConsumerState<SupplierSearchField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Color get _accent => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.accent
      : const Color(0xFF0097A7);
  Color get _hintColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.faint
      : const Color(0xFF9CA3AF);
  Color get _borderColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.line2
      : const Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!widget.focusNode.hasFocus) _removeOverlay();
      });
    }
  }

  void _onTextChange() {
    widget.onTextChanged(widget.controller.text);
    _overlayEntry?.markNeedsBuild();
  }

  Iterable<Supplier> _filtered() {
    final query = widget.controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.suppliers.take(20);
    }
    return widget.suppliers.where((s) {
      final name = (s.custNm ?? '').toLowerCase();
      final tin = (s.custTin ?? '').toLowerCase();
      final phone = (s.telNo ?? '').toLowerCase();
      return name.contains(query) || tin.contains(query) || phone.contains(query);
    }).take(20);
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(builder: (context) => _buildOverlay());
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _openCreateModal() async {
    _removeOverlay();
    widget.focusNode.unfocus();
    final created = await showNewSupplierModal(
      context,
      ref,
      initialName: widget.controller.text.trim(),
      useImportPurchaseTheme: widget.useImportPurchaseTheme,
    );
    if (created == null || !mounted) return;
    widget.controller.text = created.custNm ?? '';
    widget.onSupplierSelected(created);
    widget.onSuppliersChanged();
  }

  Widget _buildOverlay() {
    final options = _filtered().toList();
    return Positioned(
      width: 420,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 52),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (options.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No matching suppliers',
                      style: TextStyle(color: _hintColor, fontSize: 14),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final supplier = options[index];
                        final meta = <String>[
                          if (supplier.custTin?.isNotEmpty == true)
                            supplier.custTin!,
                          if (supplier.telNo?.isNotEmpty == true)
                            supplier.telNo!,
                        ].join(' · ');
                        return ListTile(
                          dense: true,
                          title: Text(
                            supplier.custNm ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: meta.isEmpty
                              ? null
                              : Text(
                                  meta,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _hintColor,
                                  ),
                                ),
                          onTap: () {
                            widget.controller.text = supplier.custNm ?? '';
                            widget.onSupplierSelected(supplier);
                            _removeOverlay();
                            widget.focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
                const Divider(height: 1),
                InkWell(
                  onTap: _openCreateModal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: _accent, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Create a new supplier',
                          style: TextStyle(
                            color: _accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: 'Search or enter supplier name',
          hintStyle: TextStyle(color: _hintColor, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: _hintColor, size: 20),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red[300]!),
          ),
        ),
        onTap: () {
          if (_overlayEntry == null) _showOverlay();
        },
      ),
    );
  }
}
