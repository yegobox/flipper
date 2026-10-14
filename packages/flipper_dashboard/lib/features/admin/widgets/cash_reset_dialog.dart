import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/cash_movement_reset_client.dart';
import 'package:flipper_models/helperModels/extensions.dart'
    show CurrencyFormatExtension;
import 'package:flipper_models/providers/currency_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart'
    show cashbookRecentTransactionsProvider;
import 'package:flipper_services/data_connector_url.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The connector client for this branch. Tests override it with a fake.
final cashMovementResetClientProvider = Provider<CashMovementResetClient>(
  (ref) => CashMovementResetClient(
    baseUrl: () async => resolveDataConnectorBaseUrl(
      dataConnectorUrl: await resolveEbmDataConnectorUrl(),
    ),
  ),
);

/// Asks for the admin PIN when one is set. Returns false to abort.
typedef CashResetAdminCheck = Future<bool> Function(BuildContext context);

const Color _kBlue = Color(0xFF2563EB);
const Color _kDanger = Color(0xFFDC2626);

/// Opens the clean-slate flow: pick kinds → preview counts → type the
/// business name → admin PIN (if set) → delete on the connector.
Future<void> showCashResetDialog(
  BuildContext context, {
  CashResetAdminCheck? verifyAdmin,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => CashResetDialog(verifyAdmin: verifyAdmin),
  );
}

enum _Step { pick, loading, confirm, deleting }

class CashResetDialog extends ConsumerStatefulWidget {
  const CashResetDialog({super.key, this.verifyAdmin});

  final CashResetAdminCheck? verifyAdmin;

  @override
  ConsumerState<CashResetDialog> createState() => _CashResetDialogState();
}

class _CashResetDialogState extends ConsumerState<CashResetDialog> {
  final Set<CashMovementKind> _kinds = {...CashMovementKind.values};
  final TextEditingController _confirm = TextEditingController();
  _Step _step = _Step.pick;
  CashResetSummary? _preview;
  String? _error;
  bool _verifyingAdmin = false;

  @override
  void initState() {
    super.initState();
    _confirm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  bool get _confirmMatches {
    final expected = _preview?.businessName.toLowerCase() ?? '';
    return expected.isNotEmpty &&
        _confirm.text.trim().toLowerCase() == expected;
  }

  /// A 403 means staff have not enabled a reset for this business (it is
  /// granted per request in Supabase). A 401 means this device has no
  /// connector session, and the server's "authentication required" tells a
  /// shop owner nothing. Anything else is a real failure.
  String _errorText(Object e) {
    final l10n = context.flipperL10n;
    if (e is CashResetException && e.statusCode == 403) {
      return l10n.cashResetNotEnabled;
    }
    if (e is CashResetException && e.statusCode == 401) {
      return l10n.cashResetSignInFailed;
    }
    return l10n.cashResetFailed('$e');
  }

  Future<void> _runPreview() async {
    setState(() {
      _step = _Step.loading;
      _error = null;
    });
    try {
      final preview = await ref.read(cashMovementResetClientProvider).preview({
        ..._kinds,
      });
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _step = _Step.confirm;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _errorText(e);
        _step = _Step.pick;
      });
    }
  }

  Future<void> _runDelete() async {
    // Two taps while the admin check is still open would otherwise each go
    // on to delete; the flag clears even if the check throws, and that
    // failure is shown like any other.
    if (_verifyingAdmin) return;
    final verify = widget.verifyAdmin;
    if (verify != null) {
      _verifyingAdmin = true;
      try {
        if (!await verify(context)) return;
      } catch (e) {
        if (mounted) setState(() => _error = _errorText(e));
        return;
      } finally {
        _verifyingAdmin = false;
      }
    }
    if (!mounted) return;
    setState(() {
      _step = _Step.deleting;
      _error = null;
    });
    try {
      final result = await ref.read(cashMovementResetClientProvider).reset({
        ..._kinds,
      }, confirm: _confirm.text);
      if (!mounted) return;
      // The Ditto tombstones reach the observers on their own; this just
      // drops the cached window so the Cash Book does not flash old rows.
      ref.invalidate(cashbookRecentTransactionsProvider);
      final messenger = ScaffoldMessenger.maybeOf(context);
      final done = context.flipperL10n.cashResetDone(result.transactions);
      Navigator.of(context).pop();
      messenger?.showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _errorText(e);
        _step = _Step.confirm;
      });
    }
  }

  String _label(CashMovementKind kind) => switch (kind) {
    CashMovementKind.cashIn => context.flipperL10n.cashbookCashIn,
    CashMovementKind.cashOut => context.flipperL10n.cashbookCashOut,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _kDanger),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.cashResetTitle)),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(child: _body(context)),
      ),
      actions: _actions(context),
    );
  }

  Widget _body(BuildContext context) {
    final l10n = context.flipperL10n;
    final error = _error == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: const TextStyle(color: _kDanger)),
          );
    switch (_step) {
      case _Step.loading:
      case _Step.deleting:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        );
      case _Step.pick:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.cashResetSubtitle),
            const SizedBox(height: 12),
            Text(
              l10n.cashResetPickKinds,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            for (final kind in CashMovementKind.values)
              CheckboxListTile(
                key: ValueKey('cash-reset-${kind.wire}'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: _kBlue,
                title: Text(_label(kind)),
                value: _kinds.contains(kind),
                onChanged: (on) => setState(
                  () => on == true ? _kinds.add(kind) : _kinds.remove(kind),
                ),
              ),
            if (error != null) error,
          ],
        );
      case _Step.confirm:
        final preview = _preview!;
        if (preview.transactions == 0) {
          return Text(l10n.cashResetNothing);
        }
        final currency = ref.watch(defaultCurrencyProvider);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.cashResetSummary(preview.transactions)),
            const SizedBox(height: 12),
            for (final kind in CashMovementKind.values)
              if (_kinds.contains(kind))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    l10n.cashResetKindLine(
                      _label(kind),
                      preview.totalsFor(kind).count,
                      preview
                          .totalsFor(kind)
                          .amount
                          .toCurrencyFormatted(symbol: currency),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('cash-reset-confirm'),
              controller: _confirm,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.cashResetTypeToConfirm(preview.businessName),
                border: const OutlineInputBorder(),
              ),
            ),
            if (error != null) error,
          ],
        );
    }
  }

  List<Widget> _actions(BuildContext context) {
    final l10n = context.flipperL10n;
    final busy = _step == _Step.loading || _step == _Step.deleting;
    final cancel = OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: _kBlue,
        side: const BorderSide(color: _kBlue),
      ),
      onPressed: busy ? null : () => Navigator.of(context).pop(),
      child: Text(
        _step == _Step.confirm && _preview?.transactions == 0
            ? l10n.close
            : l10n.cancel,
      ),
    );
    final filled = FilledButton.styleFrom(backgroundColor: _kBlue);
    return switch (_step) {
      _Step.pick || _Step.loading => [
        cancel,
        FilledButton(
          key: const ValueKey('cash-reset-preview'),
          style: filled,
          onPressed: busy || _kinds.isEmpty ? null : _runPreview,
          child: Text(l10n.cashResetPreview),
        ),
      ],
      _Step.confirm || _Step.deleting => [
        cancel,
        if ((_preview?.transactions ?? 0) > 0)
          FilledButton(
            key: const ValueKey('cash-reset-delete'),
            style: filled,
            onPressed: busy || !_confirmMatches ? null : _runDelete,
            child: Text(l10n.cashResetDelete),
          ),
      ],
    };
  }
}
