import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Smart Form widget for work orders
///
/// A form to create or edit work orders with material selection,
/// planned quantity, target date, and notes.
class WorkOrderForm extends ConsumerStatefulWidget {
  final String? workOrderId;
  final Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onCancel;

  const WorkOrderForm({
    Key? key,
    this.workOrderId,
    this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  ConsumerState<WorkOrderForm> createState() => _WorkOrderFormState();
}

class _WorkOrderFormState extends ConsumerState<WorkOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _plannedQtyController = TextEditingController();
  final _notesController = TextEditingController();
  TextEditingController? _typeAheadController;

  String? _selectedVariantId;
  Variant? _selectedVariant;
  DateTime _targetDate = DateTime.now();
  String? _selectedShift;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _plannedQtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.workOrderId != null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isEdit ? Icons.edit : Icons.add_circle_outline,
                  color: Color(VarianceColors.neutral),
                ),
                const SizedBox(width: 8),
                Text(
                  isEdit ? 'Edit Work Order' : 'Create Work Order',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (widget.onCancel != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onCancel,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Form fields in a responsive layout
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Product/Variant selection
                SizedBox(width: 300, child: _buildProductField()),
                // Planned Quantity
                SizedBox(width: 200, child: _buildQuantityField()),
                // Target Date
                SizedBox(width: 200, child: _buildDateField(context)),
                // Shift (optional)
                SizedBox(width: 200, child: _buildShiftField()),
              ],
            ),
            const SizedBox(height: 16),
            // Notes
            _buildNotesField(),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(VarianceColors.neutral),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(isEdit ? 'Update' : 'Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductField() {
    return TypeAheadField<Variant>(
      suggestionsCallback: (search) async {
        if (search.isEmpty) return [];
        final branchId = ProxyService.box.getBranchId();
        if (branchId == null) return [];

        final paged = await ProxyService.getStrategy(Strategy.capella).variants(
          name: search.toLowerCase(),
          fetchRemote: true,
          branchId: branchId,
          page: 0,
          itemsPerPage: 50,
          taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
        );
        return paged.variants.cast<Variant>().toList();
      },
      itemBuilder: (context, Variant variant) {
        return ListTile(
          title: Text(variant.name),
          subtitle: Text('SKU: ${variant.sku ?? 'N/A'}'),
          dense: true,
        );
      },
      onSelected: (Variant variant) {
        setState(() {
          _typeAheadController?.text = variant.name;
          _selectedVariantId = variant.id;
          _selectedVariant = variant;
        });
      },
      builder: (context, controller, focusNode) {
        _typeAheadController = controller;
        if (_selectedVariant != null) {
          return InkWell(
            onTap: () {
              // Optional: expand if needed, but chip usually implies selection is done
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Product/Material *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Chip(
                          label: Text(_selectedVariant!.name),
                          backgroundColor: Colors.blue.shade100,
                          deleteIcon: Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              _selectedVariant = null;
                              _selectedVariantId = null;
                              controller.text = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (text) {
            setState(() {
              _selectedVariantId = null;
              _selectedVariant = null;
            });
          },
          decoration: InputDecoration(
            labelText: 'Product/Material *',
            hintText: 'Search product',
            prefixIcon: const Icon(Icons.inventory_2_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (_selectedVariantId == null) {
              return 'Please select a product';
            }
            return null;
          },
        );
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No products found', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _plannedQtyController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Planned Quantity *',
        hintText: '0',
        suffixText: 'units',
        prefixIcon: const Icon(Icons.numbers),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Invalid quantity';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Target Date *',
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        child: Text(
          '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}',
        ),
      ),
    );
  }

  Widget _buildShiftField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedShift,
      decoration: InputDecoration(
        labelText: 'Shift (Optional)',
        prefixIcon: const Icon(Icons.access_time),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: const [
        DropdownMenuItem(value: 'morning', child: Text('Morning')),
        DropdownMenuItem(value: 'afternoon', child: Text('Afternoon')),
        DropdownMenuItem(value: 'night', child: Text('Night')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedShift = value;
        });
      },
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Notes',
        hintText: 'Additional instructions or comments...',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 48),
          child: Icon(Icons.notes),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedVariantId != null) {
      setState(() {
        _isSubmitting = true;
      });

      final data = {
        'variantId': _selectedVariantId,
        'plannedQuantity': double.parse(_plannedQtyController.text),
        'targetDate': _targetDate,
        'shiftId': _selectedShift,
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
      };

      widget.onSubmit?.call(data);

      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
