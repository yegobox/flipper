import 'package:flutter/material.dart';

mixin TextEditingControllersMixin {
  final TextEditingController textEditController = TextEditingController();
  final TextEditingController searchContrroller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> purchaseCodeFormkey = GlobalKey<FormState>();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController deliveryNoteCotroller = TextEditingController();

  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  final TextEditingController purchasecodecontroller = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
}
