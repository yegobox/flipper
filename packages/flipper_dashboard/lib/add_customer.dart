// ignore_for_file: unused_result

library flipper_login;

import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_models/db_model_export.dart';

final isWindows = UniversalPlatform.isWindows;

class AddCustomer extends StatefulHookConsumerWidget {
  const AddCustomer({Key? key, required this.transactionId, this.searchedKey})
      : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String transactionId;
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
  bool isLoading = false;

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
    final theme = Theme.of(context);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Add New Customer',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: AddCustomer._formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Type Selection
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Type',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerTypeValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCustomerTypeValue = newValue!;
                                    });
                                  },
                                  items: <String>['Business', 'Individual']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Details Card
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Details',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            // Name Field
                            BoxInputField(
                              controller: _nameController,
                              placeholder: 'Full Name',
                              leading: const Icon(Icons.person_outline),
                              validatorFunc: (value) {
                                if (value!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone Field
                            BoxInputField(
                              controller: _phoneController,
                              placeholder: 'Phone Number',
                              leading: const Icon(Icons.phone_outlined),
                              // keyboardType: TextInputType.phone,
                              validatorFunc: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Field
                            BoxInputField(
                              controller: _emailController,
                              placeholder: 'Email Address',
                              leading: const Icon(Icons.email_outlined),
                              // keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            // TIN Field
                            BoxInputField(
                              controller: _tinNumberController,
                              placeholder: 'TIN Number (Required)',
                              leading: const Icon(Icons.numbers_outlined),
                              // keyboardType: TextInputType.number,
                              validatorFunc: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'TIN is required';
                                }
                                if (!isNumeric(value)) {
                                  return 'TIN should be a number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
  ? null
  : () async {
      if (AddCustomer._formKey.currentState!.validate()) {
        setState(() => isLoading = true);
        try {
          await model.addCustomer(
            customerType: selectedCustomerTypeValue,
            email: _emailController.text,
            phone: _phoneController.text,
            name: _nameController.text,
            tinNumber: _tinNumberController.text,
            transactionId: widget.transactionId,
          );
          final URI = await ProxyService.box.getServerUrl();
          final tinNumber = ProxyService.box.tin();
          final bhfId = await ProxyService.box.bhfId();
          final branchId = ProxyService.box.getBranchId()!;

          CustomerPatch.patchCustomer(
            URI: URI!,
            tinNumber: tinNumber,
            bhfId: bhfId!,
            branchId: branchId,
            sendPort: (message) {
              ProxyService.notification.sendLocalNotification(body: message);
            },
          );

          ref.refresh(customersProvider);
          Navigator.maybePop(context);
          model.getTransactionById();
        } catch (e) {
          // Show error to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString().isNotEmpty ? e.toString() : 'Failed to add customer',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          setState(() => isLoading = false);
        }
      }
    },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Add Customer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
