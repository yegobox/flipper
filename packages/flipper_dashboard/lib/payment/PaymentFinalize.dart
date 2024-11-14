import 'package:flipper_models/helperModels/talker.dart';
import 'package:firestore_models/firestore_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/services.dart';
import 'package:flipper_services/PaymentHandler.dart';

class PaymentFinalize extends StatefulWidget {
  @override
  _PaymentFinalizeState createState() => _PaymentFinalizeState();
}

class _PaymentFinalizeState extends State<PaymentFinalize> with PaymentHandler {
  String selectedCountry = 'Other';
  String selectedPaymentMethod = 'Card';
  bool isLoading = false;
  bool v1Active = true;
  bool useCustomPhoneNumber = false;
  TextEditingController phoneNumberController = TextEditingController();
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
      textAlign: TextAlign.left,
    );
  }

  String? _getPhoneNumberError(String value) {
    // Remove spaces for validation
    String digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.isEmpty) {
      return null;
    }

    if (!digitsOnly.startsWith('250')) {
      return 'Phone number must start with 250';
    }

    if (digitsOnly.length < 12) {
      return 'Phone number must be 12 digits';
    }

    if (digitsOnly.length > 12) {
      return 'Phone number cannot exceed 12 digits';
    }

    // Validate MTN prefixes (78, 79)
    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }

    return null;
  }

// You might also want to add this validation function to use elsewhere
  bool isValidRwandaPhoneNumber(String number) {
    String digitsOnly = number.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length == 12 &&
        digitsOnly.startsWith('250') &&
        (digitsOnly.substring(3, 5) == '78' ||
            digitsOnly.substring(3, 5) == '79');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finalize Payment',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 200 : 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle(context, 'Select Country'),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Rwanda',
                          label: Text('Rwanda'),
                          icon: Icon(Icons.flag, size: 20),
                        ),
                        ButtonSegment(
                          value: 'Other',
                          label: Text('Other'),
                          icon: Icon(Icons.public, size: 20),
                        ),
                      ],
                      selected: {selectedCountry},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          selectedCountry = newSelection.first;
                          if (selectedCountry == 'Other') {
                            selectedPaymentMethod = 'Card';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(context, 'Payment Method'),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: selectedCountry == 'Rwanda'
                          ? const [
                              ButtonSegment(
                                value: 'Mobile Money',
                                label: Text('Mobile Money'),
                                icon: Icon(Icons.phone_android, size: 20),
                              ),
                              ButtonSegment(
                                value: 'Card',
                                label: Text('Card'),
                                icon: Icon(Icons.credit_card, size: 20),
                              ),
                            ]
                          : const [
                              ButtonSegment(
                                value: 'Card',
                                label: Text('Card'),
                                icon: Icon(Icons.credit_card, size: 20),
                              ),
                            ],
                      selected: {selectedPaymentMethod},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          selectedPaymentMethod = newSelection.first;
                        });
                      },
                    ),
                    if (selectedPaymentMethod == 'Mobile Money') ...[
                      const SizedBox(height: 32),
                      _buildSectionTitle(context, 'MTN Mobile Money'),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Use different phone number'),
                        subtitle: const Text(
                            'Toggle to specify a different number for payment'),
                        value: useCustomPhoneNumber,
                        onChanged: (bool value) {
                          setState(() {
                            useCustomPhoneNumber = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                      if (useCustomPhoneNumber) ...[
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) {
                            // Remove any non-digit characters
                            String digitsOnly =
                                value.replaceAll(RegExp(r'\D'), '');

                            // Ensure the number starts with 250 if not already present
                            if (digitsOnly.length >= 1 &&
                                !digitsOnly.startsWith('250')) {
                              if (digitsOnly.startsWith('0')) {
                                // If starts with 0, replace it with 250
                                digitsOnly = '25${digitsOnly}';
                              } else {
                                // Add 250 prefix
                                digitsOnly = '250$digitsOnly';
                              }
                            }

                            // Format the number with spaces for readability: 250 781 468 740
                            String formattedNumber = '';
                            for (int i = 0; i < digitsOnly.length; i++) {
                              if (i == 3 || i == 6 || i == 9) {
                                formattedNumber += ' ';
                              }
                              formattedNumber += digitsOnly[i];
                            }

                            // Update the controller with the formatted number
                            phoneNumberController.value = TextEditingValue(
                              text: formattedNumber,
                              selection: TextSelection.collapsed(
                                  offset: formattedNumber.length),
                            );

                            // Store the validated number
                            ProxyService.box.writeString(
                              key: "customPhoneNumberForPayment",
                              value: digitsOnly, // Store without formatting
                            );
                          },
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '250 781 468 740',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            errorText: _getPhoneNumberError(
                                phoneNumberController.text),
                            helperText: 'Rwanda phone number (12 digits)',
                            suffixIcon: phoneNumberController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      phoneNumberController.clear();
                                      ProxyService.box.writeString(
                                        key: "customPhoneNumberForPayment",
                                        value: '',
                                      );
                                    },
                                  )
                                : null,
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength: 15, // Including spaces: "250 781 468 740"
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return null; // Removes the built-in counter
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 40),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 3,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 54),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Complete Payment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handlePayment() async {
    setState(() {
      isLoading = true;
    });
    try {
      PaymentPlan? paymentPlan = await ProxyService.backUp
          .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!);

      talker.warning("CurrentPaymentPlan: $paymentPlan");

      int finalPrice = 0;
      //findout if there is ongoing compaign to apply discount
      if (ProxyService.box.couponCode() != null) {
        finalPrice = (paymentPlan!.totalPrice! -
                ((paymentPlan.totalPrice! * ProxyService.box.discountRate()!) /
                    100))
            .toInt();
      } else {
        finalPrice = paymentPlan?.totalPrice?.toInt() ?? 0;
      }
      if (selectedPaymentMethod == "Card") {
        toast("Card Payment is temporarily unavailable");
        await cardPayment(finalPrice, paymentPlan!, selectedPaymentMethod);

        /// listen on stream to check if payment has been completed by a user
      } else {
        handleMomoPayment(finalPrice);
      }
    } catch (e, s) {
      talker.warning(e.toString());
      talker.error(s.toString());
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }
}
