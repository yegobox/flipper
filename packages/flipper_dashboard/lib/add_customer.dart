// ignore_for_file: unused_result

library flipper_login;

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/realm_model_export.dart';

final isWindows = UniversalPlatform.isWindows;

class AddCustomer extends StatefulHookConsumerWidget {
  const AddCustomer({Key? key, required this.transactionId, this.searchedKey})
      : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int transactionId;
  final String? searchedKey;

  @override
  AddCustomerState createState() => AddCustomerState();
}

class AddCustomerState extends ConsumerState<AddCustomer> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tinNumberController = TextEditingController();

  String selectedCustomerTypeValue = 'Individual';

  bool isEmail(String? s) {
    if (s == null) {
      return false;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
    return emailValid;
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    if (isNumeric(widget.searchedKey)) {
      _phoneController.text = widget.searchedKey!;
    }
    if (!isNumeric(widget.searchedKey) && !isEmail(widget.searchedKey)) {
      _nameController.text = widget.searchedKey!;
    }
    if (isEmail(widget.searchedKey)) {
      _emailController.text = widget.searchedKey!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Form(
              key: AddCustomer._formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Column(
                        children: [
                          BoxInputField(
                            controller: _nameController,
                            placeholder: 'Name',
                            validatorFunc: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              }
                            },
                          ),
                          verticalSpaceSmall,
                          BoxInputField(
                              controller: _tinNumberController,
                              placeholder: 'Tin number',
                              validatorFunc: (value) {
                                if (value!.isEmpty &&
                                    double.parse(value).isFinite) {
                                  return 'Tin should be a number';
                                }
                              }),
                          verticalSpaceSmall,
                          BoxInputField(
                            controller: _phoneController,
                            leading: const Icon(Icons.phone),
                            placeholder: 'Phone Number',
                            validatorFunc: (value) {
                              if (value!.isEmpty) {
                                return 'Phone number is required';
                              }
                            },
                          ),
                          verticalSpaceSmall,
                          BoxInputField(
                            controller: _emailController,
                            leading: const Icon(Icons.email),
                            placeholder: 'Email',
                          ),
                          SizedBox(height: 4),
                          // input
                          DropdownButton<String>(
                            value: selectedCustomerTypeValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCustomerTypeValue = newValue!;
                              });
                            },
                            items: <String>['Business', 'Individual']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            isExpanded: true,
                            underline:
                                SizedBox(), // Remove the default underline
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: BoxButton(
                                title: 'Add Cutomer',
                                onTap: () async {
                                  if (AddCustomer._formKey.currentState!
                                      .validate()) {
                                    model.addCustomer(
                                      customerType: selectedCustomerTypeValue,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      name: _nameController.text,
                                      tinNumber: _tinNumberController.text,
                                      transactionId: widget.transactionId,
                                    );
                                    ref.refresh(customersProvider);
                                    Navigator.maybePop(context);

                                    /// this update a model when the Transaction has the customerId in it then will show related data accordingly!
                                    model.getTransactionById();
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
