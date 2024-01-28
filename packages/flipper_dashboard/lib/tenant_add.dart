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
import 'package:email_validator_flutter/email_validator_flutter.dart';
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
          body: Column(
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    isAddingUser
                        ? Center(
                            child: LoadingAnimationWidget.fallingDot(
                              color: Colors.blueGrey,
                              size: 100,
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildAddTenantForm(model, context),
                    ),
                  ],
                ),
              ),
              _buildTenantsList(model),
            ],
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
              // Validate email first
              if (EmailValidatorFlutter().validateEmail(value ?? "")) {
                // If valid email, return null (no validation error)
                return null;
              }

              // Focus on phone number validation
              if (value == null || value.isEmpty) {
                return "Please enter a phone number or email address"; // Handle empty input
              }

              if (!value.startsWith("+")) {
                return "Phone number should contain country code with + sign";
              }

              // Extract phone number without country code
              final phoneNumberWithoutCode = value.substring(1);

              // Flexible phone number validation using a more comprehensive regex
              final phoneExp = RegExp(r'^\d{7,15}$'); // Allow 7-15 digits
              if (!phoneExp.hasMatch(phoneNumberWithoutCode)) {
                return "Invalid phone number";
              }
              // Catch-all check for remaining invalid input
              if (!EmailValidatorFlutter().validateEmail(value) &&
                  !phoneExp.hasMatch(phoneNumberWithoutCode)) {
                return "Invalid input format. Please enter a valid email address or phone number.";
              }
              return null; // Valid phone number
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
                            setState(() {
                              isAddingUser = false;
                            });
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
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          children: model.tenants
              .map(
                (tenant) => Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    onTap: () async {
                      await _toggleNFC(tenant as Tenant, model);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        tenant.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    title: Text(
                      tenant.name,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.nfc,
                      color:
                          tenant.nfcEnabled == true ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
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
