import 'package:flutter/material.dart';

// Create a class to handle all the input styling
class AppInputDecoration {
  static InputDecoration buildDecoration({
    required BuildContext context,
    String? labelText,
    required String hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? controller,
    VoidCallback? onClearPressed,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Theme.of(context).hintColor.withOpacity(.7),
        fontSize: 14.0,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: Theme.of(context).primaryColor,
              size: 22.0,
            )
          : null,
      suffixIcon:
          suffixIcon ?? // Use custom suffixIcon if provided, otherwise default to clear button
              (controller != null &&
                      controller.text.isNotEmpty &&
                      onClearPressed != null
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey.shade600,
                        size: 20.0,
                      ),
                      onPressed: onClearPressed,
                    )
                  : null),
      border: _buildBorder(context, opacity: 0.5),
      enabledBorder: _buildBorder(context, opacity: 0.3),
      focusedBorder: _buildBorder(context, opacity: 1.0, width: 2.0),
      errorBorder: _buildErrorBorder(context),
      focusedErrorBorder: _buildErrorBorder(context, width: 2.0),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    );
  }

  static OutlineInputBorder _buildBorder(
    BuildContext context, {
    double opacity = 1.0,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(opacity),
        width: width,
      ),
    );
  }

  static OutlineInputBorder _buildErrorBorder(
    BuildContext context, {
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: width,
      ),
    );
  }

  // Common text style for input fields
  static TextStyle inputStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16.0,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }
}

class StyledTextFormField {
  static TextFormField create({
    required BuildContext context,
    String? labelText,
    required String hintText,
    TextEditingController? controller,
    FocusNode? focusNode, // Add optional focusNode parameter
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
    IconData? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    Key? key, // Add optional Key parameter
  }) {
    return TextFormField(
      key: key, // Pass the key to the TextFormField
      controller: controller,
      focusNode: focusNode, // Pass the optional focusNode
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      validator: validator,
      style: AppInputDecoration.inputStyle(context),
      decoration: AppInputDecoration.buildDecoration(
        context: context,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon, // Pass the custom suffixIcon
        controller: controller,
        onClearPressed: controller != null
            ? () {
                controller.clear();
                // Note: You'll need to handle setState in the parent widget
              }
            : null,
      ),
    );
  }
}
