import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'customappbar.dart';

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
            appBar: CustomAppBar(
              title: 'Add a user',
              onPop: () async {
                GoRouter.of(context).pop();
              },
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
                                suffixIcon: const Icon(Icons.person,
                                    color: Colors.blue),
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
                                  suffixIcon: const Icon(Icons.phone,
                                      color: Colors.blue),
                                  hintText: "Phone number")),
                          _steps != 0 && _steps != 1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 10),
                                    OutlinedButton(
                                        child: Text(
                                          "Add user",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xff006AFE)),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered)) {
                                                return Colors.blue
                                                    .withOpacity(0.04);
                                              }
                                              if (states.contains(
                                                      MaterialState.focused) ||
                                                  states.contains(
                                                      MaterialState.pressed)) {
                                                return Colors.blue
                                                    .withOpacity(0.12);
                                              }
                                              return null; // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_sub.currentState!.validate()) {
                                            log(_phoneController.text);
                                            try {
                                              await ProxyService.isarApi.user(
                                                  userPhone:
                                                      _phoneController.text);
                                              Business? business =
                                                  await ProxyService.isarApi
                                                      .defaultBusiness();
                                              Branch? branch =
                                                  await ProxyService.isarApi
                                                      .defaultBranch();
                                              await ProxyService.isarApi
                                                  .saveTenant(
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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Error while adding user"),
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
                    ),
                  ),
                  //on click of the trailing icon
                  // call the YB API to patch this tenant as enabled nfc
                  // then
                  ListView(
                      shrinkWrap: true,
                      children: _tenants
                          .map((e) => ListTile(
                                leading: Text(e.name),
                                trailing: Icon(Icons.nfc, color: Colors.blue),
                              ))
                          .toList()),
                ],
              ),
            ),
          );
        });
  }

  Future<List<ITenant>> loadTenants() async {
    List<ITenant> users = await ProxyService.isarApi
        .tenants(businessId: ProxyService.box.getBusinessId()!);
    setState(() {
      _tenants = [..._tenants, ...users];
    });
    return _tenants;
  }
}
