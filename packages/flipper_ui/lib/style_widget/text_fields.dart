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
    /// When set, used for enabled/focused borders instead of [Theme.primaryColor].
    Color? outlineColor,
    /// Corner radius when [outlineBorderRadius] is null.
    double borderRadius = 4.0,
    BorderRadius? outlineBorderRadius,
    Color? hintColor,
    Color? labelColor,
    Color? fillColor,
  }) {
    Widget? resolvedSuffix = suffixIcon;
    if (resolvedSuffix == null &&
        controller != null &&
        controller.text.isNotEmpty &&
        onClearPressed != null) {
      resolvedSuffix = IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.grey.shade600,
          size: 20.0,
        ),
        onPressed: onClearPressed,
      );
    }
    // Keep suffix content inset from the outline so icons/text do not sit on
    // the border (common with rounded/focused outlines).
    if (resolvedSuffix != null) {
      resolvedSuffix = Padding(
        padding: const EdgeInsetsDirectional.only(end: 10.0),
        child: resolvedSuffix,
      );
    }

    final radius =
        outlineBorderRadius ?? BorderRadius.circular(borderRadius);
    final baseColor = outlineColor ?? Theme.of(context).primaryColor;
    final iconColor = outlineColor ?? Theme.of(context).primaryColor;
    final resolvedLabelColor = labelColor ?? Theme.of(context).primaryColor;
    final resolvedHintColor =
        hintColor ?? Theme.of(context).hintColor.withValues(alpha: .7);
    final resolvedFill = fillColor ?? Theme.of(context).cardColor;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(
        color: resolvedHintColor,
        fontSize: 14.0,
      ),
      labelStyle: TextStyle(
        color: resolvedLabelColor,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: TextStyle(
        color: resolvedLabelColor,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: iconColor,
              size: 22.0,
            )
          : null,
      suffixIcon: resolvedSuffix,
      border: _outlineBorder(
        borderRadius: radius,
        color: baseColor.withValues(alpha: 0.55),
      ),
      enabledBorder: _outlineBorder(
        borderRadius: radius,
        color: baseColor.withValues(alpha: 0.55),
      ),
      focusedBorder: _outlineBorder(
        borderRadius: radius,
        color: baseColor,
        width: 2.0,
      ),
      errorBorder: _buildErrorBorder(context, borderRadius: radius),
      focusedErrorBorder: _buildErrorBorder(
        context,
        borderRadius: radius,
        width: 2.0,
      ),
      filled: true,
      fillColor: resolvedFill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    );
  }

  static OutlineInputBorder _outlineBorder({
    required BorderRadius borderRadius,
    required Color color,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder _buildErrorBorder(
    BuildContext context, {
    required BorderRadius borderRadius,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: borderRadius,
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
    Color? outlineColor,
    double borderRadius = 4.0,
    BorderRadius? outlineBorderRadius,
    Color? hintColor,
    Color? labelColor,
    Color? fillColor,
    TextStyle? style,
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
      style: style ?? AppInputDecoration.inputStyle(context),
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
        outlineColor: outlineColor,
        borderRadius: borderRadius,
        outlineBorderRadius: outlineBorderRadius,
        hintColor: hintColor,
        labelColor: labelColor,
        fillColor: fillColor,
      ),
    );
  }
}
