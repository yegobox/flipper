import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';
import 'package:stacked/stacked.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({Key? key}) : super(key: key);

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  List<ITenant> _tenants = [];
  final GlobalKey<FormState> _sub = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int _steps = 0;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddUserViewModel>.reactive(
        onModelReady: (model) async {
          await loadTenants();
        },
        viewModelBuilder: () => AddUserViewModel(),
        builder: (context, model, widget) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add Users"),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _sub,
                      child: Column(
                        children: [
                          const Text(
                              "You are about to invite user to your default branch and business"),
                          const SizedBox(height: 30),
                          GTextFormField(
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
                            suffixIcon: const Icon(Icons.person),
                            hintText: "Name of the user",
                          ),
                          const SizedBox(height: 10),
                          GTextFormField(
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
                              return null;
                            },
                            suffixIcon: const Icon(Icons.phone),
                            hintText: "Phone number",
                          ),
                          _steps != 0 && _steps != 1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 10),
                                    GOutlinedButton("Add user",
                                        onPressed: () async {
                                      if (_sub.currentState!.validate()) {
                                        try {
                                          await ProxyService.isarApi.user(
                                              userPhone: _phoneController.text);
                                          Business? business =
                                              await ProxyService.isarApi
                                                  .defaultBusiness();
                                          Branch? branch = await ProxyService
                                              .isarApi
                                              .defaultBranch();

                                          await ProxyService.isarApi.saveTenant(
                                              _phoneController.text,
                                              _nameController.text,
                                              branch: branch!,
                                              business: business!);

                                          await loadTenants();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text("Tenant added"),
                                            ),
                                          );
                                        } catch (e) {
                                          log(e.toString());
                                        }
                                      }
                                    }),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  ListView(
                      shrinkWrap: true,
                      children: _tenants
                          .map((e) => ListTile(
                                leading: Text(e.name),
                                trailing: Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                ),
                              ))
                          .toList()),
                ],
              ),
            ),
          );
        });
  }

  Future<void> loadTenants() async {
    List<ITenant> users = await ProxyService.isarApi
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    setState(() {
      _tenants = users;
    });
  }
}
