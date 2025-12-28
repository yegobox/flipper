import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxSettingsModal extends StatefulWidget {
  final String branchId;

  const TaxSettingsModal({Key? key, required this.branchId}) : super(key: key);

  @override
  State<TaxSettingsModal> createState() => _TaxSettingsModalState();
}

class _TaxSettingsModalState extends State<TaxSettingsModal> {
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
    _taxConfigsFuture = ProxyService.strategy.taxes(branchId: widget.branchId);
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
      await ProxyService.strategy.saveTax(
        configId: configId,
        taxPercentage: newTaxPercentage,
      );

      if (mounted) {
        setState(() {
          _editingStates[configId] = false;
          _statusMessage = 'Tax settings updated successfully';
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
          _statusMessage = 'Error updating tax settings:}';
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
        title: Text('${config.taxType} Tax'),
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
                      return 'Required';
                    }
                    final tax = double.tryParse(value);
                    if (tax == null) {
                      return 'Invalid number';
                    }
                    if (tax < 0 || tax > 100) {
                      return 'Must be 0-100';
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
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tax Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No tax configurations found');
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
                    child: const Text('Close'),
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
