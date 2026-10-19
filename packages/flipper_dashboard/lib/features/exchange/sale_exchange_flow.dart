import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flipper_dashboard/services/pdf_presentation_service.dart';
import 'package:flipper_dashboard/services/sale_exchange_service.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/ebm_receipt_gate.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Phones get a full-height sheet, wider screens a centred dialog. The flow
/// inside is the same widget either way.
const double kExchangeFlowSheetBreakpoint = 600;

/// Opens the item-exchange flow for [transaction]. Returns the result when an
/// exchange was saved, null when the user closed it first.
///
/// With [resumeExchangeId] it skips the steps and finishes that partly saved
/// exchange instead (see [SaleExchangeService.resumeExchange]).
Future<SaleExchangeResult?> showSaleExchangeFlow(
  BuildContext context, {
  required ITransaction transaction,
  required String currency,
  SaleExchangeService? service,
  Future<bool> Function()? ebmWillSign,
  String? resumeExchangeId,
}) {
  final flow = SaleExchangeFlow(
    transaction: transaction,
    currency: currency,
    service: service ?? SaleExchangeService(),
    ebmWillSign: ebmWillSign ?? ebmWillSignReceipt,
    resumeExchangeId: resumeExchangeId,
  );
  if (MediaQuery.sizeOf(context).width < kExchangeFlowSheetBreakpoint) {
    return showModalBottomSheet<SaleExchangeResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: PosTokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Ride above the keyboard: without this the phone keyboard covers the
      // chosen items and the Back / Next buttons while the user searches.
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: FractionallySizedBox(heightFactor: 0.94, child: flow),
      ),
    );
  }
  return showDialog<SaleExchangeResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: PosTokens.surface,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: flow,
      ),
    ),
  );
}

/// Three plain steps — what comes back, what goes out, the money — then a
/// done screen. Written for people who do not want accounting words: the
/// screen never says return, credit note, leg or VAT.
class SaleExchangeFlow extends StatefulWidget {
  const SaleExchangeFlow({
    super.key,
    required this.transaction,
    required this.currency,
    required this.service,
    required this.ebmWillSign,
    this.presentReceipt,
    this.resumeExchangeId,
  });

  final ITransaction transaction;
  final String currency;
  final SaleExchangeService service;
  final Future<bool> Function() ebmWillSign;

  /// A partly saved exchange to finish instead of starting a new one.
  final String? resumeExchangeId;

  /// Prints one receipt PDF. Defaults to the app's PDF presenter.
  final Future<void> Function(BuildContext context, Uint8List bytes)?
  presentReceipt;

  @override
  State<SaleExchangeFlow> createState() => _SaleExchangeFlowState();
}

class _SaleExchangeFlowState extends State<SaleExchangeFlow> {
  static const _lastStep = 2;

  int _step = 0;
  List<ExchangeableLine>? _lines;
  bool _loadFailed = false;
  final Map<String, double> _back = {};
  final Map<String, ExchangeTake> _taking = {};
  final Map<String, double?> _onHand = {};

  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _debounce;
  List<({Variant variant, double? onHand})> _results = const [];
  bool _searching = false;

  late String _method;
  bool _needsPurchaseCode = false;
  final _purchaseCode = TextEditingController();

  bool _saving = false;
  String? _error;
  SaleExchangeResult? _result;
  bool _finishing = false;

  /// Set once an exchange is partly saved: from then on the only way forward
  /// is to finish that one — confirming again would exchange twice.
  String? _resumableId;

  /// Finishing was tried and there is nothing left to finish (RRA refused
  /// the return, or the exchange is gone): only Close is offered.
  bool _finishGone = false;

  @override
  void initState() {
    super.initState();
    final paid = canonicalPaymentMethod(widget.transaction.paymentType);
    _method = paid.isEmpty ? 'CASH' : paid;
    final resume = widget.resumeExchangeId;
    if (resume != null) {
      _resumableId = resume;
      _resume();
      return;
    }
    _load();
    _checkPurchaseCode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _searchFocus.dispose();
    _purchaseCode.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _lines = null;
      _loadFailed = false;
    });
    try {
      final lines = await widget.service.exchangeableLines(widget.transaction);
      if (!mounted) return;
      setState(() {
        _lines = lines;
        final open = lines.where((l) => l.returnable > _qtyEpsilon).toList();
        // One item on the receipt: it is obviously the one coming back.
        if (lines.length == 1 && open.length == 1) {
          _back[open.first.line.id] = math.min(1.0, open.first.returnable);
        }
      });
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    }
  }

  Future<void> _checkPurchaseCode() async {
    final tin = widget.transaction.customerTin?.trim() ?? '';
    if (tin.isEmpty) return;
    final vat = await widget.ebmWillSign();
    if (mounted) setState(() => _needsPurchaseCode = vat);
  }

  // ---------------------------------------------------------------- totals

  double get _backTotal {
    final byId = {for (final l in _lines ?? const []) l.line.id: l};
    return _back.entries.fold(
      0,
      (s, e) => s + (byId[e.key]?.unitValue ?? 0) * e.value,
    );
  }

  double get _takeTotal => _taking.values.fold(0, (s, t) => s + t.total);

  ExchangeTotals get _totals =>
      ExchangeTotals(returned: _backTotal, taken: _takeTotal);

  String _money(num v) =>
      '${widget.currency} ${NumberFormat('#,##0').format(v.abs())}';

  String? _hint(FlipperAppLocalizations l10n) {
    switch (_step) {
      case 0:
        return _back.values.any((q) => q > 0)
            ? null
            : l10n.exchangeChooseReturn;
      case 1:
        return _taking.values.any((t) => t.qty > 0)
            ? null
            : l10n.exchangeChooseTake;
      default:
        return _needsPurchaseCode && _purchaseCode.text.trim().isEmpty
            ? l10n.refundPurchaseCodeRequired
            : null;
    }
  }

  // --------------------------------------------------------------- actions

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _searching = true);
      try {
        final found = await widget.service.searchVariants(text);
        if (!mounted || _search.text != text) return;
        setState(() => _results = found);
      } catch (_) {
        if (mounted) setState(() => _results = const []);
      } finally {
        if (mounted) setState(() => _searching = false);
      }
    });
  }

  /// A tapped result is added, the search is cleared and the keyboard closes,
  /// so the user sees the item land under the search box and the Next button.
  void _takeFromSearch(Variant variant, double qty) {
    _debounce?.cancel();
    _search.clear();
    _searchFocus.unfocus();
    setState(() {
      _results = const [];
      _searching = false;
    });
    _setTake(variant, qty);
  }

  void _setTake(Variant variant, double qty) {
    setState(() {
      if (qty <= 0) {
        _taking.remove(variant.id);
      } else {
        _taking[variant.id] = ExchangeTake(variant: variant, qty: qty);
      }
    });
  }

  Future<void> _confirm() async {
    final l10n = context.flipperL10n;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await widget.service.execute(
        SaleExchangeRequest(
          original: widget.transaction,
          returns: Map.of(_back),
          takes: _taking.values.toList(),
          paymentMethod: _method,
          purchaseCode: _needsPurchaseCode ? _purchaseCode.text.trim() : null,
        ),
      );
      if (mounted) setState(() => _result = result);
    } on SaleExchangeException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _resumableId = e.resumableExchangeId;
        });
      }
    } catch (_) {
      // The service reports every partial save as a SaleExchangeException.
      if (mounted) setState(() => _error = l10n.exchangeFailedNothingChanged);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Finishes the partly saved exchange [_resumableId].
  Future<void> _resume() async {
    final id = _resumableId;
    if (id == null) return;
    final l10n = FlipperL10n.current;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await widget.service.resumeExchange(id);
      if (mounted) setState(() => _result = result);
    } on SaleExchangeException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          if (e.resumableExchangeId == null) {
            _resumableId = null;
            _finishGone = true;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = l10n.exchangePartlySaved);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _printReceipts() async {
    final receipts = _result?.receipts ?? const <Uint8List>[];
    for (final bytes in receipts) {
      if (!mounted) return;
      final present = widget.presentReceipt;
      if (present != null) {
        await present(context, bytes);
      } else {
        await PdfPresentationService().present(
          context,
          mode: PdfPresentationMode.print,
          build: () async => bytes,
          filename: () =>
              'exchange-${DateTime.now().millisecondsSinceEpoch}.pdf',
          label: context.flipperL10n.receipt,
        );
      }
    }
  }

  Future<void> _finishSale() async {
    final result = _result;
    if (result == null) return;
    setState(() => _finishing = true);
    final bytes = await widget.service.signSale(result.saleTransaction);
    if (!mounted) return;
    setState(() {
      _finishing = false;
      if (bytes != null) {
        _result = SaleExchangeResult(
          returnTransaction: result.returnTransaction,
          saleTransaction: result.saleTransaction,
          totals: result.totals,
          receipts: [...result.receipts, if (bytes.isNotEmpty) bytes],
          saleSigned: true,
        );
      }
    });
  }

  // ------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final result = _result;
    return Material(
      color: PosTokens.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: result != null
          ? _buildDone(l10n, result)
          : widget.resumeExchangeId != null
          ? _buildResume(l10n)
          : _buildSteps(l10n),
    );
  }

  /// Finishing a partly saved exchange opened from the sale's detail.
  Widget _buildResume(FlipperAppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          step: l10n.exchangeBadge,
          title: l10n.exchangeFinish,
          onClose: _saving ? null : () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: Center(
            child: _saving
                ? const CircularProgressIndicator()
                : _finishGone
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.exchangeUnfinishedHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: PosTokens.ink2,
                      ),
                    ),
                  ),
          ),
        ),
        if (_error != null) _Message(text: _error!, tone: _MessageTone.error),
        _Footer(
          backLabel: l10n.exchangeClose,
          onBack: _saving ? null : () => Navigator.of(context).pop(),
          nextLabel: _finishGone ? null : l10n.exchangeFinish,
          busy: _saving,
          onNext: _saving ? null : _resume,
        ),
      ],
    );
  }

  Widget _buildSteps(FlipperAppLocalizations l10n) {
    final titles = [
      l10n.exchangeBringingBackTitle,
      l10n.exchangeTakingTitle,
      l10n.exchangeMoneyTitle,
    ];
    final hint = _hint(l10n);
    final resumable = _resumableId != null || _finishGone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          step: l10n.exchangeStepOf(_step + 1, _lastStep + 1),
          title: titles[_step],
          onClose: _saving ? null : () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: switch (_step) {
            0 => _buildBack(l10n),
            1 => _buildTake(l10n),
            _ => _buildMoney(l10n),
          },
        ),
        if (_error != null)
          _Message(text: _error!, tone: _MessageTone.error)
        else if (hint != null)
          _Message(text: hint, tone: _MessageTone.hint),
        if (resumable)
          // Partly saved: finish it, or close and finish it later from the
          // sale. Going back to edit would start a second exchange.
          _Footer(
            backLabel: l10n.exchangeClose,
            onBack: _saving ? null : () => Navigator.of(context).pop(),
            nextLabel: _finishGone ? null : l10n.exchangeFinish,
            busy: _saving,
            onNext: _saving ? null : _resume,
          )
        else
          _Footer(
            backLabel: _step == 0 ? l10n.cancel : l10n.exchangeBack,
            onBack: _saving
                ? null
                : () => _step == 0
                      ? Navigator.of(context).pop()
                      : setState(() {
                          _step--;
                          _error = null;
                        }),
            nextLabel: _step == _lastStep
                ? l10n.exchangeConfirm
                : l10n.exchangeNext,
            busy: _saving,
            onNext: hint != null || _saving
                ? null
                : () =>
                      _step == _lastStep ? _confirm() : setState(() => _step++),
          ),
      ],
    );
  }

  Widget _buildBack(FlipperAppLocalizations l10n) {
    final lines = _lines;
    if (_loadFailed) {
      return Center(
        child: TextButton(onPressed: _load, child: Text(l10n.retry)),
      );
    }
    if (lines == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      children: [
        for (final l in lines)
          _QtyCard(
            key: ValueKey('back-${l.line.id}'),
            title: l.line.name,
            subtitle: _money(l.unitValue),
            qty: _back[l.line.id] ?? 0,
            max: l.returnable,
            // Part of a unit (0.5 kg) can come back; only a line with
            // nothing left is "already exchanged".
            stepToMax: true,
            unavailableLabel: l.returnable <= _qtyEpsilon
                ? l10n.exchangeAlreadyExchanged
                : null,
            onChanged: (q) => setState(() {
              if (q <= 0) {
                _back.remove(l.line.id);
              } else {
                _back[l.line.id] = q;
              }
            }),
          ),
      ],
    );
  }

  Widget _buildTake(FlipperAppLocalizations l10n) {
    final chosen = _taking.values.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      children: [
        TextField(
          key: const ValueKey('exchange-search'),
          controller: _search,
          focusNode: _searchFocus,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: l10n.exchangeSearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            filled: true,
            fillColor: PosTokens.surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: PosTokens.line),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // What is already chosen sits right under the search box, so it is
        // in view (with the keyboard open too) the moment an item is added.
        for (final t in chosen)
          _QtyCard(
            key: ValueKey('take-${t.variant.id}'),
            title: t.variant.name,
            subtitle: _money(t.unitPrice),
            qty: t.qty,
            max: _onHand[t.variant.id] ?? double.infinity,
            onChanged: (q) => _setTake(t.variant, q),
          ),
        for (final r in _results)
          _SearchResult(
            key: ValueKey('result-${r.variant.id}'),
            name: r.variant.name,
            price: _money(r.variant.retailPrice ?? 0),
            outOfStockLabel: (r.onHand != null && r.onHand! <= 0)
                ? l10n.exchangeOutOfStock
                : null,
            onTap: () {
              _onHand[r.variant.id] = r.onHand;
              final next = (_taking[r.variant.id]?.qty ?? 0) + 1;
              final limit = r.onHand;
              // Same cap as the + button: never more than is on hand.
              if (limit != null && next > limit + _qtyEpsilon) return;
              _takeFromSearch(r.variant, next);
            },
          ),
        if (chosen.isEmpty && _results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l10n.exchangeNoItemsYet,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: PosTokens.ink3),
            ),
          ),
      ],
    );
  }

  Widget _buildMoney(FlipperAppLocalizations l10n) {
    final totals = _totals;
    final headline = totals.customerPays
        ? l10n.exchangeCustomerPays(_money(totals.difference))
        : totals.giveBack
        ? l10n.exchangeGiveBack(_money(totals.difference))
        : l10n.exchangeNothingToPay;
    final methods = <String>{
      _method,
      'CASH',
      kMobileMoney,
      kAirtelMoney,
    }.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: PosTokens.surface2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PosTokens.line),
          ),
          child: Column(
            children: [
              Text(
                headline,
                key: const ValueKey('exchange-headline'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.exchangeBreakdown(
                  _money(totals.returned),
                  _money(totals.taken),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: PosTokens.ink3),
              ),
            ],
          ),
        ),
        if (totals.difference != 0) ...[
          const SizedBox(height: 20),
          Text(
            l10n.exchangeHowPaid,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: PosTokens.ink2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final m in methods)
                _MethodChip(
                  label: _methodLabel(l10n, m),
                  selected: m == _method,
                  onTap: () => setState(() => _method = m),
                ),
            ],
          ),
        ],
        if (_needsPurchaseCode) ...[
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey('exchange-purchase-code'),
            controller: _purchaseCode,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: l10n.refundEnterPurchaseCodeTitle,
              hintText: l10n.refundEnterPurchaseCodeHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _methodLabel(FlipperAppLocalizations l10n, String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return l10n.cash;
      case kMobileMoney:
        return l10n.paymentMobileMoney;
      case kAirtelMoney:
        return l10n.paymentAirtelMoney;
      default:
        return method;
    }
  }

  Widget _buildDone(FlipperAppLocalizations l10n, SaleExchangeResult result) {
    final totals = result.totals;
    final summary = totals.customerPays
        ? l10n.exchangeCustomerPays(_money(totals.difference))
        : totals.giveBack
        ? l10n.exchangeGiveBack(_money(totals.difference))
        : l10n.exchangeNothingToPay;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 72,
            color: PosTokens.blue,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.exchangeDone,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: PosTokens.ink2),
          ),
          if (!result.saleSigned) ...[
            const SizedBox(height: 20),
            _Message(text: l10n.exchangeFinishHint, tone: _MessageTone.hint),
            const SizedBox(height: 8),
            _OutlinedAction(
              label: l10n.exchangeFinish,
              busy: _finishing,
              onTap: _finishing ? null : _finishSale,
            ),
          ],
          const SizedBox(height: 28),
          if (result.receipts.isNotEmpty) ...[
            _FilledAction(
              label: l10n.exchangePrintReceipts,
              onTap: _printReceipts,
            ),
            const SizedBox(height: 10),
          ],
          _OutlinedAction(
            label: l10n.exchangeClose,
            onTap: () => Navigator.of(context).pop(result),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ pieces

/// Quantities are doubles; anything closer than this is equal.
const double _qtyEpsilon = 1e-9;

class _Header extends StatelessWidget {
  const _Header({
    required this.step,
    required this.title,
    required this.onClose,
  });

  final String step;
  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PosTokens.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            iconSize: 24,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

/// A line with − / + buttons. 48 px targets so a thumb never misses.
class _QtyCard extends StatelessWidget {
  const _QtyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.qty,
    required this.max,
    required this.onChanged,
    this.unavailableLabel,
    this.stepToMax = false,
  });

  final String title;
  final String subtitle;
  final double qty;
  final double max;
  final ValueChanged<double> onChanged;
  final String? unavailableLabel;

  /// Lets the last step be part of a unit, so a line of 2.5 goes 1, 2, 2.5.
  final bool stepToMax;

  double? get _plus {
    if (stepToMax) {
      return qty < max - _qtyEpsilon ? math.min(qty + 1, max) : null;
    }
    return qty + 1 <= max + _qtyEpsilon ? qty + 1 : null;
  }

  double? get _minus {
    if (qty <= 0) return null;
    final whole = qty.floorToDouble();
    // From a fractional quantity, step down to the whole units first.
    return math.max(0.0, qty - whole > _qtyEpsilon ? whole : qty - 1);
  }

  @override
  Widget build(BuildContext context) {
    final unavailable = unavailableLabel != null;
    final selected = qty > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      decoration: BoxDecoration(
        color: selected ? PosTokens.blueTint : PosTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? PosTokens.blue : PosTokens.line,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: unavailable ? PosTokens.ink4 : PosTokens.ink1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unavailableLabel ?? subtitle,
                  style: const TextStyle(fontSize: 14, color: PosTokens.ink3),
                ),
              ],
            ),
          ),
          if (!unavailable) ...[
            _StepButton(
              icon: Icons.remove,
              onTap: _minus == null ? null : () => onChanged(_minus!),
            ),
            SizedBox(
              width: 40,
              child: Text(
                _qtyText(qty),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PosTokens.ink1,
                ),
              ),
            ),
            _StepButton(
              icon: Icons.add,
              onTap: _plus == null ? null : () => onChanged(_plus!),
            ),
          ],
        ],
      ),
    );
  }

  static String _qtyText(double q) =>
      q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(2);
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        color: PosTokens.blue,
        disabledColor: PosTokens.ink4,
        style: IconButton.styleFrom(
          backgroundColor: onTap == null ? null : PosTokens.surface,
          side: BorderSide(
            color: onTap == null ? PosTokens.line : PosTokens.blue,
          ),
        ),
      ),
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
    this.outOfStockLabel,
  });

  final String name;
  final String price;
  final VoidCallback onTap;
  final String? outOfStockLabel;

  @override
  Widget build(BuildContext context) {
    final disabled = outOfStockLabel != null;
    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      enabled: !disabled,
      onTap: disabled ? null : onTap,
      title: Text(name, style: const TextStyle(fontSize: 16)),
      subtitle: Text(outOfStockLabel ?? price),
      trailing: disabled
          ? null
          : const Icon(Icons.add_circle_outline, color: PosTokens.blue),
    );
  }
}

class _MethodChip extends StatelessWidget {
  const _MethodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? PosTokens.blue : PosTokens.blueTint,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: PosTokens.blue),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : PosTokens.blue,
          ),
        ),
      ),
    );
  }
}

enum _MessageTone { hint, error }

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.tone});

  final String text;
  final _MessageTone tone;

  @override
  Widget build(BuildContext context) {
    final error = tone == _MessageTone.error;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Text(
        text,
        key: ValueKey('exchange-message-${tone.name}'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: error ? FontWeight.w600 : FontWeight.w400,
          color: error ? PosTokens.lossInk : PosTokens.ink3,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.backLabel,
    required this.onBack,
    required this.nextLabel,
    required this.onNext,
    required this.busy,
  });

  final String backLabel;
  final VoidCallback? onBack;

  /// Null: only [backLabel] is offered.
  final String? nextLabel;
  final VoidCallback? onNext;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: PosTokens.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _OutlinedAction(label: backLabel, onTap: onBack),
          ),
          if (nextLabel case final next?) ...[
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _FilledAction(label: next, onTap: onNext, busy: busy),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilledAction extends StatelessWidget {
  const _FilledAction({required this.label, this.onTap, this.busy = false});

  final String label;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: busy ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: PosTokens.blue,
          disabledBackgroundColor: PosTokens.blue.withValues(alpha: 0.35),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({required this.label, this.onTap, this.busy = false});

  final String label;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: busy ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: PosTokens.blueTint,
          foregroundColor: PosTokens.blue,
          side: const BorderSide(color: PosTokens.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(label),
      ),
    );
  }
}
