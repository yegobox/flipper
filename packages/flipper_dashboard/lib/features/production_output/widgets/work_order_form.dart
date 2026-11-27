import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show FlipperDateField;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';

import '../../../theme/pos_tokens.dart';
import 'production_dialogs.dart';
import 'production_ui.dart';

/// Create (or edit) a work order: product, planned quantity, target date,
/// optional shift and notes.
///
/// Used by the desktop inline form, the phone bottom sheet and the incoming
/// orders "produce" flow; on phones it is drawn without its own card.
class WorkOrderForm extends ConsumerStatefulWidget {
  const WorkOrderForm({
    Key? key,
    this.workOrderId,
    this.onSubmit,
    this.onCancel,
    this.initialVariantId,
    this.initialVariantName,
    this.initialPlannedQuantity,
  }) : super(key: key);

  final String? workOrderId;
  final Future<void> Function(Map<String, dynamic>)? onSubmit;
  final VoidCallback? onCancel;
  final String? initialVariantId;
  final String? initialVariantName;
  final double? initialPlannedQuantity;

  /// Target dates the form accepts: a week back to a year ahead.
  static DateTime firstTargetDate(DateTime now) =>
      DateUtils.dateOnly(now).subtract(const Duration(days: 7));
  static DateTime lastTargetDate(DateTime now) =>
      DateUtils.dateOnly(now).add(const Duration(days: 365));

  @override
  ConsumerState<WorkOrderForm> createState() => _WorkOrderFormState();
}

class _WorkOrderFormState extends ConsumerState<WorkOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _plannedQtyController = TextEditingController();
  final _notesController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  String? _selectedVariantId;
  Variant? _selectedVariant;
  DateTime _targetDate = DateUtils.dateOnly(DateTime.now());
  String? _selectedShift;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialVariantId != null) {
      _selectedVariantId = widget.initialVariantId;
      _typeAheadController.text = widget.initialVariantName ?? '';
      // Create a temporary variant object for display if we have the name
      if (widget.initialVariantName != null) {
        _selectedVariant = Variant(
          id: widget.initialVariantId!,
          name: widget.initialVariantName!,
          sku: FlipperL10n.current.productionOutputLoadingSku,
          productId: 'temp',
          supplyPrice: 0,
          retailPrice: 0,
          branchId: 'temp',
        );
        // Attempt to fetch full variant details in background
        _fetchFullVariantDetails();
      }
    }
    if (widget.initialPlannedQuantity != null) {
      _plannedQtyController.text = widget.initialPlannedQuantity!
          .toStringAsFixed(0);
    }
  }

  Future<void> _fetchFullVariantDetails() async {
    if (_selectedVariantId == null) return;
    try {
      final variant = await ProxyService.strategy.getVariant(
        id: _selectedVariantId!,
      );
      if (variant != null && mounted) {
        setState(() {
          _selectedVariant = variant;
        });
      }
    } catch (e, s) {
      talker.warning('WorkOrderForm: could not load variant details', e, s);
    }
  }

  @override
  void dispose() {
    _plannedQtyController.dispose();
    _notesController.dispose();
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.workOrderId != null;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final l10n = context.flipperL10n;
    final now = DateTime.now();

    Widget field(double width, Widget child) =>
        SizedBox(width: isMobile ? double.infinity : width, child: child);

    final form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (desktop only; the bottom sheet has its own)
          if (!isMobile) ...[
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: PosTokens.blueTint,
                    borderRadius: BorderRadius.circular(PosTokens.radiusMd),
                  ),
                  child: Icon(
                    isEdit ? Icons.edit_outlined : Icons.add_task_rounded,
                    color: PosTokens.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit
                            ? l10n.productionOutputEditWorkOrder
                            : l10n.productionOutputCreateWorkOrder,
                        style: PosTokens.sectionTitle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.productionOutputFormSubtitle,
                        style: PosTokens.meta,
                      ),
                    ],
                  ),
                ),
                if (widget.onCancel != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: PosTokens.iconMd),
                    color: PosTokens.ink3,
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: widget.onCancel,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: PosTokens.line),
            const SizedBox(height: 18),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              field(320, _buildProductField()),
              field(200, _buildQuantityField()),
              field(
                240,
                FlipperDateField(
                  key: const ValueKey('work-order-target-date'),
                  label: l10n.productionOutputTargetDateRequired,
                  value: _targetDate,
                  firstDate: WorkOrderForm.firstTargetDate(now),
                  lastDate: WorkOrderForm.lastTargetDate(now),
                  onChanged: (date) => setState(() => _targetDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildShiftField(),
          const SizedBox(height: 16),
          _buildNotesField(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onCancel != null && !isMobile) ...[
                TextButton(
                  style: productionGhostButtonStyle(),
                  onPressed: widget.onCancel,
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                flex: isMobile ? 1 : 0,
                child: ElevatedButton.icon(
                  key: const ValueKey('work-order-submit'),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  style: productionPrimaryButtonStyle().copyWith(
                    minimumSize: const WidgetStatePropertyAll(
                      Size(0, PosTokens.controlHeight + 4),
                    ),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(isEdit ? Icons.check : Icons.add, size: 18),
                  label: Text(
                    isEdit
                        ? l10n.productionOutputUpdateWorkOrder
                        : l10n.productionOutputCreateWorkOrder,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) return form;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: productionCardDecoration(),
      child: form,
    );
  }

  Widget _buildProductField() {
    final l10n = context.flipperL10n;
    return TypeAheadField<Variant>(
      constraints: const BoxConstraints(maxHeight: 260),
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
          itemTyCd: '1',
          // taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
        );
        return paged.variants.cast<Variant>().toList();
      },
      // Must be a stable, non-null instance: RawTypeAheadField.didUpdateWidget
      // disposes its internally-created controller the moment `controller`
      // goes from null to non-null, which used to kill the live controller.
      controller: _typeAheadController,
      itemBuilder: (context, Variant variant) {
        return ListTile(
          dense: true,
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: PosTokens.surface2,
              borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: PosTokens.ink2,
              size: 18,
            ),
          ),
          title: Text(variant.name, style: PosTokens.bodyStrong),
          subtitle: Text(
            l10n.skuLabel(variant.sku ?? l10n.productionOutputNotAvailable),
            style: PosTokens.meta,
          ),
        );
      },
      onSelected: (Variant variant) {
        setState(() {
          _typeAheadController.text = variant.name;
          _selectedVariantId = variant.id;
          _selectedVariant = variant;
        });
      },
      builder: (context, controller, focusNode) {
        if (_selectedVariant != null) {
          // The pick, shown as a filled field with a clear button.
          return InputDecorator(
            decoration:
                productionInputDecoration(
                  label: l10n.productionOutputProductMaterialRequired,
                ).copyWith(
                  prefixIcon: const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: PosTokens.blue,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: PosTokens.ink3,
                    tooltip: l10n.clear,
                    onPressed: () {
                      setState(() {
                        _selectedVariant = null;
                        _selectedVariantId = null;
                        controller.text = '';
                      });
                    },
                  ),
                ),
            child: Text(
              _selectedVariant!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PosTokens.bodyStrong.copyWith(fontSize: 14),
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
          style: PosTokens.body.copyWith(fontSize: 14),
          decoration: productionInputDecoration(
            label: l10n.productionOutputProductMaterialRequired,
            hint: l10n.productionOutputSearchProduct,
            prefixIcon: Icons.search,
          ),
          validator: (value) {
            if (_selectedVariantId == null) {
              return l10n.productionOutputSelectProduct;
            }
            return null;
          },
        );
      },
      emptyBuilder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 28, color: PosTokens.ink4),
            const SizedBox(height: 8),
            Text(
              l10n.productionOutputNoProductsFound,
              style: PosTokens.bodyStrong,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.productionOutputNoProductsHint,
              textAlign: TextAlign.center,
              style: PosTokens.meta,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    final l10n = context.flipperL10n;
    return TextFormField(
      controller: _plannedQtyController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: PosTokens.body.copyWith(fontSize: 14),
      decoration: productionInputDecoration(
        label: l10n.productionOutputPlannedQuantityRequired,
        hint: '0',
        suffixText: l10n.productionOutputUnits,
        prefixIcon: Icons.numbers,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.productionOutputRequired;
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return l10n.invalidQuantity;
        }
        return null;
      },
    );
  }

  /// Morning / Afternoon / Night as one segmented control; tap the chosen
  /// shift again to clear it (the shift is optional).
  Widget _buildShiftField() {
    final l10n = context.flipperL10n;
    final shifts = <(String, String, IconData)>[
      ('morning', l10n.productionOutputShiftMorning, Icons.wb_twilight),
      (
        'afternoon',
        l10n.productionOutputShiftAfternoon,
        Icons.wb_sunny_outlined,
      ),
      ('night', l10n.productionOutputShiftNight, Icons.nightlight_outlined),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.productionOutputShiftOptional, style: PosTokens.meta),
        const SizedBox(height: 6),
        SegmentedButton<String>(
          key: const ValueKey('work-order-shift'),
          segments: [
            for (final (value, label, icon) in shifts)
              ButtonSegment<String>(
                value: value,
                label: Text(label),
                icon: Icon(icon, size: 16),
              ),
          ],
          selected: {?_selectedShift},
          emptySelectionAllowed: true,
          showSelectedIcon: false,
          onSelectionChanged: (selection) {
            setState(() {
              _selectedShift = selection.isEmpty ? null : selection.first;
            });
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: PosTokens.surface,
            foregroundColor: PosTokens.ink2,
            selectedBackgroundColor: PosTokens.blueTint,
            selectedForegroundColor: PosTokens.blue,
            side: const BorderSide(color: PosTokens.lineStrong),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PosTokens.radiusLg),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    final l10n = context.flipperL10n;
    return TextFormField(
      controller: _notesController,
      minLines: 2,
      maxLines: 4,
      style: PosTokens.body.copyWith(fontSize: 14),
      decoration: productionInputDecoration(
        label: l10n.productionOutputNotes,
        hint: l10n.productionOutputNotesHint,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate() && _selectedVariantId != null) {
      final saveFailedMessage = context.flipperL10n.productionOutputSaveFailed;
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
      } catch (e, s) {
        // The form deliberately stays open on failure — this is the single
        // catch behind every create path (mobile sheet, desktop inline form,
        // and the incoming-orders "produce" flow), so the user has to be told
        // here or the tap looks like it did nothing.
        talker.error('Error submitting work order', e, s);
        if (mounted) {
          showCustomSnackBarUtil(
            context,
            saveFailedMessage,
            type: NotificationType.error,
          );
        }
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
