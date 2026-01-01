import 'package:flutter/material.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class TenantFormMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController phoneController = TextEditingController();
  static bool isAddingUser = false;
  static bool editMode = false;
  static String selectedUserType = 'Agent';

  static void resetForm() {
    nameController.clear();
    phoneController.clear();
  }

  static String? validatePhoneOrEmailStatic(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter valid number or email address";
    }

    // Check if it's a valid email
    if (EmailValidatorFlutter().validateEmail(value)) {
      return null;
    }

    // If not an email, check if it's a valid phone number
    if (!value.startsWith("+")) {
      return "Phone number should contain country code with + sign";
    }

    try {
      final phone = PhoneNumber.parse(value);
      if (!phone.isValid(type: PhoneNumberType.mobile)) {
        return "Invalid Phone";
      }

      final phoneExp = RegExp(r'^\+\d{1,3}\d{7,15}$');
      if (!phoneExp.hasMatch(value)) {
        return "Invalid phone number";
      }
    } catch (e) {
      return "Invalid phone number format";
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
