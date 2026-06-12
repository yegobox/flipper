import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_dashboard/manual_purchase/supplier_search_field.dart';
import 'package:flipper_models/services/pos_purchase_journal_poster.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:supabase_models/brick/repository.dart';

import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';

const _legacyAccent = Color(0xFF0097A7);
const _legacyAccentSoft = Color(0xFFE0F4F7);
const _legacyLabelColor = Color(0xFF374151);
const _legacyHintColor = Color(0xFF9CA3AF);
const _legacyFieldBorderColor = Color(0xFFE0E3E7);

/// Full-page form to record a purchase manually (regTyCd 'M'). Saved purchases
/// enter the same Waiting/approval pipeline as RRA-fetched ones.
class ManualPurchaseForm extends StatefulHookConsumerWidget {
  final List<Variant> catalogVariants;
  final VoidCallback? onClose;
  final bool useImportPurchaseTheme;

  const ManualPurchaseForm({
    Key? key,
    required this.catalogVariants,
    this.onClose,
    this.useImportPurchaseTheme = false,
  }) : super(key: key);

  @override
  ConsumerState<ManualPurchaseForm> createState() => _ManualPurchaseFormState();
}

class _ManualPurchaseFormState extends ConsumerState<ManualPurchaseForm> {
  final _formKey = GlobalKey<FormState>();
  final _supplierController = TextEditingController();
  final _tinController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _catalogSearchController = TextEditingController();
  // Stable focus nodes: creating these inline in build() makes the autocomplete
  // overlay tear down on every keystroke (state rebuilds), which breaks search
  // suggestions and causes the field to lose focus / jump.
  final _supplierFocus = FocusNode();
  final _catalogFocus = FocusNode();
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
    _supplierFocus.dispose();
    _catalogFocus.dispose();
    super.dispose();
  }

  Color get _accent => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.accent
      : _legacyAccent;
  Color get _accentSoft => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.accentWash
      : _legacyAccentSoft;
  Color get _labelColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.ink2
      : _legacyLabelColor;
  Color get _hintColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.faint
      : _legacyHintColor;
  Color get _fieldBorderColor => widget.useImportPurchaseTheme
      ? ImportPurchaseTokens.line2
      : _legacyFieldBorderColor;

  void _goBackToPurchases() {
    if (widget.onClose != null) {
      widget.onClose!();
      return;
    }
    ref.read(selectedPageProvider.notifier).state = DashboardPage.purchases;
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
        await PosPurchaseJournalPoster.postPurchase(
          purchase: saved,
          postToLedger: true,
        );
        toast('Purchase recorded and approved');
      } catch (e) {
        // The purchase stays in Waiting; nothing is lost.
        toast('Purchase saved as waiting. Approval failed: $e');
      }
    } else {
      await PosPurchaseJournalPoster.postPurchase(
        purchase: saved,
        postToLedger: false,
      );
      toast('Purchase saved as waiting');
    }

    if (mounted) _goBackToPurchases();
  }

  double get _padX => widget.useImportPurchaseTheme ? 30 : 24;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualPurchaseProvider);
    final notifier = ref.read(manualPurchaseProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(_padX, 22, _padX, 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSupplierSection(state, notifier),
                      const SizedBox(height: 24),
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
            ),
          ),
          Divider(height: 1, color: _fieldBorderColor),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: _buildFooter(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _labelColor,
          ),
          children: [
            if (suffix != null)
              TextSpan(
                text: ' $suffix',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _hintColor, fontSize: 15),
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _fieldBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red[300]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Supplier'),
                  SupplierSearchField(
                    controller: _supplierController,
                    focusNode: _supplierFocus,
                    suppliers: _suppliers,
                    useImportPurchaseTheme: widget.useImportPurchaseTheme,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Supplier is required'
                            : null,
                    onTextChanged: (value) =>
                        notifier.setSupplier(name: value),
                    onSupplierSelected: (supplier) {
                      notifier.setSupplier(
                        name: supplier.custNm,
                        tin: supplier.custTin ?? '',
                        id: supplier.id,
                      );
                      _tinController.text = supplier.custTin ?? '';
                    },
                    onSuppliersChanged: _loadSuppliers,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Supplier TIN', suffix: '(optional)'),
                  TextFormField(
                    controller: _tinController,
                    decoration: _fieldDecoration(hint: 'e.g. 100123456'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      return RegExp(r'^\d{9}$').hasMatch(value.trim())
                          ? null
                          : 'TIN must be 9 digits';
                    },
                    onChanged: (value) => notifier.setSupplier(tin: value),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Invoice No.'),
                  TextFormField(
                    controller: _invoiceController,
                    decoration: _fieldDecoration(hint: 'e.g. 4521'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        int.tryParse(value?.trim() ?? '') == null
                            ? 'Numeric invoice number is required'
                            : null,
                    onChanged: notifier.setInvoiceNo,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Purchase date'),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
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
                      decoration: _fieldDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: _hintColor,
                        ),
                      ),
                      child: Text(
                        DateFormat('dd MMM yyyy').format(state.purchaseDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Payment type'),
                  DropdownButtonFormField<String>(
                    initialValue: state.pmtTyCd,
                    decoration: _fieldDecoration(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: purchasePaymentTypes.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(
                              '${e.key} – ${e.value}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) notifier.setPaymentType(value);
                    },
                  ),
                ],
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
              'LINE ITEMS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: _accent),
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Add from catalog'),
              onPressed: () =>
                  setState(() => _showCatalogSearch = !_showCatalogSearch),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: _accent),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New item'),
              onPressed: notifier.addBlankLine,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_showCatalogSearch)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildCatalogSearchField(notifier),
          ),
        if (state.lines.isEmpty)
          _buildEmptyState(notifier)
        else
          _buildLinesTable(state, notifier),
      ],
    );
  }

  Widget _buildCatalogSearchField(ManualPurchaseNotifier notifier) {
    return RawAutocomplete<Variant>(
      textEditingController: _catalogSearchController,
      focusNode: _catalogFocus,
      optionsBuilder: (textEditingValue) async {
        final query = textEditingValue.text.trim();
        if (query.isEmpty) return const Iterable<Variant>.empty();
        // Search the full system-wide catalog (not just the page-1 snapshot
        // in widget.catalogVariants). Matches what product lists query.
        final branchId = ProxyService.box.getBranchId() ?? '';
        if (branchId.isEmpty) {
          return widget.catalogVariants
              .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
              .take(20);
        }
        try {
          final paged = await ProxyService.getStrategy(Strategy.capella).variants(
            branchId: branchId,
            name: query,
            itemsPerPage: 20,
          );
          return paged.variants.cast<Variant>();
        } catch (e, s) {
          talker.error('Catalog search failed', e, s);
          // Fall back to the in-memory snapshot so search still works offline.
          return widget.catalogVariants
              .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
              .take(20);
        }
      },
      displayStringForOption: (v) => v.name,
      onSelected: (variant) {
        notifier.addLineFromVariant(variant);
        _catalogSearchController.clear();
        setState(() => _showCatalogSearch = false);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          decoration: _fieldDecoration(hint: 'Search catalog…').copyWith(
            prefixIcon: Icon(Icons.search, color: _hintColor, size: 20),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 520),
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
    );
  }

  Widget _buildEmptyState(ManualPurchaseNotifier notifier) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: Colors.grey[350]!,
        radius: 14,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Colors.grey[400],
                size: 28,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No items yet — add from your catalog or create a new line.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: _fieldBorderColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Add from catalog'),
                  onPressed: () => setState(() => _showCatalogSearch = true),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New item'),
                  onPressed: notifier.addBlankLine,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinesTable(
    ManualPurchaseState state,
    ManualPurchaseNotifier notifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _fieldBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(flex: 4, child: _columnLabel('Item')),
                Expanded(flex: 2, child: _columnLabel('Qty')),
                Expanded(flex: 2, child: _columnLabel('Unit price')),
                Expanded(flex: 2, child: _columnLabel('Tax')),
                Expanded(flex: 2, child: _columnLabel('Total', alignEnd: true)),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Divider(height: 1, color: _fieldBorderColor),
          for (var i = 0; i < state.lines.length; i++)
            _ManualPurchaseLineRow(
              key: ValueKey(state.lines[i].uid),
              line: state.lines[i],
              fieldDecoration: _fieldDecoration(),
              onChanged: ({
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

  Widget _totalsChip(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: _accentSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _accent,
        ),
      ),
    );
  }

  Widget _totalsItem(String label, String value, {String? chip}) {
    return Padding(
      padding: const EdgeInsets.only(right: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Colors.grey[600],
                ),
              ),
              if (chip != null) _totalsChip(chip),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(ManualPurchaseState state) {
    final formatter = NumberFormat('#,##0.##');
    final currency = ProxyService.box.defaultCurrency();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F1F3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _totalsItem(
            'TAXABLE',
            formatter.format(state.taxblAmt('B')),
            chip: 'B',
          ),
          _totalsItem('VAT 18%', formatter.format(state.taxAmt('B'))),
          _totalsItem(
            'EXEMPT / ZERO',
            formatter.format(
              state.taxblAmt('A') + state.taxblAmt('C') + state.taxblAmt('D'),
            ),
            chip: 'A+C+D',
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currency,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatter.format(state.totAmt),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(ManualPurchaseState state) {
    final canSave = state.isValid && !state.isSaving;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onPressed: state.isSaving ? null : _goBackToPurchases,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: _fieldBorderColor),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: canSave ? () => _save(approve: false) : null,
            child: const Text('Save as Waiting'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD6DADF),
              disabledForegroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
            onPressed: canSave ? () => _save(approve: true) : null,
          ),
        ],
      ),
    );
  }
}

class _ManualPurchaseLineRow extends StatefulWidget {
  final ManualPurchaseLine line;
  final InputDecoration fieldDecoration;
  final void Function({
    String? name,
    double? qty,
    double? unitPrice,
    String? taxTyCd,
  }) onChanged;
  final VoidCallback onRemove;

  const _ManualPurchaseLineRow({
    Key? key,
    required this.line,
    required this.fieldDecoration,
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

  InputDecoration get _cellDecoration => widget.fieldDecoration.copyWith(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
      );

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
                    decoration: _cellDecoration,
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
                        color: _legacyAccentSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'new',
                        style: TextStyle(
                          fontSize: 10,
                          color: _legacyAccent,
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
              decoration: _cellDecoration,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
              decoration: _cellDecoration,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
              decoration: _cellDecoration,
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    this.radius = 12,
    this.dashWidth = 6,
    this.dashGap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
