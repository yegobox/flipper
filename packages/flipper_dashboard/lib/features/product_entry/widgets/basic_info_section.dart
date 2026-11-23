import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/ScannViewModel.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/mobile_entry_style.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController productNameController;
  final ScannViewModel model;
  final bool isEditMode;

  const BasicInfoSection({
    Key? key,
    required this.productNameController,
    required this.model,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileEntryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MobileEntryFieldLabel(
            context.flipperL10n.productEntryProductName,
            required: true,
          ),
          TextFormField(
            controller: productNameController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            style: mobileEntryInputTextStyle,
            onChanged: (value) {
              model.setProductName(name: value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.flipperL10n.productEntryNameRequired;
              } else if (value.length < 3) {
                return context.flipperL10n.productEntryNameTooShort;
              }
              return null;
            },
            decoration: mobileEntryInputDecoration(
              hint: context.flipperL10n.productEntryProductNameHint,
            ),
          ),
        ],
      ),
    );
  }
}
