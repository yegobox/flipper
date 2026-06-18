import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/product_create_client.dart';
import 'package:flipper_models/sync/utils/pos_catalog_tax_ty_cds.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _FuelModalPalette {
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFEF3C7);
  static const Color title = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color handle = Color(0xFFE2E8F0);
}

/// Fetches Diesel + Gasoline from RRA via data-connector (`catalog_source: fuel_reference`).
class SyncFuelDialog extends ConsumerStatefulWidget {
  const SyncFuelDialog({super.key, required this.hostContext});

  /// Scaffold context below this dialog (for snackbars after pop).
  final BuildContext hostContext;

  @override
  ConsumerState<SyncFuelDialog> createState() => _SyncFuelDialogState();
}

class _SyncFuelDialogState extends ConsumerState<SyncFuelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController(text: 'Fuel');
  bool _syncing = false;
  String? _statusMessage;

  static const double _modalRadius = 32;

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({required String label, String? hint}) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _FuelModalPalette.border),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _FuelModalPalette.muted,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: _FuelModalPalette.muted,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _FuelModalPalette.amber, width: 1.5),
      ),
    );
  }

  Future<void> _syncFuel() async {
    if (!_formKey.currentState!.validate() || _syncing) return;

    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();
    if (branchId == null || branchId.isEmpty) {
      showErrorNotification(
        context,
        'Select a branch before syncing fuel.',
      );
      return;
    }
    if (businessId == null || businessId.isEmpty) {
      showErrorNotification(context, 'Business context is missing.');
      return;
    }

    final vatEnabled = await ref.read(ebmVatEnabledProvider.future);
    if (!vatEnabled) {
      showErrorNotification(
        context,
        'VAT / EBM must be enabled to sync regulated fuel products.',
      );
      return;
    }

    setState(() {
      _syncing = true;
      _statusMessage = 'Contacting data-connector…';
    });

    try {
      final category = await ProxyService.strategy.ensureUncategorizedCategory(
        branchId: branchId,
      );
      final ebm = await ProxyService.strategy.ebm(branchId: branchId);
      final client = await productCreateClientForBranch(
        dataConnectorUrl: ebm?.dataConnectorUrl,
      );

      setState(() => _statusMessage = 'Fetching fuel catalog from RRA…');

      final result = await client.syncFuelReference(
        productName: _productNameController.text.trim(),
        categoryId: category.id,
        businessId: businessId,
        branchId: branchId,
      );

      setState(() => _statusMessage = 'Waiting for Ditto sync…');

      final ditto = DittoService.instance.dittoInstance;
      if (ditto != null) {
        await ensureBranchCatalogCloudSubscriptions(
          ditto: ditto,
          branchId: branchId,
          businessId: businessId,
        );
      }

      final capella = ProxyService.getStrategy(Strategy.capella);
      final vatEnabled = await ref.read(ebmVatEnabledProvider.future);
      final taxTyCds = posCatalogTaxTyCds(vatEnabled: vatEnabled);
      await capella.variants(
        branchId: branchId,
        fetchRemote: true,
        page: 0,
        itemsPerPage: 200,
        taxTyCds: taxTyCds,
      );

      if (mounted) {
        ref.invalidate(outerVariantsProvider(branchId));
        await ref.read(outerVariantsProvider(branchId).notifier).refresh();
      }

      if (!mounted) return;
      final message = result.variantIds.isEmpty
          ? result.message
          : '${result.message} (${result.variantIds.length} variants)';
      Navigator.of(context).pop();
      if (widget.hostContext.mounted) {
        showSuccessNotification(
          widget.hostContext,
          message,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _syncing = false;
        _statusMessage = null;
      });
      showErrorNotification(
        context,
        e.toString().replaceFirst('Exception: ', ''),
        duration: const Duration(seconds: 8),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vatAsync = ref.watch(ebmVatEnabledProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Material(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_modalRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _FuelModalPalette.handle,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _FuelModalPalette.amberSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.local_gas_station_rounded,
                          color: _FuelModalPalette.amber,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sync Fuel',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _FuelModalPalette.title,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Diesel & gasoline from RRA',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: _FuelModalPalette.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Imports regulated fuel products from RRA. '
                    'Manual fuel registration is not allowed — use this sync instead.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _FuelModalPalette.muted,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _productNameController,
                    enabled: !_syncing,
                    decoration: _fieldDecoration(
                      label: 'Product name',
                      hint: 'Fuel',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  if (vatAsync case AsyncData(value: false)) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Enable VAT on this branch before syncing fuel.',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (_statusMessage != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _statusMessage!,
                            style: const TextStyle(
                              color: _FuelModalPalette.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _syncing ? null : () => unawaited(_syncFuel()),
                    icon: const Icon(Icons.cloud_download_rounded),
                    label: Text(_syncing ? 'Syncing…' : 'Sync from RRA'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _FuelModalPalette.amber,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _syncing ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
