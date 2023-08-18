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

class TenantAdd extends StatefulWidget {
  const TenantAdd({Key? key}) : super(key: key);

  @override
  State<TenantAdd> createState() => _TenantAddState();
}

class _TenantAddState extends State<TenantAdd> {
  final GlobalKey<FormState> _sub = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _steps = 0;
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TenantViewModel>.reactive(
        onViewModelReady: (model) async {
          await model.loadTenants();
        },
        viewModelBuilder: () => TenantViewModel(),
        builder: (context, model, widget) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Add a user',
              onPop: () async {
                _routerService.pop();
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: addTenantForm(model, context),
                  ),
                  Tenants(model: model),
                ],
              ),
            ),
          );
        });
  }

  Form addTenantForm(TenantViewModel model, BuildContext context) {
    return Form(
      key: _sub,
      child: Column(
        children: [
          const Text(
              "You are about to invite user to your default branch and business"),
          const SizedBox(height: 30),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _steps += 1;
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return "You need to enter name";
              }
              return null;
            },
            decoration: InputDecoration(
                enabled: true,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.person, color: Colors.blue),
                hintText: "Name of the user"),
          ),
          const SizedBox(height: 10),
          TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _steps += 1;
                  });
                }
              },
              validator: (value) {
                if (value == null) {
                  return "You need a phone number";
                }
                final RegExp phoneExp = new RegExp(r'^\d{10}$');
                if (!phoneExp.hasMatch(value)) {
                  return "Invalid phone number";
                }
                return null;
              },
              decoration: InputDecoration(
                  enabled: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.phone, color: Colors.blue),
                  hintText: "Phone number")),
          _steps != 0 && _steps != 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    OutlinedButton(
                        child: Text(
                          "Add user",
                          style: primaryTextStyle.copyWith(color: Colors.white),
                        ),
                        style: primaryButtonStyle,
                        onPressed: () async {
                          if (_sub.currentState!.validate()) {
                            try {
                              await ProxyService.isar.login(
                                  skipDefaultAppSetup: false,
                                  userPhone: _phoneController.text);
                              Business? business =
                                  await ProxyService.isar.defaultBusiness();
                              Branch? branch =
                                  await ProxyService.isar.defaultBranch();
                              await ProxyService.isar.saveTenant(
                                  _phoneController.text, _nameController.text,
                                  branch: branch!, business: business!);

                              await model.loadTenants();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Tenant added"),
                                ),
                              );
                            } catch (e) {
                              log(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Error while adding user"),
                                ),
                              );
                            }
                          }
                        }),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class Tenants extends StatefulWidget {
  Tenants({Key? key, required this.model}) : super(key: key);

  final TenantViewModel model;

  @override
  State<Tenants> createState() => _TenantsState();
}

class _TenantsState extends State<Tenants> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: widget.model.tenants
            .map((tenant) => ListTile(
                  onTap: () async {
                    tenant.nfcEnabled = !tenant.nfcEnabled;
                    // stop the nfc session first as it might be running
                    try {
                      await AppService().nfc.stopNfc();
                    } catch (e) {}
                    AppService().nfc.startNFC(
                          callback: (nfcData) async {
                            nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last;

                            showToast(context,
                                'You have added NFC card to ${tenant.name}');
                            await ProxyService.isar
                                .update<ITenant>(data: tenant);
                            widget.model.loadTenants();
                          },
                          textData:
                              "${tenant.id}:${ProxyService.box.getBusinessId()}:${ProxyService.box.getBranchId()}:${tenant.phoneNumber}",
                          write: true,
                        );
                  },
                  leading: Text(tenant.name),
                  trailing: Icon(Icons.nfc,
                      color:
                          tenant.nfcEnabled == true ? Colors.blue : Colors.red),
                ))
            .toList());
  }
}
