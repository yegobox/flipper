import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';

/// SAP Fiori-inspired Smart Form widget for work orders
///
/// A form to create or edit work orders with material selection,
/// planned quantity, target date, and notes.
class WorkOrderForm extends ConsumerStatefulWidget {
  final String? workOrderId;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 0 : 24),
      decoration: isMobile
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (only show on desktop, mobile has bottom sheet header)
            if (!isMobile) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isEdit ? Icons.edit_outlined : Icons.add_circle_outline,
                        color: Colors.blue[700],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Edit Work Order' : 'Create Work Order',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Plan production output for your products',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.onCancel != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: widget.onCancel,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Form fields in a responsive layout
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 20,
                children: [
                  // Product/Variant selection
                  SizedBox(
                    width: isMobile ? double.infinity : 300,
                    child: _buildProductField(),
                  ),
                  // Planned Quantity
                  SizedBox(
                    width: isMobile ? double.infinity : 200,
                    child: _buildQuantityField(),
                  ),
                  // Target Date
                  SizedBox(
                    width: isMobile ? double.infinity : 200,
                    child: _buildDateField(context),
                  ),
                  // Shift (optional)
                  SizedBox(
                    width: isMobile ? double.infinity : 200,
                    child: _buildShiftField(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Notes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: _buildNotesField(),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onCancel != null && !isMobile)
                    TextButton(
                      onPressed: widget.onCancel,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  if (!isMobile) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        elevation: 2,
                        shadowColor: Colors.blue.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isEdit ? Icons.check : Icons.add,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  isEdit
                                      ? 'Update Work Order'
                                      : 'Create Work Order',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
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
          // only deal with raw material
          // itemTyCd: '1',
          taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
        );
        return paged.variants.cast<Variant>().toList();
      },
      itemBuilder: (context, Variant variant) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.blue[700],
                size: 20,
              ),
            ),
            title: Text(
              variant.name,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'SKU: ${variant.sku ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            dense: true,
          ),
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
                labelStyle: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
                ),
                filled: true,
                fillColor: Colors.blue[50],
                contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Chip(
                          avatar: Icon(
                            Icons.check_circle,
                            color: Colors.blue[700],
                            size: 18,
                          ),
                          label: Text(
                            _selectedVariant!.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: Colors.white,
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
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Product/Material *',
            hintText: 'Search product',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.inventory_2_outlined,
              color: Colors.blue[700],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (_selectedVariantId == null) {
              return 'Please select a product';
            }
            return null;
          },
        );
      },
      emptyBuilder: (context) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
              SizedBox(height: 8),
              Text(
                'No products found',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _plannedQtyController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: 'Planned Quantity *',
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintText: '0',
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixText: 'units',
        suffixStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Icons.numbers, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        child: Text(
          '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildShiftField() {
    return DropdownButtonFormField<String>(
      value: _selectedShift,
      decoration: InputDecoration(
        labelText: 'Shift (Optional)',
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(Icons.access_time, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Notes',
        labelStyle: TextStyle(color: Colors.grey[700]),
        hintText: 'Additional instructions or comments...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 48),
          child: Icon(Icons.notes, color: Colors.blue[700]),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate() && _selectedVariantId != null) {
      setState(() {
        _isSubmitting = true;
      });

      final data = {
        'variantId': _selectedVariantId,
        'variantName': _selectedVariant?.name,
        'plannedQuantity': double.parse(_plannedQtyController.text),
        'targetDate': _targetDate,
        'shiftId': _selectedShift,
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
      };

      try {
        await widget.onSubmit?.call(data);
      } catch (e) {
        // Optionally handle/report errors here
        print('Error submitting work order: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
}
