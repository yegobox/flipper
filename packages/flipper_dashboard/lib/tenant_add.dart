import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';
import 'customappbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TenantAdd extends StatefulWidget {
  const TenantAdd({Key? key}) : super(key: key);

  @override
  State<TenantAdd> createState() => _TenantAddState();
}

class _TenantAddState extends State<TenantAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _steps = 0;
  final _routerService = locator<RouterService>();
  bool isAddingUser = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlipperBaseModel>.reactive(
      onViewModelReady: (model) async {
        await model.loadTenants();
      },
      viewModelBuilder: () => FlipperBaseModel(),
      builder: (context, model, widget) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Add a user',
            onPop: () async {
              _routerService.pop();
            },
          ),
          body: SafeArea(
            child: SafeArea(
              child: Stack(
                children: [
                  //
                  isAddingUser
                      ? Center(
                          child: LoadingAnimationWidget.fallingDot(
                            color: Colors.blueGrey,
                            size: 100,
                          ),
                        )
                      : SizedBox.shrink(),
                  // Your existing content
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildAddTenantForm(model, context),
                  ),
                  _buildTenantsList(model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Form _buildAddTenantForm(FlipperBaseModel model, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "You are about to invite a user to your default branch and business",
          ),
          const SizedBox(height: 30),
          _buildTextFormField(
            controller: _nameController,
            labelText: "Name of the user",
            icon: Icons.person,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            controller: _phoneController,
            labelText: "Phone number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              final RegExp phoneExp = RegExp(r'^\d{10}$');
              if (value == null || !phoneExp.hasMatch(value)) {
                return "Invalid phone number";
              }
              return null;
            },
          ),
          _steps != 0 && _steps != 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    _buildOutlinedButton(
                      label: "Add user",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              isAddingUser = true;
                            });
                            await _addUser(model);
                          } catch (e) {
                            setState(() {
                              isAddingUser = false;
                            });
                            log(e.toString());
                            _showErrorSnackBar(context);
                          }
                        }
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
        if (value.isNotEmpty) {
          setState(() {
            _steps += 1;
          });
        }
      },
      validator: validator,
      decoration: InputDecoration(
        enabled: true,
        border: const OutlineInputBorder(),
        suffixIcon: Icon(icon, color: Colors.blue),
        labelText: labelText,
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      child: Text(
        label,
        style: primaryTextStyle.copyWith(color: Colors.white),
      ),
      style: primaryButtonStyle,
      onPressed: onPressed,
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Error while adding user"),
      ),
    );
  }

  Future<void> _addUser(FlipperBaseModel model) async {
    Business? business = await ProxyService.isar.defaultBusiness();
    Branch? branch = await ProxyService.isar.defaultBranch();
    await ProxyService.isar.saveTenant(
      _phoneController.text,
      _nameController.text,
      branch: branch!,
      business: business!,
    );

    await model.loadTenants();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Tenant added"),
      ),
    );
  }

  Widget _buildTenantsList(FlipperBaseModel model) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: model.tenants
            .map(
              (tenant) => ListTile(
                onTap: () async {
                  await _toggleNFC(tenant as Tenant, model);
                },
                leading: Text(tenant.name),
                trailing: Icon(
                  Icons.nfc,
                  color: tenant.nfcEnabled == true ? Colors.blue : Colors.red,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> _toggleNFC(Tenant tenant, FlipperBaseModel model) async {
    tenant.nfcEnabled = !tenant.nfcEnabled;
    try {
      await AppService().nfc.stopNfc();
    } catch (e) {}
    AppService().nfc.startNFC(
          callback: (nfcData) async {
            nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last;

            showToast(context, 'You have added NFC card to ${tenant.name}');
            await ProxyService.isar.update<ITenant>(data: tenant as ITenant);
            model.loadTenants();
          },
          textData:
              "${tenant.id}:${ProxyService.box.getBusinessId()}:${ProxyService.box.getBranchId()}:${tenant.phoneNumber}",
          write: true,
        );
  }
}
