// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/config/tax_config_logic.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

class TaxConfigForm extends ConsumerStatefulWidget {
  const TaxConfigForm({Key? key}) : super(key: key);

  @override
  ConsumerState<TaxConfigForm> createState() => _TaxConfigFormState();
}

class _TaxConfigFormState extends ConsumerState<TaxConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _serverFieldKey = GlobalKey();
  final _dataConnectorFieldKey = GlobalKey();
  final _branchFieldKey = GlobalKey();
  final _mrcFieldKey = GlobalKey();

  final _serverUrlController = TextEditingController();
  final _dataConnectorUrlController = TextEditingController();
  final _branchController = TextEditingController();
  final _mrcController = TextEditingController();

  bool _vatEnabled = false;
  bool _isSaving = false;
  bool _dataLoaded = false;
  TaxConfigSnapshot? _initialSnapshot;

  @override
  void initState() {
    super.initState();
    _loadData();
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

  Future<void> _loadData() async {
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
      _dataLoaded = true;
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

  @override
  void dispose() {
    _serverUrlController.dispose();
    _dataConnectorUrlController.dispose();
    _branchController.dispose();
    _mrcController.dispose();
    super.dispose();
  }

  void _feedbackSuccess() {
    if (!mounted) return;
    const msg = 'Tax configuration saved';
    showSimpleNotification(
      const Text(msg),
      background: Colors.green.shade700,
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(msg),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _feedbackError(String message) {
    if (!mounted) return;
    final text = message.length > 200 ? '${message.substring(0, 200)}…' : message;
    showSimpleNotification(
      Text(text),
      background: Colors.red.shade800,
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _feedbackNoChanges() {
    if (!mounted) return;
    const msg = 'No changes to save';
    showSimpleNotification(
      const Text(msg),
      background: Colors.amber.shade800,
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(msg),
        backgroundColor: Colors.amber.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Configuration',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save applies to EBM / tax URL, data connector URL, branch code, and MRC.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        final vatEnabledAsync = ref.watch(ebmVatEnabledProvider);
                        return vatEnabledAsync.when(
                          data: (vatEnabled) {
                            if (_vatEnabled != vatEnabled) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                setState(() {
                                  _vatEnabled = vatEnabled;
                                  _syncInitialVatFromProvider(vatEnabled);
                                });
                              });
                            }
                            return SwitchListTile(
                              title: const Text('VAT Enabled'),
                              subtitle: const Text(
                                'VAT status is controlled by EBM configuration',
                              ),
                              value: vatEnabled,
                              activeThumbColor: Colors.blue,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              onChanged: null,
                            );
                          },
                          loading: () => SwitchListTile(
                            title: const Text('VAT Enabled'),
                            subtitle: const Text('Loading...'),
                            value: _vatEnabled,
                            activeThumbColor: Colors.blue,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            onChanged: null,
                          ),
                          error: (error, stack) => SwitchListTile(
                            title: const Text('VAT Enabled'),
                            subtitle: const Text('Error loading VAT status'),
                            value: _vatEnabled,
                            activeThumbColor: Colors.blue,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            onChanged: null,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _serverFieldKey,
                      controller: _serverUrlController,
                      decoration: InputDecoration(
                        labelText: 'EBM / Tax server URL',
                        hintText: 'Enter EBM URL',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      validator: _validateUrl,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _dataConnectorFieldKey,
                      controller: _dataConnectorUrlController,
                      decoration: InputDecoration(
                        labelText: 'Data connector URL',
                        hintText: 'http://127.0.0.1:8084',
                        helperText:
                            'Bulk product RRA uses this service; RRA tax URL is configured on data-connector.',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      validator: _validateOptionalUrl,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _branchFieldKey,
                      controller: _branchController,
                      decoration: InputDecoration(
                        labelText: 'Branch code (bhfId)',
                        hintText: 'Branch Code',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      validator: _validateBhfid,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: _mrcFieldKey,
                      controller: _mrcController,
                      decoration: InputDecoration(
                        labelText: 'MRC',
                        hintText: 'MRC',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      validator: _validateMrc,
                    ),
                    const SizedBox(height: 16),
                    FlipperButton(
                      color: Colors.blue,
                      width: double.infinity,
                      textColor: Colors.white,
                      isLoading: _isSaving,
                      onPressed:
                          _dataLoaded && !_isSaving ? _saveForm : null,
                      text: 'Save',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FutureBuilder<String>(
                future: AppService().version(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      'Version: ${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  } else {
                    return const Text('Version not available');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL with a scheme (e.g., http:// or https://)';
    }
    return null;
  }

  String? _validateBhfid(String? value) {
    if (value == null || value.isEmpty) {
      return 'Branch ID is required';
    }
    return null;
  }

  String? _validateMrc(String? value) {
    if (value == null || value.isEmpty) {
      return 'MRC is required';
    }
    if (value.length != 11) {
      return 'MRC must be exactly 11 characters';
    }
    return null;
  }

  Future<void> _saveForm() async {
    if (!_dataLoaded || _initialSnapshot == null) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      await _scrollToFirstError();
      return;
    }

    final current = _snapshotFromControllers();
    if (!taxConfigHasChanges(_initialSnapshot!, current)) {
      _feedbackNoChanges();
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
        _feedbackError(
          'Could not save tax configuration. Check your connection and try again.',
        );
        return;
      }

      final dcBox = dataConnectorForSave ?? '';

      await Future.wait([
        ProxyService.box.writeString(
          key: 'getServerUrl',
          value: trimmedServer,
        ),
        ProxyService.box.writeString(
          key: 'dataConnectorUrl',
          value: dcBox,
        ),
        ProxyService.box.writeString(
          key: 'bhfId',
          value: bhf,
        ),
        ProxyService.box.writeString(
          key: 'mrc',
          value: mrc,
        ),
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

      _feedbackSuccess();
    } catch (e) {
      if (!mounted) return;
      _feedbackError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
