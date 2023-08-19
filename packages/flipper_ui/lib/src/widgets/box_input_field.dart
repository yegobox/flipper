import 'package:flipper_ui/src/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BoxInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final bool enabled;
  final Function? validatorFunc;
  final Function? onChanged;
  final TextInputType textInputType;
  final void Function()? trailingTapped;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  BoxInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.enabled = true,
    this.trailing,
    this.trailingTapped,
    this.onChanged,
    this.password = false,
    this.validatorFunc,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      validator: (value) {
        if (validatorFunc != null) {
          return validatorFunc!(value);
        }
        return null;
      },
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Colors.black, height: 1),
      keyboardType: textInputType,
      obscureText: password,
      decoration: InputDecoration(
        hintText: placeholder,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        filled: true,
        fillColor: kcVeryLightGreyColor,
        prefixIcon: leading,
        suffixIcon: trailing != null
            ? GestureDetector(
                onTap: trailingTapped,
                child: trailing,
              )
            : null,
        border: circularBorder.copyWith(
          borderSide: BorderSide(color: kcLightGreyColor),
        ),
        errorBorder: circularBorder.copyWith(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: circularBorder.copyWith(
          borderSide: BorderSide(color: kcPrimaryColor),
        ),
        enabledBorder: circularBorder.copyWith(
          borderSide: BorderSide(color: kcLightGreyColor),
        ),

        // filled: true,
        // fillColor: kcVeryLightGreyColor,
      ),
    );
  }
}
