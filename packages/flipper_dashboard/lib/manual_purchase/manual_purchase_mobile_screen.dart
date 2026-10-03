import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_helpers.dart';
import 'package:flipper_dashboard/features/import_purchase/import_purchase_tokens.dart';
import 'package:flipper_dashboard/manual_purchase/amount_input.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_submit.dart';
import 'package:flipper_dashboard/manual_purchase/new_supplier_modal.dart';
import 'package:flipper_dashboard/manual_purchase/purchase_catalog_search.dart';
import 'package:flipper_dashboard/manual_purchase/purchase_suggestions.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
import 'package:supabase_models/brick/models/all_models.dart' as model;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

typedef _T = ImportPurchaseTokens;

final _money = NumberFormat('#,##0.##');
final _date = DateFormat('d MMM yyyy');

/// Tax brackets as an owner reads them, not as RRA codes.
const _taxLabels = {
  'B': 'VAT 18%',
  'A': 'Exempt',
  'C': 'Zero-rated',
  'D': 'Non-VAT',
};

/// Phone layout for recording a supplier purchase: one column of sections,
/// pickers in bottom sheets, and a fixed save bar. Shares state
/// ([manualPurchaseProvider]) and saving ([submitManualPurchase]) with the
/// desktop [ManualPurchaseForm].
class ManualPurchaseMobileScreen extends ConsumerStatefulWidget {
  const ManualPurchaseMobileScreen({
    super.key,
    this.catalogVariants = const [],
    this.onSaved,
  });

  /// In-memory catalog used when the full search is unavailable (offline).
  final List<Variant> catalogVariants;

  /// Called after a successful save, before the screen closes, with whether
  /// the purchase was approved (true) or left waiting (false).
  final ValueChanged<bool>? onSaved;

  @override
  ConsumerState<ManualPurchaseMobileScreen> createState() =>
      _ManualPurchaseMobileScreenState();
}

class _ManualPurchaseMobileScreenState
    extends ConsumerState<ManualPurchaseMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tinController = TextEditingController();
  final _invoiceController = TextEditingController();
  bool _submitting = false;

  /// Purchases already loaded on the purchases list (RRA invoices included);
  /// Ditto only holds the recorded ones.
  List<model.Purchase> get _loadedPurchases =>
      ref.read(importPurchaseViewModelProvider).purchases;

  @override
  void initState() {
    super.initState();
    _invoiceController.text = ref.read(manualPurchaseProvider).invoiceNo;
    WidgetsBinding.instance.addPostFrameCallback((_) => _suggestInvoiceNo());
  }

  Future<void> _suggestInvoiceNo() async {
    if (!mounted) return;
    try {
      await ref
          .read(manualPurchaseProvider.notifier)
          .suggestInvoiceNo(loaded: _loadedPurchases);
    } catch (_) {
      // A suggestion is a convenience; the owner can always type the number.
    }
  }

  @override
  void dispose() {
    _tinController.dispose();
    _invoiceController.dispose();
    super.dispose();
  }

  Future<void> _save({required bool approve}) async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      final saved = await submitManualPurchase(
        context: context,
        ref: ref,
        approve: approve,
      );
      if (saved && mounted) {
        widget.onSaved?.call(approve);
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickSupplier() async {
    final picked = await showModalBottomSheet<_SupplierChoice>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: _T.surface,
      builder: (_) => _SupplierPickerSheet(
        initialQuery: ref.read(manualPurchaseProvider).supplierName,
        purchases: _loadedPurchases,
      ),
    );
    if (picked == null || !mounted) return;
    final notifier = ref.read(manualPurchaseProvider.notifier);
    if (picked.createNamed != null) {
      final created = await showNewSupplierModal(
        context,
        ref,
        initialName: picked.createNamed!,
        useImportPurchaseTheme: true,
      );
      // createSupplier already put the new supplier into the form state.
      if (created != null) {
        _tinController.text = created.custTin ?? '';
        await _suggestInvoiceNo();
      }
      return;
    }
    final s = picked.option!;
    // Suppliers seen only on an RRA invoice have no saved id; the purchase
    // saves them.
    notifier.setSupplier(name: s.name, tin: s.tin, id: s.savedId);
    _tinController.text = s.tin;
    await _suggestInvoiceNo();
  }

  Future<void> _pickPurchaseDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(manualPurchaseProvider.notifier).setPurchaseDate(picked);
    }
  }

  Future<void> _pickDueDate(ManualPurchaseState state) async {
    final current =
        state.effectiveDueDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: state.purchaseDate,
      lastDate: state.purchaseDate.add(const Duration(days: 730)),
      helpText: 'Pay supplier by',
    );
    if (picked != null) {
      ref.read(manualPurchaseProvider.notifier).setDueDate(picked);
    }
  }

  Future<void> _addFromCatalog() async {
    final variant = await showModalBottomSheet<Variant>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: _T.surface,
      builder: (_) => _CatalogSearchSheet(snapshot: widget.catalogVariants),
    );
    if (variant == null || !mounted) return;
    final notifier = ref.read(manualPurchaseProvider.notifier);
    notifier.addLineFromVariant(variant);
    // Straight into the editor: the quantity is what the owner still needs.
    await _editLine(ref.read(manualPurchaseProvider).lines.length - 1);
  }

  Future<void> _newLine() async {
    final result = await _showLineEditor(null);
    if (result == null) return;
    final notifier = ref.read(manualPurchaseProvider.notifier);
    notifier.addBlankLine();
    notifier.updateLine(
      ref.read(manualPurchaseProvider).lines.length - 1,
      name: result.name,
      qty: result.qty,
      unitPrice: result.unitPrice,
      taxTyCd: result.taxTyCd,
    );
  }

  Future<void> _editLine(int index) async {
    final lines = ref.read(manualPurchaseProvider).lines;
    if (index < 0 || index >= lines.length) return;
    final result = await _showLineEditor(lines[index]);
    if (result == null) return;
    final notifier = ref.read(manualPurchaseProvider.notifier);
    if (result.remove) {
      notifier.removeLine(index);
      return;
    }
    notifier.updateLine(
      index,
      name: result.name,
      qty: result.qty,
      unitPrice: result.unitPrice,
      taxTyCd: result.taxTyCd,
    );
  }

  Future<_LineEdit?> _showLineEditor(ManualPurchaseLine? line) {
    return showModalBottomSheet<_LineEdit>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: _T.surface,
      builder: (_) => _LineEditorSheet(line: line),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualPurchaseProvider);
    final notifier = ref.read(manualPurchaseProvider.notifier);
    final busy = _submitting || state.isSaving;
    ref.listen(manualPurchaseProvider, (_, next) {
      if (next.invoiceAutoFilled && _invoiceController.text != next.invoiceNo) {
        _invoiceController.text = next.invoiceNo;
      }
    });

    return Scaffold(
      backgroundColor: _T.canvas,
      appBar: CustomAppBar(
        title: 'Record purchase',
        onPop: () => Navigator.of(context).maybePop(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _Section(
              title: 'Supplier',
              children: [
                _TapRow(
                  icon: Icons.storefront_outlined,
                  label: state.supplierName.trim().isEmpty
                      ? 'Choose supplier'
                      : state.supplierName,
                  placeholder: state.supplierName.trim().isEmpty,
                  onTap: _pickSupplier,
                ),
                const _Divider(),
                _FieldRow(
                  child: TextFormField(
                    controller: _tinController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _inputDecoration('TIN (optional)'),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return null;
                      return RegExp(r'^\d{9}$').hasMatch(v)
                          ? null
                          : 'TIN must be 9 digits';
                    },
                    onChanged: (value) => notifier.setSupplier(tin: value),
                  ),
                ),
              ],
            ),
            _Section(
              title: 'Invoice',
              children: [
                _FieldRow(
                  child: TextFormField(
                    controller: _invoiceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _inputDecoration('Invoice number').copyWith(
                      helperText: state.invoiceAutoFilled
                          ? 'Next number after your last invoice'
                          : null,
                    ),
                    validator: (value) =>
                        int.tryParse(value?.trim() ?? '') == null
                        ? 'Enter the invoice number'
                        : null,
                    onChanged: notifier.setInvoiceNo,
                  ),
                ),
                const _Divider(),
                _TapRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Purchase date',
                  value: _date.format(state.purchaseDate),
                  onTap: () => _pickPurchaseDate(state.purchaseDate),
                ),
              ],
            ),
            _Section(
              title: 'How did you pay?',
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in purchasePaymentTypes.entries)
                        ChoiceChip(
                          label: Text(e.value),
                          selected: state.pmtTyCd == e.key,
                          showCheckmark: false,
                          selectedColor: _T.accentWash,
                          side: BorderSide(
                            color: state.pmtTyCd == e.key
                                ? _T.accent
                                : _T.line2,
                          ),
                          labelStyle: ImportPurchaseHelpers.text(
                            size: 13.5,
                            weight: FontWeight.w600,
                            color: state.pmtTyCd == e.key
                                ? _T.accentStrong
                                : _T.ink2,
                          ),
                          onSelected: (_) => notifier.setPaymentType(e.key),
                        ),
                    ],
                  ),
                ),
                if (state.isOnCredit) ...[
                  const _Divider(),
                  _TapRow(
                    icon: Icons.event_outlined,
                    label: 'Pay supplier by',
                    value: _date.format(state.effectiveDueDate),
                    onTap: () => _pickDueDate(state),
                  ),
                  if (state.pmtTyCd == '03') ...[
                    const _Divider(),
                    _FieldRow(
                      child: TextFormField(
                        initialValue: state.paidUpfront > 0
                            ? formatAmountForEdit(state.paidUpfront)
                            : null,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _inputDecoration('Paid now'),
                        onChanged: (v) => notifier.setPaidUpfront(
                          parseAmount(v),
                        ),
                      ),
                    ),
                  ],
                  _OwedBanner(amount: state.amountOwed),
                ],
              ],
            ),
            _Section(
              title: 'Items',
              trailing: state.lines.isEmpty ? null : '${state.lines.length}',
              children: [
                if (state.lines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 6),
                    child: Text(
                      'Add what you bought from your catalog, or type a new '
                      'item.',
                      style: ImportPurchaseHelpers.text(
                        size: 14,
                        weight: FontWeight.w500,
                        color: _T.muted,
                      ),
                    ),
                  ),
                for (var i = 0; i < state.lines.length; i++) ...[
                  if (i > 0) const _Divider(),
                  _LineTile(line: state.lines[i], onTap: () => _editLine(i)),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _addFromCatalog,
                          icon: const Icon(Icons.search, size: 18),
                          label: const Text('From catalog'),
                          style: _secondaryButtonStyle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _newLine,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('New item'),
                          style: _secondaryButtonStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (state.lines.isNotEmpty) _TotalsSection(state: state),
            if (state.error != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _T.redWash,
                  borderRadius: BorderRadius.circular(_T.radiusSm),
                ),
                child: Text(
                  state.error!,
                  style: ImportPurchaseHelpers.text(
                    size: 13.5,
                    weight: FontWeight.w500,
                    color: _T.redStrong,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _SaveBar(
        total: state.totAmt,
        busy: busy,
        onSaveWaiting: () => _save(approve: false),
        onSaveApprove: () => _save(approve: true),
      ),
    );
  }
}

// ─── Layout pieces ───────────────────────────────────────────────────────────

InputDecoration _inputDecoration(String label) => InputDecoration(
  labelText: label,
  border: InputBorder.none,
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 10),
  labelStyle: ImportPurchaseHelpers.text(
    size: 14.5,
    weight: FontWeight.w500,
    color: _T.muted,
  ),
);

final _secondaryButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: _T.accentStrong,
  side: const BorderSide(color: _T.line2),
  minimumSize: const Size.fromHeight(46),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_T.radiusSm),
  ),
  textStyle: ImportPurchaseHelpers.text(size: 14, weight: FontWeight.w600),
);

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.trailing});

  final String title;
  final String? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: ImportPurchaseHelpers.text(
                      size: 12,
                      weight: FontWeight.w700,
                      color: _T.muted,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: ImportPurchaseHelpers.text(
                      size: 12,
                      weight: FontWeight.w700,
                      color: _T.muted,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.radius),
              boxShadow: _T.cardShadows,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, indent: 14, color: _T.line);
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    child: child,
  );
}

/// A full-width tappable row: icon, label, optional value, chevron.
class _TapRow extends StatelessWidget {
  const _TapRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final bool placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 54),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _T.ink2),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ImportPurchaseHelpers.text(
                    size: 15,
                    weight: placeholder ? FontWeight.w500 : FontWeight.w600,
                    color: placeholder ? _T.muted : _T.ink,
                  ),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 8),
                Text(
                  value!,
                  style: ImportPurchaseHelpers.text(
                    size: 14.5,
                    weight: FontWeight.w600,
                    color: _T.accentStrong,
                  ),
                ),
              ],
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 20, color: _T.faint),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwedBanner extends StatelessWidget {
  const _OwedBanner({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _T.amberWash,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 18, color: _T.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'You will owe this supplier',
              style: ImportPurchaseHelpers.text(
                size: 13.5,
                weight: FontWeight.w600,
                color: _T.amber,
              ),
            ),
          ),
          Text(
            _money.format(amount),
            style: ImportPurchaseHelpers.text(
              size: 15,
              weight: FontWeight.w800,
              color: _T.amber,
              tabular: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.onTap});

  final ManualPurchaseLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = line.name.trim().isEmpty ? 'Unnamed item' : line.name;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ImportPurchaseHelpers.text(
                      size: 15,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_money.format(line.qty)} × ${_money.format(line.unitPrice)}'
                    ' · ${_taxLabels[line.taxTyCd] ?? line.taxTyCd}',
                    style: ImportPurchaseHelpers.text(
                      size: 13,
                      weight: FontWeight.w500,
                      color: _T.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _money.format(line.total),
              style: ImportPurchaseHelpers.text(
                size: 15,
                weight: FontWeight.w700,
                tabular: true,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: _T.faint),
          ],
        ),
      ),
    );
  }
}

class _TotalsSection extends StatelessWidget {
  const _TotalsSection({required this.state});

  final ManualPurchaseState state;

  @override
  Widget build(BuildContext context) {
    final exempt =
        state.taxblAmt('A') + state.taxblAmt('C') + state.taxblAmt('D');
    Widget row(String label, double value, {bool strong = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: ImportPurchaseHelpers.text(
                size: strong ? 15 : 14,
                weight: strong ? FontWeight.w700 : FontWeight.w500,
                color: strong ? _T.ink : _T.ink2,
              ),
            ),
          ),
          Text(
            _money.format(value),
            style: ImportPurchaseHelpers.text(
              size: strong ? 16 : 14,
              weight: strong ? FontWeight.w800 : FontWeight.w600,
              tabular: true,
            ),
          ),
        ],
      ),
    );

    return _Section(
      title: 'Summary',
      children: [
        const SizedBox(height: 4),
        row('Taxable (VAT 18%)', state.taxblAmt('B')),
        row('VAT included', state.taxAmt('B')),
        if (exempt > 0) row('Exempt / zero-rated', exempt),
        const _Divider(),
        row('Total', state.totAmt, strong: true),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.total,
    required this.busy,
    required this.onSaveWaiting,
    required this.onSaveApprove,
  });

  final double total;
  final bool busy;
  final VoidCallback onSaveWaiting;
  final VoidCallback onSaveApprove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _T.surface,
        border: Border(top: BorderSide(color: _T.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onSaveWaiting,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _T.ink2,
                    side: const BorderSide(color: _T.line2),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_T.radiusSm),
                    ),
                  ),
                  child: const Text('Save as waiting'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : onSaveApprove,
                  style: FilledButton.styleFrom(
                    backgroundColor: _T.accent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_T.radiusSm),
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            total > 0
                                ? 'Approve · ${_money.format(total)}'
                                : 'Save & approve',
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom sheets ───────────────────────────────────────────────────────────

/// Either an existing supplier, or a name to create a new one with.
class _SupplierChoice {
  const _SupplierChoice.existing(SupplierOption this.option)
    : createNamed = null;
  const _SupplierChoice.create(String this.createNamed) : option = null;

  final SupplierOption? option;
  final String? createNamed;
}

class _SupplierPickerSheet extends StatefulWidget {
  const _SupplierPickerSheet({
    required this.initialQuery,
    required this.purchases,
  });

  final String initialQuery;

  /// Past invoices; their suppliers are offered even if never saved.
  final List<model.Purchase> purchases;

  @override
  State<_SupplierPickerSheet> createState() => _SupplierPickerSheetState();
}

class _SupplierPickerSheetState extends State<_SupplierPickerSheet> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );
  List<SupplierOption>? _suppliers;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      setState(() => _suppliers = const []);
      return;
    }
    // Saved suppliers are Ditto-only; Brick/SQLite never has them.
    var saved = const <Supplier>[];
    try {
      saved = await ManualPurchaseDitto.listSuppliers(branchId);
    } catch (_) {
      // Offer the suppliers from past invoices anyway.
    }
    if (!mounted) return;
    setState(
      () => _suppliers = mergeSupplierOptions(
        saved: saved,
        purchases: widget.purchases,
      ),
    );
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.text.trim().toLowerCase();
    final all = _suppliers;
    final matches = all == null
        ? const <SupplierOption>[]
        : all
              .where(
                (s) =>
                    q.isEmpty ||
                    s.name.toLowerCase().contains(q) ||
                    s.tin.contains(q),
              )
              .toList();
    final exact = matches.any((s) => s.name.toLowerCase() == q);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _query,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search suppliers',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: _T.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_T.radiusSm),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: _T.accentWash,
                child: Icon(Icons.add, color: _T.accentStrong),
              ),
              title: Text(
                q.isEmpty || exact
                    ? 'New supplier'
                    : 'Add "${_query.text.trim()}"',
              ),
              subtitle: const Text('Save a supplier you have not used before'),
              onTap: () => Navigator.of(
                context,
              ).pop(_SupplierChoice.create(exact ? '' : _query.text.trim())),
            ),
            const Divider(height: 1),
            Expanded(
              child: all == null
                  ? const Center(child: CircularProgressIndicator())
                  : matches.isEmpty
                  ? Center(
                      child: Text(
                        all.isEmpty
                            ? 'No suppliers yet'
                            : 'No supplier matches "${_query.text.trim()}"',
                        style: ImportPurchaseHelpers.text(
                          weight: FontWeight.w500,
                          color: _T.muted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: matches.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (context, i) {
                        final s = matches[i];
                        final name = s.name;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _T.surface3,
                            child: Text(
                              name.isEmpty ? '?' : name[0].toUpperCase(),
                              style: ImportPurchaseHelpers.text(
                                weight: FontWeight.w700,
                                color: _T.ink2,
                              ),
                            ),
                          ),
                          title: Text(name),
                          subtitle: s.tin.isEmpty && s.isSaved
                              ? null
                              : Text(
                                  [
                                    if (s.tin.isNotEmpty) 'TIN ${s.tin}',
                                    if (!s.isSaved) 'From your invoices',
                                  ].join(' · '),
                                ),
                          onTap: () => Navigator.of(
                            context,
                          ).pop(_SupplierChoice.existing(s)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogSearchSheet extends StatefulWidget {
  const _CatalogSearchSheet({required this.snapshot});

  final List<Variant> snapshot;

  @override
  State<_CatalogSearchSheet> createState() => _CatalogSearchSheetState();
}

class _CatalogSearchSheetState extends State<_CatalogSearchSheet> {
  final _query = TextEditingController();
  List<Variant> _results = const [];
  bool _searching = false;
  int _seq = 0;

  Future<void> _search(String text) async {
    final seq = ++_seq;
    setState(() => _searching = text.trim().isNotEmpty);
    final found = await searchPurchaseCatalog(text, snapshot: widget.snapshot);
    // Drop answers to older keystrokes.
    if (!mounted || seq != _seq) return;
    setState(() {
      _results = found.toList();
      _searching = false;
    });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.text.trim().isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _query,
                autofocus: true,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search your catalog',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: _T.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_T.radiusSm),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: !hasQuery
                  ? Center(
                      child: Text(
                        'Type a product name',
                        style: ImportPurchaseHelpers.text(
                          weight: FontWeight.w500,
                          color: _T.muted,
                        ),
                      ),
                    )
                  : _results.isEmpty && !_searching
                  ? Center(
                      child: Text(
                        'No product matches "${_query.text.trim()}"',
                        style: ImportPurchaseHelpers.text(
                          weight: FontWeight.w500,
                          color: _T.muted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 16),
                      itemBuilder: (context, i) {
                        final v = _results[i];
                        final cost = v.supplyPrice;
                        return ListTile(
                          title: Text(v.name),
                          subtitle: Text(
                            [
                              if (cost != null) 'Cost ${_money.format(cost)}',
                              _taxLabels[v.taxTyCd ?? 'B'] ?? '',
                            ].where((s) => s.isNotEmpty).join(' · '),
                          ),
                          trailing: const Icon(
                            Icons.add_circle_outline,
                            color: _T.accent,
                          ),
                          onTap: () => Navigator.of(context).pop(v),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Result of the line editor sheet.
class _LineEdit {
  const _LineEdit({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.taxTyCd,
  }) : remove = false;

  const _LineEdit.remove()
    : name = '',
      qty = 0,
      unitPrice = 0,
      taxTyCd = 'B',
      remove = true;

  final String name;
  final double qty;
  final double unitPrice;
  final String taxTyCd;
  final bool remove;
}

class _LineEditorSheet extends StatefulWidget {
  const _LineEditorSheet({required this.line});

  /// Null when adding a new item.
  final ManualPurchaseLine? line;

  @override
  State<_LineEditorSheet> createState() => _LineEditorSheetState();
}

class _LineEditorSheetState extends State<_LineEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.line?.name ?? '');
  late final _qty = TextEditingController(
    text: formatAmountForEdit(widget.line?.qty ?? 1),
  );
  late final _price = TextEditingController(
    text: (widget.line?.unitPrice ?? 0) > 0
        ? formatAmountForEdit(widget.line!.unitPrice)
        : '',
  );
  late String _tax = widget.line?.taxTyCd ?? 'B';

  /// Catalog items keep their name; only new lines are typed in.
  bool get _fromCatalog => widget.line?.catalogVariantId != null;

  static double _num(String raw) =>
      parseAmount(raw);

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  void _done() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      _LineEdit(
        name: _name.text.trim(),
        qty: _num(_qty.text),
        unitPrice: _num(_price.text),
        taxTyCd: _tax,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _num(_qty.text) * _num(_price.text);
    final isNew = widget.line == null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isNew ? 'New item' : 'Edit item',
                style: ImportPurchaseHelpers.text(
                  size: 18,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                readOnly: _fromCatalog,
                autofocus: isNew,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter the item name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qty,
                      autofocus: !isNew,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) =>
                          _num(v ?? '') <= 0 ? 'More than 0' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Unit cost',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Tax',
                style: ImportPurchaseHelpers.text(
                  size: 13,
                  weight: FontWeight.w600,
                  color: _T.ink2,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in _taxLabels.entries)
                    ChoiceChip(
                      label: Text(e.value),
                      selected: _tax == e.key,
                      showCheckmark: false,
                      selectedColor: _T.accentWash,
                      onSelected: (_) => setState(() => _tax = e.key),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Line total',
                    style: ImportPurchaseHelpers.text(
                      weight: FontWeight.w500,
                      color: _T.ink2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _money.format(total),
                    style: ImportPurchaseHelpers.text(
                      size: 17,
                      weight: FontWeight.w800,
                      tabular: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _done,
                style: FilledButton.styleFrom(
                  backgroundColor: _T.accent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_T.radiusSm),
                  ),
                ),
                child: Text(isNew ? 'Add item' : 'Done'),
              ),
              if (!isNew) ...[
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pop(const _LineEdit.remove()),
                  style: TextButton.styleFrom(foregroundColor: _T.redStrong),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove item'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
