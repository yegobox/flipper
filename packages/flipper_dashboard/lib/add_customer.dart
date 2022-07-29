library flipper_login;

import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/isar_models.dart';

final isWindows = UniversalPlatform.isWindows;

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key, required this.orderId, this.searchedKey})
      : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int orderId;
  final String? searchedKey;

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tinNumberController = TextEditingController();
  final log = getLogger('AddCustomer');

  bool isEmail(String? s) {
    if (s == null) {
      return false;
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
    return emailValid;
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
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      viewModelBuilder: () => BusinessHomeViewModel(),
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
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      name: _nameController.text,
                                      tinNumber: _tinNumberController.text,
                                      orderId: widget.orderId,
                                    );

                                    Navigator.maybePop(context);

                                    /// this update a model when the Order has the customerId in it then will show related data accordingly!
                                    model.getOrderById();
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
