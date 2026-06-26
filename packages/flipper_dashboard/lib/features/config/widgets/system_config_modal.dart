// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/features/config/system_config_tokens.dart';
import 'package:flipper_dashboard/features/config/tax_config_logic.dart';
import 'package:flipper_dashboard/features/config/widgets/currency_options.dart';
import 'package:flipper_dashboard/features/config/widgets/support_section.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/view_models/setting_view_model.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

/// Opens the redesigned system configuration modal.
Future<void> showSystemConfigModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: SystemConfigTokens.scrim,
    builder: (context) => const _SystemConfigDialog(),
  );
}

class _SystemConfigDialog extends StatelessWidget {
  const _SystemConfigDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: SystemConfigModalCard(
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Modal card content — used in dialogs and full-page routes.
class SystemConfigModalCard extends ConsumerStatefulWidget {
  const SystemConfigModalCard({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  ConsumerState<SystemConfigModalCard> createState() =>
      _SystemConfigModalCardState();
}

class _SystemConfigModalCardState extends ConsumerState<SystemConfigModalCard> {
  bool _isTaxEnabled = false;
  bool _taxDataLoaded = false;
  bool _isSaving = false;
  bool _saved = false;
  Timer? _savedTimer;

  bool _vatEnabled = false;
  TaxConfigSnapshot? _initialSnapshot;

  final _formKey = GlobalKey<FormState>();
  final _serverFieldKey = GlobalKey();
  final _dataConnectorFieldKey = GlobalKey();
  final _branchFieldKey = GlobalKey();
  final _mrcFieldKey = GlobalKey();

  final _serverUrlController = TextEditingController();
  final _dataConnectorUrlController = TextEditingController();
  final _branchController = TextEditingController();
  final _mrcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTaxEnabled();
    for (final c in [
      _serverUrlController,
      _dataConnectorUrlController,
      _branchController,
      _mrcController,
    ]) {
      c.addListener(_onFieldEdited);
    }
  }

  @override
  void dispose() {
    _savedTimer?.cancel();
    _serverUrlController.dispose();
    _dataConnectorUrlController.dispose();
    _branchController.dispose();
    _mrcController.dispose();
    super.dispose();
  }

  void _onFieldEdited() => _resetSavedState();

  void _resetSavedState() {
    if (!_saved) return;
    _savedTimer?.cancel();
    setState(() => _saved = false);
  }

  Future<void> _loadTaxEnabled() async {
    try {
      final isTaxEnabledForBusiness = await ProxyService.strategy.isTaxEnabled(
        businessId: ProxyService.box.getBusinessId()!,
        branchId: ProxyService.box.getBranchId()!,
      );
      if (!mounted) return;
      setState(() => _isTaxEnabled = isTaxEnabledForBusiness);
      if (isTaxEnabledForBusiness) {
        await _loadTaxData();
      }
    } catch (e, s) {
      talker.warning(s);
    }
  }

  TaxConfigSnapshot _snapshotFromControllers() {
    return TaxConfigSnapshot.fromInputs(
      serverUrl: _serverUrlController.text,
      dataConnectorUrl: _dataConnectorUrlController.text,
      bhfId: _branchController.text,
      mrc: _mrcController.text,
      vatEnabled: _vatEnabled,
    );
  }

  Future<void> _loadTaxData() async {
    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    final serverUrl =
        ebm?.taxServerUrl ?? await ProxyService.box.getServerUrl();

    _serverUrlController.text = serverUrl ?? '';
    _dataConnectorUrlController.text = ebm?.dataConnectorUrl?.trim() ?? '';

    final bhFId = ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? '';
    _branchController.text = bhFId;
    final mrc = ebm?.mrc ?? ProxyService.box.mrc();
    _mrcController.text = (mrc == null || mrc.isEmpty) ? '' : mrc;

    if (ebm != null) {
      await ProxyService.box
          .writeBool(key: 'vatEnabled', value: ebm.vatEnabled ?? false);
    }

    if (!mounted) return;
    setState(() {
      if (ebm != null) {
        _vatEnabled = ebm.vatEnabled ?? false;
      }
      _initialSnapshot = _snapshotFromControllers();
      _taxDataLoaded = true;
    });
  }

  void _syncInitialVatFromProvider(bool vatEnabled) {
    final base = _initialSnapshot;
    if (base == null) return;
    _initialSnapshot = TaxConfigSnapshot(
      serverUrl: base.serverUrl,
      dataConnectorUrlOrNull: base.dataConnectorUrlOrNull,
      bhfId: base.bhfId,
      mrc: base.mrc,
      vatEnabled: vatEnabled,
    );
  }

  void _showSavedConfirmation() {
    setState(() => _saved = true);
    _savedTimer?.cancel();
    _savedTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  Future<void> _scrollToFirstError() async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    final validators = <String? Function()>[
      () => _validateUrl(_serverUrlController.text),
      () => _validateOptionalUrl(_dataConnectorUrlController.text),
      () => _validateBhfid(_branchController.text),
      () => _validateMrc(_mrcController.text),
    ];
    final fieldKeys = [
      _serverFieldKey,
      _dataConnectorFieldKey,
      _branchFieldKey,
      _mrcFieldKey,
    ];
    for (var i = 0; i < validators.length; i++) {
      if (validators[i]() != null) {
        final ctx = fieldKeys[i].currentContext;
        if (ctx != null) {
          await Scrollable.ensureVisible(
            ctx,
            alignment: 0.12,
            duration: const Duration(milliseconds: 280),
          );
        }
        break;
      }
    }
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid URL';
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL with a scheme (e.g., http:// or https://)';
    }
    return null;
  }

  String? _validateOptionalUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL with a scheme (e.g., http:// or https://)';
    }
    return null;
  }

  String? _validateBhfid(String? value) {
    if (value == null || value.isEmpty) return 'Branch ID is required';
    return null;
  }

  String? _validateMrc(String? value) {
    if (value == null || value.isEmpty) return 'MRC is required';
    if (value.length != 11) return 'MRC must be exactly 11 characters';
    return null;
  }

  Future<void> _saveTaxConfig() async {
    if (!_taxDataLoaded || _initialSnapshot == null) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      await _scrollToFirstError();
      return;
    }

    final current = _snapshotFromControllers();
    if (!taxConfigHasChanges(_initialSnapshot!, current)) {
      showWarningNotification(context, 'No changes to save');
      return;
    }

    final trimmedServer = trimTaxConfigUrl(_serverUrlController.text);
    final dataConnectorForSave =
        normalizeOptionalConnectorUrl(_dataConnectorUrlController.text);
    final bhf = trimTaxConfigUrl(_branchController.text);
    final mrc = trimTaxConfigUrl(_mrcController.text);

    setState(() => _isSaving = true);
    try {
      final ok = await ProxyService.strategy.saveEbm(
        branchId: ProxyService.box.getBranchId()!,
        severUrl: trimmedServer,
        bhFId: bhf,
        vatEnabled: _vatEnabled,
        mrc: mrc,
        dataConnectorUrl: dataConnectorForSave,
      );

      if (!mounted) return;

      if (!ok) {
        showErrorNotification(
          context,
          'Could not save tax configuration. Check your connection and try again.',
        );
        return;
      }

      final dcBox = dataConnectorForSave ?? '';

      await Future.wait([
        ProxyService.box.writeString(key: 'getServerUrl', value: trimmedServer),
        ProxyService.box.writeString(key: 'dataConnectorUrl', value: dcBox),
        ProxyService.box.writeString(key: 'bhfId', value: bhf),
        ProxyService.box.writeString(key: 'mrc', value: mrc),
        ProxyService.box.writeBool(key: 'vatEnabled', value: _vatEnabled),
      ]);

      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        ref.refresh(outerVariantsProvider(branchId));
        ref.invalidate(ebmVatEnabledProvider);
      }

      setState(() {
        _initialSnapshot = _snapshotFromControllers();
      });

      showSuccessNotification(context, 'Tax configuration saved');
      _showSavedConfirmation();
    } catch (e) {
      if (!mounted) return;
      final text =
          e.toString().length > 200 ? '${e.toString().substring(0, 200)}…' : e.toString();
      showErrorNotification(context, text);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, _) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: SystemConfigTokens.cardMaxWidth,
            maxHeight: maxHeight,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SystemConfigTokens.cardRadius),
            boxShadow: SystemConfigTokens.cardShadow,
          ),
          child: Material(
            color: SystemConfigTokens.surface,
            borderRadius:
                BorderRadius.circular(SystemConfigTokens.cardRadius),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(onClose: widget.onClose),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      SystemConfigTokens.cardPaddingH,
                      22,
                      SystemConfigTokens.cardPaddingH,
                      8,
                    ),
                    child: _isTaxEnabled
                        ? _buildTaxEnabledBody(model)
                        : const _SupportBody(),
                  ),
                ),
                if (_isTaxEnabled)
                  _Footer(
                    saved: _saved,
                    isSaving: _isSaving,
                    dataLoaded: _taxDataLoaded,
                    onSave: _saveTaxConfig,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaxEnabledBody(SettingViewModel model) {
    final vatAsync = ref.watch(ebmVatEnabledProvider);
    vatAsync.whenData((vatEnabled) {
      if (_vatEnabled != vatEnabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _vatEnabled = vatEnabled;
            _syncInitialVatFromProvider(vatEnabled);
          });
        });
      }
    });

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionLabel(title: 'General'),
          const SizedBox(height: 12),
          _GeneralSection(
            model: model,
            onChanged: () {
              _resetSavedState();
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          const _SectionLabel(title: 'Tax Configuration'),
          const SizedBox(height: 6),
          Text(
            'Save applies to EBM / tax URL, data connector URL, branch code, and MRC.',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              color: SystemConfigTokens.secondary,
            ),
          ),
          const SizedBox(height: 14),
          _VatLockedRow(vatEnabled: _vatEnabled),
          const SizedBox(height: 16),
          _ScTextField(
            fieldKey: _serverFieldKey,
            label: 'EBM / Tax server URL',
            controller: _serverUrlController,
            validator: _validateUrl,
          ),
          const SizedBox(height: 14),
          _ScTextField(
            fieldKey: _dataConnectorFieldKey,
            label: 'Data connector URL',
            controller: _dataConnectorUrlController,
            validator: _validateOptionalUrl,
            helper:
                'Bulk product RRA uses this service; RRA tax URL is configured on data-connector.',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ScTextField(
                  fieldKey: _branchFieldKey,
                  label: 'Branch code (bhfId)',
                  controller: _branchController,
                  validator: _validateBhfid,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ScTextField(
                  fieldKey: _mrcFieldKey,
                  label: 'MRC',
                  controller: _mrcController,
                  validator: _validateMrc,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportBody extends StatelessWidget {
  const _SupportBody();

  @override
  Widget build(BuildContext context) {
    return const SupportSection();
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SystemConfigTokens.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: SystemConfigTokens.accentTint,
              borderRadius: BorderRadius.circular(SystemConfigTokens.iconRadius),
            ),
            child: const Icon(
              Icons.settings_outlined,
              size: 20,
              color: SystemConfigTokens.accent,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Configuration',
                  style: GoogleFonts.outfit(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.01 * 21,
                    color: SystemConfigTokens.ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage POS behaviour, currency and tax integration.',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    color: SystemConfigTokens.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            _CloseButton(onTap: onClose!),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _hovered ? SystemConfigTokens.inputFill : SystemConfigTokens.surface,
            borderRadius: BorderRadius.circular(SystemConfigTokens.closeRadius),
            border: Border.all(color: SystemConfigTokens.border),
          ),
          child: const Icon(
            Icons.close,
            size: 16,
            color: SystemConfigTokens.secondary,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.16 * 11,
            color: SystemConfigTokens.accent,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(height: 1, thickness: 1, color: SystemConfigTokens.border),
        ),
      ],
    );
  }
}

class _GeneralSection extends StatelessWidget {
  const _GeneralSection({
    required this.model,
    required this.onChanged,
  });

  final SettingViewModel model;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: SystemConfigTokens.border),
        borderRadius: BorderRadius.circular(SystemConfigTokens.sectionRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SystemConfigTokens.sectionRadius),
        child: Column(
          children: [
            _ToggleRow(
              label: 'Training Mode',
              value: model.isTrainingModeEnabled,
              onChanged: (v) {
                model.isTrainingModeEnabled = v;
                onChanged();
              },
            ),
            _ToggleRow(
              label: 'Proforma Mode',
              value: model.isProformaModeEnabled,
              onChanged: (v) {
                model.isProformaModeEnabled = v;
                onChanged();
              },
            ),
            _ToggleRow(
              label: 'Print A4',
              value: model.printA4,
              onChanged: (v) {
                model.printA4 = v;
                onChanged();
              },
            ),
            _ToggleRow(
              label: 'Export as PDF',
              value: model.exportAsPdf,
              onChanged: (v) {
                model.exportAsPdf = v;
                onChanged();
              },
            ),
            _CurrencyRow(
              value: model.systemCurrency,
              onChanged: (v) {
                model.systemCurrency = v;
                onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SystemConfigTokens.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: SystemConfigTokens.ink,
              ),
            ),
          ),
          _ScSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SystemConfigTokens.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'System Currency',
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: SystemConfigTokens.ink,
              ),
            ),
          ),
          SizedBox(
            width: 230,
            child: _CurrencyDropdown(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: SystemConfigTokens.inputFill,
        borderRadius: BorderRadius.circular(SystemConfigTokens.fieldRadius),
        border: Border.all(color: SystemConfigTokens.inputBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: SystemConfigTokens.secondary,
            size: 18,
          ),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SystemConfigTokens.ink,
          ),
          items: CurrencyOptions.getCurrencyOptions(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _ScSwitch extends StatelessWidget {
  const _ScSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchTheme(
      data: SwitchThemeData(
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SystemConfigTokens.accent;
          }
          return SystemConfigTokens.switchOff;
        }),
      ),
      child: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _VatLockedRow extends StatelessWidget {
  const _VatLockedRow({required this.vatEnabled});

  final bool vatEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: SystemConfigTokens.vatSurface,
        borderRadius: BorderRadius.circular(SystemConfigTokens.vatRadius),
        border: Border.all(color: SystemConfigTokens.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'VAT Enabled',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SystemConfigTokens.secondary,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.lock_outline,
                      size: 13,
                      color: SystemConfigTokens.muted,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Controlled by EBM configuration',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: SystemConfigTokens.muted,
                  ),
                ),
              ],
            ),
          ),
          SwitchTheme(
            data: SwitchThemeData(
              trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
              thumbColor: const WidgetStatePropertyAll(Colors.white),
              trackColor: const WidgetStatePropertyAll(SystemConfigTokens.vatTrack),
            ),
            child: Switch(
              value: vatEnabled,
              onChanged: null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScTextField extends StatefulWidget {
  const _ScTextField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.validator,
    this.helper,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String? helper;

  @override
  State<_ScTextField> createState() => _ScTextFieldState();
}

class _ScTextFieldState extends State<_ScTextField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: SystemConfigTokens.secondary,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SystemConfigTokens.fieldRadius),
            boxShadow: _focused
                ? const [
                    BoxShadow(
                      color: SystemConfigTokens.focusRing,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            key: widget.fieldKey,
            controller: widget.controller,
            focusNode: _focusNode,
            validator: widget.validator,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: SystemConfigTokens.ink,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _focused
                  ? SystemConfigTokens.surface
                  : SystemConfigTokens.inputFill,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SystemConfigTokens.fieldRadius),
                borderSide: const BorderSide(color: SystemConfigTokens.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SystemConfigTokens.fieldRadius),
                borderSide: const BorderSide(color: SystemConfigTokens.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SystemConfigTokens.fieldRadius),
                borderSide: const BorderSide(color: SystemConfigTokens.accent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SystemConfigTokens.fieldRadius),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
            ),
          ),
        ),
        if (widget.helper != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helper!,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              color: SystemConfigTokens.muted,
            ),
          ),
        ],
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.saved,
    required this.isSaving,
    required this.dataLoaded,
    required this.onSave,
  });

  final bool saved;
  final bool isSaving;
  final bool dataLoaded;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SystemConfigTokens.border)),
      ),
      child: Column(
        children: [
          _SaveButton(
            saved: saved,
            isSaving: isSaving,
            enabled: dataLoaded && !isSaving,
            onSave: onSave,
          ),
          const SizedBox(height: 12),
          FutureBuilder<String>(
            future: AppService().version(),
            builder: (context, snapshot) {
              final version = snapshot.hasData
                  ? snapshot.data!
                  : snapshot.connectionState == ConnectionState.waiting
                      ? '…'
                      : 'Version not available';
              return Text(
                'Version $version',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: SystemConfigTokens.muted,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({
    required this.saved,
    required this.isSaving,
    required this.enabled,
    required this.onSave,
  });

  final bool saved;
  final bool isSaving;
  final bool enabled;
  final VoidCallback onSave;

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.saved
        ? SystemConfigTokens.accentStrong
        : SystemConfigTokens.accent;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.enabled ? widget.onSave : null,
      child: AnimatedScale(
        scale: _pressed ? 0.992 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.enabled ? bg : bg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(SystemConfigTokens.buttonRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isSaving)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else if (widget.saved)
                const Icon(Icons.check, size: 18, color: Colors.white),
              if (widget.isSaving || widget.saved) const SizedBox(width: 9),
              Text(
                widget.isSaving
                    ? 'Saving…'
                    : widget.saved
                        ? 'Saved'
                        : 'Save configuration',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
