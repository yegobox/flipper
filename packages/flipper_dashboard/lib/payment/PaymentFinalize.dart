import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
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

  // Define theme colors
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFFE3F2FD);
  final Color darkBlue = const Color(0xFF1565C0);

  String? _getPhoneNumberError(String value) {
    String digitsOnly = value.replaceAll(' ', '');
    if (digitsOnly.isEmpty) return null;
    if (!digitsOnly.startsWith('250'))
      return 'Phone number must start with 250';
    if (digitsOnly.length < 12) return 'Phone number must be 12 digits';
    if (digitsOnly.length > 12) return 'Phone number cannot exceed 12 digits';
    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }
    return null;
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildSegmentedButton({
    required List<ButtonSegment<String>> segments,
    required String selected,
    required Function(Set<String>) onSelectionChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryBlue.withValues(alpha: 0.2)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SegmentedButton<String>(
          segments: segments,
          selected: {selected},
          onSelectionChanged: onSelectionChanged,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primaryBlue;
                }
                return Colors.transparent;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return primaryBlue;
              },
            ),
            side: WidgetStateProperty.all(BorderSide.none),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Finalize Payment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryBlue,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryBlue.withValues(alpha: .1), Colors.white],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 200 : 20,
                    vertical: 20,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionTitle(context, 'Select Country'),
                          const SizedBox(height: 16),
                          _buildSegmentedButton(
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
                            selected: selectedCountry,
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
                          const SizedBox(height: 16),
                          _buildSegmentedButton(
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
                            selected: selectedPaymentMethod,
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                selectedPaymentMethod = newSelection.first;
                              });
                            },
                          ),
                          if (selectedPaymentMethod == 'Mobile Money') ...[
                            const SizedBox(height: 32),
                            _buildSectionTitle(context, 'MTN Mobile Money'),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: lightBlue.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SwitchListTile(
                                title: Text(
                                  'Use different phone number',
                                  style: TextStyle(
                                    color: darkBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Toggle to specify a different number for payment',
                                  style: TextStyle(
                                      color: darkBlue.withValues(alpha: 0.7)),
                                ),
                                value: useCustomPhoneNumber,
                                onChanged: (bool value) {
                                  setState(() {
                                    useCustomPhoneNumber = value;
                                  });
                                },
                                activeColor: primaryBlue,
                              ),
                            ),
                            if (useCustomPhoneNumber) ...[
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) {
                                  String digitsOnly =
                                      value.replaceAll(RegExp(r'\D'), '');
                                  if (digitsOnly.length >= 1 &&
                                      !digitsOnly.startsWith('250')) {
                                    if (digitsOnly.startsWith('0')) {
                                      digitsOnly = '25$digitsOnly';
                                    } else {
                                      digitsOnly = '250$digitsOnly';
                                    }
                                  }

                                  String formattedNumber = '';
                                  for (int i = 0; i < digitsOnly.length; i++) {
                                    if (i == 3 || i == 6 || i == 9) {
                                      formattedNumber += ' ';
                                    }
                                    formattedNumber += digitsOnly[i];
                                  }

                                  phoneNumberController.value =
                                      TextEditingValue(
                                    text: formattedNumber,
                                    selection: TextSelection.collapsed(
                                      offset: formattedNumber.length,
                                    ),
                                  );

                                  ProxyService.box.writeString(
                                    key: "customPhoneNumberForPayment",
                                    value: digitsOnly,
                                  );
                                },
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(color: darkBlue),
                                  hintText: '250 781 468 740',
                                  prefixIcon:
                                      Icon(Icons.phone, color: primaryBlue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: primaryBlue),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color:
                                            primaryBlue.withValues(alpha: 0.3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: primaryBlue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: lightBlue.withValues(alpha: 0.1),
                                  errorText: _getPhoneNumberError(
                                      phoneNumberController.text),
                                  helperText: 'Rwanda phone number (12 digits)',
                                  helperStyle: TextStyle(
                                      color: darkBlue.withValues(alpha: 0.7)),
                                  suffixIcon:
                                      phoneNumberController.text.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.clear,
                                                  color: primaryBlue),
                                              onPressed: () {
                                                phoneNumberController.clear();
                                                ProxyService.box.writeString(
                                                  key:
                                                      "customPhoneNumberForPayment",
                                                  value: '',
                                                );
                                              },
                                            )
                                          : null,
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 15,
                                buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) {
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[\d ]')),
                                ],
                              ),
                            ],
                          ],
                          const SizedBox(height: 40),
                          Container(
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [primaryBlue, darkBlue],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _handlePayment,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Complete Payment',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
      models.Plan? paymentPlan = await ProxyService.strategy
          .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!);

      talker.warning("CurrentPaymentPlan: $paymentPlan");

      int finalPrice = 0;
      if (ProxyService.box.couponCode() != null) {
        finalPrice = (paymentPlan!.totalPrice! -
                ((paymentPlan.totalPrice! * ProxyService.box.discountRate()!) /
                    100))
            .toInt();
      } else {
        finalPrice = paymentPlan!.totalPrice?.toInt() ?? 0;
      }

      if (selectedPaymentMethod == "Card") {
        toast("Card Payment is temporarily unavailable");
        await cardPayment(finalPrice, paymentPlan, selectedPaymentMethod,
            plan: paymentPlan);
      } else {
        handleMomoPayment(finalPrice, plan: paymentPlan);
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
