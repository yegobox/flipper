// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flipper_services/app_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';

class TaxConfigForm extends ConsumerStatefulWidget {
  const TaxConfigForm({Key? key}) : super(key: key);

  @override
  ConsumerState<TaxConfigForm> createState() => _TaxConfigFormState();
}

class _TaxConfigFormState extends ConsumerState<TaxConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _branchController = TextEditingController();
  final _mrcController = TextEditingController();
  bool _vatEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    final serverUrl =
        await ebm?.taxServerUrl ?? await ProxyService.box.getServerUrl();

    _serverUrlController.text = serverUrl ?? "";

    final bhFId = ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? "";
    _branchController.text = bhFId;
    String? mrc = ProxyService.box.mrc();
    _mrcController.text = (mrc == null || mrc.isEmpty) ? "" : mrc;

    // Load VAT enabled status
    final vatEnabled = await ProxyService.box.vatEnabled() as bool?;
    if (ebm != null) {
      setState(() {
        _vatEnabled = vatEnabled ?? ebm.vatEnabled ?? false;
      });
      // Save the initial value if it came from EBM
      if (ebm.vatEnabled != null) {
        await ProxyService.box
            .writeBool(key: 'vatEnabled', value: ebm.vatEnabled ?? false);
      }
    } else if (vatEnabled != null) {
      setState(() {
        _vatEnabled = vatEnabled;
      });
    }
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _branchController.dispose();
    _mrcController.dispose();
    super.dispose();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tax Configuration',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // VAT Enabled Switch
                  SwitchListTile(
                    title: const Text('VAT Enabled'),
                    subtitle:
                        const Text('Enable Value Added Tax for this business'),
                    value: _vatEnabled,
                    activeColor: Colors.blue,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    onChanged: (bool value) async {
                      setState(() {
                        _vatEnabled = value;
                      });
                      // Save the new VAT status immediately
                      await ProxyService.box.writeBool(
                        key: 'vatEnabled',
                        value: value,
                      );
                      // Invalidate the outerVariantsProvider to refresh the variants list
                      final branchId = ProxyService.box.getBranchId();
                      if (branchId != null) {
                        ref.refresh(outerVariantsProvider(branchId));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _serverUrlController,
                    decoration: InputDecoration(
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
                          vertical: 16, horizontal: 16),
                    ),
                    validator: _validateUrl,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _branchController,
                    decoration: InputDecoration(
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
                          vertical: 16, horizontal: 16),
                    ),
                    validator: _validateBhfid,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mrcController,
                    decoration: InputDecoration(
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
                          vertical: 16, horizontal: 16),
                    ),
                    validator: _validateMrc,
                  ),
                  const SizedBox(height: 16),
                  FlipperButton(
                    color: Colors.blue,
                    width: double.infinity,
                    textColor: Colors.white,
                    onPressed: _saveForm,
                    text: "Save",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FutureBuilder<String>(
                future: AppService().version(), // Fetch version from AppService
                builder: (context, snapshot) {
                  // Check the state of the Future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Text(
                      "Version: ${snapshot.data}",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    );
                  } else {
                    return const Text("Version not available");
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
    if (!Uri.tryParse(value.trim())!.hasScheme) {
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

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Get current MRC value from storage
      final currentMrc = ProxyService.box.mrc() ?? '';
      final newMrc = _mrcController.text;
      final currentVatEnabled = ProxyService.box.vatEnabled();

      // Check if MRC or VAT status has changed
      if (currentMrc.isNotEmpty &&
          currentMrc == newMrc &&
          currentVatEnabled == _vatEnabled) {
        toast("No changes detected");
        return;
      }

      // Save EBM configuration
      await ProxyService.strategy.saveEbm(
          branchId: ProxyService.box.getBranchId()!,
          severUrl: _serverUrlController.text,
          bhFId: _branchController.text,
          vatEnabled: _vatEnabled);

      // Save to local storage
      await Future.wait([
        ProxyService.box.writeString(
          key: "getServerUrl",
          value: _serverUrlController.text,
        ),
        ProxyService.box.writeString(
          key: "bhfId",
          value: _branchController.text,
        ),
        ProxyService.box.writeString(
          key: "mrc",
          value: newMrc,
        ),
        ProxyService.box.writeBool(key: 'vatEnabled', value: _vatEnabled),
      ]);

      // Invalidate the outerVariantsProvider to refresh the variants list
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        ref.refresh(outerVariantsProvider(branchId));
      }

      toast("Saved successfully");
    }
  }
}
