import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:supabase_models/brick/repository.dart';

/// Modal form to record a purchase manually (regTyCd 'M'). Saved purchases
/// enter the same Waiting/approval pipeline as RRA-fetched ones.
class ManualPurchaseDialog extends StatefulHookConsumerWidget {
  final List<Variant> catalogVariants;

  const ManualPurchaseDialog({Key? key, required this.catalogVariants})
    : super(key: key);

  /// Returns the saved [Purchase], or null if the user cancelled.
  static Future<Purchase?> show(
    BuildContext context, {
    required List<Variant> catalogVariants,
  }) async {
    final width = MediaQuery.of(context).size.width;
    if (width < 768) return null;

    return showDialog<Purchase?>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ManualPurchaseDialog(catalogVariants: catalogVariants),
    );
  }

  @override
  ConsumerState<ManualPurchaseDialog> createState() =>
      _ManualPurchaseDialogState();
}

class _ManualPurchaseDialogState extends ConsumerState<ManualPurchaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _supplierController = TextEditingController();
  final _tinController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _catalogSearchController = TextEditingController();
  List<Supplier> _suppliers = [];
  bool _showCatalogSearch = false;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    final suppliers = await Repository().get<Supplier>(
      query: brick.Query(where: [brick.Where('branchId').isExactly(branchId)]),
    );
    if (mounted) setState(() => _suppliers = suppliers);
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _tinController.dispose();
    _invoiceController.dispose();
    _catalogSearchController.dispose();
    super.dispose();
  }

  Future<void> _save({required bool approve}) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final notifier = ref.read(manualPurchaseProvider.notifier);
    final linesSnapshot = ref.read(manualPurchaseProvider).lines;

    if (await notifier.invoiceAlreadyExists()) {
      if (!mounted) return;
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Duplicate invoice'),
          content: const Text(
            'A purchase with this invoice number already exists for this '
            'branch. Save anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    final saved = await notifier.save();
    if (saved == null) return;

    if (approve) {
      try {
        final itemMapper = <String, List<Variant>>{};
        final savedVariants = saved.variants ?? [];
        for (
          var i = 0;
          i < linesSnapshot.length && i < savedVariants.length;
          i++
        ) {
          final catalogId = linesSnapshot[i].catalogVariantId;
          if (catalogId != null) {
            itemMapper.putIfAbsent(catalogId, () => []).add(savedVariants[i]);
          }
        }
        final coreViewModel = CoreViewModel();
        await coreViewModel.acceptPurchase(
          purchases: [saved],
          itemMapper: itemMapper,
          pchsSttsCd: '02',
          purchase: saved,
        );
        toast('Purchase recorded and approved');
      } catch (e) {
        // The purchase stays in Waiting; nothing is lost.
        toast('Purchase saved as waiting. Approval failed: $e');
      }
    } else {
      toast('Purchase saved as waiting');
    }

    if (mounted) Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualPurchaseProvider);
    final notifier = ref.read(manualPurchaseProvider.notifier);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSupplierSection(state, notifier),
                      const SizedBox(height: 16),
                      _buildLineItemsSection(state, notifier),
                      const SizedBox(height: 16),
                      _buildTotalsSection(state),
                      if (state.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.error!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildFooter(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.post_add, color: Colors.blue[700]),
          const SizedBox(width: 8),
          const Text(
            'Record Purchase',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierSection(
    ManualPurchaseState state,
    ManualPurchaseNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: RawAutocomplete<Supplier>(
                textEditingController: _supplierController,
                focusNode: FocusNode(),
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.toLowerCase();
                  if (query.isEmpty) return const Iterable<Supplier>.empty();
                  return _suppliers.where(
                    (s) => (s.custNm ?? '').toLowerCase().contains(query),
                  );
                },
                displayStringForOption: (s) => s.custNm ?? '',
                onSelected: (supplier) {
                  notifier.setSupplier(
                    name: supplier.custNm,
                    tin: supplier.custTin ?? '',
                  );
                  _tinController.text = supplier.custTin ?? '';
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Supplier is required'
                            : null,
                        onChanged: (value) => notifier.setSupplier(name: value),
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 400,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final supplier = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(supplier.custNm ?? ''),
                              subtitle: supplier.custTin != null
                                  ? Text('TIN: ${supplier.custTin}')
                                  : null,
                              onTap: () => onSelected(supplier),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _tinController,
                decoration: const InputDecoration(
                  labelText: 'Supplier TIN (optional)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  return RegExp(r'^\d{9}$').hasMatch(value.trim())
                      ? null
                      : 'TIN must be 9 digits';
                },
                onChanged: (value) => notifier.setSupplier(tin: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _invoiceController,
                decoration: const InputDecoration(
                  labelText: 'Invoice No.',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value?.trim() ?? '') == null
                    ? 'Numeric invoice number is required'
                    : null,
                onChanged: notifier.setInvoiceNo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: state.purchaseDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) notifier.setPurchaseDate(picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Purchase date',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(state.purchaseDate),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: state.pmtTyCd,
                decoration: const InputDecoration(
                  labelText: 'Payment type',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: purchasePaymentTypes.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text('${e.key} – ${e.value}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) notifier.setPaymentType(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineItemsSection(
    ManualPurchaseState state,
    ManualPurchaseNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Line items',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Add from catalog'),
              onPressed: () =>
                  setState(() => _showCatalogSearch = !_showCatalogSearch),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New item'),
              onPressed: notifier.addBlankLine,
            ),
          ],
        ),
        if (_showCatalogSearch)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RawAutocomplete<Variant>(
              textEditingController: _catalogSearchController,
              focusNode: FocusNode(),
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.toLowerCase();
                if (query.isEmpty) return const Iterable<Variant>.empty();
                return widget.catalogVariants
                    .where((v) => v.name.toLowerCase().contains(query))
                    .take(20);
              },
              displayStringForOption: (v) => v.name,
              onSelected: (variant) {
                notifier.addLineFromVariant(variant);
                _catalogSearchController.clear();
                setState(() => _showCatalogSearch = false);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search catalog…',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 240,
                        maxWidth: 500,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final variant = options.elementAt(index);
                          return ListTile(
                            dense: true,
                            title: Text(variant.name),
                            subtitle: Text(
                              'Supply: ${variant.supplyPrice ?? '-'} · Tax: ${variant.taxTyCd ?? 'B'}',
                            ),
                            onTap: () => onSelected(variant),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (state.lines.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No items yet. Add from catalog or create a new item.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: _columnLabel('Item')),
                      Expanded(flex: 2, child: _columnLabel('Qty')),
                      Expanded(flex: 2, child: _columnLabel('Unit price')),
                      Expanded(flex: 2, child: _columnLabel('Tax')),
                      Expanded(
                        flex: 2,
                        child: _columnLabel('Total', alignEnd: true),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (var i = 0; i < state.lines.length; i++)
                  _ManualPurchaseLineRow(
                    key: ValueKey(state.lines[i].uid),
                    line: state.lines[i],
                    onChanged:
                        ({
                          String? name,
                          double? qty,
                          double? unitPrice,
                          String? taxTyCd,
                        }) {
                          notifier.updateLine(
                            i,
                            name: name,
                            qty: qty,
                            unitPrice: unitPrice,
                            taxTyCd: taxTyCd,
                          );
                        },
                    onRemove: () => notifier.removeLine(i),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _columnLabel(String text, {bool alignEnd = false}) {
    return Text(
      text,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildTotalsSection(ManualPurchaseState state) {
    final formatter = NumberFormat('#,##0.##');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _totalsItem('Taxable (B)', formatter.format(state.taxblAmt('B'))),
          _totalsItem('VAT 18%', formatter.format(state.taxAmt('B'))),
          _totalsItem(
            'Exempt/zero (A+C+D)',
            formatter.format(
              state.taxblAmt('A') + state.taxblAmt('C') + state.taxblAmt('D'),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                formatter.format(state.totAmt),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ManualPurchaseState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: state.isSaving
                ? null
                : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: state.isSaving ? null : () => _save(approve: false),
            child: const Text('Save as Waiting'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            icon: state.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check, size: 18),
            label: const Text('Save & Approve'),
            onPressed: state.isSaving ? null : () => _save(approve: true),
          ),
        ],
      ),
    );
  }
}

class _ManualPurchaseLineRow extends StatefulWidget {
  final ManualPurchaseLine line;
  final void Function({
    String? name,
    double? qty,
    double? unitPrice,
    String? taxTyCd,
  })
  onChanged;
  final VoidCallback onRemove;

  const _ManualPurchaseLineRow({
    Key? key,
    required this.line,
    required this.onChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<_ManualPurchaseLineRow> createState() => _ManualPurchaseLineRowState();
}

class _ManualPurchaseLineRowState extends State<_ManualPurchaseLineRow> {
  late final TextEditingController _nameController;
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.line.name);
    _qtyController = TextEditingController(
      text: widget.line.qty == 0 ? '' : widget.line.qty.toString(),
    );
    _priceController = TextEditingController(
      text: widget.line.unitPrice == 0 ? '' : widget.line.unitPrice.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.##');
    final fromCatalog = widget.line.catalogVariantId != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    readOnly: fromCatalog,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null,
                    onChanged: (value) => widget.onChanged(name: value),
                  ),
                ),
                if (!fromCatalog)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'new',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _qtyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) =>
                  ((double.tryParse(value ?? '') ?? 0) <= 0) ? '> 0' : null,
              onChanged: (value) =>
                  widget.onChanged(qty: double.tryParse(value) ?? 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) =>
                  ((double.tryParse(value ?? '') ?? -1) < 0) ? '>= 0' : null,
              onChanged: (value) =>
                  widget.onChanged(unitPrice: double.tryParse(value) ?? 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              initialValue: widget.line.taxTyCd,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'A', child: Text('A')),
                DropdownMenuItem(value: 'B', child: Text('B')),
                DropdownMenuItem(value: 'C', child: Text('C')),
                DropdownMenuItem(value: 'D', child: Text('D')),
              ],
              onChanged: (value) {
                if (value != null) widget.onChanged(taxTyCd: value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              formatter.format(widget.line.total),
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red[300],
              ),
              tooltip: 'Remove',
              onPressed: widget.onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
