import 'package:flipper_localize/flipper_localize.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class TenantFormMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController phoneController = TextEditingController();
  static bool isAddingUser = false;
  static bool editMode = false;
  static String selectedUserType = 'Cashier';

  static void resetForm() {
    nameController.clear();
    phoneController.clear();
  }

  static String? validatePhoneOrEmailStatic(String? value) {
    if (value == null || value.isEmpty) {
      return FlipperL10n.current.tenantMgmtEnterPhoneOrEmail;
    }

    if (EmailValidator.validate(value.trim())) {
      return null;
    }

    // If not an email, check if it's a valid phone number
    if (!value.startsWith("+")) {
      return FlipperL10n.current.tenantMgmtPhoneNeedsCountryCode;
    }

    try {
      final phone = PhoneNumber.parse(value);
      if (!phone.isValid(type: PhoneNumberType.mobile)) {
        return FlipperL10n.current.tenantMgmtInvalidPhone;
      }

      final phoneExp = RegExp(r'^\+\d{1,3}\d{7,15}$');
      if (!phoneExp.hasMatch(value)) {
        return FlipperL10n.current.tenantMgmtInvalidPhone;
      }
    } catch (e) {
      return FlipperL10n.current.tenantMgmtInvalidPhoneFormat;
    }

    return null;
  }

  static Widget buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required TextInputType keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
