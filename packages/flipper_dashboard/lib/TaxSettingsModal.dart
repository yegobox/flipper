import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/config/system_config_tokens.dart';
import 'package:flipper_dashboard/features/config/widgets/config_chrome.dart';
import 'package:flipper_dashboard/features/receipt_header/receipt_header_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Tax rates and the receipt header (phone, email, welcome line) for a branch,
/// in the same chrome as System Configuration.
class TaxSettingsModal extends ConsumerStatefulWidget {
  final String branchId;

  const TaxSettingsModal({Key? key, required this.branchId}) : super(key: key);

  @override
  ConsumerState<TaxSettingsModal> createState() => _TaxSettingsModalState();
}

/// Screen width under which a tax rate being edited moves below its label.
const double _stackedEditBelow = 480;

class _TaxSettingsModalState extends ConsumerState<TaxSettingsModal> {
  late Future<List<Configurations>> _taxConfigsFuture;
  final Map<String, bool> _editingStates = {};
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};
  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _loadTaxConfigurations();
  }

  void _loadTaxConfigurations() {
    _taxConfigsFuture = ref
        .read(branchServicesProvider)
        .strategy
        .taxes(branchId: widget.branchId);
  }

  Future<void> _saveTaxConfiguration(
    String configId,
    String newTaxValue,
  ) async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = null;
      });

      final newTaxPercentage = double.parse(newTaxValue);
      await ref
          .read(branchServicesProvider)
          .strategy
          .saveTax(configId: configId, taxPercentage: newTaxPercentage);

      if (mounted) {
        setState(() {
          _editingStates[configId] = false;
          _statusMessage = context.flipperL10n.taxSettingsUpdated;
          _isError = false;
          _loadTaxConfigurations();
        });

        _statusTimer?.cancel();
        _statusTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) setState(() => _statusMessage = null);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = context.flipperL10n.taxSettingsUpdateError;
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _submit(Configurations config) {
    // Enter in the field bypasses the disabled buttons; one save at a time.
    if (_isLoading) return;
    if (_formKeys[config.id]!.currentState!.validate()) {
      _saveTaxConfiguration(config.id, _controllers[config.id]!.text);
    }
  }

  void _cancelEdit(Configurations config) {
    setState(() {
      _editingStates[config.id] = false;
      _controllers[config.id]!.text = config.taxPercentage.toString();
    });
  }

  String? _validateRate(String? value) {
    final l10n = context.flipperL10n;
    if (value == null || value.isEmpty) return l10n.taxSettingsRequired;
    final tax = double.tryParse(value);
    if (tax == null) return l10n.invalidNumber;
    if (tax < 0 || tax > 100) return l10n.taxSettingsRange;
    return null;
  }

  Widget _buildTaxRow(Configurations config, {required bool first}) {
    final bool isEditing = _editingStates[config.id] ?? false;
    final l10n = context.flipperL10n;

    if (!_controllers.containsKey(config.id)) {
      _controllers[config.id] = TextEditingController(
        text: config.taxPercentage.toString(),
      );
      _formKeys[config.id] = GlobalKey<FormState>();
    }

    final code = (config.taxType ?? '').trim();
    final label = Text(
      l10n.taxSettingsTaxType(code),
      style: GoogleFonts.outfit(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: SystemConfigTokens.ink,
      ),
    );
    final editButton = _RowIconButton(
      icon: Icons.edit_outlined,
      tooltip: l10n.edit,
      onPressed: _isLoading
          ? null
          : () => setState(() => _editingStates[config.id] = true),
    );

    if (!isEditing) {
      return ConfigGroupRow(
        first: first,
        child: Row(
          children: [
            _TaxCodeBadge(code: code),
            const SizedBox(width: 14),
            Expanded(child: label),
            Text(
              '${config.taxPercentage}%',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: SystemConfigTokens.ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 8),
            editButton,
          ],
        ),
      );
    }

    final field = Form(
      key: _formKeys[config.id],
      child: ConfigTextField(
        fieldKey: ValueKey('taxRate-${config.id}'),
        controller: _controllers[config.id]!,
        autofocus: true,
        suffixText: '%',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: _validateRate,
        onFieldSubmitted: (_) => _submit(config),
      ),
    );
    final actions = [
      _RowIconButton(
        icon: Icons.check,
        tooltip: l10n.save,
        primary: true,
        onPressed: _isLoading ? null : () => _submit(config),
      ),
      const SizedBox(width: 6),
      _RowIconButton(
        icon: Icons.undo,
        tooltip: l10n.cancel,
        onPressed: _isLoading ? null : () => _cancelEdit(config),
      ),
    ];

    // A phone leaves ~230px per row; badge + field + two buttons need ~262,
    // so the editor drops to its own line there.
    if (MediaQuery.sizeOf(context).width < _stackedEditBelow) {
      return ConfigGroupRow(
        first: first,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _TaxCodeBadge(code: code),
                const SizedBox(width: 14),
                Expanded(child: label),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: field),
                const SizedBox(width: 8),
                ...actions,
              ],
            ),
          ],
        ),
      );
    }

    return ConfigGroupRow(
      first: first,
      child: Row(
        children: [
          _TaxCodeBadge(code: code),
          const SizedBox(width: 14),
          Expanded(child: label),
          SizedBox(width: 130, child: field),
          const SizedBox(width: 8),
          ...actions,
        ],
      ),
    );
  }

  Widget _buildRates() {
    final l10n = context.flipperL10n;
    return FutureBuilder<List<Configurations>>(
      future: _taxConfigsFuture,
      builder: (context, snapshot) {
        final muted = GoogleFonts.outfit(
          fontSize: 13,
          color: SystemConfigTokens.muted,
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: SystemConfigTokens.accent,
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return ConfigNotice(
            tone: ConfigNoticeTone.error,
            message: l10n.errorMessage('${snapshot.error}'),
          );
        }
        final rows = snapshot.data ?? const <Configurations>[];
        if (rows.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(l10n.taxSettingsNoneFound, style: muted),
          );
        }
        return ConfigGroup(
          children: [
            for (var i = 0; i < rows.length; i++)
              _buildTaxRow(rows[i], first: i == 0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConfigDialogCard(
        maxWidth: 600,
        header: ConfigHeader(
          icon: Icons.receipt_long_outlined,
          title: l10n.taxSettings,
          subtitle: l10n.taxSettingsSubtitle,
          onClose: () => Navigator.of(context).maybePop(),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReceiptHeaderSection(branchId: widget.branchId),
            const SizedBox(height: 28),
            ConfigSectionLabel(title: l10n.taxSettingsRates),
            const SizedBox(height: 6),
            ConfigSectionHint(l10n.taxSettingsRatesHint),
            const SizedBox(height: 14),
            if (_statusMessage != null) ...[
              ConfigNotice(
                key: const ValueKey('taxSettingsStatus'),
                tone: _isError
                    ? ConfigNoticeTone.error
                    : ConfigNoticeTone.success,
                message: _statusMessage!,
                onDismiss: _isError
                    ? () => setState(() => _statusMessage = null)
                    : null,
              ),
              const SizedBox(height: 12),
            ],
            _buildRates(),
          ],
        ),
      ),
    );
  }
}

/// The RRA tax code ("A", "B", "TT") in a tinted tile.
class _TaxCodeBadge extends StatelessWidget {
  const _TaxCodeBadge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: SystemConfigTokens.accentTint,
        borderRadius: BorderRadius.circular(SystemConfigTokens.iconRadius),
      ),
      child: Text(
        code.isEmpty ? '–' : code,
        style: GoogleFonts.outfit(
          fontSize: code.length > 1 ? 12.5 : 15,
          fontWeight: FontWeight.w700,
          color: SystemConfigTokens.accent,
        ),
      ),
    );
  }
}

class _RowIconButton extends StatelessWidget {
  const _RowIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: primary ? SystemConfigTokens.accent : SystemConfigTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
          side: primary
              ? BorderSide.none
              : const BorderSide(color: SystemConfigTokens.border),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
          ),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(
              icon,
              size: 17,
              color: primary ? Colors.white : SystemConfigTokens.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
