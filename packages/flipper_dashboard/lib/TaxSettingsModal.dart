import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/receipt_header/receipt_header_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Tax rates and the receipt header (phone, email, welcome line) for a branch.
class TaxSettingsModal extends ConsumerStatefulWidget {
  final String branchId;

  const TaxSettingsModal({Key? key, required this.branchId}) : super(key: key);

  @override
  ConsumerState<TaxSettingsModal> createState() => _TaxSettingsModalState();
}

class _TaxSettingsModalState extends ConsumerState<TaxSettingsModal> {
  late Future<List<Configurations>> _taxConfigsFuture;
  final Map<String, bool> _editingStates = {};
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};
  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;

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

        // Clear success message after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _statusMessage = null;
            });
          }
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
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Widget _buildTaxRow(Configurations config) {
    final bool isEditing = _editingStates[config.id] ?? false;

    if (!_controllers.containsKey(config.id)) {
      _controllers[config.id] = TextEditingController(
        text: config.taxPercentage.toString(),
      );
      _formKeys[config.id] = GlobalKey<FormState>();
    }

    return Card(
      child: ListTile(
        title: Text(
          context.flipperL10n.taxSettingsTaxType(config.taxType ?? ''),
        ),
        subtitle: isEditing
            ? Form(
                key: _formKeys[config.id],
                child: TextFormField(
                  controller: _controllers[config.id],
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.flipperL10n.taxSettingsRequired;
                    }
                    final tax = double.tryParse(value);
                    if (tax == null) {
                      return context.flipperL10n.invalidNumber;
                    }
                    if (tax < 0 || tax > 100) {
                      return context.flipperL10n.taxSettingsRange;
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKeys[config.id]!.currentState!.validate()) {
                      _saveTaxConfiguration(config.id, value);
                    }
                  },
                ),
              )
            : Text('${config.taxPercentage}%'),
        trailing: IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: _isLoading
              ? null
              : () {
                  if (isEditing) {
                    if (_formKeys[config.id]!.currentState!.validate()) {
                      _saveTaxConfiguration(
                        config.id,
                        _controllers[config.id]!.text,
                      );
                    }
                  } else {
                    setState(() {
                      _editingStates[config.id] = true;
                    });
                  }
                },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.flipperL10n.taxSettings,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ReceiptHeaderSection(branchId: widget.branchId),
              const Divider(height: 32),
              if (_statusMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _isError ? Colors.red.shade50 : Colors.green.shade50,
                    border: Border.all(
                      color: _isError
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isError
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        color: _isError
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(
                            color: _isError
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (_isError)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _statusMessage = null;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red.shade700,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              FutureBuilder<List<Configurations>>(
                future: _taxConfigsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text(
                      context.flipperL10n.errorMessage('${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(context.flipperL10n.taxSettingsNoneFound);
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: snapshot.data!.map(_buildTaxRow).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.flipperL10n.close),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
