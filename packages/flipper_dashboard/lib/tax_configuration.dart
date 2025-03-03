import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:flipper_ui/style_widget/button.dart';
import 'package:flipper_services/app_service.dart';

class TaxConfiguration extends StatefulHookConsumerWidget {
  const TaxConfiguration({Key? key, required this.showheader})
      : super(key: key);
  final bool showheader;

  @override
  _TaxConfigurationState createState() => _TaxConfigurationState();
}

class _TaxConfigurationState extends ConsumerState<TaxConfiguration> {
  bool isTaxEnabled = false;
  final _routerService = locator<RouterService>();
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _branchController = TextEditingController();
  final _mrcController = TextEditingController();

  // ignore: unused_field
  String _supportLine = "";

  Future<void> _loadData() async {
    // Your async operations here
    final ebm = await ProxyService.strategy
        .ebm(branchId: ProxyService.box.getBranchId()!);
    final serverUrl =
        await ebm?.taxServerUrl ?? await ProxyService.box.getServerUrl();

    _serverUrlController.text = serverUrl!;

    final bhFId = ebm?.bhfId ?? (await ProxyService.box.bhfId()) ?? "";
    _branchController.text = bhFId;
    String? mrc = ProxyService.box.mrc();
    _mrcController.text = (mrc == null || mrc.isEmpty) ? "" : mrc;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _supportLine = ProxyService.remoteConfig.supportLine();
    });
    _loadData();
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
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async {
        try {
          final isTaxEnabledForBusiness = await ProxyService.strategy
              .isTaxEnabled(businessId: ProxyService.box.getBusinessId()!);
          if (isTaxEnabledForBusiness) {
            setState(() {
              isTaxEnabled = true;
            });
          }
          Business? business = await ProxyService.strategy
              .getBusiness(businessId: ProxyService.box.getBusinessId()!);
          model.isEbmActive = business!.tinNumber != null &&
              (await ProxyService.box.bhfId()) != null &&
              business.dvcSrlNo != null &&
              business.taxEnabled == true;
        } catch (e, s) {
          talker.warning(s);
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: widget.showheader
              ? CustomAppBar(
                  onPop: () async {
                    ref.refresh(transactionItemListProvider);
                    _routerService.pop();
                  },
                  closeButton: CLOSEBUTTON.WIDGET,
                  isDividerVisible: false,
                  customLeadingWidget: back.BackButton(),
                )
              : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tax Configuration',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (!isTaxEnabled) _buildSupportSection(),
                  if (isTaxEnabled) ...[
                    _buildSwitchTile(
                      title: 'Training Mode',
                      value: model.isTrainingModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          model.isTrainingModeEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Proforma Mode',
                      value: model.isProformaModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          model.isProformaModeEnabled = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Print A4',
                      value: model.printA4,
                      onChanged: (value) {
                        setState(() {
                          model.printA4 = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: 'Export as PDF',
                      value: model.exportAsPdf,
                      onChanged: (value) {
                        setState(() {
                          model.exportAsPdf = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildProformaUrlForm(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact support to add EBM to Flipper',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _launchWhatsApp,
              icon: const Icon(Icons.support_agent),
              label: const Text('Contact Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile.adaptive(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildProformaUrlForm() {
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
                    'EBM URL',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                        borderSide: BorderSide(color: Colors.blue),
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
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                    validator: _validaBhfid,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mrcController,
                    decoration: InputDecoration(
                      hintText: 'Mrc ',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
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
            Center(
              child: FutureBuilder<String>(
                future: AppService().version(), // Fetch version from AppService
                builder: (context, snapshot) {
                  // Check the state of the Future
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Text(
                      "Version: ${snapshot.data}",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    );
                  } else {
                    return Text("Version not available");
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

  String? _validaBhfid(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please a value';
    }
    return null;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      ProxyService.strategy.saveEbm(
          branchId: ProxyService.box.getBranchId()!,
          severUrl: _serverUrlController.text,
          bhFId: _branchController.text);
      ProxyService.box.writeString(
        key: "getServerUrl",
        value: _serverUrlController.text,
      );
      ProxyService.box.writeString(
        key: "bhfId",
        value: _branchController.text,
      );

      ProxyService.box.writeString(
        key: "mrc",
        value: _mrcController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully')),
      );
    }
  }

  void _launchWhatsApp() async {
    int businessId = ProxyService.box.getBusinessId()!;
    final initialMessage =
        "I am writing to request support to add EBM to flipper, my businessID is: $businessId";
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/250788360058?text=${Uri.encodeComponent(initialMessage)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }
}
